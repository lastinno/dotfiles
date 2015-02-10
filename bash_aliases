# General
#alias ls='ls -F --color=auto'
alias la='ls -la'
alias lt='ls -lrt'
alias ll='ls -l'
alias h='history'
alias cp='cp -i'
alias grep='grep --color=auto'
alias rm='rm -i'
alias vi='vim'

alias findsrc='/usr/bin/find . -type f -name "*.h" -o -name "*.cpp" | xargs grep -n --color=always'
alias finds='  /usr/bin/find . -type f -name "*.h" | xargs grep -n --color=always'
alias findh='  /usr/bin/find . -type f -name "*.cpp" | xargs grep -n --color=always'
alias ctagall='/usr/bin/find . -type f -name "*.cpp" | xargs ctags grep -n --color=always'

# Windows
alias open='explorer'

# MySQL
alias mysql='mysql --auto-rehash'

