package api;

import io.dropwizard.auth.PrincipalImpl;

public class User extends PrincipalImpl {
	String username;

	public User(String name) {
		super(name);
		username=name;
	}

	
	
}
