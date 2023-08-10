#!/bin/bash
SIMPLE_MY_SHELL_DIR="$1"

function to_cui {
  sudo systemctl set-default multi-user.target
  sudo systemctl get-default
}

function to_gui {
  sudo systemctl set-default graphical.target
  sudo systemctl get-default
}


function that {
    local run_option=''
    local run_cmd=$(cat ${SIMPLE_MY_SHELL_DIR}/comannd_list.md | fzf)
    run_cmd=$(eval echo ${run_cmd})
    if [[ "${run_cmd}" =~  "#ARGUMENT#" ]]; then
        read -p "  > " run_option
        run_cmd=$(echo $run_cmd | sed -e "s/#ARGUMENT#/${run_option}/")
        echo "  COMMAND : "${run_cmd}
        read -p "  Do you want to execute? (y:Yes/n:No): " yn
        case "$yn" in
            [yY]*);;
            *) return ;;
        esac
        echo " "
    fi
    echo $run_cmd
    $run_cmd
    history -s $run_cmd
}
