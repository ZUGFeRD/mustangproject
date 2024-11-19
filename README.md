
Mustangproject
=====

Source code repository for the [Mustang project](http://www.mustangproject.org/) open source java PDF invoice metadata library in ZUGFeRD format.

Build
-----

These are the recommended dependencies for the project: 

 - OpenJDK 21.0.2 2024-01-16
 - Apache Maven 3.9.6

You can build the project with: 

```shell
mvn clean install
``` 

This will run the tests, build the project artefacts, and install the artifacts to the local 
cache. After that the mustang JAR can be used.

More information on how to develop **on** mustang: 
 
 - [Developer documentation](https://github.com/ZUGFeRD/mustangproject/blob/master/doc/development_documentation.md)

Usage
-----

If you set up a Maven project, you can reference the mustang artifact like this:

```xml
<dependency>
    <groupId>org.mustangproject</groupId>
    <artifactId>validator</artifactId>
    <version>2.15.0</version>
    <classifier>shaded</classifier>
</dependency>
```

Further docs on how to develop **with** mustang: 
 - [Usage examples](https://www.mustangproject.org/use/): Read and write electronic invoices.
 - [Mustang classes](https://www.mustangproject.org/invoice-class/): Using the mustang classes.

Contact
-----

Developer: Jochen Stärk. For questions please contact Jochen at jstaerk [at] usegroup.de 

License
-----

Subject to the [Apache-2.0 license](http://www.apache.org/licenses/LICENSE-2.0.html).
