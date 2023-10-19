# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


## ---- Personal script starts here ---- ##

# env variables
export MY_NAME=suharto
export L_NAME=sbanerj_m
export GROUP=ag_sanders
export MY_EMAIL=suharto.banerjee@mdc-berlin.de
export TMPDIR=/fast/users/$L_NAME/scratch/TMPDIR
export PAGER=less




# Lazy aliases
alias v='vim'
alias e='~/work/squashfs-root/AppRun'
alias nvim='~/work/squashfs-root/AppRun'
alias l='less'
alias t='tree -L 1'
alias tt='tree -L 2'
alias ttt='tree -L 3'
alias la="ls -alh"
alias u="cd .."
alias cpr='cp -r'
alias grepi='grep -i'
alias dush='du -sh'
alias ncpus='echo $SLURM_CPUS_PER_TASK'
alias cls='clear'


# Function to login to the compute node with variable cores and mem
slogin() { srun --nodes=1 --ntasks=1 --cpus-per-task=$1 --mem=${2}G --pty bash; }

# function to login when time is needed
sloginTime() { srun --nodes=1 --ntasks=1 --cpus-per-task=$1 --mem=${2}G --time=$3 --pty bash; }


# Function to login to the compute node with variable cores and mem
# with x11 forwarding
sloginx() { srun --nodes=1 --ntasks=1 --cpus-per-task=$1 --mem=${2}G --time=$3 --pty --x11 bash; }

# login to do basic stuff - 4 cores and 8gb of ram
alias base="slogin 8 16" 


# login to do basic stuff - 4 cores and 8gb of ram
# x11 forwarding
alias basex="sloginx 8 16 2-00" 


# launching srun with desired specs
alias spec="slogin $1 $2"

# to login with time bounds
alias specTime="sloginTime $1 $2 $3"

# launching srun with desired specs
# x11 forwarding
alias specx="sloginx $1 $2 2-00"


# Creating aliases to move to imp dir
alias gscratch="cd /fast/groups/${GROUP}/scratch/suharto_tmp"
alias gdata="cd /fast/groups/${GROUP}/work/data"
alias gprj="cd /fast/groups/${GROUP}/work/projects/suharto"
alias gtools="cd /fast/groups/${GROUP}/work/tools"

alias sscratch="cd /fast/scratch/users/${L_NAME}/"
alias swork="cd /fast/work/users/${L_NAME}/"


# checking the job resources
job_status() { sacct --format=JobID,Start,End,Elapsed,Partition,REQCPUS,State,ALLOCTRES%30 -j $1; }
alias jstat="job_status $1"
alias cjstat="job_status $SLURM_JOB_ID"


# storing the absolute path of imp folders
export g_scratch=/fast/groups/${GROUP}/scratch/${MY_NAME}_tmp
export g_data=/fast/groups/${GROUP}/work/data
export g_prj=/fast/groups/${GROUP}/work/projects/${MY_NAME}
export g_tools=/fast/groups/${GROUP}/work/tools

export s_scratch=/fast/scratch/users/${L_NAME}/
export s_work=/fast/work/users/${L_NAME}/

# list your current jobs on the cluster
alias myjobs="squeue --me"


# print disk quotas
alias myquota="bih-gpfs-report-quota user ${L_NAME}"
alias ourquota="bih-gpfs-report-quota group ${GROUP}"

alias del="recycle_items"
alias touchy="find . -type f -exec touch {} \;"



recycle_items() {
    mkdir -p $s_scratch/TRASH/$(date +%Y%m%d_%H%M%S_$1)

    for item in "$@"
    do
        printf "\nMoving $@ to TRASH ...\n"
        mv $item $s_scratch/TRASH/$(date +%Y%m%d_%H%M%S_$1)/.
    done
}



# Path variables
export PATH=$PATH:/fast/groups/ag_sanders/work/tools/eagle/Eagle_v2.4.1/
export PATH=$PATH:/fast/work/users/sbanerj_m/miniconda/envs/numbat/lib/R/library/numbat/bin/
export PATH="/fast/groups/ag_sanders/work/tools/cellranger-7.1.0:$PATH"
export PATH="$g_tools/sra-toolkit/sratoolkit.3.0.1-centos_linux64/bin:$PATH"
export PATH="/fast/groups/ag_sanders/work/tools/CrushTunnel:$PATH"


# export environmental variables
#export TERM=xterm
#export TERM=tmux

# prettify the terminal prompt with colors
#PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '
PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;35m\]\h:\[\033[1;32m\]$( [ "$PWD" = "$HOME" ] && echo "~" || echo ".../$(basename "$(dirname "$(dirname "$PWD")")")/$(basename "$(dirname "$PWD")")/$(basename "$PWD")" )\[\033[1;31m\]\$\[\033[0m\] '


# alias to access dotfiles git
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'




# Make Conda available upon login
case "${SLURMD_NODENAME-${HOSTNAME}}" in
    login-*)
        ;;
    *)
        export PATH=$HOME/work/miniconda3/condabin:$PATH
        ;;
esac



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/fast/work/users/sbanerj_m/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/fast/work/users/sbanerj_m/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/fast/work/users/sbanerj_m/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/fast/work/users/sbanerj_m/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/fast/work/users/sbanerj_m/miniconda3/etc/profile.d/mamba.sh" ]; then
    . "/fast/work/users/sbanerj_m/miniconda3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<


