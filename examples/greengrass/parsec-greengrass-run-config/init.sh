#!/bin/bash -e

cd $(dirname "$0")
source secrets.env
mkdir -p device_root
cd device_root

GREENGRASS_RELEASE_VERSION=2.5.0
GREENGRASS_ZIP_FILE=greengrass-${GREENGRASS_RELEASE_VERSION}.zip
GREENGRASS_RELEASE_URI=https://d2s8p88vqu9w66.cloudfront.net/releases/${GREENGRASS_ZIP_FILE}

if ! test -f "${GREENGRASS_ZIP_FILE}"; then
  curl -o ${GREENGRASS_ZIP_FILE} ${GREENGRASS_RELEASE_URI}
  unzip -o "${GREENGRASS_ZIP_FILE}"
fi
common_params="\
--root $(pwd) \
--thing-name $(id -un)--gg-parsec \
--thing-group-name GreengrassQuickStartGroup \
--setup-system-service false \
--deploy-dev-tools true \
--init-config ../config.yml \
--trusted-plugin ../../parsec-greengrass-plugin/target/aws.greengrass.crypto.ParsecProvider.jar \
"
function write_run_config() {
  name="$1"
  params="${common_params} $2"
  cat > ../../../../.run/${name}.run.xml << EOF
  <component name="ProjectRunConfigurationManager">
    <configuration default="false" name="${name}" type="JarApplication">
      <option name="JAR_PATH" value="$(pwd)/lib/Greengrass.jar" />
      <option name="PROGRAM_PARAMETERS" value="${params}" />
      <option name="WORKING_DIRECTORY" value="$(pwd)" />
      <option name="ALTERNATIVE_JRE_PATH_ENABLED" value="true" />
      <option name="ALTERNATIVE_JRE_PATH" value="corretto-8" />
      <envs>
        <env name="AWS_ACCESS_KEY_ID" value="${AWS_ACCESS_KEY_ID}" />
        <env name="AWS_SECRET_ACCESS_KEY" value="${AWS_SECRET_ACCESS_KEY}" />
        <env name="AWS_REGION" value="${AWS_REGION}" />
      </envs>
      <method v="2">
            <option name="Maven.BeforeRunTask" enabled="true" file="\$PROJECT_DIR$/examples/greengrass/parsec-greengrass-plugin/pom.xml" goal="package -DskipTests=true" />
      </method>
    </configuration>
  </component>
EOF
}
write_run_config GreenGrassProvision "--provision true --start false"
write_run_config GreenGrassRun "--provision false --start true"




