#!/bin/bash
set -e -o pipefail

JAVA_OPTS=""
case "${1}" in
/bin/*sh)
  exec "${1}"
  ;;
debug)
  JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005"
  echo "using Debug config ${JAVA_OPTS}"
  ;;
esac

for mandatory_env in GG_THING_NAME GG_PROVISION GG_START; do
  if [ "${!mandatory_env}" == "" ]; then
    echo "the env variable ${mandatory_env} needs to be set"
      exit 255
  fi
done

for warn_env in AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_REGION; do
  if [ "${!warn_env}" == "" ]; then
    # AWS SDKs have a series of strategies for picking up config, env variables is just one
    # of them.
    echo "the env variable ${warn_env} is not set, container might fail later"
  fi
done

if [ "${GG_PROVISION}" == "true" ]; then
  aws --region "${AWS_REGION}" iot create-thing --thing-name "${GG_THING_NAME}"
fi

if ! test -e /greengrass/config.yml; then
  echo "please map a config file to /greengrass/config.yml"
  exit 255
fi

# shellcheck disable=SC2086
exec java ${JAVA_OPTS} -Droot=/home/ggc-user \
  -jar /greengrass/lib/Greengrass.jar \
  --thing-name "${GG_THING_NAME}" \
  --thing-group-name GreengrassQuickStartGroup \
  --component-default-user ggc_user:ggc_group \
  --provision "${GG_PROVISION}" \
  --setup-system-service false \
  --deploy-dev-tools true \
  --init-config /greengrass/config.yml \
  --start "${GG_START}" ${GG_ADDITIONAL_CMD_ARGS}
