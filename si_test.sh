#!/bin/sh
add_si() {
    num1=$(printf "%s\n" "$1" | numfmt --from=iec)
    num2=$(printf "%s\n" "$2" | numfmt --from=iec)
    sum=$((num1 + num2))
    printf "%s\n" "$sum" | numfmt --to=iec
}
add_si 1GiB 2MiB