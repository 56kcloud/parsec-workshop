#!/bin/bash

if [ $# -ne 3 ]
then
    echo "Please supply AWS access key id, secret key, and thing name prefix, in that order"
fi
## Create one thing per enviroment this code runs on
export THING_NAME=$1-gg-parsec
export AWS_ACCESS_KEY_ID=$2
export AWS_SECRET_ACCESS_KEY=43
export AWS_REGION=eu-central-1


# Provision: this could run in the docker build, but we need AWS credentials.
# AWS IOT Thing, Idempotent
aws iot create-thing --thing-name ${THING_NAME}
# Greengrass keys
java -Droot=/home/ggc_user/gg_root -Dlog.store=CONSOLE -jar /home/ggc_user/greengrass/lib/Greengrass.jar --aws-region ${AWS_REGION} --thing-name "${THING_NAME}" --thing-group-name GreengrassQuickStartGroup --component-default-user ggc_user:ggc_group --provision true --setup-system-service false --deploy-dev-tools true --init-config /home/ggc_user/greengrass/config.yaml --trusted-plugin pkcs11-provider-2.0.0-SNAPSHOT.jar --start false

# Run, shouldn't
java -Droot=/home/ggc_user/gg_root -Dlog.store=CONSOLE -jar /home/ggc_user/greengrass/lib/Greengrass.jar --aws-region ${AWS_REGION} --thing-name "${THING_NAME}" --thing-group-name GreengrassQuickStartGroup --component-default-user ggc_user:ggc_group --provision false --setup-system-service false --deploy-dev-tools true --init-config /home/ggc_user/greengrass/config.yaml --trusted-plugin pkcs11-provider-2.0.0-SNAPSHOT.jar
