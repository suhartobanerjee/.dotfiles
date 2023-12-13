
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


## ---- Personal script starts here ---- ##

# env variables
export MY_NAME=suharto
export L_NAME=sbanerj
export GROUP=ag_sanders
export MY_EMAIL=suharto.banerjee@mdc-berlin.de
export TMPDIR=/fast/AG_Sanders/suharto/TMPDIR
export PAGER=less
export GUIX_PROFILE="/home/sbanerj/.config/guix/current"




# Lazy aliases
alias v='vim'
alias e='AppRun'
alias nvim='AppRun'
alias l='less'
alias t='tree -L 1'
alias tt='tree -L 2'
alias ttt='tree -L 3'
alias la="ls -alh --color=auto"
alias u="cd .."
alias cpr='cp -r'
alias grepi='grep -i'
alias dush='du -sh'
alias cls='clear'
alias ls='ls --color=auto'



# gridEngine intact job submission
qrspec() {
    qrsh -now no -pe smp $1 -l m_mem_free=${2}G
}

bih_max_transfer() {
    rsync -avPe "ssh -i ~/.ssh/bih_private_key" "sbanerj_m@hpc-transfer-2.cubi.bihealth.org:$1" "$2"
}

max_bih_transfer() {
    rsync -avPe "ssh -i ~/.ssh/bih_private_key" "$1" "sbanerj_m@hpc-transfer-1.cubi.bihealth.org:$2"
}


# think of a way to recycle_items
recycle_items() {
    mkdir -p $s_scratch/TRASH/$(date +%Y%m%d_%H%M%S_$1)

    for item in "$@"
    do
        printf "\nMoving $@ to TRASH ...\n"
        mv $item $s_scratch/TRASH/$(date +%Y%m%d_%H%M%S_$1)/.
    done
}



# Path variables
export PATH="/home/sbanerj/.guix-profile/bin:$PATH"
export PATH="/home/sbanerj/.config/guix/current/bin:$PATH"
export PATH="/home/sbanerj/suh/squashfs-root:$PATH"

# export environmental variables
#export TERM=xterm
#export TERM=tmux

# prettify the terminal prompt with colors
#PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '
PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;35m\]\h:\[\033[1;32m\]$( [ "$PWD" = "$HOME" ] && echo "~" || echo ".../$(basename "$(dirname "$(dirname "$PWD")")")/$(basename "$(dirname "$PWD")")/$(basename "$PWD")" )\[\033[1;31m\]\$\[\033[0m\] '


# alias to access dotfiles git
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/sbanerj/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/sbanerj/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/sbanerj/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/sbanerj/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


