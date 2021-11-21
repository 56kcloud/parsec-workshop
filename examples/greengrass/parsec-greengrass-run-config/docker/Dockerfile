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


FROM parallaxsecond/parsec:0.8.1 as parsec

FROM amazoncorretto:8
LABEL greengrass-version=${GREENGRASS_RELEASE_VERSION}
COPY --from=parsec /bin/parsec-tool /bin/
COPY --from=builder /greengrass/ /greengrass/

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
