#!/usr/bin/env bash

# Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ as an error
# when performing parameter expansion. An error message will be written to the standard error,
# and a non-interactive shell will exit.
set -o nounset

# The return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status,
# or zero if all commands in the pipeline exit successfully:
set -o pipefail

ROOT_DIR=$(cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/.." && pwd)

separator=${1:-','}
quote=${2:-'"'}
output_fs=${3:-'|'}
awk_script=$ROOT_DIR/src/csv-parser.awk

awk \
    -f $awk_script \
    -v separator=$separator \
    -v quote=$quote \
    -v output_fs=$output_fs \
    --source '{csv_parse_and_display($0, separator, quote, output_fs)}'
