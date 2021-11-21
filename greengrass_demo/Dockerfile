FROM parallaxsecond/greengrass_patched:latest as from_source_builder
RUN yum install -y maven
COPY ./ /project

RUN cd /project && \
     mvn -N io.takari:maven:0.7.7:wrapper && \
     ./mvnw clean install -DskipTests=true -Dcontainers.skip=true

FROM parallaxsecond/greengrass_demo:latest

COPY --from=from_source_builder /project/examples/greengrass/parsec-greengrass-plugin/target/aws.greengrass.crypto.ParsecProvider.jar /provider.jar
COPY greengrass_demo/config.yml /greengrass/


