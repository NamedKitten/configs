#!/usr/bin/env bash
set -e
trap "echo '==> Command failed to execute!'; exit 1" ERR
source /etc/os-release
if [ "$ID_LIKE" ]; then
    bash "./scripts/platforms/$ID_LIKE.sh"
elif [ "$ID" ]; then
    bash "./scripts/platforms/$ID.sh"
fi
