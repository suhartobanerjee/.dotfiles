#!/bin/bash


conda env list | \
    awk 'NR>2 {print $1}' | \
    xargs -I ev bash -c 'source ~/.bashrc; conda activate ev;
        printf "Exporting env: %s\n" $CONDA_DEFAULT_ENV; conda env export > ev.yaml &'

printf "\nAll envs exported!\n"
