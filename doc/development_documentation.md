
## General approach

1. build

as excercise to check if the neccessary tools are there, the build is in a stable state and works on your platform, e.g. download and extract https://github.com/ZUGFeRD/mustangproject/archive/master.zip and run ./mvnw clean package

Mvnw is a maven wrapper which will download maven.Maven is the dependency management tool which will download all libraries, their dependencies, and build the whole thing.

You will need a Java JDK, e.g. https://www.azul.com/downloads/zulu-community/?architecture=x86-64-bit&package=jdk

If that does not work feel free to address the community support mailing list with error messages/steps to reproduce.

You may already start developing what you wanted. Of course you can use any editor or IDE you like, I suggest Intellij Community Edition https://www.jetbrains.com/de-de/idea/download/


2. fork

Once you can build, the idea is that you contribute patches via pull requests. For this you need a github account and  a personal copy of the repository to store your changes in. Just klick fork on the mustangproject. On your copy you will have git write access. My suggestion as git client is sourcetree (I can send you instructions how to set it up).

3. branch

If you do a pull request, please do a feature branch, e.g. if you are working on a feature abc you could call your branch feature_abc. Merge requests unfortunately don't work if you don't have a branch you request merge of. Technically we follow the "github flow" strategy (not to be exchanged with the more sophisticated "git flow" strategy)

4. test

Most of mustang is a library, adding (autmated junit) test cases is often not only the most sustainable but also the fastest way to see if new/changed functionality works. If something is changed so that old test cases break on purpose please do not just remove them but take the time to fix the test cases



## New build

Target platform is java 1.8

## Build

The package can be build with
```
mvnw clean package
```

## Test

`package -Dmaven.surefire.debug="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8001 -Xnoagent -Djava.compiler=NONE"`
can be used as debug configuration goal in Eclipse. In that case you can set breakpoints in tests.

## Validate

[ZUV](https://github.com/ZUGFeRD/ZUV/) can be used to validate generated files.

## Deployment

A section in Maven's settings.xml is needed, in Linux (and MacOS) that's at ~/.m2/settings.xml 

As „servers“, enter the following
```xml
   <servers> 
    <server> 
      <id>github</id> 
      <password>GITHUB-TOKEN</password> 
    </server> 
   </servers> 
```
The whole settings.xml then looks e.g. like this
```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                          https://maven.apache.org/xsd/settings-1.0.0.xsd">
      <localRepository/>
      <interactiveMode/>
      <usePluginRegistry/>
      <offline/>
      <pluginGroups/>
      <servers>
        <server> 
      	<id>github</id> 
      	<password>TOKEN</password> 
        </server> 
      </servers>
      <mirrors/>
      <proxies/>
      <profiles/>
      <activeProfiles/>
</settings>
```

The password is generated on github.
See the following screenshot:


Sign in in GitHub and click on the profile picture -> Settings. Now just generate a new token and set the checkboxes from the screenshot.
![screenshot](development_documentation_screenshot_github_settings.png "Screenshot Github Settings")
 The Token-ID is the password. 

## Integrate before release

If you added functionality which you need to test in another project before a new version of Mustang is released you can
install the jar you just generated in your target branch in your local maven cache so it gets picked *instead* of the
maybe not yet even existing new release version:

`mvn install:install-file -Dfile=mustang-1.7.6-SNAPSHOT.jar -DgroupId=org.mustangproject.ZUGFeRD -DartifactId=mustang -Dversion=1.7.6 -Dpackaging=jar -DgeneratePom=true`


## Release

You will need a git client on the console, if that's available can e.g. be checked with "git --version" . 
Change to the root of the repo.

Change to the project directory and run 
  * `mvn clean install` confirm javadoc is OK with
  * `mvn javadoc:javadoc`. If that works you can 
  * clean the release with `mvn release:clean` and prepare the release with
  * `mvn release:prepare  -DignoreSnapshots=true` and enter the version numbers. 
  * After that is through you can create a new release via `mvn release:perform -Dmaven.java.skip=True`.This will also update the maven repo. 
  
  ![screenshot](development_documentation_screenshot_release.png "Screenshot Release")
  

Afterwards you can access the release page and update the documentation, e.g. upload the jar, the jar javadoc and ZugferdDev. You can also enter a changelog and a better title. 


## Release process

  * Update documentation
  * write/translate announcement
  * release via/for mvn
  * Publish a github release
  * update mustangproject.org RE
    * version number and release date
    * sample file?
    * Deployment jar
  * put announcement on usegroup
  * email the mailing list
  * freshcode.club
 
