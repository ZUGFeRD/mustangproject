package api;

import org.glassfish.jersey.media.multipart.MultiPartFeature;
import org.glassfish.jersey.server.filter.RolesAllowedDynamicFeature;

import io.dropwizard.Application;
import io.dropwizard.auth.AuthDynamicFeature;
import io.dropwizard.auth.AuthValueFactoryProvider;
import io.dropwizard.auth.basic.BasicCredentialAuthFilter;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import io.federecio.dropwizard.swagger.SwaggerBundle;
import io.federecio.dropwizard.swagger.SwaggerBundleConfiguration;
import mustang.MustangResource;

public class ApiApplication extends Application<ApiConfiguration> {
	public static void main(String[] args) throws Exception {
		new ApiApplication().run(args);
	}

	@Override
	public String getName() {
		return "Mustang Server";
	}

	@Override
	public void initialize(Bootstrap<ApiConfiguration> bootstrap) {

		bootstrap.addBundle(new SwaggerBundle<ApiConfiguration>() {
			@Override
			protected SwaggerBundleConfiguration getSwaggerBundleConfiguration(ApiConfiguration configuration) {
				return configuration.swaggerBundleConfiguration;
			}
		});
	}

	@Override
	public void run(ApiConfiguration configuration, Environment environment) {
		final MustangResource resource = new MustangResource();

		environment.jersey()
				.register(new AuthDynamicFeature(new BasicCredentialAuthFilter.Builder<User>()
						.setAuthenticator(new BasicAuthenticator()).setAuthorizer(new BasicAuthorizer())
						.setRealm("Rest API access").buildAuthFilter()));
		environment.jersey().register(RolesAllowedDynamicFeature.class);
		environment.jersey().register(new AuthValueFactoryProvider.Binder<>(User.class));
		environment.jersey().register(MultiPartFeature.class);
		environment.jersey().register(resource);
	}

}