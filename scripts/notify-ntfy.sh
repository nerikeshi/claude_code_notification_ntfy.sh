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
USER_CMD=""
RESULT=""

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    USER_CMD=$(jq -r 'select(.type == "user") | .message.content[] | select(.type == "text") | .text // empty' "$TRANSCRIPT_PATH" 2>/dev/null | \
        grep -v "^\[Request interrupted" | \
        tail -1 | \
        tr '\n' ' ' | \
        cut -c1-100)

    RESULT=$(jq -r 'select(.type == "assistant") | .message.content[] | select(.type == "text") | .text // empty' "$TRANSCRIPT_PATH" 2>/dev/null | \
        tail -1 | \
        tr '\n' ' ' | \
        cut -c1-100)
fi

MESSAGE=""
if [ -n "$USER_CMD" ]; then
    MESSAGE="Command: ${USER_CMD}"
fi
if [ -n "$RESULT" ]; then
    if [ -n "$MESSAGE" ]; then
        MESSAGE="${MESSAGE}
Result: ${RESULT}"
    else
        MESSAGE="Result: ${RESULT}"
    fi
fi
if [ -z "$MESSAGE" ]; then
    MESSAGE="Task completed"
fi

curl -s \
    -H "Title: ${PROJECT_NAME}" \
    -H "Priority: default" \
    -d "$MESSAGE" \
    "https://${NTFY_SERVER}/${NTFY_TOPIC}" > /dev/null 2>&1

exit 0
