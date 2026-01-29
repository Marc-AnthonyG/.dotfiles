source ~/.fzf.zsh

# MAC
export ARCHFLAGS="-arch arm64"

# ALIAS
alias updateYabai='echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai'

# PNPM
export PNPM_HOME="/Users/marc-anthonygirard/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# export
export ANDROID_HOME=$HOME/Library/Android/sdk
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
