export PATH="$HOME/.local/share/bob/nvim-bin:$HOME/.local/bin:$HOME/go/bin:$PATH"
export GOPATH=$HOME/go

# for wsl browser links
export BROWSER="$HOME/links/chrome.exe"

function vimgrep_and_open() {
  rg -i --vimgrep "$@" | nvim -q -
}

function replace_rg_with_vg_and_open() {
  replaced=$(history 2 | head -n 1 | sed 's/[[:space:]]*[0-9]*[[:space:]]*rg/vg/')
  eval $replaced | nvim -q -
}

function send_fd_results_to_quickfix_and_open() {
  command=$(history 2 | head -n 1 | sed 's,[[:space:]]*[0-9]*[[:space:]]*,,')
  quickfix_formatted_command="nvim -q <($command --format {}:1:1:{/})"
  eval $quickfix_formatted_command
}

function _worktree() {
  if [[ -z "$1" ]]; then
    worktree
    return
  fi

  if [[ "$1" == "use" ]]; then
    selected="$2"

    if [[ -z "$selected" ]]; then
      worktree_root="$(worktree root)"

      if [[ $? -eq 1 ]]; then
        echo "Error: can't find worktree root"
        return
      fi

      cd "$worktree_root"

      selected=$(fd --path-separator "" -td -d1 | fzf)
    fi

    if [[ -z "$selected" ]]; then
      return
    fi

    path=$(worktree find "$selected")

    if [[ -d "$path" ]]; then
      cd "$path"
      echo "Switched to worktree $selected"
    else
      echo "Error: worktree $2 not found."
    fi

    return
  fi

  worktree $@
}

# add to .bash_completion *****************
function _worktree_completion() {
  local subcommand
  subcommand="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=($(compgen -W "init add find root remove list bare use" -- "$subcommand"))
}

complete -F _worktree_completion worktree
# *****************

alias vc='cd ~/.config/nvim && vim'
alias vim='nvim'
alias vimdiff="nvim -d"
alias kx='SHELL= kubectx'
alias ks='SHELL= kubens'
alias gs='git switch "$(git branch --all | fzf | sed s,remotes\/origin\/,, | tr -d '[:space:]')"'
alias dev='cd /mnt/c/dev'
alias rg='rg -i'
alias rgh="rg -i --hidden --glob '!.git' --glob '!.vs' --glob '!vendor' --glob '!.bin' --glob '!node_modules' --glob '!package-lock.json'"
alias vg='rg -i --vimgrep'
alias vgg='vimgrep_and_open'
alias rr='replace_rg_with_vg_and_open'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias bat='bat --paging=never'
alias xclip="xclip -selection c"
alias ff='send_fd_results_to_quickfix_and_open'
alias fdh='fd --hidden'
alias vf='fd --format {}:1:1:{/}'
alias lg='lazygit'
alias worktree='_worktree'

# rg ENV -l  | xargs sed -i 's/ENV/something/' for find and replace
# rg -p foo | less -R for paging rg results
# rg --hidden --glob '!.git' --glob '!.vs' --glob '!vendor' 2.7.3 for including hidden files with ignored globs
# rg --hidden --glob '!.git' --glob '!.vs' --glob '!vendor' --glob '!.bin' --glob '!node_modules' 2.7.3 for including hidden files with ignored globs

PROMPT_DIRTRIM=1

eval "$(fzf --bash)"
export EDITOR=nvim

export PATH=~/.nvm/versions/node/v20.9.0/bin:$PATH

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(zoxide init bash)"

source ~/git-prompt.sh
export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[1;31m\]\$(__git_ps1 \"(%s)\")\[\033[00m\]\$ "

# Color mapping
# grey='\[\033[1;30m\]'
# red='\[\033[0;31m\]'
# RED='\[\033[1;31m\]'
# green='\[\033[0;32m\]'
# GREEN='\[\033[1;32m\]'
# yellow='\[\033[0;33m\]'
# YELLOW='\[\033[1;33m\]'
# purple='\[\033[0;35m\]'
# PURPLE='\[\033[1;35m\]'
# white='\[\033[0;37m\]'
# WHITE='\[\033[1;37m\]'
# blue='\[\033[0;34m\]'
# BLUE='\[\033[1;34m\]'
# cyan='\[\033[0;36m\]'
# CYAN='\[\033[1;36m\]'
# NC='\[\033[0m\]'
