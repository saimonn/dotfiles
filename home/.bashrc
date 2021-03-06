# ~/.bashrc: executed by bash(1) for non-login shells.

export LESS='-q'
export EDITOR=vim
export LESS='--quit-if-one-screen --RAW-CONTROL-CHARS --no-init'

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
export HISTCONTROL=ignoredups
eval `dircolors`
alias ls='ls $LS_OPTIONS'
alias l='ls $LS_OPTIONS -Fahl'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

if [ `id -u` -eq 0 ]; then
  export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/bin/X11:/usr/games"
fi
# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
   PATH=~/bin:"${PATH}"
fi

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# include .bashrc.d files
if [ -d ~/.bashrc.d/ ]
then
  for f in ~/.bashrc.d/*
  do
    source $f
  done
fi
