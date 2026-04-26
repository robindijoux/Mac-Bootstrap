#!/bin/bash
set -euo pipefail

# =============================================================================
# Mac Bootstrap Script
# Installe : Homebrew, Git, OpenCode, OhMyOpenCode, Zed
# =============================================================================

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}ℹ  $1${NC}"; }
success() { echo -e "${GREEN}✔  $1${NC}"; }
warn()    { echo -e "${YELLOW}⚠  $1${NC}"; }
error()   { echo -e "${RED}✖  $1${NC}"; }

# Vérifie macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "Ce script est conçu pour macOS uniquement."
    exit 1
fi

info "Démarrage de l'installation des outils de développement..."
echo ""

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew &> /dev/null; then
    info "Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Ajoute Homebrew au PATH (différent selon Intel / Apple Silicon)
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        if ! grep -q "/opt/homebrew/bin/brew shellenv" ~/.zprofile 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
    else
        eval "$(/usr/local/bin/brew shellenv)"
        if ! grep -q "/usr/local/bin/brew shellenv" ~/.zprofile 2>/dev/null; then
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        fi
    fi
    success "Homebrew installé avec succès."
else
    success "Homebrew est déjà installé ($(brew --version | head -n1))."
fi

# ---------------------------------------------------------------------------
# 2. Git
# ---------------------------------------------------------------------------
if ! command -v git &> /dev/null; then
    info "Installation de Git..."
    brew install git
    success "Git installé avec succès."
else
    success "Git est déjà installé ($(git --version))."
fi

# ---------------------------------------------------------------------------
# 3. nvm + Node.js 24
# ---------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    info "Installation de nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    success "nvm installé avec succès."
else
    success "nvm est déjà installé."
fi

# Charge nvm pour la suite du script
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! nvm ls 24 &> /dev/null; then
    info "Installation de Node.js 24 via nvm..."
    nvm install 24
    nvm use 24
    nvm alias default 24
    success "Node.js $(node --version) installé avec succès."
else
    nvm use 24 > /dev/null
    success "Node.js $(node --version) est déjà installé."
fi

# ---------------------------------------------------------------------------
# 4. pnpm
# ---------------------------------------------------------------------------
if ! command -v pnpm &> /dev/null; then
    info "Installation de pnpm..."
    npm install -g pnpm
    success "pnpm installé avec succès ($(pnpm --version))."
else
    success "pnpm est déjà installé ($(pnpm --version))."
fi

# ---------------------------------------------------------------------------
# 5. OpenCode (CLI AI coding agent)
# ---------------------------------------------------------------------------
if ! command -v opencode &> /dev/null; then
    info "Installation d'OpenCode..."
    brew install opencode
    success "OpenCode installé avec succès."
else
    success "OpenCode est déjà installé ($(opencode --version 2>/dev/null || echo 'version inconnue'))."
fi

# ---------------------------------------------------------------------------
# 6. OhMyOpenCode (plugin / agent pour OpenCode)
# ---------------------------------------------------------------------------
info "Installation de OhMyOpenCode..."
npx oh-my-opencode install
success "OhMyOpenCode installé avec succès."

# ---------------------------------------------------------------------------
# 7. Zed (éditeur avec AI intégré)
# ---------------------------------------------------------------------------
if ! command -v zed &> /dev/null && [[ ! -d "/Applications/Zed.app" ]]; then
    info "Installation de Zed..."
    brew install --cask zed
    success "Zed installé avec succès."
else
    success "Zed est déjà installé."
fi

# ---------------------------------------------------------------------------
# Résumé
# ---------------------------------------------------------------------------
echo ""
success "=========================================="
success "  Installation terminée avec succès !    "
success "=========================================="
echo ""
info "Outils installés :"
echo "  • Homebrew  → $(brew --version | head -n1)"
echo "  • Git       → $(git --version)"
echo "  • nvm       → $(nvm --version 2>/dev/null || echo 'disponible')"
echo "  • Node.js   → $(node --version 2>/dev/null || echo 'disponible')"
echo "  • pnpm      → $(pnpm --version 2>/dev/null || echo 'disponible')"
echo "  • OpenCode  → $(opencode --version 2>/dev/null || echo 'disponible')"
echo "  • Zed       → $(zed --version 2>/dev/null || echo 'disponible dans /Applications')"
echo ""
warn "IMPORTANT : Redémarrez votre terminal ou exécutez :"
echo "    source ~/.zprofile"
echo ""
info "Pour lancer OpenCode avec OhMyOpenCode :"
echo "    cd votre-projet"
echo "    opencode"
echo ""
info "Pour lancer Zed :"
echo "    zed ."
echo ""
