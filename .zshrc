# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="xiong-chiamiov-plus"
ZSH_THEME="amuse"

plugins=( 
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
# pokemon-colorscripts --no-title -s -r

alias vim="lvim"
alias nvim="lvim"
alias lg="lazygit"

PATH="$PATH":"$HOME/.local/scripts/"
bindkey -s ^f "tmux-sessionizer\n"

export EDITOR='lvim'

alias sysup="sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y"
