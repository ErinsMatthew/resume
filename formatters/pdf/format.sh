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

dependencyCheck "wkhtmltopdf"

# format YAML as HTML
TEMP_DIR=$(mktemp -d)

cp formatters/html/html.css "${TEMP_DIR}"

HTML_TEMP_FILE=${TEMP_DIR}/resume.html

formatters/html/format.sh "$1" "${HTML_TEMP_FILE}"

# convert temporary HTML file to PDF
wkhtmltopdf --enable-local-file-access "${HTML_TEMP_FILE}" "$2"

rm -r "${TEMP_DIR}"
