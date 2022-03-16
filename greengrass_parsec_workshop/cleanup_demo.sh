#!/bin/bash
set -e

# Cleanup the container's that are started in the `build_demo.sh` script
docker rm -f greengrass_demo_run
docker rm -f parsec_docker_run
