package mustangAPI;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;

import org.glassfish.jersey.client.authentication.HttpAuthenticationFeature;
import api.ApiApplication;

public class IntegrationTest {
	   /*@ClassRule
	    public static final DropwizardAppRule<ApiConfiguration> RULE
	            = new DropwizardAppRule<>(ApiApplication.class,
	                    "config.yml");
	    @Test
	    public void testGetGreeting() {
	    	//test w/ssl
	    	 *   //Create SSL Configurator
        SslConfigurator sslConfigurator = SslConfigurator.newInstance();
        //Register a keystore
        sslConfigurator.trustStoreFile("dwstart.keystore")
                .trustStorePassword("crimson");
        //Create SSL Context
        SSLContext sSLContext = sslConfigurator.createSSLContext();
        //Obtain client
        Client client = ClientBuilder
                .newBuilder()
                .sslContext(sSLContext)
                .build();
	    	 
	
	
	
	        String expected = "Hello world!";
	        //Obtain client
	        Client client = ClientBuilder.newClient();
	        //Build a feature in basic authentication mode
	        HttpAuthenticationFeature feature
	                = HttpAuthenticationFeature.basic("javaeeeee", "crimson");
	        //Register the feature
	        client.register(feature);
	        //Get actual resul string
	        String actual = client
	                .target("http://localhost:8080/secured_hello")
	                .request(MediaType.TEXT_PLAIN)
	                .get(String.class);
	        //Do an assertion
	        assertEquals(expected, actual);
	    }*/
	}
