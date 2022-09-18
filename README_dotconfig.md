https://www.atlassian.com/git/tutorials/dotfiles

Run the following on a new machine:

* git clone --bare git@github.com:forestf255/dotfiles.git $HOME/.dotconfig
* source $HOME/.bashrc
* dotconfig config --local status.showUntrackedFiles no
