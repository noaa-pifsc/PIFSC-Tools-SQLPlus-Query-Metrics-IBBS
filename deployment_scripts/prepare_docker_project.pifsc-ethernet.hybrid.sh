#! /bin/bash

# change directory to the folder this script is in to ensure the include .sh script reference is valid
cd "$(dirname "$0")"

# load the PIFSC ethernet hybrid scenario configuration script to set the runtime variable values
. ../docker/src/scripts/sh_script_config/project_scenario_config.pifsc-ethernet.hybrid.sh

# execute the preparation script
. ./prepare_docker_project.sh
