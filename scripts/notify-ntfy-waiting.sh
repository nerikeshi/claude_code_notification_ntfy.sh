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

INPUT=$(cat)

# permission_prompt 以外は通知しない（idle_prompt などをスキップ）
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // empty' 2>/dev/null)
if [ "$NOTIFICATION_TYPE" != "permission_prompt" ]; then
    exit 0
fi

PROJECT_NAME=$(basename "$(pwd)")

MESSAGE="Your input or approval is required"

curl -s \
    -H "Title: ${PROJECT_NAME}" \
    -H "Priority: high" \
    -d "$MESSAGE" \
    "https://${NTFY_SERVER}/${NTFY_TOPIC}" > /dev/null 2>&1

exit 0
