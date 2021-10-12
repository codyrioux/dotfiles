# Syntax Highlighting
 case "$OSTYPE" in
  darwin*)
	export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
	source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ;;
  linux*)
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ;;
  dragonfly*|freebsd*|netbsd*|openbsd*)
    # ...
  ;;
esac
