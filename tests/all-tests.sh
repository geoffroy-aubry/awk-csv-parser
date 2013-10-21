#!/usr/bin/env bash

# Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’ as an error
# when performing parameter expansion. An error message will be written to the standard error,
# and a non-interactive shell will exit.
set -o nounset

# The return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status,
# or zero if all commands in the pipeline exit successfully:
set -o pipefail

ROOT_DIR=$(cd "$(dirname "$(readlink -f "$BASH_SOURCE")")/.." && pwd)
SRC_DIR=$ROOT_DIR/src
TESTS_DIR=$ROOT_DIR/tests
RESOURCES_DIR=$TESTS_DIR/resources

status=0
for tests_set in ok invalid; do
    echo -e "\033[1;37mTesting $RESOURCES_DIR/$tests_set.csv:\033[0m"
    tmp_path="$(mktemp /tmp/awk-csv-parser-XXXXXXXXXX)";
    cat $RESOURCES_DIR/$tests_set.csv \
        | $SRC_DIR/awk-csv-parser.sh ',' '"' '|' \
        | sed -r 's:(\033|\x1B)\[[0-9;]*[mK]::ig' \
        > $tmp_path
    diff --report-identical-files $tmp_path $RESOURCES_DIR/$tests_set-expected.txt
    status=$(( $? | status))
done

echo
if [ $status -ne 0 ]; then
    echo -e "\033[1;37;41m\033[0K Tests FAILED!\033[0m\n"
else
    echo -e "\033[1;37;42m\033[0K Tests OK.\033[0m\n"
fi
exit $status
