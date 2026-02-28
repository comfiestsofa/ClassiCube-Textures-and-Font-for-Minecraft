#!/usr/bin/env bash
exiftool -all= -overwrite_original "$@"
oxipng -o max -p -vvvvvvvv --fix -Z "$@"
