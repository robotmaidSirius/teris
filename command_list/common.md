shutdown -h 0

mypy
printenv
source ${HOME}/.bashrc
apt list --installed
to_cui
to_gui
open_port "#ARGUMENT#"
git config --global user.name "#ARGUMENT#"
git config --global user.email "#ARGUMENT#"
git config --global --list
ssh -T git@github.com
sudo gpasswd -a $USER docker
source ${TERIS_DIR}/env.bash ${TERIS_DIR}
sudo hostnamectl set-hostname "#ARGUMENT#"

teris_update
