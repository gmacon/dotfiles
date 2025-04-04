{ writeShellApplication, curl }:
writeShellApplication {
  name = "pushover";
  runtimeInputs = [ curl ];
  text = ''
    # This script is configured by sourcing a shell file.
    # For example:
    #
    # # ~/.config/pushover.sh
    # APP_TOKEN='pushover_app_token'
    # USER_KEY='pushover_target_user_key another_target_user_key'

    # shellcheck source=/dev/null
    source "''${XDG_CONFIG_HOME:-$HOME/.config}/pushover.sh"

    for user in $USER_KEY; do
      curl https://api.pushover.net/1/messages.json \
        --silent \
        --show-error \
        --output /dev/null \
        --data-urlencode "token=$APP_TOKEN" \
        --data-urlencode "user=$user" \
        --data-urlencode "message=$*"
    done
  '';
}
