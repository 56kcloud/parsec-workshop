#!/bin/bash
set -e -o pipefail

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



java -Droot=/greengrass \
  -jar ./lib/Greengrass.jar \
  --thing-name "${GG_THING_NAME}" \
  --thing-group-name GreengrassQuickStartGroup \
  --component-default-user ggc_user:ggc_group \
  --provision "${GG_PROVISION}" \
  --setup-system-service false \
  --deploy-dev-tools true \
  --init-config ./config.yaml \
  --start "${GG_START}" ${GG_ADDITIONAL_CMD_ARGS}
