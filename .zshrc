
# Aliases
export LOGIN_MDC=sbanerj
export LOGIN_BIH=sbanerj_m
export EMAIL=suharto.banerjee@mdc-berlin.de

alias bihlogin1="ssh -A -t -l $LOGIN_BIH hpc-login-1.cubi.bihealth.org"
alias bihlogin2="ssh -A -t -l $LOGIN_BIH hpc-login-2.cubi.bihealth.org"
#alias bihx1="ssh -X -l $LOGIN_BIH hpc-login-1.cubi.bihealth.org"
#alias bihx2="ssh -X -l $LOGIN_BIH hpc-login-2.cubi.bihealth.org"
alias maxlogin="ssh ${LOGIN_MDC}@max-login.mdc-berlin.net"


alias kbihlogin1="kitty +kitten ssh -A -t -l $LOGIN_BIH hpc-login-1.cubi.bihealth.org"
alias kbihlogin2="kitty +kitten ssh -A -t -l $LOGIN_BIH hpc-login-2.cubi.bihealth.org"
alias kbihx="kitty +kitten ssh -X -l $LOGIN_BIH hpc-login-1.cubi.bihealth.org"
alias kmaxlogin="kitty +kitten ssh ${LOGIN_MDC}@max-login.mdc-berlin.net"


## Mounting clusters locally ##
# defer permissions is to allow me to access folders only
# sbanerj_m can access. Be careful with this
bih_mount ()
{
    # unmounting if already mounted
    if [[ $(mount | grep BIH_CLUSTER) ]]; then
       bih_unmount 
    fi

    sshfs -o follow_symlinks $LOGIN_BIH@hpc-transfer-2.cubi.bihealth.org:/fast/users/sbanerj_m/ ~/PhD_SandersLab/BIH_CLUSTER -o volname=BIH_CLUSTER -o defer_permissions
}

bih_unmount ()
{
    diskutil unmount force ~/PhD_SandersLab/BIH_CLUSTER
}


# max cluster mount and unmounting functions
max_mount ()
{
    # unmounting if already mounted
    if [[ $(mount | grep MAX_CLUSTER) ]]; then
       max_unmount 
    fi

    sshfs -o follow_symlinks $LOGIN_MDC@max-login1.mdc-berlin.net:/home/sbanerj/ ~/PhD_SandersLab/MAX_CLUSTER -o volname=MAX_CLUSTER -o defer_permissions
}

max_unmount ()
{
    diskutil unmount force ~/PhD_SandersLab/MAX_CLUSTER
}


# Functions to copy data from cluster to local
bih_local_copy ()
{
    rsync -avPe ssh $LOGIN_BIH@hpc-transfer-2.cubi.bihealth.org:$1 $2
}

max_local_copy ()
{
    rsync -avPe ssh $LOGIN_MDC@max-login1.mdc-berlin.net:$1 $2
}

# login to ssh "jail" outside MDC. Then run 1. or 2. above to log into the cluster 
alias jail="eval '$(ssh-agent -s)' ; ssh-add ; ssh -A -t -l ${LOGIN_MDC} ssh1.mdc-berlin.de"

# for managing the dotfiles repo
alias dotfiles='git --git-dir=$HOME/.dotfiles/.git/ --work-tree=$HOME'

# Lazy aliases
alias v='vim'
alias e='nvim'
alias l='less'
alias la='ls -lah'
alias t='tree -L 1'
alias tt='tree -L 2'
alias ttt='tree -L 3'
alias u='cd ..'
alias cpr='cp -r'
alias s='kitty +kitten'
alias cls='clear'

# Making neovim the default editor
export EDITOR="nvim"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/sbanerj/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/sbanerj/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/sbanerj/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/sbanerj/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


autoload -U colors && colors
PS1="%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[magenta]%}%m %{$fg[green]%}%(5~|%-1~/.../%3~|%4~) %{$reset_color%}%% "
