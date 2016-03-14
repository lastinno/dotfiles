#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/repos/dotfiles              # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory

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
      "

##########

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
  mv ~/.$file ~/dotfiles_old/
  echo "Creating symlink to $file in home directory."
  ln -s $dir/$file ~/.$file
done

# install vim vundle
mkdir -p ~/.vim/bundle
if [ ! -e ~/.vim/bundle/Vundle.vim ]
then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall

mkdir -p ~/.vimtmp
mkdir -p ~/.tmux

. ~/.bashrc
