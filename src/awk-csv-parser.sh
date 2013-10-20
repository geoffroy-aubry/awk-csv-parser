#!/usr/bin/env bash

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
