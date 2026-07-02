package org.mustangproject.validator;
import com.sun.management.HotSpotDiagnosticMXBean;
import org.junit.jupiter.api.Test;
import org.mustangproject.validator.ZUGFeRDValidator;

import javax.management.MBeanServer;
import javax.management.ObjectName;
import java.io.InputStream;
import java.lang.management.ManagementFactory;
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.Callable;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

/***
 * tests handling of resources, i.e. memory leaks etc
 */
public class ResourcesTest {


		// REQUIRES on the test JVM:  --add-opens java.base/java.lang=ALL-UNNAMED
		//   Gradle:  test { jvmArgs '--add-opens', 'java.base/java.lang=ALL-UNNAMED' }
		//   Maven (surefire): <argLine>--add-opens java.base/java.lang=ALL-UNNAMED</argLine>

		//Disable Verapdf logging
		private static final Logger VERAPDF_LOG = Logger.getLogger("org.verapdf");
		static {
			VERAPDF_LOG.setLevel(Level.OFF);
		}

		//Config
		private static final String RHINO_LOADER = "org.mozilla.javascript.DefiningClassLoader";
		private static final String TEMP_DIR = "./tmp";
		// TODO: Point to correct folder full of test zugferd examples
		private static final String FILE_SOURCE = "./src/main/resources/classloader";
		private static final boolean CREATE_HEAP_DUMP = false;

		/**
		 * Classloaders are freed only when GC runs and nothing references them.
		 */
		private static void forceGc() throws InterruptedException {
			for (int i = 0; i < 4; i++) {
				System.gc();                 // only a hint -> loop + short waits
				System.runFinalization();
				Thread.sleep(500);
				System.out.println("GC round " + i + " done");
			}
		}

		/**
		 * Counts loaders of the given concrete class name via VM.classloader_stats.
		 */
		private static long countLoaders(String loaderClassName) {
			try {
				MBeanServer mbs = ManagementFactory.getPlatformMBeanServer();
				ObjectName dc = new ObjectName("com.sun.management:type=DiagnosticCommand");

				// The operation is the camel-cased jcmd name. It's "vmClassloaderStats"
				// (lowercase 'l' -- "classloader" is one token). Discover it so we don't
				// depend on exact casing across JDK versions.
				String op = null;
				for (var info : mbs.getMBeanInfo(dc).getOperations()) {
					if (info.getName().toLowerCase().contains("classloaderstats")) {
						op = info.getName();
						break;
					}
				}
				if (op == null) {
					throw new IllegalStateException("VM.classloader_stats operation not found");
				}

				String out = (String) mbs.invoke(
					dc, op,
					new Object[]{new String[0]},           // no command arguments
					new String[]{"[Ljava.lang.String;"});  // arg type: String[]
				return out.lines()
					.filter(line -> line.contains(loaderClassName))
					.count();
			} catch (Exception e) {
				throw new IllegalStateException("Could not query classloader stats", e);
			}
		}

		static void dumpHeap(String path, boolean liveOnly) throws Exception {
			Path filePath = Paths.get(path);
			if (Files.exists(filePath)) {
				Files.delete(filePath);
			}

			HotSpotDiagnosticMXBean bean = ManagementFactory.newPlatformMXBeanProxy(
				ManagementFactory.getPlatformMBeanServer(),
				"com.sun.management:type=HotSpotDiagnostic",
				HotSpotDiagnosticMXBean.class);
			bean.dumpHeap(path, liveOnly);   // liveOnly=true runs a GC first
		}

		private static void validateAllDocumentsInPath(String path) throws Exception {
			List<Path> pdfs;
			try (var s = Files.list(Paths.get(path))) {
				pdfs = s.filter(p -> p.toString().endsWith(".pdf")).toList();
			}
			var threadPool = Executors.newFixedThreadPool(8);
			var tasks = pdfs.stream()
				.map(p -> (Callable<Void>) () -> validateFile(p))
				.toList();
			long startVirtualThreads = System.currentTimeMillis();
			threadPool.invokeAll(tasks);
			System.out.println("\nAnalyse of " + pdfs.size() + " files took " + (System.currentTimeMillis() - startVirtualThreads) + "ms\n");
		}

