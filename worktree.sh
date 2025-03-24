#!/usr/bin/env bash

set -e

# check fetch configuration
# git config --local --get-all remote.origin.fetch

function usage() {
  echo "Usage: ./worktree.sh [OPTION]..."
  echo "Arguments:"
  echo "  setup url         use URL as repository url"
  echo "  add name source   use NAME as branch name. Use SOURCE as source branch name (defaults to default branch for repository)"
}

command=""

if [[ -z "$1" ]]; then
  usage
  exit 1
fi

if [[ -n "$1" && ("$1" == "setup" || "$1" == "add") ]]; then
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
    echo "Error: directory $folder already exists."
    exit 1
  fi

  mkdir $folder
  pushd $folder

  git clone --bare "$url"
  pushd $bare_folder

  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

  default_branch=$(git remote show "$url" | sed -n '/HEAD branch/s/.*: //p' | xargs echo)
  git worktree add ../"$default_branch" "$default_branch"

  exit 0
fi

if [[ "$command" == "add" ]]; then
  branch="$2"

  if [[ -z "$branch" ]]; then
    usage
    exit 1
  fi

  if [[ -n "$3" ]]; then
    source_branch="$3"
  else
    # TODO: decide if it's better not to reach out to the internet for this information
    source_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p' | xargs echo)
  fi

  url=$(git config get remote.origin.url)
  bare_folder="${url##*/}"

  while ! [[ -d "$bare_folder" ]]; do
    cd ../
  done

  cd "$bare_folder"

  git worktree add -b "$branch" "../$branch" "$source_branch"

  exit 0
fi
