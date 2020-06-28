#!/bin/bash

PROJECT_DIRECTORY="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)")"

echo "Converting $1 to $2..."
if ! docker run \
  --rm \
  --mount "type=bind,source=$PROJECT_DIRECTORY,destination=/data" \
  --userns=host \
  --user "$(id -u):$(id -g)" \
  pandoc/core \
  pandoc \
  --self-contained \
  --css=style.css \
  "$1" \
  -o "$2"; \
  then
  echo "A problem occurred when attempting to convert $1 to HTML"
  exit 1
fi
