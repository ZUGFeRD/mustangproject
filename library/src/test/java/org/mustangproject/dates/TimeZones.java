package org.mustangproject.dates;

import java.time.ZoneId;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Runs code with a different JVM default zone (and locale).
 * <p>
 * ZUGFeRDDateFormat caches its SimpleDateFormat per thread (including the zone in effect at
 * creation), so the code runs on a fresh thread after the zone has been set.
 */
final class TimeZones {

	static final ZoneId UTC = ZoneId.of("UTC");
	static final ZoneId BERLIN = ZoneId.of("Europe/Berlin");

	private static final long TIMEOUT_SECONDS = 60;

	@FunctionalInterface
	interface ThrowingRunnable {
		void run() throws Exception;
	}

	private TimeZones() {
	}

	static void runInZone(ZoneId zone, ThrowingRunnable body) throws Exception {
		inZone(zone, () -> {
			body.run();
			return null;
		});
	}

	static <T> T inZone(ZoneId zone, Callable<T> body) throws Exception {
		TimeZone previousZone = TimeZone.getDefault();
		try {
			TimeZone.setDefault(TimeZone.getTimeZone(zone));
			return onFreshThread(body);
		} finally {
			TimeZone.setDefault(previousZone);
		}
	}

	static <T> T inZoneAndLocale(ZoneId zone, Locale locale, Callable<T> body) throws Exception {
		Locale previousLocale = Locale.getDefault();
		Locale previousFormatLocale = Locale.getDefault(Locale.Category.FORMAT);
		Locale previousDisplayLocale = Locale.getDefault(Locale.Category.DISPLAY);
		try {
			Locale.setDefault(locale);
			return inZone(zone, body);
		} finally {
			Locale.setDefault(previousLocale);
			Locale.setDefault(Locale.Category.FORMAT, previousFormatLocale);
			Locale.setDefault(Locale.Category.DISPLAY, previousDisplayLocale);
		}
	}

	private static <T> T onFreshThread(Callable<T> body) throws Exception {
		ExecutorService freshThread = Executors.newSingleThreadExecutor();
		try {
			return freshThread.submit(body).get(TIMEOUT_SECONDS, TimeUnit.SECONDS);
		} catch (ExecutionException e) {
			// rethrow assertion failures as they are, so IDEs show expected/actual
			if (e.getCause() instanceof Error) {
				throw (Error) e.getCause();
			}
			if (e.getCause() instanceof Exception) {
				throw (Exception) e.getCause();
			}
			throw e;
		} finally {
			freshThread.shutdownNow();
		}
	}
}
