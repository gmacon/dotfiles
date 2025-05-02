{ ... }:
{
  programs.zsh.envExtra = ''
    if [ -z "$SSH_CONNECTION" ]; then
      SSH_AUTH_SOCK="$HOME/.1password/agent.sock";
    fi
  '';
}
