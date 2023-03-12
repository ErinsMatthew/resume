#!/usr/bin/env bash

set -o nounset

checkForDependency() {
    #debug "Checking for dependency '$1'."

    if ! command -v "$1" &> /dev/null; then
        echo "Dependency '$1' is missing." > /dev/stderr

        exit
    fi
}

dependencyCheck() {
    local DEPENDENCY

    for DEPENDENCY in $1; do
        checkForDependency "${DEPENDENCY}"
    done
}

dependencyCheck "yq node"

JSON_TEMP_FILE=$(mktemp)

# use yq to convert YAML to JSON
yq . "$1" > "${JSON_TEMP_FILE}"

OUTPUT_DIR=$(dirname "$2")

cp formatters/html/html.css "${OUTPUT_DIR}"

node formatters/html/html.js "${JSON_TEMP_FILE}" > "$2"

rm "${JSON_TEMP_FILE}"
