## General settings ##

shopt -s checkwinsize # fix line wrap on window resize
shopt -s cdspell      # correct "cd" misspelling
set -o noclobber      # prevent overwritting of file with > (use >| to override)
#shopt -s hostcomplete # hostname expansion
#shopt -s extglob      # extended pattern matching features

HISTSIZE=5000                               # historyopts: http://git.io/Y18IYA
HISTFILESIZE=20000
HISTCONTROL=erasedups
shopt -s histappend
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

set_prompt_style () {                       # Command prompt
  local bldblk='\e[1;30m'                   # bold black
  local bldred='\e[1;31m'                   # bold red
  local bldgrn='\e[1;32m'                   # bold green
  local bldblu='\e[1;34m'                   # bold blue
  local bldpur='\e[1;35m'                   # bold purple
  local txtrst='\e[0m'                      # text reset
  local bashusr="\[$bldgrn\]\u@\[$txtrst\]" # username
  local bashhst="\[$bldgrn\]\h\[$txtrst\]"  # hostname
  local bashdir="\[$bldblu\]\W\[$txtrst\]"  # directory
  local bashprt="\[$bldblk\]: \[$txtrst\]"  # prompt character
  if [ $EUID = 0 ]; then
    local bashusr=""
    local bashhst="\[$bldred\]\h\[$txtrst\]"
  fi
  PS1="${bashusr}${bashhst} ${bashdir}${bashprt}"
} ; set_prompt_style

eval $(dircolors -b)                        # coloring for ls and grep
alias grep='grep --color=auto'
export GREP_COLOR="1;35"                    # purple

if [[ ${TERM} == "xterm" ]]; then           # manpage coloring for less
  export LESS_TERMCAP_mb=$'\e[1;31m'        # red
  export LESS_TERMCAP_md=$'\e[01;38;5;12m'  # bold mode      - main      (blue)
  export LESS_TERMCAP_us=$'\e[38;5;13m'     # underline mode - second    (purp)
  export LESS_TERMCAP_so=$'\e[38;5;06m'     # standout-mode  - info/find (cyan)
  export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking - unused?   (red)
  export LESS_TERMCAP_ue=$'\e[0m'           # end underline
  export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
  export LESS_TERMCAP_me=$'\e[0m'           # end all mode   - txt rest
else
  export LESS_TERMCAP_md=$'\e[01;34m'
  export LESS_TERMCAP_us=$'\e[01;35m'
  export LESS_TERMCAP_so=$'\e[01;30m'
  export LESS_TERMCAP_mb=$'\e[01;31m'
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_me=$'\e[0m'
fi

# Paths (additional executable directories)
scrpt_dir=$HOME/.local/bin                  # local script directory
export PATH="$scrpt_dir:$PATH"

## Aliases ##

alias ls='ls --color=auto --group-directories-first' # Lists
alias ls1='ls -1'                                    # sort by line
alias lsd='ls -lAtrh'                                # sort by date
alias lsl='ls -lAh'                                  # long list, human-readabl
alias lss='ls -shAxSr'                               # sort by size
alias lsx='ls -lAhX'                                 # sort by extension
alias treeview='tree -C | less -R'                   # tree directory w/ pager

alias   ..="cd .."                                   # Directories
alias  ...='cd ../..'
alias ....='cd ../../..'
alias cdd="cd ~/Desktop/"
alias cdp="cd ~/.local/abs/"
alias cds="cd $scrpt_dir"
alias cdt="cd ~/.local/share/Trash/files/"

alias chx="chmod +x"                                 # Other
alias cp="cp -ai"                                    # cp interactive if exists
alias iotop="sudo iotop"
alias pn="ping -c2 archlinux.org"
alias rm="rm -i"                                     # remove interactively
alias v="vim"
alias vi="vim"
alias sv="sudo vim"

## Functions ##

abacus () { awk "BEGIN { print $* ; }"; }
#abacus () { echo "scale=4;$@" | bc -l ; }
pdfcat () {
  gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
  -sOutputFile=concatenated.pdf "$@" ;}

## Bash-completion ##

complete -cf bgcmd
complete -W "`awk '{ print $2 }' /etc/hosts`" ssh
complete -cf sudo
bashcompfiles=(/usr/share/bash-completion/completions/burp
               /usr/share/doc/pkgfile/command-not-found.bash
               /usr/share/git/completion/git-completion.bash)
for file in ${bashcompfiles[@]}; do
  [ -f "$file" ] && source "$file"; done

# vim:set ft=sh ts=2 sw=2 et: