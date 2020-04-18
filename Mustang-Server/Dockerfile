# See https://docs.docker.com/engine/userguide/eng-image/multistage-build/
# to build please run
#  sudo docker build --tag mustang:2.0 . 
# to start please run
#  sudo docker run --publish 8080:8080 --detach --name mustang mustang:2.0
# takes around 15s to start up, afterwards access http://127.0.0.1:8080
# to remove please run
#  sudo docker rm --force mustang

FROM openjdk:8-jdk-alpine as builder
WORKDIR /build
RUN apk --no-cache add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk --update add git maven
RUN git clone https://github.com/ZUGFeRD/mustangproject.git
RUN cd mustangproject && mvn clean package


FROM openjdk:8-jre-alpine as runner

ENV MUSTANG_VERSION=2.0.0-SNAPSHOT

# Since this is a running network service we'll create an unprivileged account
# which will be used to perform the rest of the work and run the actual service:

# Debian:
# RUN useradd --system --user-group --home-dir=/opt/mustang mustang
# Alpine / Busybox:
RUN install -d -o root -g root -m 755 /opt && adduser -h /opt/mustang -S mustang
USER mustang
WORKDIR /opt/mustang

COPY --from=builder /build/mustangproject/Mustang-Server/target/Mustang-Server-${MUSTANG_VERSION}.jar /opt/mustang/
COPY --from=builder /build/mustangproject/Mustang-Server/config.yml /opt/mustang/
COPY --from=builder /build/mustangproject/Mustang-Server/dwstart.keystore /opt/mustang/

EXPOSE 8080
ENTRYPOINT java -jar /opt/mustang/Mustang-Server-${MUSTANG_VERSION}.jar server config.yml
