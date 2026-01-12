#!/usr/bin/env bash

if [[ -z "$1" ]]; then
    echo You did not specify an action
    exit 1
fi

action="$1"

reset() {
    eww update calendar-selected-year="$(date +%Y)" calendar-selected-month="$(date +%m)"
    "@calPy@"
}

month_down() {
    month="$(eww get calendar-selected-month | sed 's/^0*//')"
    year="$(eww get calendar-selected-year | sed 's/^0*//')"
    if [[ "$month" == 1 ]]; then
        month=12
        year=$((year - 1))
    else
        month=$((month - 1))
    fi
    eww update calendar-selected-month="$month" calendar-selected-year="$year"
    "@calPy@"
}

month_up() {
    month="$(eww get calendar-selected-month | sed 's/^0*//')"
    year="$(eww get calendar-selected-year | sed 's/^0*//')"
    if [[ "$month" == 12 ]]; then
        month=1
        year=$((year + 1))
    else
        month=$((month + 1))
    fi
    eww update calendar-selected-month="$month" calendar-selected-year="$year"
    "@calPy@"
}

year_down() {
    year="$(eww get calendar-selected-year)"
    eww update calendar-selected-year=$((year - 1))
    "@calPy@"
}

year_up() {
    year="$(eww get calendar-selected-year)"
    eww update calendar-selected-year=$((year + 1))
    "@calPy@"
}

$action
