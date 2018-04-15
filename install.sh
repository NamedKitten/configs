#!/usr/bin/env bash
set -e
trap "echo '==> Command failed to execute!'; exit 1" ERR
source /etc/os-release
bash "./scripts/platforms/$ID_LIKE.sh"
