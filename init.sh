# add alias to .bashrc
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# change show untracked files change
config config --local status.showUntrackedFiles no

# clone config repo
git clone --bare git@github.com:timredband/dotfiles.git $HOME/.cfg

config checkout
