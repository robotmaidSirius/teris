# simple_my_shell

It is for easily calling commands that are used all the time but are not known unless you look them up.

## Install

```bash
sudo apt install -y fzf

SIMPLE_MY_SHELL_DIR=${HOME}/.simple_my_shell
echo 'source '${SIMPLE_MY_SHELL_DIR}'/env.bash '${SIMPLE_MY_SHELL_DIR}'' >> ${HOME}/.bashrc
```


## Aliases list

| Aliases   | Command                                 | Note.                                       |
| --------- | --------------------------------------- | ------------------------------------------- |
| that      | --                                      | Select a command and register it in history |
| to_cui    | systemctl set-default multi-user.target | Switch to CUI                               |
| to_gui    | systemctl set-default graphical.target  | Switch to GUI                               |
| open_port | nc IP_ADDRESS PORT -w 1                 | Explore each port information.              |


