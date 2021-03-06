## General settings
shopt -s autocd       # prepend cd, enables entering path only to change dir.
shopt -s checkwinsize # window size monitor to adjust line wrappings
shopt -s cdspell      # fix cd directory misspellings
#shopt -s extglob      # extended pattern matching features
#shopt -s hostcomplete # hostname expansion
source /etc/profile.d/vte.sh  # adopt current working directory in new terms.

# prevent redirection overwrites (use >| to force)
set -o noclobber

## History: http://git.io/Y18IYA
HISTSIZE=5000
HISTFILESIZE=20000
HISTCONTROL=erasedups
shopt -s histappend
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

## Prompt
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
# Cursor color (man colors` for values)
#echo -en "\e]12;grey40\a"
echo -en "\e]12;forest green\a"

## Colors
eval $(dircolors -b)                        # coloring for ls and grep
alias grep='grep --color=auto'
export GREP_COLOR="1;35"                    # purple

if [[ ${TERM} == "xterm" ]]; then           # manpage colors with less pager
  export LESS_TERMCAP_mb=$'\e[1;31m'        # mode blinking     - unused?! (red)
  export LESS_TERMCAP_md=$'\e[01;38;5;12m'  # mode double-bright- primary  (blu)
  export LESS_TERMCAP_so=$'\e[01;38;5;08m'  # mode standout     - info/find(gry)
  export LESS_TERMCAP_us=$'\e[38;5;13m'     # underline start   - secondary(pur)
  export LESS_TERMCAP_me=$'\e[0m'           # mode end (reset: mb, md, so, us)
  export LESS_TERMCAP_se=$'\e[0m'           # standout-mode end
  export LESS_TERMCAP_ue=$'\e[0m'           # underline end
else
  export LESS_TERMCAP_mb=$'\e[01;31m'
  export LESS_TERMCAP_md=$'\e[01;34m'
  export LESS_TERMCAP_so=$'\e[01;30m'
  export LESS_TERMCAP_us=$'\e[01;35m'
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_ue=$'\e[0m'
fi

## Environment
scrpt_dir=$HOME/.local/bin                           # Local script directory
export PATH="$scrpt_dir:$PATH"

## Aliases
alias ls="ls --color=auto --group-directories-first" # Lists
alias ls1="ls -1"                                    # sort by line
alias lsd="ls -lAtrh"                                # sort by date
alias lsl="ls -lAh"                                  # long list, human-readable
alias lss="ls -shAxSr"                               # sort by size
alias lsx="ls -lAhX"                                 # sort by extension

alias cda="cd ~/.local/abs/"                         # Directory shortcuts
alias cdb="cd $scrpt_dir"
alias cdd="cd ~/Desktop/"
alias cdt="cd ~/.local/share/Trash/files/"

alias c="clear"                                      # Other
alias chx="chmod +x"
alias cp="cp -ai"                                    # cp interactive if exists
alias iotop="sudo iotop"
alias mv="mv -ni"                                    # mv interactive if exists
alias rm="rm -i"                                     # remove interactively
alias tarlist="bsdtar -tvf"                          # archive list contents
alias v="vim"
alias vi="vim"
alias sv="sudo vim"

alias ebash="sv /usr/share/doc/gently-bashrc/gently.bashrc"
alias sbash="source /usr/share/doc/gently-bashrc/gently.bashrc"

## Bash completion
complete -cf bgcmd
complete -W "`awk '{ print $2 }' /etc/hosts`" ssh
complete -cf sudo

bashcompfiles=(/usr/share/bash-completion/completions/burp
               /usr/share/bash-completion/completions/dkms
               /usr/share/bash-completion/completions/systemctl
               /usr/share/doc/pkgfile/command-not-found.bash
               /usr/share/git/completion/git-completion.bash)
for file in ${bashcompfiles[@]}; do
  [ -f "$file" ] && source "$file"
done

## Functions ##
abacus    () { awk "BEGIN { print $* ; }" ; }
g         () { nohup gedit "$@" &> /dev/null & }
mountlist () { mount | awk '{ print $1" "$3" "$5" "$6 }' | sort -uV | \
                 column -t -o " " ; }
pb        () { if curl -Is https://www.archlinux.org -o /tmp/url-head; then
                 echo "Network is connected."
               else
                 echo "Network unavailable."
               fi ; }
treeless  () { if [ $# -gt 0 ]; then
                 dir=$(realpath "$1")
               else
                 dir=$(realpath $PWD)
               fi
               tree -C -a "$dir" | less -R ; }

# vim:set ft=sh ts=2 sw=2 et:
