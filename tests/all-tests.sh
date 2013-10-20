#!/usr/bin/env bash

TEST_DIR=$(cd "$(dirname "$(readlink -f "$BASH_SOURCE")")" && pwd)
RESOURCES_DIR=$TEST_DIR/resources

ok_path="$(mktemp /tmp/awk-csv-parser-XXXXXXXXXX)";
cat tests/resources/ok.csv | src/awk-csv-parser.sh ',' '"' '|' > $ok_path
diff --report-identical-files $ok_path $RESOURCES_DIR/ok-expected.txt
# \ && …
