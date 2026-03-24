#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
fail()  { echo -e "${RED}[ERROR]${NC} $*"; }

errors=0

# 1. 依存ツールのチェック
info "依存ツールを確認中..."
check_command() {
  local cmd="$1" label="$2" install_hint="$3"
  if command -v "$cmd" &>/dev/null; then ok "$label: $(command -v "$cmd")"
  else fail "$label が見つかりません: $install_hint"; ((errors++)); fi
}
check_command "claude"  "Claude Code CLI" "https://docs.anthropic.com/en/docs/claude-code"
check_command "node"    "Node.js"         "brew install node"
check_command "npx"     "npx"             "Node.js に付属"
check_command "python3" "Python 3"        "brew install python"
check_command "uv"      "uv"              "curl -LsSf https://astral.sh/uv/install.sh | sh"
check_command "bun"     "Bun"             "curl -fsSL https://bun.sh/install | bash"

(( errors > 0 )) && { echo ""; fail "不足ツールをインストール後に再実行してください。"; exit 1; }
echo ""

# 2. workspace ディレクトリ
info "workspace/ を確認中..."
mkdir -p workspace
[ ! -f workspace/.gitkeep ] && touch workspace/.gitkeep
ok "workspace/ 準備完了"
echo ""

# 3. Google Workspace MCP 拡張の確認
GWS_EXT_DIR="$HOME/Library/Application Support/Claude/Claude Extensions/local.dxt.taylor-wilsdon.workspace-mcp"
info "Google Workspace MCP 拡張を確認中..."
if [ -d "$GWS_EXT_DIR" ]; then
  ok "拡張ディレクトリ検出: $GWS_EXT_DIR"
  uv sync --directory "$GWS_EXT_DIR" --quiet 2>/dev/null && ok "依存パッケージ同期完了" || warn "uv sync 失敗。手動確認してください"
else
  warn "Google Workspace MCP 拡張が見つかりません。"
  echo "  Claude Desktop で workspace-mcp 拡張をインストールしてください:"
  echo "  https://github.com/taylor-wilsdon/google-workspace-mcp"
fi
echo ""

# 4. .mcp.json の生成
info ".mcp.json を確認中..."
if [ -f .mcp.json ]; then
  ok ".mcp.json は既に存在します（スキップ）"
else
  info ".mcp.json が見つかりません。対話形式で作成します。"
  echo ""

  # Google Workspace MCP パス
  DEFAULT_GWS_DIR="$HOME/Library/Application Support/Claude/Claude Extensions/local.dxt.taylor-wilsdon.workspace-mcp"
  read -rp "Google Workspace MCP ディレクトリ [$DEFAULT_GWS_DIR]: " GWS_DIR
  GWS_DIR="${GWS_DIR:-$DEFAULT_GWS_DIR}"

  cat > .mcp.json <<MCPEOF
{
  "mcpServers": {
    "google-workspace": {
      "type": "stdio",
      "command": "uv",
      "args": [
        "run", "--directory",
        "${GWS_DIR}",
        "python",
        "${GWS_DIR}/main.py"
      ],
      "env": {
        "WORKSPACE_MCP_PORT": "8001"
      }
    }
  }
}
MCPEOF

  ok ".mcp.json を生成しました"
fi
echo ""

# 5. Google OAuth クライアントシークレットの確認
info "Google OAuth クライアントシークレットを確認中..."
CLIENT_SECRET=$(find "$REPO_ROOT" -maxdepth 1 -name 'client_secret_*.json' 2>/dev/null | head -1)
if [ -n "$CLIENT_SECRET" ]; then ok "検出: $(basename "$CLIENT_SECRET")"
else
  warn "client_secret_*.json が見つかりません。"
  echo "  Google Cloud Console で OAuth クライアント ID を作成し、"
  echo "  ダウンロードした JSON をプロジェクトルートに配置してください。"
fi
echo ""

# 6. 完了
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
info "セットアップ完了！"
echo ""
echo "  次のステップ:"
echo "    1. claude を起動してMCP接続を確認"
echo "       $ cd $(basename "$REPO_ROOT") && claude"
echo ""
echo "    2. 動作確認:"
echo "       「今日の予定を教えて」  → Google Calendar"
echo "       「未読メールを確認して」 → Gmail"
echo ""
echo "  初回の Google Workspace 認証:"
echo "    Google 系ツールを使うと OAuth 認証フローが開始されます。"
echo "    ブラウザで認証を完了してください。"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
