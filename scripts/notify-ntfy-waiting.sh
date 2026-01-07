#!/bin/bash
#
# Claude Code 入力待ち通知スクリプト
#

CONFIG_FILE="$HOME/.claude/scripts/ntfy-config"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    exit 1
fi

PROJECT_NAME=$(basename "$(pwd)")

MESSAGE="Your input or approval is required"

curl -s \
    -H "Title: ${PROJECT_NAME}" \
    -H "Priority: high" \
    -d "$MESSAGE" \
    "https://${NTFY_SERVER}/${NTFY_TOPIC}" > /dev/null 2>&1

exit 0
