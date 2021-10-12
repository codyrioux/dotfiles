set -o vi # vi mode
alias ll='ls -alhGF' # Colorize, trailing slashes on directories, all

# vim as editor, use macvim internal vim on osx
case "$OSTYPE" in
  darwin*)
    alias vim='/Applications/MacVim.app/Contents/MacOS/vim'
;;
esac
export EDITOR=vim

# grep
alias grep='grep --color=always'

# zsh completions
 if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
typeset -U fpath
autoload -U compinit
compinit -u

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' use-cache on
set corectall #Spelling correction for completions

# zsh syntax highlighting
 case "$OSTYPE" in
  darwin*)
    export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$(brew --prefix)/share/zsh-syntax-highlighting/highlighters
	source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ;;
  linux*)
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ;;
  dragonfly*|freebsd*|netbsd*|openbsd*)
    # ...
  ;;
esac

# zsh prompt
autoload -U promptinit
promptinit
prompt off

export PS1="%~ %# "

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'

# History
export HISTSIZE=10000
export HISTFILE=$HOME/.zsh_history
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

# Config
setopt autocd
setopt extendedglob
export GNUTERM=x11

autoload -U zmv
export PATH="/usr/local/sbin:$PATH"

# Add current directory to path
export PATH=.:$PATH
export PATH=$HOME/bin:$PATH

#
# user defined functions
#

alias urlencode='python -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
function sloc() {
	find . -name "*.$1" | xargs wc -l
}

alias slack="open -na 'Google Chrome' --args '--app=https://netflix.slack.com'"
alias isodate='date -u +%FT%TZ'

# Gifs
gifify() {
  if [[ -n "$1" ]]; then
    if [[ $2 == '--good' ]]; then
      ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
      rm out-static*.png
    else
      ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
    fi
  else
    echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}

weather() {
  curl https://wttr.in/$1
}


# golang configuration
PATH=$PATH:/usr/local/go/bin
GOPATH=$HOME/go
#PATH=$PATH:/home/pi/go/bin
