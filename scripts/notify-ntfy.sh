#!/bin/bash
#
# Claude Code タスク完了時 ntfy.sh 通知スクリプト
#

CONFIG_FILE="$HOME/.claude/scripts/ntfy-config"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    exit 1
fi

INPUT=$(cat)
PROJECT_NAME=$(basename "$(pwd)")

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
RESULT=""

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    RESULT=$(jq -r 'select(.type == "assistant") | .message.content[] | select(.type == "text") | .text // empty' "$TRANSCRIPT_PATH" 2>/dev/null | \
        tail -1 | \
        tr '\n' ' ' | \
        cut -c1-200)
fi

MESSAGE="${RESULT:-Task completed}"

curl -s \
    -H "Title: ${PROJECT_NAME}" \
    -H "Priority: default" \
    -d "$MESSAGE" \
    "https://${NTFY_SERVER}/${NTFY_TOPIC}" > /dev/null 2>&1

exit 0
