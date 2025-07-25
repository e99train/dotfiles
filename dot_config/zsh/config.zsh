[[ -r ~/Repos/znap/znap.zsh ]] ||
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Variable defaults
#
EZA_CONFIG_DIR=/Users/ethanborsky/.config/eza
EDITOR=/opt/homebrew/bin/nvim
export MANPAGER='nvim +Man\!'
export MISE_ENV_FILE=.env
export ANDROID_HOME=$HOME/Library/Android/sdk


# PATH additions
#
export PATH=$PATH:/opt/homebrew/bin
export PATH="$PATH:$HOME/Documents/Tools/tmux-sessionizer-aarch64-apple-darwin"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.dotnet/tools


source ~/.config/zsh/colors.zsh


# Vim mode options
#
MODE_CURSOR_VIINS="#ffffff blinking bar"
MODE_CURSOR_REPLACE="$MODE_CURSOR_VIINS #ff0000"
MODE_CURSOR_VICMD="#ababab block"
MODE_CURSOR_SEARCH="#ff00ff steady underline"
MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD steady bar"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL #00ffff"

KEYTIMEOUT=1

export GITHUB_LS_TOKEN="$(chezmoi secret keyring get --service=githubUIG --user=e99train)"

# Main plugins
#
znap source romkatv/powerlevel10k
znap source softmoth/zsh-vim-mode
znap source zsh-users/zsh-completions
znap source zsh-users/zsh-autosuggestions

# znap source marlonrichert/zsh-autocomplete
zstyle ':completion:*' file-sort date
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:processes' command 'ps -afu $USER'

if type brew &>/dev/null; then
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
fi

(( $+commands[direnv] )) && znap eval direnv "direnv hook zsh"

alias ta="tmux attach -t"
alias tad="tmux attach -d -t"
alias ts="tmux new-session -s"
alias tl="tmux list-sessions"
alias tksv="tmux kill-server"
alias tkss="tmux kill-session -t"
alias dotnet8="mise x dotnet@8 -- dotnet"

alias ls="eza"
alias fzfp="fzf --preview \"bat --color=always {}\""

if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

(( $+commands[zoxide] )) && znap eval zoxide 'zoxide init --cmd cd zsh'
# eval "$(zoxide init zsh --cmd cd)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

znap source zsh-users/zsh-history-substring-search


eval "$(mise activate zsh)"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
znap source zsh-users/zsh-syntax-highlighting
