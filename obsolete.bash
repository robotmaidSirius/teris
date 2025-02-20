#!/bin/bash
#################
# obsolete
#################

function obsolete_venv_activate {
  local flag_error=false
  local env_path="${HOME}/.cache/teris/venv"
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
