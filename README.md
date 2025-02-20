# Teris

Teris is a blend of '**TER**minal' and 'Bas**IS**'.
It provides a simple way to execute frequently used commands that are often forgotten and require looking up.

## Install

```bash
sudo apt install -y fzf
```

```bash
TERIS_DIR=${HOME}/.teris

git clone https://github.com/robotmaidSirius/teris.git ${TERIS_DIR}
echo 'source '${TERIS_DIR}'/env.bash '${TERIS_DIR}'' >> ${HOME}/.bashrc
```


## Aliases List

The following table lists available aliases and their corresponding commands.

| Alias         | Command                                   | Description                                    |
| ------------- | ----------------------------------------- | ---------------------------------------------- |
| **that**      | --                                        | Selects a command and registers it in history. |
| **to_cui**    | `systemctl set-default multi-user.target` | Switches to a command-line interface (CUI).    |
| **to_gui**    | `systemctl set-default graphical.target`  | Switches to a graphical user interface (GUI).  |
| **open_port** | `nc IP_ADDRESS PORT -w 1`                 | Checks information about specific ports.       |
| **mypy**      | --                                        | Selects a Python command.                      |


