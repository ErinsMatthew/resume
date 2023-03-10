#!/usr/bin/env bash

set -o nounset

# format YAML as HTML
HTML_TEMP_FILE=$(mktemp)

formatters/html/format.sh "$1" "${HTML_TEMP_FILE}"

# convert temporary HTML file to PDF
wkhtmltopdf - "$2" < "${HTML_TEMP_FILE}"

rm "${HTML_TEMP_FILE}"
