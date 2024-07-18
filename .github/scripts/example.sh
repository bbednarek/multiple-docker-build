#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
    echo 'Too many/few arguments, expecting one' >&2
    exit 1
fi

if [ -z "$1" ]; then
  echo "ERROR: Usage is: $(basename $0) failure|success"
  exit 1
fi

case $1 in
    "failure")
      echo "Failure"
      echo "status=failure" >> "$GITHUB_OUTPUT"
      ;;
    "success")
      echo "Success"
      echo "status=success" >> "$GITHUB_OUTPUT"
      ;;
    *)
      echo "Invalid option: $1"
      echo "Usage: $(basename $0) failure|success"
      ;;
esac
