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

# Python
# set -x PATH "$HOME/.pyenv/bin" $PATH
# if test -e $HOME/.pyenv
#   set -x PYTHON_CONFIGURE_OPTS --enable-shared
#   status --is-interactive; and . (pyenv init -|psub)
#   status --is-interactive; and . (pyenv virtualenv-init -|psub)
# end

function _ssh_auth_save
  set -l _sock $HOME/.ssh/ssh_auth_sock.(hostname)
  if [ $SSH_AUTH_SOCK ]; and test -e $SSH_AUTH_SOCK
    if test -L $_sock
      # Everything is OK, do nothing.
      return 0
    else
      ln -sf $SSH_AUTH_SOCK $_sock
      return 0
    end
  else
    rm -f $_sock
	set -x SSH_AUTH_SOCK
    return 1
  end
end

function _startup_ssh_agent
  if not _ssh_auth_save
    # If no agent is running and we have a terminal, run ssh-agent and ssh-add
    eval (ssh-agent -c)
    /usr/bin/tty > /dev/null; ssh-add
    _ssh_auth_save
	return $status
  end
  return 0
end

if not _startup_ssh_agent
  echo Failed to startup ssh-agent.
end
