# Claude Code ntfy.sh 通知セットアップ - GitHub リポジトリ構成

このドキュメントは、コーディングエージェントがGitHubリポジトリを作成するための全ファイル内容をまとめたものです。

## リポジトリ情報

- **リポジトリ名（推奨）**: `claude-code-ntfy-notify`
- **説明**: Claude Codeのタスク完了時にntfy.shでスマホにプッシュ通知を送信するセットアップスクリプト
- **ライセンス**: MIT
- **言語**: Shell (Bash)

---

## ディレクトリ構造

```
claude-code-ntfy-notify/
├── README.md
├── LICENSE
├── setup-claude-ntfy.sh
├── uninstall-claude-ntfy.sh
└── scripts/
    ├── notify-ntfy.sh
    └── notify-ntfy-waiting.sh
```

---

## ファイル内容

### README.md

```markdown
# Claude Code × ntfy.sh 通知

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)

Claude Codeのタスク完了時に、[ntfy.sh](https://ntfy.sh/)でスマホにプッシュ通知を送信するセットアップスクリプトです。

## ✨ 特徴

- 🚀 **アカウント登録不要** - トピック名を決めるだけ
- 💰 **完全無料** - 制限なし
- ⚡ **セットアップ1分** - スクリプト実行するだけ
- 📱 **iOS/Android対応** - 公式アプリあり
- 🔓 **オープンソース** - サービス終了の心配なし

## 📋 前提条件

- Claude Code がインストールされていること
- `curl` コマンドが使用可能であること
- `jq` コマンド（オプション、既存設定のマージに使用）

## 🚀 クイックスタート

### 1. インストール

```bash
# リポジトリをクローン
git clone https://github.com/YOUR_USERNAME/claude-code-ntfy-notify.git
cd claude-code-ntfy-notify

# 実行権限を付与
chmod +x setup-claude-ntfy.sh

# セットアップ実行（トピック名は自動生成）
./setup-claude-ntfy.sh

# または、トピック名を指定
./setup-claude-ntfy.sh my-secret-topic-xyz
```

### 2. スマホアプリの設定

| プラットフォーム | リンク |
|-----------------|--------|
| iOS | [App Store](https://apps.apple.com/app/ntfy/id1625396347) |
| Android | [Google Play](https://play.google.com/store/apps/details?id=io.heckel.ntfy) / [F-Droid](https://f-droid.org/packages/io.heckel.ntfy/) |

1. アプリをインストール
2. 「+」ボタンをタップ
3. セットアップ時に表示されたトピック名を入力
4. 「Subscribe」をタップ

### 3. Claude Codeを再起動

設定を反映するため、Claude Codeを再起動してください。

## 📁 インストール後のファイル構成

```
~/.claude/
├── settings.json           # Claude Code設定（hooks追加）
└── scripts/
    ├── ntfy-config         # トピック名・サーバー設定
    ├── notify-ntfy.sh      # タスク完了通知
    └── notify-ntfy-waiting.sh  # 入力待ち通知
```

## 🔔 通知タイミング

| イベント | 説明 | 優先度 | アイコン |
|---------|------|--------|----------|
| Stop | タスク完了時 | default | 🤖 |
| Notification | 入力/許可待ち時 | high | ⏳ |

## ⚙️ カスタマイズ

### トピック名の変更

```bash
vim ~/.claude/scripts/ntfy-config
```

```bash
NTFY_TOPIC=new-topic-name
NTFY_SERVER=ntfy.sh
```

### セルフホストサーバーを使う

```bash
NTFY_SERVER=ntfy.example.com ./setup-claude-ntfy.sh my-topic
```

### 通知の優先度・タグを変更

`~/.claude/scripts/notify-ntfy.sh` を編集:

```bash
# 優先度: min, low, default, high, urgent
-H "Priority: high" \

