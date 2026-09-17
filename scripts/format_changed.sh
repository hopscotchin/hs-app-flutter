#!/bin/sh
# This script is used to format the changed Dart files in the current branch.
# Run this script to format the changed Dart files in the current branch.
# (IMPORTANT) make it executable by running (by running this command in the terminal only once): 
# chmod +x scripts/format_changed.sh
# and then run (by running this command in the terminal whenever you want to format the changed Dart files):
# ./scripts/format_changed.sh

ALL=$(
  { git diff --name-only --diff-filter=ACM; git diff --cached --name-only --diff-filter=ACM; } \
    | grep '\.dart$' | sort -u
)

if [ -z "$ALL" ]; then
  echo "No changed Dart files to format."
  exit 0
fi

echo "Formatting changed Dart files..."
echo "$ALL" | xargs dart format
echo "Done."
