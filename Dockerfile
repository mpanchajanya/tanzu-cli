# Base image and platform
FROM --platform=linux/amd64 ubuntu:latest

# Tanzu CLI version and other build arguments
ARG TANZU_CLI_BUILD_VERSION
ARG TANZU_CLI_CEIP_OPT_IN_PROMPT_ANSWER
ARG TANZU_CLI_E2E_TEST_LOCAL_CENTRAL_REPO_URL
ARG TANZU_CLI_PRE_RELEASE_REPO_IMAGE
ARG TANZU_CLI_PLUGIN_DISCOVERY_IMAGE_SIGNATURE_VERIFICATION_SKIP_LIST
ARG TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_DIR
ARG TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_VERSION
ARG TANZU_CLI_COEXISTENCE_NEW_TANZU_CLI_DIR

# Set environment variables
ENV TANZU_CLI_BUILD_VERSION=$TANZU_CLI_BUILD_VERSION \
    TANZU_CLI_CEIP_OPT_IN_PROMPT_ANSWER=$TANZU_CLI_CEIP_OPT_IN_PROMPT_ANSWER \
    TANZU_CLI_E2E_TEST_LOCAL_CENTRAL_REPO_URL=$TANZU_CLI_E2E_TEST_LOCAL_CENTRAL_REPO_URL \
    TANZU_CLI_PRE_RELEASE_REPO_IMAGE=$TANZU_CLI_PRE_RELEASE_REPO_IMAGE \
    TANZU_CLI_PLUGIN_DISCOVERY_IMAGE_SIGNATURE_VERIFICATION_SKIP_LIST=$TANZU_CLI_PLUGIN_DISCOVERY_IMAGE_SIGNATURE_VERIFICATION_SKIP_LIST \
    TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_DIR=$TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_DIR \
    TANZU_CLI_COEXISTENCE_NEW_TANZU_CLI_DIR=$TANZU_CLI_COEXISTENCE_NEW_TANZU_CLI_DIR \
    TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_VERSION=$TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_VERSION

# Install dependencies and go1.19
RUN apt-get update && \
    apt-get install -y wget gcc vim make git curl && \
    wget https://golang.org/dl/go1.19.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz && \
    rm go1.19.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Setup legacy Tanzu CLI; Fetch the legacy tanzu cli binary
RUN mkdir -p "${TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_DIR}" && \
    wget -P "${TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_DIR}" https://github.com/vmware-tanzu/tanzu-framework/releases/download/"${TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_VERSION}"/tanzu-cli-linux-amd64.tar.gz && \
    tar -xvf "${TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_DIR:?}"/tanzu-cli-linux-amd64.tar.gz -C "${TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_DIR}" && \
    mv "${TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_DIR}"/"${TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_VERSION}"/tanzu-core-linux_amd64 "${TANZU_CLI_COEXISTENCE_LEGACY_TANZU_CLI_DIR}"/tanzu

# Copy source code
WORKDIR /app/src
COPY . /app/src/

# Build the application
RUN make build

# Copy the built tanzu binary to the new tanzu cli location
RUN mkdir -p ${TANZU_CLI_COEXISTENCE_NEW_TANZU_CLI_DIR} && \
    cp -r ./bin/tanzu ${TANZU_CLI_COEXISTENCE_NEW_TANZU_CLI_DIR}

CMD ["bash"]