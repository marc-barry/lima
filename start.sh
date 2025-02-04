#!/bin/bash

# Check for required environment variables
required_vars=("MACHINE_NAME" "DOCKER_CONTEXT" "DEV_DIR")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
    echo "Error: Missing required environment variables: ${missing_vars[*]}"
    echo "Please ensure all required variables are set in your environment or .env file"
    exit 1
fi

# custom start arguments for limactl
LIMACTL_ARGS=()

# Check that Brew is installed
if ! command -v brew &> /dev/null
then
    echo "Brew could not be found, please install it from https://brew.sh/"
    exit 1
fi

# Check if limactl is installed and if not, install it
if ! command -v limactl &> /dev/null
then
    echo "limactl could not be found, installing..."
    brew install lima
fi

# Check if the machine exists and create it if it doesn't
if ! limactl list | grep -q "${MACHINE_NAME}"
then
    echo "Machine ${MACHINE_NAME} does not exist, creating..."
    limactl start --name ${MACHINE_NAME} --mount="${DEV_DIR}:w" "${LIMACTL_ARGS[@]}" ./machine.yaml
fi

# Check if the machine is running
 if ! limactl list | grep -q "${MACHINE_NAME}\s*Running"
then
    echo "Machine ${MACHINE_NAME} is not running, starting..."
    limactl start ${MACHINE_NAME}
else
    echo "Machine ${MACHINE_NAME} is already running."
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker could not be found, installing..."
    brew install docker docker-buildx
fi

# Check if docker-buildx is installed
if ! command -v docker-buildx &> /dev/null
then
    echo "docker-buildx could not be found, installing..."
    brew install docker-buildx
fi

# Check if the Docker context exists and remove if broken
if ! docker context inspect "${DOCKER_CONTEXT}" >/dev/null 2>&1; then
    docker context rm "${DOCKER_CONTEXT}" 2>/dev/null || true
    echo "Creating Docker context ${DOCKER_CONTEXT}..."
    docker context create "${DOCKER_CONTEXT}" --docker "host=unix://$HOME/.lima/${MACHINE_NAME}/sock/docker.sock"
fi

# Set the Docker context
docker context use "${DOCKER_CONTEXT}"

# Print the Docker context
echo "Docker context set to ${DOCKER_CONTEXT}."

