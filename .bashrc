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
HISTSIZE=1000
HISTFILESIZE=2000

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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

_git_branch_delete_pattern () {
  git branch | grep $1 | xargs git branch -D
}

_git_rebase_onto () {
  _REBASE_FROM="HEAD~1"
  _REBASE_TO="origin/master"
  if [[ -z "$1" && -z "$2" ]]; then
    # $1 is the commit that we are rebasing from
    # $2 is the commit that we are rebasing to
    _REBASE_FROM=$1
    _REBASE_TO=$2
  elif [[ -z "$1" ]]; then
    # $1 is the commit that we are rebasing to
    _REBASE_TO=$1
  fi
  git rebase $_REBASE_FROM --onto $_REBASE_TO
}


__set_prompt() {
  local EXIT="$?"             # This needs to be first
  PS1=""

  local Red='\[\e[0;31m\]'
  local Gre='\[\e[0;32m\]'
  local Blu='\[\e[1;34m\]'
  local Purp='\[\e[1;35m\]'
  local BluBG='\[\e[48;5;27m\e[38;5;231m\]'
  local Clear='\[\e[0m\]'

  if [ $EXIT != 0 ]; then
    PS1+="[${Red}${EXIT}${Clear}]"      # Add red if exit code non 0
  fi

  if [ -f /.dockerenv ]; then
    PS1+="${BluBG}\u@\h${Clear}"
  else
    PS1+="\u@\h"
  fi
  PS1+="${Blu}\w ${Purp}$(parse_git_branch)\[\e[00m\]$ "
}

export PROMPT_COMMAND=__set_prompt

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

export FZF_DEFAULT_COMMAND='rg --files --hidden'

#### ALIASES ####
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto -F'
  alias ll='ls --color=auto -Flh'
  alias la='ls --color=auto -Fa'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias ga='git add'
  alias gb='git branch'
  alias gbd='_git_branch_delete_pattern'
  alias gco='git checkout'
  alias gcb='git checkout -b'
  alias gcm='git commit'
  alias gcma='git commit --amend'
  alias gl='git log'
  alias gr='git rebase'
  alias gro='_git_rebase_onto'
  alias gs='git status'
fi

# https://www.atlassian.com/git/tutorials/dotfiles
alias dotconfig='/usr/bin/git --git-dir=$HOME/.dotconfig/ --work-tree=$HOME'

alias cds='cd ~/src/'
alias cdg='cd `git rev-parse --show-toplevel`'
alias r='ranger'
alias f='fzf'
alias tm='tmux attach -t default -d || tmux new-session -s default'

export VIMRC_PATH=$HOME/.vim/vimrc

export PATH=$PATH:$HOME/bin
if [ -e "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
