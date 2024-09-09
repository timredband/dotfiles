# add alias to .bashrc
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# change show untracked files change
config config --local status.showUntrackedFiles no

# clone config repo
git clone --bare git@github.com:timredband/dotfiles.git $HOME/.cfg

config checkout

# to push do config push --set-upstream origin master
#
#
# inspired from this
# git clone --bare https://bitbucket.org/durdn/cfg.git $HOME/.cfg
# function config {
#   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
# }
# mkdir -p .config-backup
# config checkout
# if [ $? = 0 ]; then
#   echo "Checked out config."
# else
#   echo "Backing up pre-existing dot files."
#   config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
# fi
# config checkout
# config config status.showUntrackedFiles no
