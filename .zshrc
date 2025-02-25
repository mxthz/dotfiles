# Check if Homebrew is installed and set it up
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    HOMEBREW_NO_AUTO_UPDATE=1
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    HOMEBREW_NO_AUTO_UPDATE=1
fi

export XDG_CONFIG_HOME="$HOME/dotfiles"

# ALIASES
alias sudo="sudo "
alias {v,vim}='nvim'
alias gmj='gitmoji -c'
alias bbd='brew bundle dump -f --global'
alias yncm="cd ~/Dev/yonoco_mobile"
alias t="tree"

# Homemade scripts
export PATH="$PATH:/$HOME/bin"

# Neovim
export PATH="$HOME/dotfiles/shell_scripts:$PATH"

# ANDROID STUDIO
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_USER_HOME="$HOME/.android"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# FLUTTER
export PATH="$PATH:$HOME/dev/flutter/bin"
export PATH="$PATH:$HOME/dev/flutter/.pub-cache/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"

# JAVA
if [ -d "/opt/homebrew/opt/openjdk@17" ]; then
    export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
    export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
elif [ -d "/usr/lib/jvm/java-17-openjdk-amd64" ]; then
    export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
    export PATH="$JAVA_HOME/bin:$PATH"
fi

# NODE
if [ -d "/opt/homebrew/opt/node@18" ]; then
    export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
    export LDFLAGS="-L/opt/homebrew/opt/node@18/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/node@18/include"
elif [ -d "/usr/local/node@18" ]; then
    export PATH="/usr/local/node@18/bin:$PATH"
fi

# DOCKER
if [ -S "$HOME/.colima/default/docker.sock" ]; then
    export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
fi

# ZSH
export ZSH="$HOME/.oh-my-zsh"

# plugins
if [ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

if [ -f "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh" ]; then
    source "/opt/homebrew/opt/zsh-git-prompt/zshrc.sh"
elif [ -f "/usr/share/zsh-git-prompt/zshrc.sh" ]; then
    source "/usr/share/zsh-git-prompt/zshrc.sh"
fi

ZSH_THEME="pretty"
plugins=(git)

source $ZSH/oh-my-zsh.sh
