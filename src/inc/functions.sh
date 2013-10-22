#!/usr/bin/env bash

##
# Parse command options.
#
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
            -o) long_option="--output-separator" ;;
            -s) long_option="--separator" ;;
            -[^-]*) displayHelp; exit 0 ;;

            # Long options:
            --enclosure=*)        ENCLOSURE=${i#*=} ;;
            --output-separator=*) OUTPUT_SEPARATOR=${i#*=} ;;
            --separator=*)        SEPARATOR=${i#*=} ;;
            --*)                  displayHelp; exit 0 ;;

            # CSVs to parse:
            *) [[ $IN == '-' ]] && IN="$i" || IN="$IN $i" ;;
        esac
    done
}

##
# Help.
#
function displayHelp () {
    local normal='\033[0;37m'
    local title='\033[1;37m'
    local tab='\033[0;30m┆\033[0m   '$normal
    local opt='\033[1;33m'
    local param='\033[1;36m'
    local cmd='\033[0;36m'

    echo -e "
${title}Description
${tab}AWK and Bash code to easily parse CSV files, with possibly embedded commas and quotes.

${title}Usage
$tab${cmd}$(basename $0) $normal[${opt}OPTION$normal]… $normal[$param<CSV-file>$normal]…

${title}Options
$tab$opt-e $param<character>$normal, $opt--enclosure$normal=$param<character>
$tab${tab}Set the CSV field enclosure. One character only, '\"' (double quote) by default.
$tab
$tab$opt-o $param<string>$normal, $opt--output-separator$normal=$param<string>
$tab${tab}Set the output field enclosure. Multiple characters allowed, '|' (pipe) by default.
$tab
$tab$opt-s $param<character>$normal, $opt--separator$normal=$param<character>
$tab${tab}Set the CSV field separator. One character only, ',' (comma) by default.
$tab
$tab$opt-h$normal, $opt--help
$tab${tab}Display this help.
$tab
$tab$param<CSV-file>
$tab${tab}CSV file to parse.

${title}Discussion
${tab}– The last record in the file may or may not have an ending line break.
${tab}– Each line may not contain the same number of fields throughout the file.
${tab}– The last field in the record must not be followed by a field separator.
${tab}– Fields containing field enclosures or field separators must be enclosed in field
${tab}  enclosure.
${tab}– A field enclosure appearing inside a field must be escaped by preceding it with
${tab}  another field enclosure. Example: \"aaa\",\"b\"\"bb\",\"ccc\"

${title}Examples
${tab}Parse a CSV and display records without field enclosure, fields pipe-separated:
$tab$tab${cmd}$(basename $0) $opt--output-separator$normal=$param'|' resources/iso_3166-1.csv
$tab
${tab}Remove CSV's header before parsing:
$tab$tab${cmd}tail -n+2 resources/iso_3166-1.csv | $(basename $0)
$tab
${tab}Keep only first column of multiple files:
$tab$tab${cmd}$(basename $0) ${param}a.csv b.csv c.csv$cmd | cut -d'|' -f1
$tab
${tab}Keep only first column, using multiple UTF-8 characters output separator:
$tab$tab${cmd}$(basename $0) $opt-o $param'⇒⇒' resources/iso_3166-1.csv$cmd | awk -F '⇒⇒' '{print \$1}'
$tab
${tab}You can directly call the Awk script:
$tab$tab${cmd}awk -f csv-parser.awk -v separator=',' -v enclosure='\"' --source '{
$tab$tab${cmd}    csv_parse_record($0, separator, enclosure, csv)
$tab$tab${cmd}    print csv[2] \" ⇒ \" csv[0]
$tab$tab${cmd}}' resources/iso_3166-1.csv
"
}
