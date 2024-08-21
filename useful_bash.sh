export PATH="$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:$HOME/go/bin:$PATH"
export GOPATH=$HOME/go

alias vc='cd ~/.config/nvim && vim'
alias vim='nvim'
alias vimdiff="nvim -d"
alias kx='SHELL= kubectx'
alias ks='SHELL= kubens'
alias gs='git switch "$(git branch --all | fzf | sed s,remotes\/origin\/,, | tr -d '[:space:]')"'
alias dev='cd /mnt/c/dev'
alias rg='rg --smart-case'
alias vg='rg --vimgrep'

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no

eval "$(fzf --bash)"
export EDITOR=nvim

export PATH=~/.nvm/versions/node/v20.9.0/bin:$PATH

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(zoxide init bash)"
