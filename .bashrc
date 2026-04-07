#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\@] \u@\h \w \$ '


alias update='yay -Syu'

# db custom bin
export PATH="$HOME/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

alias cacafire='CACA_DRIVER=ncurses cacafire'

# adaptive fastfetch: side-by-side logo on wide terminals, logo on top when narrow
fastfetch() {
    if [ "$(tput cols)" -lt 105 ]; then
        command fastfetch --logo-position top "$@"
    else
        command fastfetch "$@"
    fi
}
