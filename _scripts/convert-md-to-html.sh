#!/bin/bash

echo "Converting $1 to $2..."
if ! pandoc \
  --standalone \
  --css=style.css \
  "$1" \
  -o "$2"; \
  then
  echo "A problem occurred when attempting to convert $1 to HTML"
  exit 1
fi
