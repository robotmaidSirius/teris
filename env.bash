#!/bin/bash
SIMPLE_MY_SHELL_DIR=${1:-$(dirname $0)}
if [ ! -e ${SIMPLE_MY_SHELL_DIR}/command_list/common.md ]; then
  echo [ERROR] simple_my_shell : Not Found Directory : ${SIMPLE_MY_SHELL_DIR}
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
    local run_cmd=$(cat ${SIMPLE_MY_SHELL_DIR}/command_list/common.md | fzf)
    run_cmd=$(eval echo ${run_cmd})
    if [[ "${run_cmd}" =~  "#ARGUMENT#" ]]; then
        read -p "  > " run_option
        run_cmd=$(echo ${run_cmd} | sed -e "s/#ARGUMENT#/${run_option}/")
        echo "  COMMAND : "${run_cmd}
        read -p "  Do you want to execute? (y:Yes/n:No): " yn
        case "$yn" in
            [yY]*) ${run_cmd};;
            *) return ;;
        esac
        echo " "
    fi
    echo ${run_cmd}
    # ${run_cmd}
    history -s ${run_cmd}
}

function mypy {
    history -s mypy
    local run_option=''
    local run_cmd=$(cat ${SIMPLE_MY_SHELL_DIR}/command_list/python_list.md | fzf)
    run_cmd=$(eval echo ${run_cmd})
    if [[ "${run_cmd}" =~  "#ARGUMENT#" ]]; then
        read -p "  > " run_option
        run_cmd=$(echo ${run_cmd} | sed -e "s/#ARGUMENT#/${run_option}/")
    fi
    echo "[COMMAND] "${run_cmd}
    history -s ${run_cmd}
    ${run_cmd}
}

function venv_activate {
  local flag_error=false
  local env_path="${HOME}/.cache/simple_my_shell/venv"
  if [ ! -d "${env_path}" ]; then
    mkdir -p ${env_path}
  fi
  if [ ! -d "${env_path}/__NEW__" ]; then
    mkdir -p ${env_path}/__NEW__
  fi

  pushd "${env_path}" >/dev/null 2>&1
    local env_name=$(find * -maxdepth 0 -type d | fzf)
    local flag_input=false
    if [ "__NEW__" == "${env_name}" ]; then
      flag_input=true
    elif [ "" == "${env_name}" ]; then
      flag_input=true
    fi
    if [ true == ${flag_input} ]; then
      read -p " Virtual Environment Name > " env_name
    fi
    if [ "" != "${env_name}" ]; then
      if [ true == ${flag_input} ]; then
        python -m venv ${env_name}
      fi
      source ${env_name}/bin/activate
    else
      flag_error=true
    fi
  popd >/dev/null 2>&1
  if [ true == ${flag_error} ]; then
    echo "[ERROR] There was no input"
  else
    echo -e "\n$(python -V) : $(which python)"
  fi
  history -s deactivate
}

function pyenv_version_change {
  PYENV_INSTALL_VERSION=$(pyenv install --list | fzf)

  pyenv install ${PYENV_INSTALL_VERSION}
  ret=$?
  if [ 0 == ${ret} ]; then
      pyenv global ${PYENV_INSTALL_VERSION}
      python3 -m pip install --upgrade pip
  fi

  python --version
  pyenv versions
}
