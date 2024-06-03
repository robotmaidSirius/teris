#!/bin/bash
SIMPLE_MY_SHELL_DIR=${1:-$(dirname $0)}
if [ ! -e ${SIMPLE_MY_SHELL_DIR}/comannd_list.md ]; then
  echo [EEROR] simple_my_shell : Not Found Direcctory : ${SIMPLE_MY_SHELL_DIR}
  return
fi

function to_cui {
  sudo systemctl set-default multi-user.target
  sudo systemctl get-default
}

function to_gui {
  sudo systemctl set-default graphical.target
  sudo systemctl get-default
}

function open_port {
  local ip_addr=${1:-127.0.0.1}
  local result=""
  local port_min=0
  local port_max=0
  read -p " PORT MIN > " port_min
  read -p " PORT MAX > " port_max
  echo "Search port ${ip_addr}:${port_min} -> ${ip_addr}:${port_max} "
  for n in $(seq $(echo $port_min) $port_max)
  do
    result=$(nc ${ip_addr} ${n} -w 1)
    if [[ "${result}" != "" ]]; then
      echo "${ip_addr}:${n} / ${result}"
    fi
  done
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
            [yY]*) ${run_cmd};;
            *) return ;;
        esac
        echo " "
    fi
    echo $run_cmd
    # $run_cmd
    history -s $run_cmd
}
