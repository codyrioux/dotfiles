set -o vi
alias ll='ls -alhG'
alias chdir='cd'

# Vim
#alias vim='/Applications/MacVim.app/Contents/MacOS/vim'
alias grep='grep --color=always'
export EDITOR=vim

# Gradle Completion History
export GRADLE_CACHE_TTL_MINUTES=$(expr 1440 \* 21)
export GRADLE_COMPLETION_UNQUALIFIED_TASKS="true"

# Completions
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

# Prompts
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

# Syntax Highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export GNUTERM=x11

autoload -U zmv
export PATH="/usr/local/sbin:$PATH"

# Add current directory to path
export PATH=.:$PATH
export PATH=$HOME/bin:$PATH
#export JAVA_HOME=$(/usr/libexec/java_home)

# Netflix AWS Configuratin
export EC2_OWNER_ID=567395257996
export EC2_REGION=us-east-1
export REGION=us-east-1
export NETFLIX_ENVIRONMENT=test
export EC2_AVAILABILITY_ZONE=us-east-1a
export MANTIS_ENVIRONMENT=dev

alias urlencode='python -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
function sloc() {
	find . -name "*.$1" | xargs wc -l
}

# Nebula
alias nebulastrap='curl -s "https://stash.corp.netflix.com/projects/NEBULA/repos/bootstrap/browse/nebulaWrapper.sh?raw" | bash'
alias refreshdeps='./gradlew -x test -PdependencyLock.overrideFile=override.lock --info clean generateLock saveLock'

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

alias findbugs="spotbugs &"

# added by travis gem
[ -f /Users/crioux/.travis/travis.sh ] && source /Users/crioux/.travis/travis.sh

weather() {
  curl https://wttr.in/$1
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/crioux/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/crioux/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/crioux/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/crioux/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

PATH=$PATH:/usr/local/go/bin
GOPATH=$HOME/go

PATH=$PATH:/home/pi/go/bin
