#!/usr/bin/env bash

set -o nounset

JSON_TEMP_FILE=$(mktemp)

yq . "$1" > "${JSON_TEMP_FILE}"

node formatters/html/html.js "${JSON_TEMP_FILE}" > "$2"

rm "${JSON_TEMP_FILE}"
