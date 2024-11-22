# HOMEBREW
eval "$(/opt/homebrew/bin/brew shellenv)"
HOMEBREW_NO_AUTO_UPDATE=1

# ALIASES
alias vim='nvim'
alias gmj='gitmoji -c'
alias bbd='brew bundle dump -f --global'
alias ync="cd ~/Dev/yonoco/lib"

# Neovim
export XDG_CONFIG_HOME="$HOME/dotfiles"
export PATH="$HOME/dotfiles/shell_scripts:$PATH"

# ANDROID STUDIO
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# FLUTTER
export PATH="$PATH:$HOME/dev/flutter/bin"
export PATH="$PATH":"$HOME/dev/flutter/.pub-cache/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"

# JAVA
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"

# NODE
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/node@18/lib"
export CPPFLAGS="-I/opt/homebrew/opt/node@18/include"

#ZSH
export PATH="/opt/homebrew/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"


# plugins
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"

ZSH_THEME="pretty"
plugins=(git)

source $ZSH/oh-my-zsh.sh

