#!/usr/bin/env bash

set -o nounset

JSON_TEMP_FILE=$(mktemp)

# use yq to convert YAML to JSON
yq . "$1" > "${JSON_TEMP_FILE}"

OUTPUT_DIR=$(dirname "$2")

cp formatters/html/html.css "${OUTPUT_DIR}"

node formatters/html/html.js "${JSON_TEMP_FILE}" > "$2"

rm "${JSON_TEMP_FILE}"
