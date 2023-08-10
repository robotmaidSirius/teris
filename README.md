# simple_my_shell

It is for easily calling commands that are used all the time but are not known unless you look them up.

## Install

```bash
sudo apt install -y fzf

echo 'source '${HOME}'/simple_my_shell/env.bash '${HOME}'/simple_my_shell' >> ${HOME}/.bashrc
```


## Aliases list

| Aliases | Command                                     |
| ------- | ------------------------------------------- |
| that    | Select a command and register it in history |
| to_cui  | systemctl set-default multi-user.target     |
| to_gui  | systemctl set-default graphical.target      |

