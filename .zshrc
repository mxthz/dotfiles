# =============================================================================
#                            ZSH Configuration File
# =============================================================================

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# ZSH Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="pretty"
plugins=(git)

# =============================================================================
#                                Path Management
# =============================================================================

# Helper function to add to PATH only if directory exists and isn't already in PATH
pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:${PATH}"
  fi
}

# Homebrew setup - cross-platform detection
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Disable Homebrew auto-update
#export HOMEBREW_NO_AUTO_UPDATE=1

# Homemade scripts
pathadd "$HOME/bin"
pathadd "$HOME/dotfiles/shell_scripts"

# =============================================================================
#                           Development Environments
# =============================================================================

# Android Studio
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_USER_HOME="$HOME/.android"
pathadd "$ANDROID_HOME/emulator"
pathadd "$ANDROID_HOME/tools"
pathadd "$ANDROID_HOME/tools/bin"
pathadd "$ANDROID_HOME/platform-tools"

# Flutter (lazy loading approach)
flutter_init() {
  pathadd "$HOME/dev/flutter/bin"
  pathadd "$HOME/dev/flutter/.pub-cache/bin"
  pathadd "$HOME/.pub-cache/bin"
}

# Auto-initialize Flutter (comment out if you want to use lazy loading)
flutter_init

# Java
pathadd "/opt/homebrew/opt/openjdk@17/bin"
export JAVA_CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

# Node
pathadd "/opt/homebrew/opt/node@18/bin"
export NODE_LDFLAGS="-L/opt/homebrew/opt/node@18/lib"
export NODE_CPPFLAGS="-I/opt/homebrew/opt/node@18/include"

# Combine all CPPFLAGS (avoids overwriting)
export CPPFLAGS="${JAVA_CPPFLAGS} ${NODE_CPPFLAGS}"

# Docker
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

# =============================================================================
#                                    Aliases
# =============================================================================

alias tmux='tmux attach || tmux new-session'
alias sudo="sudo "
alias v='nvim'
alias vim='nvim'
alias gmj='gitmoji -c'
alias bbd='brew bundle dump -f --global'
alias t="tree"

# =============================================================================
#                            Plugins and Extensions
# =============================================================================

# Source plugins
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
