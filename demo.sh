#!/usr/bin/env bash

ROOT_DIR=$(dirname "$0")

tail -n+2 $ROOT_DIR/resources/iso_3166-1.csv \
    | $ROOT_DIR/src/awk-csv-parser.sh \
    | cut -d'|' -f1 | grep --color=always ,
