# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Private alias definitions.
if [ -f ~/.bashrc_private ]; then
  source ~/.bashrc_private
fi

# Fzf shortcuts.
if [ -f ~/.bashrc_fzf ]; then
  source ~/.bashrc_fzf
fi

# Fzf install
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

_git_alias() {
  _alias=$1
  _operation=$2
  alias $_alias="git $_operation"
  __git_complete $_alias _git_$_operation
}

if [ -f "/usr/share/bash-completion/completions/git" ]; then
  source /usr/share/bash-completion/completions/git
  _git_alias "ga" "add"
  _git_alias "gb" "branch"
  _git_alias "gco" "checkout"
  _git_alias "gcm" "commit"
  _git_alias "gl" "log"
  _git_alias "gr" "rebase"
  _git_alias "gs" "status"
fi

PROMPT_DIRTRIM=3
[ -f /.dockerenv ] && _IN_DOCKER=1

parse_git_branch() {
  local branch
  branch=$(git --no-optional-locks symbolic-ref --short HEAD 2>/dev/null) \
    || branch=$(git --no-optional-locks rev-parse --short HEAD 2>/dev/null) \
    || return
  if git --no-optional-locks diff-index --cached --quiet HEAD -- 2>/dev/null; then
    echo '\[\e[0;32m\]'"($branch)"
  else
    echo '\[\e[0;33m\]'"($branch)"
  fi
}
__set_prompt() {
  local EXIT="$?"             # This needs to be first
  PS1=""

  local Red='\[\e[0;31m\]'
  local Yel='\[\e[1;33m\]'
  local Blu='\[\e[1;34m\]'
  local BluBG='\[\e[48;5;27m\e[38;5;231m\]'
  local Clear='\[\e[0m\]'

  if [ "$EXIT" != 0 ]; then
    PS1+="[${Red}${EXIT}${Clear}]"      # Add red if exit code non 0
  fi

  local _kube_ctx
  _kube_ctx=$(kubectl config current-context 2>/dev/null)
  if [[ -n "$_kube_ctx" && ! "$_kube_ctx" =~ "dev" ]]; then
    PS1+="${Yel}[CAUTION: K8S PROD CONTEXT]${Clear} "
  fi

  [ -n "$VIRTUAL_ENV" ] && PS1+="(${VIRTUAL_ENV##*/}) "

  if [ -n "$_IN_DOCKER" ]; then
    PS1+="${BluBG}\u@\h${Clear}"
  else
    PS1+="\u@\h"
  fi
  PS1+="${Blu}\w ${Clear}$(parse_git_branch)${Clear}$ "
}
PROMPT_COMMAND=__set_prompt

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export FZF_DEFAULT_COMMAND='rg --files --hidden'

_git_delete_branches() {
  pattern=$1
  # Get the list of local branches matching the pattern
  branches=$(git branch | grep -E "$pattern" | sed 's/^\s*//')

  for branch in $branches; do
    if ! git show-ref --verify --quiet --heads "refs/heads/$branch"; then
      # Skip invalid branches
      continue
    fi
    # Confirm before deletion
    next_branch=0
    while [ $next_branch == 0 ]; do
      read -p "Are you sure you want to delete $branch? (y/n/l): " confirm
      if [ "$confirm" == "y" ]; then
        git branch -D "$branch"
        echo "Deleted local branch: $branch"
        next_branch=1
      elif [ "$confirm" == "n" ]; then
        next_branch=1
      elif [ "$confirm" == "l" ]; then
        git log $branch
      fi
    done
  done
}

_git_rebase_onto () {
  _REBASE_FROM="HEAD~1"
  _REBASE_TO="origin/master"
  if [[ -n "$1" && -n "$2" ]]; then
    # $1 is the commit that we are rebasing from
    # $2 is the commit that we are rebasing to
    _REBASE_FROM=$1
    _REBASE_TO=$2
  elif [[ -n "$1" ]]; then
    # $1 is the commit that we are rebasing to
    _REBASE_TO=$1
  fi
  git rebase $_REBASE_FROM --onto $_REBASE_TO
}

