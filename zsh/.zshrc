alias ls="eza --color=auto --long --header --git --icons"

export PATH="$HOME/.local/bin:$PATH"

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
 

alias c='clear'

# eza (modern ls replacement)
alias ls='eza --icons --group-directories-first -a'
alias la='eza --icons --group-directories-first -la'
alias lt='eza --icons --group-directories-first --tree --level=3'

# bat (better cat)
alias cat='bat --paging=never'
alias catp='bat'  # cat with pager

cd() {
    __zoxide_z "$@"
   la 
}

# Zoxide integration with eza
zl() {
  if command -v _z > /dev/null; then
    _z "$@"
    if [ $? -eq 0 ] && [ -d "$PWD" ]; then
      eza --group-directories-first --icons --color=always -l -a
    fi
  else
    echo "z is not installed"
  fi
}
 


# ALTA
api() {
  CONFIG="$HOME/.alta-api-hosts.json"

    # env picker
    ENV=$(jq -r 'keys[]' "$CONFIG" \
        | fzf --height=40% --border --layout=reverse --prompt="Select environment > ")

    [[ -z "$ENV" ]] && return

    # url picker
    URL_NAME=$(jq -r --arg env "$ENV" '.[$env] | keys[]' "$CONFIG" \
        | fzf --height=40% --border --layout=reverse --prompt="Select URL ($ENV) > ")

    [[ -z "$URL_NAME" ]] && return

    # get api host
    API_HOST=$(jq -r --arg env "$ENV" --arg name "$URL_NAME" '.[$env][$name]' "$CONFIG")

    export API_HOST

    echo ""
    echo "Environment: $ENV"
    echo "Host: $API_HOST"
    echo ""
    echo "Starting server..."
    echo ""

   env API_HOST="$API_HOST" ALTA_DEBUG=true pnpm dev
}

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init zsh)"
