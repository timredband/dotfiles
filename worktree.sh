#!/usr/bin/env bash

set -e

# check fetch configuration
# git config --local --get-all remote.origin.fetch

function usage() {
  echo "Usage: ./worktree.sh [OPTION]..."
  echo "Arguments:"
  echo "  setup url        use URL as repository url. Initialize repository with default worktree"
  echo "  add name source  use NAME as branch name. Add worktree with NAME. Use SOURCE as source branch name (defaults to default branch for repository)"
  echo "  find name        use NAME as worktree name. Print path of worktree if found"
  echo "  root             Print path of worktree root"
}

command=""

if [[ -z "$1" ]]; then
  usage
  exit 1
fi

if [[ -n "$1" && ("$1" == "setup" || "$1" == "add" || "$1" == "find" || "$1" == "root") ]]; then
  command="$1"
fi

if [[ -z "$command" ]]; then
  usage
  exit 1
fi

if [[ "$command" == "setup" ]]; then
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
  pushd $folder

  git clone --bare "$url"
  pushd $bare_folder

  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

  default_branch=$(git remote show "$url" | sed -n '/HEAD branch/s/.*: //p' | xargs echo)
  git worktree add ../"$default_branch" "$default_branch"

  cd ../

  echo $default_branch >.gitdefaultbranch

  exit 0
fi

if [[ "$command" == "add" ]]; then
  branch="$2"

  if [[ -z "$branch" ]]; then
    usage
    exit 1
  fi

  attempts=10
  while ! [[ -f ".gitdefaultbranch" ]]; do
    if [[ $attempts -lt 1 ]]; then
      break
    fi

    cd ../
    attempts=$((attempts - 1))
  done

  if ! [[ -f ".gitdefaultbranch" ]]; then
    echo "Error: cannot find .gitdefaultbranch"
    exit 1
  fi

  source_branch=$(head -n 1 .gitdefaultbranch)

  if [[ -n "$3" ]]; then
    source_branch="$3"
  fi

  # find bare folder
  fd -td -d1 -1 -q .git

  if [[ $? -eq 1 ]]; then
    echo "Error: can't find bare folder"
    exit 1
  fi

  bare_folder=$(fd -td -d1 -1 .git)
  cd "$bare_folder"

  git worktree add -b "$branch" "../$branch" "$source_branch"

  exit 0
fi

if [[ "$command" == "find" ]]; then
  worktree="$2"

  if [[ -z "$worktree" ]]; then
    usage
    exit 1
  fi

  attempts=10
  while ! [[ -d "$worktree" ]]; do
    if [[ $attempts -lt 1 ]]; then
      break
    fi

    cd ../
    attempts=$((attempts - 1))
  done

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
    echo "Error: cannot find .gitdefaultbranch"
    exit 1
  fi

  pwd

  exit 0
fi
