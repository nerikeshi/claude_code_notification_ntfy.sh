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
