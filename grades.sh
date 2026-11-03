#!/usr/bin/env bash

set -o pipefail

# Display usage
usage() {
    echo "Usage: $0 FILE.csv" >&2
}

# Display error and exit
die() {
    echo "Error: $1" >&2
    exit 1
}

# Trim spaces and remove Windows carriage returns
trim() {
    local value="$1"
    value="${value//$'\r'/}"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    printf '%s' "$value"
}

# Create the grade report
create_report() {
    local file="$1"
    local tmp
    local line_number=1
    local skipped=0
    local total_sum=0
    local student_count=0
    local rank=0
    local valid=true

    tmp=$(mktemp) || die "Cannot create temporary file."

    while IFS=',' read -r name html css bash git || [[ -n "$name$html$css$bash$git" ]]; do
        ((line_number++))

        # Clean each value
        name=$(trim "$name")
        html=$(trim "$html")
        css=$(trim "$css")
        bash=$(trim "$bash")
        git=$(trim "$git")

        # Validate student name
        if [[ -z "$name" ]]; then
            echo "Warning: Invalid line $line_number: missing name." >&2
            ((skipped++))
            continue
        fi

        # Validate all four scores
        valid=true

        for score in "$html" "$css" "$bash" "$git"; do
            if [[ ! "$score" =~ ^[0-9]+$ ]] || (( score > 20 )); then
                valid=false
                break
            fi
        done

        if [[ "$valid" == false ]]; then
            echo "Warning: Invalid line $line_number: missing or invalid score." >&2
            ((skipped++))
            continue
        fi

        # Calculate total and average
        local total=$((html + css + bash + git))
        local avg

        avg=$(awk -v total="$total" 'BEGIN { printf "%.2f", total / 4 }')

        # Determine mention using total
        local mention

        if (( total >= 64 )); then
            mention="Très bien"
        elif (( total >= 56 )); then
            mention="Bien"
        elif (( total >= 48 )); then
            mention="Assez bien"
        elif (( total >= 40 )); then
            mention="Passable"
        else
            mention="Échec"
        fi

        # Save valid student record
        printf '%s|%s|%s|%s|%s|%s|%s\n' \
            "$avg" "$name" "$html" "$css" "$bash" "$git" "$mention" >> "$tmp" ||
            {
                rm -f "$tmp"
                die "Cannot write temporary file."
            }

        total_sum=$((total_sum + total))
        ((student_count++))

    done < <(tail -n +2 "$file")

    # Display report
    printf "\n"
    printf "%4d  %-16s %5s %5s %5s %5s %6s  %s\n" \
    "$rank" "$name" "$html" "$css" "$bash" "$git" "$avg" "$mention"

    rank=0

    while IFS='|' read -r avg name html css bash git mention; do
        ((rank++))

        printf "%4d  %-16s %4s %4s %4s %4s %6s  %s\n" \
            "$rank" "$name" "$html" "$css" "$bash" "$git" "$avg" "$mention"

    done < <(sort -t'|' -k1,1nr "$tmp")

    printf '%s\n' "------------------------------------------------------------"

    if (( student_count > 0 )); then
        local class_avg
        class_avg=$(awk -v total="$total_sum" -v count="$student_count" \
            'BEGIN { printf "%.2f", total / (count * 4) }')

        printf "Class average: %s\n" "$class_avg"
    else
        printf "Class average: 0.00\n"
    fi

    printf "Skipped %d invalid lines (see warnings above)\n" "$skipped"

    rm -f "$tmp"
}

# Main function
main() {
    if [[ $# -ne 1 ]]; then
        usage
        exit 2
    fi

    local file="$1"

    [[ -f "$file" && -r "$file" ]] || die "File does not exist or cannot be read."

    create_report "$file"
}

main "$@"
