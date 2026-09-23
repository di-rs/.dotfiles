# dotfiles

Personal configs managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```sh
git clone <this repo> ~/personal/.dotfiles
cd ~/personal/.dotfiles
./install.sh
```

## Notes

`.Brewfile` is generated with `brew bundle dump` and read via `brew bundle --global`. 
Regenerate it after installing/removing packages:

```sh
brew bundle dump --file=~/personal/.dotfiles/brew/.Brewfile --force
dotsync "update Brewfile"
```
