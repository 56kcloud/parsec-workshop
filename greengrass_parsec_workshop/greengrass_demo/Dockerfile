FROM parallaxsecond/greengrass_patched:latest as from_source_builder
COPY ./ /project
RUN cd /project && \
     ./mvnw clean install -DskipTests=true -Dcontainers.skip=true

FROM parallaxsecond/greengrass_patched:latest
COPY --from=from_source_builder /project/aws-greengrass-parsec-provider/examples/greengrass/parsec-greengrass-plugin/target/aws.greengrass.crypto.ParsecProvider.jar /provider.jar
COPY greengrass_demo/config.yml /greengrass/
