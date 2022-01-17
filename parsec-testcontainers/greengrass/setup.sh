#!/bin/bash

# Greengrass latest (2.5.0)
mkdir greengrass
cd greengrass
curl -s ${GREENGRASS_RELEASE_URI} > ${GREENGRASS_ZIP_FILE}
unzip ${GREENGRASS_ZIP_FILE}

# prepare config and generate thing name
cat << EOF > config.yaml

EOF
