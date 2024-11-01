export PATH="$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:$HOME/go/bin:$PATH"
export GOPATH=$HOME/go

function vimgrep_and_open() {
  rg -i --vimgrep "$1" | nvim -q -
}

alias vc='cd ~/.config/nvim && vim'
alias vim='nvim'
alias vimdiff="nvim -d"
alias kx='SHELL= kubectx'
alias ks='SHELL= kubens'
alias gs='git switch "$(git branch --all | fzf | sed s,remotes\/origin\/,, | tr -d '[:space:]')"'
alias dev='cd /mnt/c/dev'
alias rg='rg -i'
alias vg='rg -i --vimgrep'
alias vgg='vimgrep_and_open'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias bat='bat --paging=never'
alias xclip="xclip -selection c"

# rg ENV -l  | xargs sed -i 's/ENV/something/' for find and replace
# rg -p foo | less -R for paging rg results

eval "$(fzf --bash)"
export EDITOR=nvim

export PATH=~/.nvm/versions/node/v20.9.0/bin:$PATH

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(zoxide init bash)"
