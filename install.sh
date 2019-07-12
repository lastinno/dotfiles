#!/bin/bash
############################
# install.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir="$PWD"                        # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

function install_fish_plugin
{
  local name=$1
  fish -c "echo installing fish plugin ${name}.; fisher ${name} 2> /dev/null"
}

# list of files/folders to symlink in homedir
files="bashrc
       bash_aliases
       vimrc
       gvimrc
       inputrc
       minttyrc
       tmux.conf
       gitconfig
       gitignore
       tigrc
       git-prompt.sh
       ctags
       flake8
       ycm_extra_conf.py
       config/fish/config.fish
      "

# Fish
mkdir -p ~/.config/fish
if [ ! -e $HOME/.config/fish/functions/fisher.fish ]
then
  curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
fi
install_fish_plugin z
install_fish_plugin tuvistavie/fish-ssh-agent
install_fish_plugin kennethreitz/fish-pipenv

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files
do
  echo "Moving any existing dotfiles from ~ to $olddir"
  mv -f ~/.$file ~/dotfiles_old/
  echo "Creating symlink to $file in home directory."
  ln -s $dir/$file ~/.$file
done

# Vim
mkdir -p ~/.vim/autoload
if [ ! -e ~/.vim/autoload/plug.vim ]
then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
vim +PlugInstall +qall

if [ ! -e ~/.tmux/plugins/tpm ]
then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

mkdir -p ~/.vimtmp

# Tmux
mkdir -p ~/.tmux

. ~/.bashrc
