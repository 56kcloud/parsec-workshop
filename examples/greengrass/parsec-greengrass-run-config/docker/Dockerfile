FROM amazoncorretto:8 as builder
WORKDIR "/home/ggc_user"
RUN yum install -y unzip

# Pass AWS Credentials into docker build with --build-args
ENV THING_NAME=sample-thing
ARG GREENGRASS_RELEASE_VERSION=2.5.0
ARG GREENGRASS_ZIP_FILE=greengrass-${GREENGRASS_RELEASE_VERSION}.zip
ARG GREENGRASS_RELEASE_URI=https://d2s8p88vqu9w66.cloudfront.net/releases/${GREENGRASS_ZIP_FILE}
ARG GREENGRASS_ZIP_SHA256=greengrass.zip.sha256
RUN mkdir /greengrass && \
    curl -s ${GREENGRASS_RELEASE_URI} > /${GREENGRASS_ZIP_FILE} && \
    cd /greengrass && \
    unzip ../${GREENGRASS_ZIP_FILE}

FROM amazoncorretto:8 as from_source_builder

RUN yum install -y maven make cmake3 git gcc && \
    ln -s /usr/bin/cmake3 /usr/bin/cmake

RUN git clone --recursive https://github.com/awslabs/aws-crt-java.git && \
    cd aws-crt-java && \
    git checkout key-op-prototype && \
    git submodule update --init && \
    mvn -N io.takari:maven:0.7.7:wrapper && \
    ./mvnw clean install -DskipTests=true

RUN git clone --recursive https://github.com/aws/aws-iot-device-sdk-java-v2.git && \
    cd aws-iot-device-sdk-java-v2 && \
    git checkout key-op-prototype && \
    git submodule update --init && \
    mvn -N io.takari:maven:0.7.7:wrapper && \
    ./mvnw clean install -DskipTests=true

RUN git clone --recursive  https://github.com/aws-greengrass/aws-greengrass-nucleus.git && \
    cd aws-greengrass-nucleus && \
    git checkout v2.5.0 && \
    git submodule update --init && \
    mvn -N io.takari:maven:0.7.7:wrapper && \
    ./mvnw clean install -DskipTests=true && \
    ./mvnw install -DskipTests=true && \
    sed -i  's/1.5.3-WINDOWS-SNAPSHOT/1.0.0-SNAPSHOT/g' pom.xml && \
    ./mvnw install -DskipTests=true

FROM parallaxsecond/parsec:0.8.1 as parsec

FROM amazoncorretto:8
LABEL greengrass-version=${GREENGRASS_RELEASE_VERSION}
COPY --from=parsec /bin/parsec-tool /bin/
COPY --from=builder /greengrass/ /greengrass/
COPY --from=builder /greengrass/ /greengrass/
COPY --from=from_source_builder /aws-greengrass-nucleus/target/Greengrass.jar /greengrass/lib/

# TINI_KILL_PROCESS_GROUP allows forwarding SIGTERM to all PIDs in the PID group so Greengrass can exit gracefully
ENV TINI_KILL_PROCESS_GROUP=1
ENV GG_ADDITIONAL_CMD_ARGS=""
ENV GG_START=""
ENV GG_PROVISION=""
ENV GG_THING_NAME=""
RUN yum install -y awscli shadow-utils
RUN groupadd ggc_group && \
    useradd ggc_user -m -g ggc_group
WORKDIR /home/ggc_user
COPY start.sh /greengrass/start.sh
COPY config_example.yml /greengrass/config_example.yml
RUN chmod +x /greengrass/start.sh
ENTRYPOINT ["/greengrass/start.sh"]
