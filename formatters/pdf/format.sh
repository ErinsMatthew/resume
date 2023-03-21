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

dependencyCheck "wkhtmltopdf yq"

# format YAML as HTML
TEMP_DIR=$(mktemp -d)

cp formatters/html/html.css "${TEMP_DIR}"

HTML_TEMP_FILE=${TEMP_DIR}/resume.html

YAML_SOURCE_FILE="$1"

formatters/html/format.sh "${YAML_SOURCE_FILE}" "${HTML_TEMP_FILE}"

source formatters/pdf/headers_footers.sh

# convert temporary HTML file to PDF
eval wkhtmltopdf \
  --enable-local-file-access \
  --log-level error \
  "${FOOTER_OPTIONS}" \
  "${HEADER_OPTIONS}" \
  "${HTML_TEMP_FILE}" "$2"

rm -r "${TEMP_DIR}"
