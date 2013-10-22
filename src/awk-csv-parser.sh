#!/usr/bin/env bash

# Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ as an error
# when performing parameter expansion. An error message will be written to the standard error,
# and a non-interactive shell will exit.
set -o nounset

# The return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status,
# or zero if all commands in the pipeline exit successfully:
set -o pipefail

# Globals:
ROOT_DIR=$(cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/.." && pwd)
ENCLOSURE='"'
SEPARATOR=','
OUTPUT_SEPARATOR='|'
IN='-'

# Includes:
. $ROOT_DIR/src/inc/functions.sh

# Main:
getOpts "$@"
cat $IN | awk \
    -f $ROOT_DIR/src/csv-parser.awk \
    -v separator=$SEPARATOR \
    -v enclosure=$ENCLOSURE \
    -v output_separator=$OUTPUT_SEPARATOR \
    --source '{csv_parse_and_display($0, separator, enclosure, output_separator)}'
