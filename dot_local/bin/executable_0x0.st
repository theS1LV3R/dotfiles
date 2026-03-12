#!/usr/bin/env bash
# vi: ft=bash

filename="$1"
expires=24 # hours

curl -F "file=@$filename" -F "expires=$expires" https://0x0.st
