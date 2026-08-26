# Zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Vi mode (jeffreytse/zsh-vi-mode) — loads immediately, not in turbo.
# ZVM_INIT_MODE=sourcing: init at source time instead of first prompt,
# so later plugins (fzf-tab) keep their Tab/^I bindings.
ZVM_INIT_MODE=sourcing
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# zvm is fully initialized here (sourcing mode), so bindings below win.
# fzf: Ctrl+R fuzzy history, Ctrl+T files, Alt+C cd
if command -v fzf &> /dev/null; then
    source <(fzf --zsh)
fi

bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo

# Plugins — turbo mode (lazy load after prompt, big startup win).
# Order matters: fzf-tab first (after compinit via atinit),
# syntax highlighting after it, autosuggestions last.
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
        Aloxaf/fzf-tab \
    zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    MichaelAquilina/zsh-you-should-use

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'      # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"        # colored entries
zstyle ':completion:*' menu no                                 # fzf-tab handles the menu
zstyle ':completion:*:descriptions' format '[%d]'              # group headers
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 $realpath'

# PATH
export PATH=$PATH:$HOME/.local/bin/
export PATH=~/.npm-global/bin:$PATH
export PATH=$PATH:/var/lib/snapd/snap/bin
export PATH=/home/xera/.opencode/bin:$PATH
export PATH="$HOME/.local/share/npm-global/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export XDG_DATA_DIRS="/var/lib/snapd/desktop:$XDG_DATA_DIRS"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

# Aliases import
if [ -f ~/.zsh_aliases.zsh ]; then
    source ~/.zsh_aliases.zsh
fi

# Starship prompt
eval "$(starship init zsh)"

# uv / local env
. "$HOME/.local/bin/env"

# Auto-start Hyprland on tty1
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec Hyprland
fi

[ -z "$TMUX" ] && fastfetch
alias clear='clear && printf "\e[3J"'
export CLAUDE_OBSIDIAN_VAULT="$HOME/Documents/obsidian-vaults/claude-vault"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/xera/.lmstudio/bin"
# End of LM Studio CLI section

