export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="muse"

zstyle ':omz:update' mode reminder  

DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git asdf)

source $ZSH/oh-my-zsh.sh
export ARCHFLAGS="-arch x86_64"

alias termSource="~/.zshrc"
alias vim=nvim
alias canoeF="~/repository/canoe/frontend"
alias canoeB="~/repository/canoe/backend"
alias i3config="~/.dotfiles/i3/config"
alias connectLinux="ssh marc@10.0.0.74"

# for go
. ~/.asdf/plugins/golang/set-env.zsh

export OBSIDIAN_REST_API_KEY="b86584e0ada566a3f80e9df70af618fb58da31c54469190a2b0d62bed23d497a"
export ARCHFLAGS="-arch arm64"
export PATH="/Users/marc-anthonygirard/.local/bin:$PATH"

export PATH=$(asdf where lua)/bin:$PATH

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github
clear

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PNPM_HOME="/Users/marc-anthonygirard/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
