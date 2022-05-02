
if status is-interactive
  if test -z "$SSH_AGENT_PID"
    eval "$(ssh-agent -c)" >/dev/null
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  end
end