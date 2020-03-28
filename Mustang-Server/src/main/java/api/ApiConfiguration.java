package api;
import io.dropwizard.Configuration;
import io.federecio.dropwizard.swagger.SwaggerBundleConfiguration;

import com.fasterxml.jackson.annotation.JsonProperty;

public class ApiConfiguration extends Configuration {

    @JsonProperty("swagger")
    public SwaggerBundleConfiguration swaggerBundleConfiguration;
    
}