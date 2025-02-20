#!/bin/bash
TERIS_DIR=${1:-$(dirname $0)}
if [ ! -e ${TERIS_DIR}/command_list/common.md ]; then
  echo "[ERROR] teris : Not Found Directory : "${TERIS_DIR}
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
    local run_cmd=$(cat ${TERIS_DIR}/command_list/common.md | fzf)
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
        echo ${run_cmd}
    else
      echo ${run_cmd}
      ${run_cmd}
    fi
    history -s ${run_cmd}
}

function mypy {
    history -s mypy
    local run_option=''
    local run_cmd=$(cat ${TERIS_DIR}/command_list/python_list.md | fzf)
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
  if [ -n "${VIRTUAL_ENV}" ]; then
    echo "Deactivate : ${VIRTUAL_ENV}"
    deactivate
  fi

  local ENV_PATH=$(find . -maxdepth 3 -type f -name "activate" | fzf)
  if [ -e "${ENV_PATH}" ]; then
    source ${ENV_PATH}
  else
    local env_name=""
    read -p " Virtual Environment Name > " env_name
    python -m venv ${env_name}
    source ${env_name}/bin/activate
  fi
  echo -e "$(python -V) : $(which python) : ${VIRTUAL_ENV}"
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

function teris_update() {
  pushd "${TERIS_DIR}" >/dev/null 2>&1
    echo "Update 'teris': "${TERIS_DIR}
    git checkout .
    if [ -f "${TERIS_DIR}/requirements_apt.txt" ]; then
      apt_in ${TERIS_DIR}/requirements_apt.txt
    fi
  popd >/dev/null 2>&1
}

function apt_in() {
  local REQUIREMENTS_TEXT=${1}
  if [ -z "${REQUIREMENTS_TEXT}" ]; then
    echo "[ERROR] Not Found File : "${REQUIREMENTS_TEXT}
    return
  elif [ ! -f "${REQUIREMENTS_TEXT}" ]; then
    echo "[ERROR] Not Found File : "${REQUIREMENTS_TEXT}
    return
  fi
  while read LINE
  do
    if [ -z "${LINE}" ]; then continue; fi
    if [[ ${LINE} =~ ^#.* ]]; then continue; fi

    export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
    echo -e "#####################\n[APT] Install '${LINE}'\n#####################"
    sudo -E apt install -y ${LINE}
    if [ $? -ne 0 ]; then
      echo "[ERROR] Install '${LINE}' is failed" >&2
    fi
  done < ${REQUIREMENTS_TEXT}
}


# ========================================
# Set Environment
# ========================================
## MAX_JOBS
export MAX_JOBS=$((`nproc` - 1))
if [[ ${MAX_JOBS} -le 0 ]]; then
  export MAX_JOBS=1
fi

# ========================================
function get_jq_value() {
  local key=${1}
  local value=$(eval echo $(jq -r '.'${key} ${CONFIG_FILE}));
  if [ "null" == "${value}" ];then
    value=""
  fi
  echo ${value}
}
function flag_jq_value() {
  local key=${1}
  local value=$(eval echo $(jq -r '.'${key} ${CONFIG_FILE}));
  if [ true == "${value}" ];then
    value=1
  else
    value=0
  fi
  echo ${value}
}
