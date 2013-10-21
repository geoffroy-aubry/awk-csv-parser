#!/usr/bin/env bash

# Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ as an error
# when performing parameter expansion. An error message will be written to the standard error,
# and a non-interactive shell will exit.
set -o nounset

# The return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status,
# or zero if all commands in the pipeline exit successfully:
set -o pipefail

ROOT_DIR=$(cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/.." && pwd)
ENCLOSURE='"'
SEPARATOR=','
OUTPUT_SEPARATOR='|'
DISPLAY_HELP=0
IN='-'

function getOpts () {
    local i
    local long_option=''

    for i in "$@"; do
        # Converting short option into long option:
        if [ ! -z "$long_option" ]; then
            i="$long_option=$i"
            long_option=''
        fi

        case $i in
            # Short options:
            -e) long_option="--enclosure" ;;
            -s) long_option="--separator" ;;
            -o) long_option="--output-separator" ;;
            -h) DISPLAY_HELP=1 ;;

            # Long options:
            --enclosure=*)        ENCLOSURE=${i#*=} ;;
            --separator=*)        SEPARATOR=${i#*=} ;;
            --output-separator=*) OUTPUT_SEPARATOR=${i#*=} ;;
            --help)               DISPLAY_HELP=1 ;;

            # CSVs to parse:
            *) [[ $IN == '-' ]] && IN="$i" || IN="$IN $i" ;;
        esac
    done
}

getOpts "$@"
cat $IN | awk \
    -f $ROOT_DIR/src/csv-parser.awk \
    -v separator=$SEPARATOR \
    -v enclosure=$ENCLOSURE \
    -v output_separator=$OUTPUT_SEPARATOR \
    --source '{csv_parse_and_display($0, separator, enclosure, output_separator)}'
