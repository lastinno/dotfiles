set fish_greeting
set -x PYTHON_CONFIGURE_OPTS --enable-shared

alias la "ls -la"
alias lt "ls -lrt"
alias ll "ls -l"
alias h "history"
alias cp "cp -i"
alias grep "grep --color=auto"
alias rm "rm -i"
alias vi "vim"
alias top "top -oRES"

# Python
set -x PATH "$HOME/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)
