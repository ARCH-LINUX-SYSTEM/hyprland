# check status interactive của shell : khi mở kiity/fish => interactive , nhưng khi thực thị script có thể không phải
# check tồn tại file local.config thì reload không thì bỏ qua

if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c | string collect)
end

# Add SSH keys
if test -f ~/.ssh/id_ed25519_backlog
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519_backlog 2>/dev/null
end

if status is-interactive
    # nạp tất cả module trong fish/config/ (alias, env, tools, ...)
    for f in $__fish_config_dir/config/*.fish
        source $f
    end

    set -l local_config "$HOME/.config/fish/local.config"

    # Auto load SSH keys
    for key in \
        ~/.ssh/id_ed25519_gitlab \
        ~/.ssh/id_ed25519_github

        if test -f $key
            ssh-add $key 2>/dev/null
        end
    end
end
# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# >>> railway initialize >>>
source "$HOME/.railway/env.fish"
# <<< railway initialize <<<
