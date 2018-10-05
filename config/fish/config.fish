set fish_greeting

alias la "ls -la"
alias lt "ls -lrt"
alias ll "ls -l"
alias h "history"
alias cp "cp -i"
alias grep "grep --color=auto"
alias rm "rm -i"
alias vi "vim"
alias top "top -oRES"
alias tmux "_ssh_auth_save; command tmux"

# Python
set -x PATH "$HOME/.pyenv/bin" $PATH
if test -e $HOME/.pyenv
  set -x PYTHON_CONFIGURE_OPTS --enable-shared
  status --is-interactive; and . (pyenv init -|psub)
  status --is-interactive; and . (pyenv virtualenv-init -|psub)
end

set -g _ssh_sock_link $HOME/.ssh/ssh_auth_sock.(hostname)

function _ssh_auth_save
  set -l sock_linked (readlink -f $_ssh_sock_link)
  if [ -e $SSH_AUTH_SOCK ]; and [ "$SSH_AUTH_SOCK" = "$sock_linked" ]
    # Everything is OK, do nothing.
    return 0
  end

  if [ -e $SSH_AUTH_SOCK ]; and [ "$SSH_AUTH_SOCK" != "$sock_linked" ]
    # Created symlink to SSH_AUTH_SOCK
    _remove_sock_link
    ln -sf $SSH_AUTH_SOCK $_ssh_sock_link
    return 0
  end

  _stop_ssh_agent
  return 1
end

function _startup_ssh_agent
  if not _ssh_auth_save
    # If no agent is running and we have a terminal, run ssh-agent and ssh-add
    eval (ssh-agent -c | sed -e 's/setenv/set -x/g')
    /usr/bin/tty > /dev/null; and ssh-add
    _ssh_auth_save
    return $status
  end
  return 0
end

function _stop_ssh_agent
  ssh-agent -k
  _remove_sock_link
end


function _remove_sock_link
  rm -f $_ssh_sock_link
end
