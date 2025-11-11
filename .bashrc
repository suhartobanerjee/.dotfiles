# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


## ---- Personal script starts here ---- ##

# env variables
export MY_NAME=suharto
export L_NAME=sbanerj_m
export GROUP=sanders
export MY_EMAIL=suharto.banerjee@mdc-berlin.de
export TMPDIR=/data/cephfs-1/scratch/projects/sanders-digital-karyotype/TMPDIR
export SYSTEMD_PAGER=/usr/bin/less
export PAGER=/usr/bin/less




# Lazy aliases
alias v='vim'
alias e='nvim'
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
alias mtop='htop -u $L_NAME'
alias pwd="realpath ."


# Function to login to the compute node with variable cores and mem
slogin() { srun --ntasks=1 --cpus-per-task=${1:-2} --mem=${2:-8}G --pty bash; }

# function to login when GPU is needed
sloginGPU() { srun --gres=gpu:tesla:$1 --partition gpu --ntasks=$2 --mem=${3}G --pty bash; }

# function to login when time is needed
sloginTime() { srun --nodes=1 --ntasks=${1:-2} --mem=${2:-8}G --time=$3 --pty bash; }


# Function to login to the compute node with variable cores and mem
# with x11 forwarding
sloginx() { srun --nodes=1 --ntasks=1 --cpus-per-task=$1 --mem=${2}G --time=$3 --pty --x11 bash; }


# storing the absolute path of imp folders
# this is based on the symlinks in my
# home dir
export g_scratch=$(readlink ~/my_gscratch)
export g_data=$(readlink ~/group_data)
export g_prj=$(readlink ~/my_gprojects)
export g_tools=$(readlink ~/group_tools)

export s_work=$(readlink ~/work)
export dig_kar=$(readlink ~/sanders-digital-karyotype)

# Creating aliases to move to imp dir
alias gscratch="cd $g_scratch"
alias gdata="cd $g_data"
alias gprj="cd $g_prj"
alias gtools="cd $g_tools"

alias swork="cd $s_work"
alias digkar="cd $dig_kar"


# checking the job resources
job_status() { sacct --format=JobID,Elapsed,ReqCPUS,ReqMem -j $1; }
alias jstat="job_status $1"
alias cjstat="job_status $SLURM_JOB_ID"
alias gpustatus="squeue | grep -iwE 'JOBID|gpu'"
alias blockedgpus='gpustatus | grep hpc | wc -l'



# list your current jobs on the cluster
alias myjobs="squeue --me"


# print disk quotas
alias myquota="bih-gpfs-report-quota user ${L_NAME}"
alias ourquota="bih-gpfs-report-quota group ${GROUP}"

#alias del="recycle_items"
alias touchy="find . -exec touch {} \;"


function deletethis() {
    filename=$(basename $1)
    deldir=~/scratch/deletethis/$(date +%Y%m%d_%H%M%S_$filename)
    mkdir -p $deldir
    for myfile in "$@"
    do
        echo "deleting $myfile"
        mv $myfile $deldir
    done
}


function undodeletethis(){
    mydir=$(ls -t ~/scratch/deletethis | head -n1)
    for myfile in ~/scratch/deletethis/${mydir}/*
    do
        myname=$(basename ${myfile})
        echo "restoring ${myname}"
        mv ${myfile} .
    done
    rmdir ~/scratch/deletethis/${mydir}
}


recycle_items() {
    mkdir -p $s_scratch/TRASH/$(date +%Y%m%d_%H%M%S_$1)

    for item in "$@"
    do
        printf "\nMoving $@ to TRASH ...\n"
        mv $item $s_scratch/TRASH/$(date +%Y%m%d_%H%M%S_$1)/.
    done
}



# Path variables
# Will change the paths if required. Migrated
# export PATH=$PATH:/fast/groups/ag_sanders/work/tools/eagle/Eagle_v2.4.1/
# export PATH=$PATH:/fast/work/users/sbanerj_m/miniconda/envs/numbat/lib/R/library/numbat/bin/
# export PATH="/fast/groups/ag_sanders/work/tools/cellranger-7.1.0:$PATH"
export PATH="${g_tools}/sra-toolkit/sratoolkit.3.0.1-centos_linux64/bin:$PATH"
export PATH="${g_tools}/CrushTunnel:$PATH"
export PATH="/data/cephfs-1/work/groups/sanders/users/sbanerj_m/nvim-linux-x86_64/bin:$PATH"
export PATH="/data/cephfs-1/work/groups/sanders/users/sbanerj_m/ripgrep-14.1.1-x86_64-unknown-linux-musl:$PATH"
export PATH="/data/cephfs-1/home/users/sbanerj_m/work/fd-v10.2.0-x86_64-unknown-linux-gnu:$PATH"


# export environmental variables
export TERM=xterm-256color
export LC_ALL=C.utf8
export LANG=C.utf8
#export TERM=tmux

# prettify the terminal prompt with colors
#PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '
PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;35m\]\h:\[\033[1;32m\]$( [ "$PWD" = "$HOME" ] && echo "~" || echo ".../$(basename "$(dirname "$(dirname "$PWD")")")/$(basename "$(dirname "$PWD")")/$(basename "$PWD")" )\[\033[1;31m\]\$\[\033[0m\] '


# alias to access dotfiles git
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


# activate conda env and export a global var to capture
# in nvim
conda_activate () {
    conda activate $1
    export CDE=$(echo $CONDA_DEFAULT_ENV)
}


# Make Conda available upon login
case "${SLURMD_NODENAME-${HOSTNAME}}" in
    login-*)
        ;;
    *)
        export PATH=/data/cephfs-1/home/users/sbanerj_m/work/miniforge3/condabin:$PATH
        ;;
esac





# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/data/cephfs-1/work/groups/sanders/users/sbanerj_m/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/data/cephfs-1/work/groups/sanders/users/sbanerj_m/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/data/cephfs-1/work/groups/sanders/users/sbanerj_m/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/data/cephfs-1/work/groups/sanders/users/sbanerj_m/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/data/cephfs-1/work/groups/sanders/users/sbanerj_m/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/data/cephfs-1/work/groups/sanders/users/sbanerj_m/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

