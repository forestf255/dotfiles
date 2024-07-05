# enable color support of ls etc...
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Load git integration
autoload -Uz vcs_info
precmd() {vcs_info}
zstyle ':vcs_info:git:*' formats '(%b)'

# Load color support
autoload -U colors && colors

# Set prompt
if [ -f /.dockerenv ]; then
  setopt PROMPT_SUBST
  PROMPT='%n@%m %F{green}%~ %F{red}${vcs_info_msg_0_}%F{white}$ '
else
  setopt PROMPT_SUBST
  PROMPT='%n@%m %F{green}%~ %F{red}${vcs_info_msg_0_}%F{white}$ '
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

bindkey -v
bindkey '^R' history-incremental-search-backward

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Fixex ctrl-arrow skipping words
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

source ~/.zsh/aliases
source ~/.work/workrc

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# Load zsh-syntax-highlighting; should be last.
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
