#!/bin/bash

# Load default environment variables
if [ -f .env_default ]; then
    echo "Loading default .env_default"
    # Convert and source the environment variables
    set -a
    # shellcheck disable=SC1090
    grep -v '^#' .env_default | sed 's/LIMACTL_ARGS=.*$//' > .env_default.tmp
    source .env_default.tmp
    rm .env_default.tmp
    set +a
fi

# Load custom environment variables (override defaults)
if [ -f .env ]; then
    echo "Loading custom .env"
    # Convert and source the environment variables
    set -a
    # shellcheck disable=SC1090
    grep -v '^#' .env | sed 's/LIMACTL_ARGS=.*$//' > .env.tmp
    source .env.tmp
    rm .env.tmp
    set +a
fi
