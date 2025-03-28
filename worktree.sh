#!/usr/bin/env bash

set -e

# check fetch configuration
# git config --local --get-all remote.origin.fetch

function usage() {
  echo "Usage: ./worktree.sh [OPTION]..."
  echo "Arguments:"
  echo "  init url         use URL as repository url. Initialize repository with default worktree"
  echo "  add name source  use NAME as branch name. Add worktree with NAME. Use SOURCE as source branch name (defaults to default branch for repository)"
  echo "  find name        use NAME as worktree name. Print path of worktree if found"
  echo "  root             print path of worktree root"
  echo "  remove           remove worktree"
  echo "  list             list worktrees"
  echo "  bare             print path of bare repository"
}

command=""

if [[ -z "$1" ]]; then
  usage
  exit 1
fi

if [[ -n "$1" && ("$1" == "init" || "$1" == "add" || "$1" == "find" || "$1" == "root" || "$1" == "remove" || "$1" == "list" || "$1" == "bare") ]]; then
  command="$1"
fi

if [[ -z "$command" ]]; then
  usage
  exit 1
fi

if [[ "$command" == "init" ]]; then
  url="$2"

  if [[ -z "$url" ]]; then
    usage
    exit 1
  fi

  bare_folder="${url##*/}"
  folder="${bare_folder/.git/}"

  if [[ -d "$folder" ]]; then
    echo "Error: directory $folder already exists"
    exit 1
  fi

  mkdir $folder
  cd $folder

  git clone --bare "$url"
  cd $bare_folder

  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch

  default_branch=$(git remote show "$url" | sed -n '/HEAD branch/s/.*: //p' | xargs echo)
  git worktree add ../$default_branch $default_branch
  git branch | rg -v "$default_branch" | xargs git branch -D
  git branch --set-upstream-to=origin/$default_branch $default_branch

  cd ../

  echo $default_branch >.gitdefaultbranch

  exit 0
fi

if [[ "$command" == "add" ]]; then
  branch="$2"

  set +e

  worktree_root=$(worktree root)

  if [[ $? -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd "$worktree_root"

  source_branch=$(head -n 1 .gitdefaultbranch)

  if [[ -n "$3" ]]; then
    source_branch="$3"
  fi

  bare_folder=$(worktree bare)
  cd "$bare_folder"

  selected=""
  if [[ -z "$branch" ]]; then
    selected=$(git branch --all | fzf | tr -d '[:space:]')

    if [[ -z "$selected" ]]; then
      echo "Error: no branch selected"
      exit 1
    fi

    selected="${selected##*/}"
  fi

  if [[ -n "$selected" ]]; then
    git worktree add "../$selected" "$selected"
  else
    git worktree add -b "$branch" "../$branch" "$source_branch"
  fi

  exit 0
fi

if [[ "$command" == "find" ]]; then
  worktree="$2"

  if [[ -z "$worktree" ]]; then
    usage
    exit 1
  fi

  set +e

  worktree_root=$(worktree root)

  if [[ $? -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd "$worktree_root"

  if [[ -d "$worktree" ]]; then
    cd "$worktree"
    pwd
  else
    echo "Error: worktree $worktree not found"
    exit 1
  fi

  exit 0
fi

if [[ "$command" == "root" ]]; then
  attempts=10
  while ! [[ -f ".gitdefaultbranch" ]]; do
    if [[ $attempts -lt 1 ]]; then
      break
    fi

    cd ../
    attempts=$((attempts - 1))
  done

  if ! [[ -f ".gitdefaultbranch" ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  pwd

  exit 0
fi

if [[ "$command" == "remove" ]]; then
  set +e

  worktree_root=$(worktree root)

  if [[ $? -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd "$worktree_root"

  selected=$(fd --path-separator "" -td -d1 | fzf)

  bare_folder=$(worktree bare)

  if [[ $? -eq 1 ]]; then
    echo "Error: can't find bare folder"
    exit 1
  fi

  cd "$bare_folder"

  set -e

  if [[ -n "$selected" ]]; then
    git worktree remove "$selected"
    echo "Successfully removed worktree $selected"
  else
    echo "Error: worktree $2 not found"
  fi

  exit 0
fi

if [[ "$command" == "list" ]]; then
  set +e

  worktree_root=$(worktree root)

  if [[ $? -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd "$worktree_root"

  set -e

  fd --color never --path-separator "" -td -d1

  exit 0
fi

if [[ "$command" == "bare" ]]; then
  set +e

  worktree_root=$(worktree root)

  if [[ $? -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd $worktree_root

  # find bare folder
  fd -td -d1 -1 -q .git

  if [[ $? -eq 1 ]]; then
    echo "Error: can't find bare folder"
    exit 1
  fi

  set -e

  bare_folder=$(fd --path-separator "" -td -d1 -1 .git)
  echo "$bare_folder"
fi
