#!/usr/bin/env bash

set -o nounset

# enable extended pattern matching features
shopt -s extglob

usage() {
    cat << EOT 1>&2
Usage: generate.sh [-d] [-f fmt] [-b basename] dir

OPTIONS
=======
-b basename  use 'basename' for output file; default: resume
-f fmt       format option: a valid formatter or 'all'; default: pdf
-d           output debug information
-i fn        use 'fn' for input file; default: matthew.yml
-h           show help

ARGUMENTS
=========
dir          directory to write output files

EXAMPLES
========
# generate a PDF version of resume.yml and output to current directory
$ generate.sh -d -i resume.yml -f pdf .

EOT

    exit
}

initGlobals() {
    declare -gA GLOBALS=(
        [BASENAME]=''                   # -b
        [DEBUG]='false'                 # -d
        [FORMAT]=''                     # -f
        [FORMATTERS_DIR]='formatters'
        [INPUT_FILE]=''                 # -i
        [OUTPUT_DIR]=''                 # dir
        [VALID_FORMATTERS]=''
    )
}

debug() {
    if [[ ${GLOBALS[DEBUG]} == 'true' ]]; then
        echo "$@"
    fi
}

loadValidFormatters() {
    GLOBALS[VALID_FORMATTERS]=$(find "${GLOBALS[FORMATTERS_DIR]}" -depth 2 -type f -name format.sh -print0 | xargs -0 -I{} dirname {} | xargs -I{} basename {} | grep -v 'all' | tr '\n' '|' | sed -e 's/|$//')
}

processOptions() {
    local FLAG
    local OPTARG
    local OPTIND

    [[ $# -eq 0 ]] && usage

    while getopts ":b:df:hi:" FLAG; do
        case "${FLAG}" in
            b)
                GLOBALS[BASENAME]=${OPTARG}

                debug "Basename set to '${GLOBALS[BASENAME]}'."
                ;;

            d)
                GLOBALS[DEBUG]='true'

                debug "Debug mode turned on."
                ;;

            f)
                if [[ ${OPTARG} == 'all' ]]; then
                    GLOBALS[FORMAT]='all'

                    debug "Generating all formats."
                elif [[ ${OPTARG} == @(${GLOBALS[VALID_FORMATTERS]}) ]]; then
                    GLOBALS[FORMAT]=${OPTARG}

                    debug "Setting format to '${GLOBALS[FORMAT]}'."
                else
                    echo "Invalid format '${OPTARG}'." > /dev/stderr

                    usage
                fi
                ;;

            i)
                GLOBALS[INPUT_FILE]=${OPTARG}

                debug "Input file set to '${GLOBALS[INPUT_FILE]}'."
                ;;

            h | *)
                usage
                ;;
        esac
    done

    shift $(( OPTIND - 1 ))

    [[ $# -eq 0 ]] && usage

    GLOBALS[OUTPUT_DIR]=$(realpath "$1")
}

validateInputs() {
    if [[ -z ${GLOBALS[OUTPUT_DIR]} ]]; then
        echo "Missing output directory." > /dev/stderr

        usage
    fi

    debug "Valid formatters set to '${GLOBALS[VALID_FORMATTERS]}'."
}

setDefaults() {
    if [[ -z ${GLOBALS[BASENAME]} ]]; then
        GLOBALS[BASENAME]='resume'

        debug "Basename set to default of '${GLOBALS[BASENAME]}'."
    fi

    if [[ -z ${GLOBALS[FORMAT]} ]]; then
        GLOBALS[FORMAT]='pdf'

        debug "Format set to default of '${GLOBALS[FORMAT]}'."
    fi

    if [[ -z ${GLOBALS[INPUT_FILE]} ]]; then
        GLOBALS[INPUT_FILE]='matthew.yml'

        debug "Input file set to default of '${GLOBALS[INPUT_FILE]}'."
    fi
}

checkForDependency() {
    debug "Checking for dependency '$1'."

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

performSetup() {
    initGlobals

    loadValidFormatters

    processOptions "$@"

    validateInputs

    setDefaults

    dependencyCheck "cat find realpath sed tr xargs"
}

formatResume() {
    local OUTPUT_FILE

    OUTPUT_FILE=${GLOBALS[OUTPUT_DIR]}/${GLOBALS[BASENAME]}.$1

    debug "Formatting resume '${OUTPUT_FILE}'."

    eval "${GLOBALS[FORMATTERS_DIR]}/$1/format.sh '${GLOBALS[INPUT_FILE]}' '${OUTPUT_FILE}'"
}

generateResume() {
    local FORMAT

    if [[ ${GLOBALS[FORMAT]} == 'all' ]]; then
        OIFS=${IFS}

        IFS=\|

        for FORMAT in ${GLOBALS[VALID_FORMATTERS]}; do
            formatResume "${FORMAT}"
        done

        IFS=${OIFS}
    else
        formatResume "${GLOBALS[FORMAT]}"
    fi
}

performSetup "$@"

generateResume