_git_prune_local_branches() {
  git fetch -p  # Prune deleted remote branches
  for branch in $(git branch -vv | awk '/: gone]/{print $1}'); do
    git branch -D "$branch"
  done
}

_wt_path() {
  local branch="$1"
  local main_repo
  main_repo=$(git worktree list 2>/dev/null | head -1 | awk '{print $1}')
  if [[ -z "$main_repo" ]]; then
    echo "Not in a git repository" >&2
    return 1
  fi
  echo "$HOME/.worktrees/$(basename "$main_repo")-${branch//\//-}"
}

_wt_fzf() {
  find "$HOME/.worktrees" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | \
    fzf --prompt="${1:-Worktree: }" --preview="git -C {} log --oneline -5 2>/dev/null"
}

_wt_open() {
  local name="$1" path="$2"
  if ! tmux select-window -t "$name" 2>/dev/null; then
    tmux new-window -n "$name"
    tmux send-keys "cd '$path' && clear" Enter
  fi
}

_wt_create() {
  local branch="$1"
  local repo_root worktree_path
  repo_root=$(git worktree list 2>/dev/null | head -1 | awk '{print $1}')
  if [[ -z "$repo_root" ]]; then
    echo "Not in a git repository" >&2
    return 1
  fi
  worktree_path=$(_wt_path "$branch") || return 1

  if ! git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$repo_root" branch "$branch"
  fi

  mkdir -p "$HOME/.worktrees"
  if [[ ! -d "$worktree_path" ]]; then
    git -C "$repo_root" worktree add "$worktree_path" "$branch"
  fi

  _wt_open "${branch//\//-}" "$worktree_path"
}

_wt_remove() {
  local worktree_path
  if [[ -n "$1" ]]; then
    worktree_path=$(_wt_path "$1") || return 1
  else
    worktree_path=$(_wt_fzf "Delete worktree: ")
    [[ -z "$worktree_path" ]] && return 0
  fi

  local branch=$(git -C "$worktree_path" rev-parse --abbrev-ref HEAD 2>/dev/null)
  local main_repo=$(git -C "$worktree_path" worktree list 2>/dev/null | head -1 | awk '{print $1}')

  git worktree remove "$worktree_path" || return 1
  echo "Removed worktree: $worktree_path"

  if [[ -n "$branch" && "$branch" != "HEAD" && -n "$main_repo" ]]; then
    git -C "$main_repo" branch -d "$branch"
  fi
}

_wt_navigate() {
  local worktree_path
  worktree_path=$(_wt_fzf) || return 0
  [[ -z "$worktree_path" ]] && return 0
  _wt_open "$(basename "$worktree_path")" "$worktree_path"
}

wt() {
  case "$1" in
    rm) _wt_remove "$2" ;;
    "")  _wt_navigate ;;
    *)   _wt_create "$1" ;;
  esac
}

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

#### ALIASES ####
alias v="nvim"
alias ls='ls --color=auto -F'
alias ll='ls --color=auto -Flh'
alias la='ls --color=auto -Fa'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias gbd='_git_delete_branches'
alias gpb='_git_prune_local_branches'
alias gcb='git checkout -b'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gro='_git_rebase_onto'

# https://www.atlassian.com/git/tutorials/dotfiles
alias dotconfig='/usr/bin/git --git-dir=$HOME/.dotconfig/ --work-tree=$HOME'

alias cds='cd ~/src/'
alias cdg='cd `git rev-parse --show-toplevel`'
alias r='ranger'
alias f="fzf --bind 'enter:become(nvim {})'"
alias tm='tmux attach -t default -d || tmux new-session -s default'

export VIMRC_PATH=$HOME/.vim/vimrc

export PATH=$PATH:$HOME/bin:/usr/local/bin

[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv bash)"

[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"
