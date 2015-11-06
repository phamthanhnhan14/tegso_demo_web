#FROM registry-docker.apps.vn:5000/demo/ubuntu
#FROM ubuntu:14.04
FROM registry-docker.apps.vn:5000/ubuntu:14.04
MAINTAINER demo@gitlab.zapps.vn 

RUN \
	mkdir -p /zserver && \
	mkdir -p /zserver/init.d && \
	mkdir -p /zserver/java-projects && \
	cd /tmp 

ADD jdk1.7.0_11 /zserver/jdk1.7.0_11
RUN ln -s /zserver/jdk1.7.0_11 /zserver/java && \
	ln -s /zserver/java/bin/* /usr/local/bin/ && \
	cd /zserver/java && rm -rf \
		lib/plugin.jar \
		lib/ext/jfxrt.jar \
		bin/javaws \
		lib/javaws.jar \
		lib/desktop \
		plugin \
		lib/deploy* \
		lib/*javafx* \
		lib/*jfx* \
		lib/amd64/libdecora_sse.so \
		lib/amd64/libprism_*.so \
		lib/amd64/libfxplugins.so \
		lib/amd64/libglass.so \
		lib/amd64/libgstreamer-lite.so \
		lib/amd64/libjavafx*.so \
		lib/amd64/libjfx*.so

ADD localtime /etc/localtime
ENV JAVA_HOME /zserver/java
RUN mkdir -p /zserver/java-projects/tegso_demo_web
RUN useradd -m zdeploy -u 2000
ADD tegso_demo_web /zserver/java-projects/tegso_demo_web
RUN chown -R zdeploy. /zserver/java-projects/tegso_demo_web
EXPOSE 8888
USER zdeploy

WORKDIR /zserver/java-projects/tegso_demo_web
ADD localtime /etc/localtime
ENTRYPOINT /bin/bash runserver start
