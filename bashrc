# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000 # flush bash_history after each command, so that bash hisotory is shared
# among multiple session/terminal environment
export PROMPT_COMMAND='history -a'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

#----------------
# PS1
#----------------
if [ -f ~/.git-prompt.sh ]; then
	source ~/.git-prompt.sh
	export PS1="\u@\h"'$(__git_ps1 "(%s)")'':$(echo $PWD | sed "s|${HOME}|~|")\$ '
	#export PS1='$(__git_ps1)'
else
	export PS1="\u@\h:\W\\$\[$(tput sgr0)\] "
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Load bash_profile
#if [ -f ~/.bash_profile ]; then
#    . ~/.bash_profile
#fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# User specific environment and startup programs
ENV=$HOME/.bashrc
PATH="$HOME/bin:$PATH:$HOME/usr/bin:/usr/local/bin"

# record time of command history
export HISTTIMEFORMAT='%Y-%m-%d %T '

# CTRL-w deletes back to the last path
stty werase undef
bind '\C-w:unix-filename-rubout'

#----------------
# python
#----------------

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

#----------------
# js
#----------------
export PATH=~/.npm-global/bin:$PATH

#----------------
# ssh
#----------------
# Make sure ssh-agent dies on logout
#trap '
#  test -n "${SSH_AGENT_PID}" && eval `ssh-agent -k`;
#  test -n "${SSH2_AGENT_PID}" && kill ${SSH2_AGENT_PID}
#' 0

function _ssh_auth_save
{
  export HOSTNAME=`hostname`
  _sock=~/.ssh/ssh_auth_sock.$HOSTNAME
  if [ ! -e "${_sock}" ]
  then
    ln -sf ${SSH_AUTH_SOCK} ${_sock}
    export SSH_AUTH_SOCK=${_sock}
  fi
}
alias tmux="_ssh_auth_save; tmux"

# If no agent is running and we have a terminal, run ssh-agent and ssh-add
if [ "${SSH_AUTH_SOCK}" == "" ]
then
  eval `ssh-agent`
  /usr/bin/tty > /dev/null && ssh-add
else
  _ssh_auth_save
fi

#----------------
# Haskell
#----------------
export GHC_DOT_APP="/Applications/ghc-7.10.3.app"
if [ -d "$GHC_DOT_APP" ]; then
	export PATH="${HOME}/.local/bin:${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi

#----------------
# Rust
#----------------
source $HOME/.cargo/env
