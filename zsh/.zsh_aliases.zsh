# Eza (modern ls)
if command -v eza &> /dev/null; then
    alias ll='eza -lha --icons=always --color=always'
    alias ls='eza --icons=always --color=always'
    alias lt='eza --tree --level=2 --icons'
else
    alias ls='ls --color'
    alias ll='ls -lh --color'
fi

# Editor aliases
alias nano='vim'
alias vi='vim'

if command -v nvim &> /dev/null; then
    export EDITOR=/usr/bin/nvim
    alias vim=nvim
    alias v=nvim
fi

# Kitty specific
if [[ $TERM == "xterm-kitty" ]]; then 
    alias ssh="kitty +kitten ssh"
    alias icat="kitten icat"
fi

# Yay (AUR helper)
if command -v yay &> /dev/null; then 
    alias yayy='yay --noconfirm --color always'
    alias update='yay -Syu'
    alias cleanup='yay -Sc && yay -Yc'
fi

# Zoxide (smart cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# Lazygit
if command -v lazygit &> /dev/null; then
    alias lzg="lazygit"
fi

# Lazydocker
if command -v lazydocker &> /dev/null; then
    alias lzd="lazydocker"
fi

# Docker
alias dc='docker compose'

# WireGuard
alias wg='sudo wg'
alias wg-quick='sudo wg-quick'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# System
alias grep='grep --color=auto'
alias cat='bat --style=plain --paging=never'

# Hyprland configs
alias hypr='nvim ~/.config/hypr/hyprland.conf'
alias waybar='nvim ~/.config/waybar/config.jsonc'
alias zshrc='nvim ~/.zshrc'
alias aliases='nvim ~/.zsh_aliases.zsh'

# Nvim update
alias nvim-update='nvim +Lazy sync +qa && echo "✓ Nvim plugins updated"'
alias nvim-clean='rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim && echo "✓ Nvim cache cleaned"'
