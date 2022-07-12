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
fi

# https://www.atlassian.com/git/tutorials/dotfiles
alias dotconfig='/usr/bin/git --git-dir=$HOME/.dotconfig/ --work-tree=$HOME'

alias cds='cd ~/src/'
alias cdg='cd `git rev-parse --show-toplevel`'
alias r='ranger'
alias f='fzf'
alias tm='tmux attach -t default || tmux new-session -s default'

