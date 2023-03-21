#!/usr/bin/env bash
#
# From wkhtmltopdf --extended-help:
#
# Headers And Footer Options:
#       --footer-center <text>          Centered footer text
#       --footer-font-name <name>       Set footer font name (default Arial)
#       --footer-font-size <size>       Set footer font size (default 12)
#       --footer-html <url>             Adds a html footer
#       --footer-left <text>            Left aligned footer text
#       --footer-line                   Display line above the footer
#       --no-footer-line                Do not display line above the footer
#                                       (default)
#       --footer-right <text>           Right aligned footer text
#       --footer-spacing <real>         Spacing between footer and content in mm
#                                       (default 0)
#       --header-center <text>          Centered header text
#       --header-font-name <name>       Set header font name (default Arial)
#       --header-font-size <size>       Set header font size (default 12)
#       --header-html <url>             Adds a html header
#       --header-left <text>            Left aligned header text
#       --header-line                   Display line below the header
#       --no-header-line                Do not display line below the header
#                                       (default)
#       --header-right <text>           Right aligned header text
#       --header-spacing <real>         Spacing between header and content in mm
#                                       (default 0)
#       --replace <name> <value>        Replace [name] with value in header and
#                                       footer (repeatable)

CANDIDATE_NAME=$(yq -r '.name' "${YAML_SOURCE_FILE}")

buildFooterOptions() {
    local FOOTER_CENTER=''
    local FOOTER_FONT_NAME=''
    local FOOTER_FONT_SIZE='8'
    local FOOTER_HTML=''
    local FOOTER_LEFT=''
    local FOOTER_RIGHT="[Resume of ${CANDIDATE_NAME}, Page [page] of [topage]]"
    local FOOTER_SPACING=''
    local FOOTER_LINE='false'

    declare -a OPTIONS=()

    if [[ -n ${FOOTER_CENTER} ]]; then
        OPTIONS+=("--footer-center \"${FOOTER_CENTER}\"")
    fi

    if [[ -n ${FOOTER_FONT_NAME} ]]; then
        OPTIONS+=("--footer-font-name \"${FOOTER_FONT_NAME}\"")
    fi

    if [[ -n ${FOOTER_FONT_SIZE} ]]; then
        OPTIONS+=("--footer-font-size \"${FOOTER_FONT_SIZE}\"")
    fi

    if [[ -n ${FOOTER_HTML} ]]; then
        OPTIONS+=("--footer-html \"${FOOTER_HTML}\"")
    fi

    if [[ -n ${FOOTER_LEFT} ]]; then
        OPTIONS+=("--footer-left \"${FOOTER_LEFT}\"")
    fi

    if [[ -n ${FOOTER_RIGHT} ]]; then
        OPTIONS+=("--footer-right \"${FOOTER_RIGHT}\"")
    fi

    if [[ -n ${FOOTER_SPACING} ]]; then
        OPTIONS+=("--footer-spacing \"${FOOTER_SPACING}\"")
    fi

    if [[ ${FOOTER_LINE} == 'true' ]]; then
        OPTIONS+=("--footer-line")
    else
        OPTIONS+=("--no-footer-line")
    fi

    echo "${OPTIONS[@]}"
}

buildHeaderOptions() {
    local HEADER_CENTER=''
    local HEADER_FONT_NAME=''
    local HEADER_FONT_SIZE=''
    local HEADER_HTML=''
    local HEADER_LEFT=''
    local HEADER_RIGHT=''
    local HEADER_SPACING=''
    local HEADER_LINE='false'

    declare -a OPTIONS=()

    if [[ -n ${HEADER_CENTER} ]]; then
        OPTIONS+=("--header-center \"${HEADER_CENTER}\"")
    fi

    if [[ -n ${HEADER_FONT_NAME} ]]; then
        OPTIONS+=("--header-font-name \"${HEADER_FONT_NAME}\"")
    fi

    if [[ -n ${HEADER_FONT_SIZE} ]]; then
        OPTIONS+=("--header-font-size \"${HEADER_FONT_SIZE}\"")
    fi

    if [[ -n ${HEADER_HTML} ]]; then
        OPTIONS+=("--header-html \"${HEADER_HTML}\"")
    fi

    if [[ -n ${HEADER_LEFT} ]]; then
        OPTIONS+=("--header-left \"${HEADER_LEFT}\"")
    fi

    if [[ -n ${HEADER_RIGHT} ]]; then
        OPTIONS+=("--header-right \"${HEADER_RIGHT}\"")
    fi

    if [[ -n ${HEADER_SPACING} ]]; then
        OPTIONS+=("--header-spacing \"${HEADER_SPACING}\"")
    fi

    if [[ ${HEADER_LINE} == 'true' ]]; then
        OPTIONS+=("--header-line")
    else
        OPTIONS+=("--no-header-line")
    fi

    echo "${OPTIONS[@]}"
}

# build footer and header options
FOOTER_OPTIONS=$(buildFooterOptions)

HEADER_OPTIONS=$(buildHeaderOptions)
