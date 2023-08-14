package org.mustangproject;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URI;
import java.net.URL;

import org.apache.fop.apps.io.ResourceResolverFactory;
import org.apache.xmlgraphics.io.Resource;
import org.apache.xmlgraphics.io.ResourceResolver;

public class ClasspathResolverURIAdapter implements ResourceResolver {

	private final ResourceResolver wrapped;


	public ClasspathResolverURIAdapter() {
		this.wrapped = ResourceResolverFactory.createDefaultResourceResolver();
	}


	@Override
	public Resource getResource(URI uri) throws IOException {
		if (uri.getScheme().equals("classpath")) {
			URL url = getClass().getClassLoader().getResource(uri.getSchemeSpecificPart());

			return new Resource(url.openStream());
		} else {
			return wrapped.getResource(uri);
		}
	}

	@Override
	public OutputStream getOutputStream(URI uri) throws IOException {
		return wrapped.getOutputStream(uri);
	}

}