		private static Void validateFile(Path p) {
			try (InputStream stream = Files.newInputStream(p);) {
				ZUGFeRDValidator validator = new ZUGFeRDValidator();
				validator.validate(stream, p.getFileName().toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
			return null;
		}

		/**
		 * For each live thread, counts the distinct Rhino DefiningClassLoaders reachable
		 * from that thread's ThreadLocal values. Prints a per-thread tally and a total.
		 * <p>
		 * Mechanism: thread.threadLocals -> ThreadLocalMap.table[].value (the cache)
		 * -> values that are org.mozilla.javascript.* (compiled scripts)
		 * -> value.getClass().getClassLoader()  (the DefiningClassLoader)
		 */
		static void countRhinoLoadersPerThread() throws Exception {
			Field tlField = Thread.class.getDeclaredField("threadLocals");
			tlField.setAccessible(true);
			Class<?> tlmClass = Class.forName("java.lang.ThreadLocal$ThreadLocalMap");
			Field tableField = tlmClass.getDeclaredField("table");
			tableField.setAccessible(true);
			Class<?> entryClass = Class.forName("java.lang.ThreadLocal$ThreadLocalMap$Entry");
			Field valueField = entryClass.getDeclaredField("value");
			valueField.setAccessible(true);

			Map<String, Integer> perThread = new TreeMap<>();
			// Track loaders globally too, so we can see if any are shared across threads.
			Set<ClassLoader> allLoaders = java.util.Collections.newSetFromMap(new IdentityHashMap<>());

			for (Thread t : Thread.getAllStackTraces().keySet()) {
				Object tlm = tlField.get(t);
				if (tlm == null) continue;
				Object[] table = (Object[]) tableField.get(tlm);
				if (table == null) continue;

				// distinct loaders reachable from THIS thread's thread-locals
				Set<ClassLoader> loaders = java.util.Collections.newSetFromMap(new IdentityHashMap<>());

				for (Object entry : table) {
					if (entry == null) continue;
					Object value = valueField.get(entry);
					if (value == null) continue;
					collectRhinoLoaders(value, loaders);
				}

				if (!loaders.isEmpty()) {
					perThread.put(t.getName(), loaders.size());
					allLoaders.addAll(loaders);
				}
			}

			System.out.println("=== Rhino DefiningClassLoaders bound per thread ===");
			int sum = 0;
			for (var e : perThread.entrySet()) {
				System.out.printf("  %-28s %d%n", e.getKey(), e.getValue());
				sum += e.getValue();
			}
			System.out.println("  ----");
			System.out.printf("  threads holding loaders : %d%n", perThread.size());
			System.out.printf("  sum of per-thread counts: %d%n", sum);
			System.out.printf("  distinct loaders total  : %d%n", allLoaders.size());
			// If sum > distinct total, some loaders are shared across threads.
			// If sum == distinct total, every loader belongs to exactly one thread (pure per-thread).
		}

		/**
		 * Walk a thread-local value (typically a Map cache) and collect the loaders of any Rhino objects.
		 */
		private static void collectRhinoLoaders(Object value, Set<ClassLoader> out) {
			if (value instanceof Map<?, ?> m) {
				for (var e : m.entrySet()) {
					addIfRhino(e.getKey(), out);
					addIfRhino(e.getValue(), out);
				}
			} else if (value instanceof Iterable<?> it) {
				for (Object o : it) addIfRhino(o, out);
			} else {
				addIfRhino(value, out);
			}
		}

		private static void addIfRhino(Object o, Set<ClassLoader> out) {
			if (o == null) return;
			Class<?> c = o.getClass();
			if (c.getName().startsWith("org.mozilla.javascript")) {
				ClassLoader cl = c.getClassLoader();
				if (cl != null && cl.getClass().getName().contains("DefiningClassLoader")) {
					out.add(cl);
				}
			}
		}

		@Test
		void test() throws Exception {
			forceGc();
			long baseline = countLoaders(RHINO_LOADER);
			System.out.println("baseline Rhino loaders = " + baseline);

			validateAllDocumentsInPath(FILE_SOURCE);

			forceGc();
			long after = countLoaders(RHINO_LOADER);
			long retained = after - baseline;
			System.out.println("\n" + RHINO_LOADER + " after GC = " + after + "  (retained = " + retained + ")\n");
			if (CREATE_HEAP_DUMP) {
				dumpHeap(TEMP_DIR + "/heapDump.hprof", true);
			}

			countRhinoLoadersPerThread();
		}



}
