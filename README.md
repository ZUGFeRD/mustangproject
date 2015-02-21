PDFA3
=====

Some samples how to create PDF/A3 files and PDF/A3 files with embedded files using Apache PDFBox and
the source code for the [Mustang project](http://www.mustangproject.org/).

License
-----

Subject to the Apache license http://www.apache.org/licenses/LICENSE-2.0.html

Running
-----

This project requires Maven to run. Build project with "mvn clean install". This will build the project, test it and install the artifacts to local cache. After that the mustang jar can be used.

More informations in [the mustang documentation](https://github.com/Rayman2200/PDFA3/blob/master/mustang/doc/ZugferdDev.en.pdf?raw=true)).

Usage
-----

If you setup a Maven project, you can grab the artifacts from this maven repository.
 

```xml
<repositories>
    <repository>
        <id>mustang-mvn-repo</id>
        <url>https://raw.github.com/Rayman2200/PDFA3/mvn-repo/</url>
    </repository>
</repositories>
```

As dependency use this

```xml
<dependency>
  <groupId>org.mustangproject.ZUGFeRD</groupId>
  <artifactId>mustang</artifactId>
  <version>1.1.1alpha</version>
</dependency>
```

Contact
-----

Developer: Jochen Stärk. For questions please contact Jochen at jstaerk [at] usegroup.de 

