#!/bin/bash
#
# Claude Code ntfy.sh 通知 アンインストールスクリプト
#

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CLAUDE_DIR="$HOME/.claude"
SCRIPTS_DIR="$CLAUDE_DIR/scripts"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

echo -e "${YELLOW}Claude Code ntfy.sh通知をアンインストールしますか? (y/N)${NC}"
read -r CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "キャンセルしました"
    exit 0
fi

echo ""
echo -e "${YELLOW}スクリプトを削除中...${NC}"

rm -f "$SCRIPTS_DIR/notify-ntfy.sh"
rm -f "$SCRIPTS_DIR/notify-ntfy-waiting.sh"
rm -f "$SCRIPTS_DIR/ntfy-config"
echo -e "${GREEN}  ✓ スクリプト削除完了${NC}"

if [ -f "$SETTINGS_FILE" ] && command -v jq &> /dev/null; then
    echo -e "${YELLOW}設定ファイルを更新中...${NC}"
    jq 'del(.hooks)' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"
    echo -e "${GREEN}  ✓ hooks設定削除完了${NC}"
else
    echo -e "${YELLOW}  ⚠ settings.jsonは手動で編集してください${NC}"
fi

echo ""
echo -e "${GREEN}アンインストール完了！${NC}"
echo "Claude Codeを再起動すると反映されます"
