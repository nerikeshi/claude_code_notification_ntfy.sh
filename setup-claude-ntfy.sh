#!/bin/bash
#
# Claude Code × ntfy.sh セットアップスクリプト
# 使用方法: ./setup-claude-ntfy.sh [トピック名]
#
# トピック名を省略するとランダム生成されます
#

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ロゴ表示
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║   Claude Code × ntfy.sh セットアップ                     ║"
echo "║   タスク完了時にスマホへプッシュ通知                     ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# トピック名の設定
if [ -n "$1" ]; then
    TOPIC="$1"
else
    # ランダムなトピック名を生成（推測されにくいように）
    TOPIC="$(openssl rand -base64 32 2>/dev/null | tr -dc 'a-zA-Z0-9' | head -c 32 || cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 32)"
    echo -e "${YELLOW}トピック名が指定されていないため、ランダム生成します${NC}"
fi

NTFY_SERVER="${NTFY_SERVER:-ntfy.sh}"
CLAUDE_DIR="$HOME/.claude"
SCRIPTS_DIR="$CLAUDE_DIR/scripts"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
CONFIG_FILE="$SCRIPTS_DIR/ntfy-config"

echo ""
echo -e "${CYAN}📱 トピック名: ${TOPIC}${NC}"
echo -e "${CYAN}🌐 サーバー: ${NTFY_SERVER}${NC}"
echo ""

# ステップ1: ディレクトリ作成
echo -e "${YELLOW}[1/5] ディレクトリ作成中...${NC}"
mkdir -p "$SCRIPTS_DIR"
echo -e "${GREEN}  ✓ $SCRIPTS_DIR${NC}"

# ステップ2: 設定ファイル作成
echo -e "${YELLOW}[2/5] 設定ファイル作成中...${NC}"
cat > "$CONFIG_FILE" << EOF
NTFY_TOPIC=${TOPIC}
NTFY_SERVER=${NTFY_SERVER}
EOF
chmod 600 "$CONFIG_FILE"
echo -e "${GREEN}  ✓ ntfy-config${NC}"

# ステップ3: 通知スクリプト作成
echo -e "${YELLOW}[3/5] 通知スクリプト作成中...${NC}"

# タスク完了通知スクリプト
cat > "$SCRIPTS_DIR/notify-ntfy.sh" << 'SCRIPT_EOF'
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
SCRIPT_EOF

chmod +x "$SCRIPTS_DIR/notify-ntfy.sh"
echo -e "${GREEN}  ✓ notify-ntfy.sh (タスク完了通知)${NC}"

# 入力待ち通知スクリプト
cat > "$SCRIPTS_DIR/notify-ntfy-waiting.sh" << 'SCRIPT_EOF'
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
SCRIPT_EOF

chmod +x "$SCRIPTS_DIR/notify-ntfy-waiting.sh"
echo -e "${GREEN}  ✓ notify-ntfy-waiting.sh (入力待ち通知)${NC}"

# ステップ4: Claude Code設定更新
echo -e "${YELLOW}[4/5] Claude Code設定ファイル更新中...${NC}"

HOOKS_CONFIG='{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/notify-ntfy.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/notify-ntfy-waiting.sh"
          }
        ]
      }
    ]
  }
}'

if [ -f "$SETTINGS_FILE" ]; then
    echo "  既存の設定ファイルを検出"
    cp "$SETTINGS_FILE" "${SETTINGS_FILE}.backup.$(date +%Y%m%d%H%M%S)"
    echo -e "${GREEN}  ✓ バックアップ作成完了${NC}"

    if command -v jq &> /dev/null; then
        echo "$HOOKS_CONFIG" | jq -s '.[0] * .[1]' "$SETTINGS_FILE" - > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"
    else
        echo "$HOOKS_CONFIG" > "$SETTINGS_FILE"
        echo -e "${YELLOW}  ⚠ jqがないため設定を上書きしました${NC}"
    fi
else
    echo "$HOOKS_CONFIG" > "$SETTINGS_FILE"
fi
echo -e "${GREEN}  ✓ settings.json 更新完了${NC}"

# ステップ5: テスト通知
echo -e "${YELLOW}[5/5] テスト通知送信中...${NC}"

TEST_RESULT=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Title: 🎉 セットアップ完了" \
    -H "Priority: default" \
    -H "Tags: tada,rocket" \
    -d "Setup completed" \
    "https://${NTFY_SERVER}/${TOPIC}")

if [ "$TEST_RESULT" = "200" ]; then
    echo -e "${GREEN}  ✓ テスト通知送信成功！${NC}"
else
    echo -e "${RED}  ✗ テスト通知送信失敗 (HTTP: ${TEST_RESULT})${NC}"
    echo "  ネットワーク接続を確認してください"
fi

# 完了メッセージ
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗"
echo -e "║   ✅ セットアップ完了！                                   ║"
echo -e "╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📱 スマホで通知を受け取るには:${NC}"
echo ""
echo "  1. ntfyアプリをインストール"
echo "     • iOS:     https://apps.apple.com/app/ntfy/id1625396347"
echo "     • Android: https://play.google.com/store/apps/details?id=io.heckel.ntfy"
echo ""
echo "  2. アプリを開いて「+」→ トピックを購読:"
echo -e "     ${GREEN}${TOPIC}${NC}"
echo ""
echo "  または、ブラウザでアクセス:"
echo -e "     ${CYAN}https://${NTFY_SERVER}/${TOPIC}${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "作成されたファイル:"
echo "  📄 $CONFIG_FILE"
echo "  📄 $SCRIPTS_DIR/notify-ntfy.sh"
echo "  📄 $SCRIPTS_DIR/notify-ntfy-waiting.sh"
echo "  📄 $SETTINGS_FILE"
echo ""
echo "通知タイミング:"
echo "  🤖 Stop         → タスク完了時"
echo "  ⏳ Notification → 入力/許可待ち時"
echo ""
echo -e "${YELLOW}⚠️  Claude Code を再起動すると設定が反映されます${NC}"
echo ""