# タグ（絵文字に変換される）
-H "Tags: rocket,fire" \
```

### 特定プロジェクトのみ通知

`~/.claude/settings.json` の `matcher` を編集:

```json
{
  "matcher": "my-important-project",
  "hooks": [...]
}
```

## 🔧 トラブルシューティング

### 通知が届かない

```bash
# 手動でテスト送信
curl -d "テスト通知" ntfy.sh/YOUR_TOPIC_NAME

# ブラウザで確認
open https://ntfy.sh/YOUR_TOPIC_NAME
```

### jqがインストールされていない

```bash
# macOS
brew install jq

# Ubuntu/Debian  
sudo apt install jq

# CentOS/RHEL
sudo yum install jq
```

### トピック名を忘れた

```bash
cat ~/.claude/scripts/ntfy-config
```

## 🗑️ アンインストール

```bash
./uninstall-claude-ntfy.sh
```

または手動で:

```bash
rm ~/.claude/scripts/notify-ntfy*.sh
rm ~/.claude/scripts/ntfy-config
# settings.json から hooks セクションを削除
```

## 🔒 セキュリティ

- トピック名は**推測されにくい文字列**を使用してください
- 公開サーバー(ntfy.sh)ではトピック名を知っている人は誰でも購読可能です
- より高いセキュリティが必要な場合は[セルフホスト](https://docs.ntfy.sh/install/)を検討してください

## 📝 LINE Notify からの移行

LINE Notifyは2025年3月31日でサービス終了しました。ntfy.shは完全な代替となります。

| 項目 | ntfy.sh | LINE Notify |
|------|---------|-------------|
| 料金 | 無料 | 無料だった |
| アカウント | 不要 | LINE必須 |
| トークン | 不要 | 必要 |
| セルフホスト | 可能 | 不可 |
| サービス継続性 | オープンソース | 2025/3終了 |

## 📚 参考リンク

- [ntfy.sh 公式サイト](https://ntfy.sh/)
- [ntfy ドキュメント](https://docs.ntfy.sh/)
- [Claude Code Hooks ドキュメント](https://docs.claude.com/en/docs/claude-code/hooks)
- [Claude Code Hooks ガイド](https://code.claude.com/docs/en/hooks-guide)
- [ntfy GitHub](https://github.com/binwiederhier/ntfy)

## 🤝 Contributing

Issues や Pull Requests を歓迎します！

## 📄 License

MIT License - 詳細は [LICENSE](LICENSE) を参照してください。
```

---

### LICENSE

```
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

### setup-claude-ntfy.sh

```bash
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
    TOPIC="claude-code-$(openssl rand -hex 6 2>/dev/null || cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 12 | head -n 1)"
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

# 設定読み込み
CONFIG_FILE="$HOME/.claude/scripts/ntfy-config"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "設定ファイルが見つかりません: $CONFIG_FILE" >&2
    exit 1
fi

# 標準入力からフックデータを読み込み
INPUT=$(cat)

# プロジェクト名（現在のディレクトリ名）
PROJECT_NAME=$(basename "$(pwd)")

# タイムスタンプ
TIMESTAMP=$(date "+%H:%M:%S")

# トランスクリプトから最後のメッセージを取得（オプション）
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
LAST_MSG=""
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    LAST_MSG=$(tail -30 "$TRANSCRIPT_PATH" 2>/dev/null | \
        jq -r 'select(.message.role == "assistant") | .message.content[0].text // empty' 2>/dev/null | \
        tail -1 | \
        tr '\n' ' ' | \
        cut -c1-150)
fi

# メッセージ構築
if [ -n "$LAST_MSG" ]; then
    MESSAGE="📁 ${PROJECT_NAME} (${TIMESTAMP})
${LAST_MSG}..."
else
    MESSAGE="📁 ${PROJECT_NAME}
⏰ ${TIMESTAMP}"
fi

# ntfy.sh へ送信
curl -s \
    -H "Title: 🤖 Claude Code 完了" \
    -H "Priority: default" \
    -H "Tags: robot,white_check_mark" \
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
TIMESTAMP=$(date "+%H:%M:%S")

