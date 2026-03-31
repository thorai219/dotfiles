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
 
gwt() {
  if [ -z "$1" ]; then
    echo "Usage: gwt <branch> [base] [name]"
    return 1
  fi

  local branch="$1"
  local base="${2:-nextjs}"
  local name="${3:-$branch}"

  local root="$HOME/dev/alta"
  local target="$root/$name"
  local remote_base="origin/$base"

  # fetch base
  git fetch origin "$base" >/dev/null 2>&1

  # check for dir
  mkdir -p "$root"

  if [ -d "$target" ]; then
    echo "Directory already exists: $target"
    return 1
  fi

  # create or reuse branch
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git worktree add "$target" "$branch"
  else
    git worktree add -b "$branch" "$target" "$remote_base"
  fi

  echo "Worktree: $target"
  echo "Branch:   $branch (from $remote_base)"

  cd "$target" || return
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
