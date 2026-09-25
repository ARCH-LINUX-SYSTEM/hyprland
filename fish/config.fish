# Start ssh-agent if needed
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c | string collect) >/dev/null
end

# Add SSH keys silently on success
find ~/.ssh \
    -name 'id_ed25519*' \
    ! -name '*.pub' \
    -exec ssh-add {} + 2>/dev/null

# Restart exited Podman containers silently on success
podman ps \
    --filter status=exited \
    --format '{{.Names}}' |
    xargs -r podman restart 2>/dev/null

# Interactive shell configuration
if status is-interactive
    for f in $__fish_config_dir/config/*.fish
        source $f
    end

    set -l local_config "$HOME/.config/fish/local.config"

    # local config
    if test -f $local_config
        source $local_config
    end
end

# Bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
