export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt autocd appendhistory sharehistory

alias lg='lazygit'
alias vim='nvim'
