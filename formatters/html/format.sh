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

dependencyCheck "mktemp node realpath yq"

JSON_TEMP_FILE=$(mktemp)
TEMPLATE_FILE=$(realpath 'formatters/html/template.html.hbs')

# use yq to convert YAML to JSON
yq . "$1" > "${JSON_TEMP_FILE}"

OUTPUT_DIR=$(dirname "$2")

cp formatters/html/html.css "${OUTPUT_DIR}"

node formatters/html/html.js \
  --json="${JSON_TEMP_FILE}" \
  --template="${TEMPLATE_FILE}" > "$2"

rm "${JSON_TEMP_FILE}"
