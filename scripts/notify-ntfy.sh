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
    # macOS: tail -r, Linux: tac
    if command -v tac &> /dev/null; then
        REVERSE_CMD="tac"
    else
        REVERSE_CMD="tail -r"
    fi

    USER_CMD=$($REVERSE_CMD "$TRANSCRIPT_PATH" 2>/dev/null | \
        jq -r 'select(.type == "user") | select(.message.content[0].type == "text") | .message.content[0].text // empty' 2>/dev/null | \
        head -1 | \
        tr '\n' ' ' | \
        cut -c1-100)

    RESULT=$($REVERSE_CMD "$TRANSCRIPT_PATH" 2>/dev/null | \
        jq -r 'select(.type == "assistant") | .message.content[0].text // empty' 2>/dev/null | \
        head -1 | \
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
