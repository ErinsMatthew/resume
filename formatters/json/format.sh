#!/usr/bin/env bash

set -o nounset

# use yq to convert YAML to JSON
yq . "$1" > "$2"
