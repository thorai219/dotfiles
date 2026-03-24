#!/usr/bin/env bash

cava -p ~/.config/cava/config | while read -r line; do
    clean=$(echo "$line" | tr -d ';')

    if [[ "$clean" =~ ^0+$ ]]; then
        echo " "
    else
        echo "$clean" | sed -u \
            -e 's/0/ /g' \
            -e 's/1/▂/g' \
            -e 's/2/▃/g' \
            -e 's/3/▄/g' \
            -e 's/4/▅/g' \
            -e 's/5/▆/g' \
            -e 's/6/▇/g' \
            -e 's/7/█/g' \
            -e 's/8/▉/g' \
            -e 's/9/▊/g'
    fi
done
