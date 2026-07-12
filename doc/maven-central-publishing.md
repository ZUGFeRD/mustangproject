# Publishing Mustang to Maven Central

This guide is for Mustang release maintainers. It documents the one-time
Sonatype Central Portal setup and the release procedure for the
`org.mustangproject` namespace. It deliberately does not include credentials,
tokens, or passphrases.

## One-time Central Portal setup

1. Sign in to the [Central Portal](https://central.sonatype.com/) with the
   GitHub account of a Mustang release maintainer. If an existing OSSRH
   publisher account or namespace is shown, use it or request access from its
   current owners before creating anything new.
2. In **View Namespaces**, check whether `org.mustangproject` is already
   verified. If it is not, add that namespace. The current Maven `groupId` is
   `org.mustangproject`, so this is the namespace that must be authorised.
3. Verify it through the domain owner of `mustangproject.org`: the Portal will
   provide a verification key for a DNS TXT record. Add the record exactly as
   requested, wait for DNS propagation, and only then select **Verify
   Namespace**. The reverse of `mustangproject.org` is `org.mustangproject`.
4. Grant every person who may release access in the Portal instead of sharing
   a personal account or token. Re-check that the POM's developer names and
   email addresses are current and approved for publication.
5. Generate a Central Portal user token and keep it in the releaser's Maven
   settings, not in Git, CI logs, or a GitHub issue:

   ```xml
   <settings>
     <servers>
       <server>
         <id>central</id>
         <username><!-- Central token username --></username>
         <password><!-- Central token password --></password>
       </server>
     </servers>
   </settings>
   ```

6. Confirm that the release GPG key configured in the root `pom.xml` is
   available to the releaser, has not expired or been revoked, and its public
   key is discoverable from a Central-supported public keyserver. Do not add a
   private key or its passphrase to the repository.

Central's current [namespace instructions](https://central.sonatype.org/register/namespace/)
and [publishing requirements](https://central.sonatype.org/publish/requirements/)
are authoritative. In particular, every published JAR needs sources,
Javadoc, PGP signatures, checksums, and complete POM metadata.

## What the POM configures

The root POM uses Sonatype's `central-publishing-maven-plugin`, replacing the
retired `nexus-staging-maven-plugin`. `mvn deploy` creates and uploads a
bundle to the Central Portal using the Maven server id `central`.

`autoPublish` is intentionally `false`: a release maintainer reviews the
validated deployment in the Portal and explicitly selects **Publish**. Once
the process is established and a protected CI release workflow is in place,
the maintainers may choose to enable automatic publishing.

The library, validator, and CLI all deploy their main artifacts. Source JARs
are attached for each module, and the inherited Javadoc configuration attaches
Javadoc JARs. The aggregator POM is deliberately not deployed.

## Release checklist

1. Start with a clean worktree and a current `master` branch. Build the
   intended release locally:

   ```shell
   mvn clean verify
   ```

   Confirm that every module produces its main JAR, `-sources.jar`, and
   `-javadoc.jar`.
2. Ensure the Central Portal token is available under the Maven server id
   `central`, and that GPG can sign with the configured release key. Use the
   existing Maven release-plugin procedure:

   ```shell
   mvn release:clean
   mvn release:prepare
   mvn release:perform
   ```

   The final command runs `deploy`, uploads the release bundle, and waits for
   Central validation. Do not retry a version that Central has already
   accepted: releases on Maven Central are immutable.
3. Open [Central deployments](https://central.sonatype.com/publishing/deployments),
   inspect the validated `mustangproject-<version>` bundle, and select
   **Publish**. If validation fails, fix the cause, increment the version, and
   create a new release.
4. After Central reports the deployment as published, verify the expected
   artifacts in [Maven Central Search](https://central.sonatype.com/) before
   announcing the GitHub release.

For a first production publication, perform a signed release rehearsal with a
new, disposable version and keep publication manual until the Portal validates
the bundle successfully.