MESSAGE="📁 ${PROJECT_NAME}
⏰ ${TIMESTAMP}
あなたの入力または許可が必要です"

curl -s \
    -H "Title: ⏳ Claude Code 入力待ち" \
    -H "Priority: high" \
    -H "Tags: hourglass_flowing_sand,warning" \
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
    -d "Claude Codeのタスク完了通知が有効になりました！

📱 このトピックをntfyアプリで購読してください:
${TOPIC}" \
    "https://${NTFY_SERVER}/${NTFY_TOPIC}")

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
```

---

### uninstall-claude-ntfy.sh

```bash
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
```

---

### scripts/notify-ntfy.sh

```bash
#!/bin/bash
#
# Claude Code タスク完了時 ntfy.sh 通知スクリプト
#
# このファイルはセットアップスクリプトによって ~/.claude/scripts/ に配置されます
# 単体での使用例:
#   echo '{"transcript_path": "/path/to/transcript.jsonl"}' | ./notify-ntfy.sh
#

# 設定読み込み
CONFIG_FILE="$HOME/.claude/scripts/ntfy-config"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "設定ファイルが見つかりません: $CONFIG_FILE" >&2
    exit 1
fi

# 標準入力からフックデータを読み込み
INPUT=$(cat)

# プロジェクト名（現在のディレクトリ名）
PROJECT_NAME=$(basename "$(pwd)")

# タイムスタンプ
TIMESTAMP=$(date "+%H:%M:%S")

# トランスクリプトから最後のメッセージを取得（オプション）
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
LAST_MSG=""
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    LAST_MSG=$(tail -30 "$TRANSCRIPT_PATH" 2>/dev/null | \
        jq -r 'select(.message.role == "assistant") | .message.content[0].text // empty' 2>/dev/null | \
        tail -1 | \
        tr '\n' ' ' | \
        cut -c1-150)
fi

# メッセージ構築
if [ -n "$LAST_MSG" ]; then
    MESSAGE="📁 ${PROJECT_NAME} (${TIMESTAMP})
${LAST_MSG}..."
else
    MESSAGE="📁 ${PROJECT_NAME}
⏰ ${TIMESTAMP}"
fi

# ntfy.sh へ送信
curl -s \
    -H "Title: 🤖 Claude Code 完了" \
    -H "Priority: default" \
    -H "Tags: robot,white_check_mark" \
    -d "$MESSAGE" \
    "https://${NTFY_SERVER}/${NTFY_TOPIC}" > /dev/null 2>&1

exit 0
```

---

### scripts/notify-ntfy-waiting.sh

```bash
#!/bin/bash
#
# Claude Code 入力待ち通知スクリプト
#
# このファイルはセットアップスクリプトによって ~/.claude/scripts/ に配置されます
#

CONFIG_FILE="$HOME/.claude/scripts/ntfy-config"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    exit 1
fi

PROJECT_NAME=$(basename "$(pwd)")
TIMESTAMP=$(date "+%H:%M:%S")

MESSAGE="📁 ${PROJECT_NAME}
⏰ ${TIMESTAMP}
あなたの入力または許可が必要です"

curl -s \
    -H "Title: ⏳ Claude Code 入力待ち" \
    -H "Priority: high" \
    -H "Tags: hourglass_flowing_sand,warning" \
    -d "$MESSAGE" \
    "https://${NTFY_SERVER}/${NTFY_TOPIC}" > /dev/null 2>&1

exit 0
```

---

## コーディングエージェントへの指示

以下の手順でGitHubリポジトリを作成してください：

1. 新しいリポジトリ `claude-code-ntfy-notify` を作成
2. 上記の各ファイルを対応するパスに配置
3. 以下のコマンドで実行権限を設定:
   ```bash
   chmod +x setup-claude-ntfy.sh uninstall-claude-ntfy.sh scripts/*.sh
   ```
4. コミット & プッシュ

### トピック（タグ）推奨

- `claude-code`
- `ntfy`
- `notifications`
- `push-notifications`
- `bash`
- `shell-script`
- `developer-tools`
