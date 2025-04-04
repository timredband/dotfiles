#!/usr/bin/env bash

set -e
set -o pipefail

function usage() {
  echo "Usage: ./worktree.sh command [OPTION]"
  echo "Commands:"
  echo "  init url             use URL as repository url. Initialize repository with default worktree"
  echo "  add [name] [source]  use NAME as branch name. Add worktree with NAME. Use SOURCE as source branch name (defaults to default branch for repository). If NAME omitted use fzf"
  echo "  find [name]          use NAME as worktree name. Find worktree with NAME. If NAME omitted use fzf"
  echo "  root                 print path of worktree root"
  echo "  remove [name]        use NAME as worktree name. Remove worktree with NAME. If NAME omitted use fzf"
  echo "  list                 list worktrees"
  echo "  bare                 print path of bare repository"
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

  worktree_root=$(worktree root) || found=$?

  if [[ $found -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd "$worktree_root"

  source_branch=$(head -n 1 .gitdefaultbranch)

  if [[ -n "$3" ]]; then
    source_branch="$3"
  fi

  bare_folder=$(worktree bare) || found=$?

  if [[ $found -eq 1 ]]; then
    echo "Error: can't find bare folder"
    exit 1
  fi

  cd "$bare_folder"

  selected=""
  if [[ -z "$branch" ]]; then
    selected=$(git branch --all | fzf | tr -d '[:space:]*')

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
  worktree_root=$(worktree root) || found=$?

  if [[ $found -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd "$worktree_root"

  selected="$2"

  if [[ -z "$selected" ]]; then
    selected=$(fd --path-separator "" -td -d1 | fzf)
  fi

  if [[ -d "$selected" ]]; then
    cd "$selected"
    pwd
  else
    echo "Error: worktree $selected not found"
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
  worktree_root=$(worktree root) || found=$?

  if [[ $found -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd "$worktree_root"

  selected="$2"

  if [[ -z "$selected" ]]; then
    selected=$(fd --path-separator "" -td -d1 | fzf)

    if [[ -z "$selected" ]]; then
      echo "Error: no worktree selected"
      exit 1
    fi
  fi

  bare_folder=$(worktree bare) || found=$?

  if [[ $found -eq 1 ]]; then
    echo "Error: can't find bare folder"
    exit 1
  fi

  cd "$bare_folder"

  if [[ -n "$selected" ]]; then
    git worktree remove "$selected"
    echo "Successfully removed worktree $selected"
  else
    echo "Error: worktree $2 not found"
  fi

  exit 0
fi

if [[ "$command" == "list" ]]; then
  worktree_root=$(worktree root) || found=$?

  if [[ $found -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd "$worktree_root"

  fd --color never --path-separator "" -td -d1

  exit 0
fi

if [[ "$command" == "bare" ]]; then
  worktree_root=$(worktree root) || found=$?

  if [[ $found -eq 1 ]]; then
    echo "Error: cannot find worktree root"
    exit 1
  fi

  cd $worktree_root

  # find bare folder
  fd -td -d1 -1 -q .git || found=$?

  if [[ $found -eq 1 ]]; then
    echo "Error: can't find bare folder"
    exit 1
  fi

  bare_folder=$(fd --path-separator "" -td -d1 -1 .git)
  echo "$bare_folder"
fi
