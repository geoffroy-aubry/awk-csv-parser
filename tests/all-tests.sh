#!/usr/bin/env bash

# Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ as an error
# when performing parameter expansion. An error message will be written to the standard error,
# and a non-interactive shell will exit.
set -o nounset

# The return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status,
# or zero if all commands in the pipeline exit successfully:
set -o pipefail

TEST_DIR=$(cd "$(dirname "$(readlink -f "$BASH_SOURCE")")" && pwd)
RESOURCES_DIR=$TEST_DIR/resources

ok_path="$(mktemp /tmp/awk-csv-parser-XXXXXXXXXX)";
cat tests/resources/ok.csv | src/awk-csv-parser.sh ',' '"' '|' > $ok_path
diff --report-identical-files $ok_path $RESOURCES_DIR/ok-expected.txt
# \ && …
