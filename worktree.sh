# check fetch configuration
# git config --local --get-all remote.origin.fetch

DEFAULT_BRANCH=main

git clone --bare "url"
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git worktree add ../$DEFAULT_BRANCH $DEFAULT_BRANCH
git worktree add -b dev-foo ../dev-foo $DEFAULT_BRANCH

# could potentially create a sym link so when cd into project don't have to think about the default branch name
ln -s $DEFAULT_BRANCH default
