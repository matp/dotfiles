# basic settings {{{
  export PAGER=less
  export MANPAGER="less -X"
  export VISUAL=vi
  export EDITOR=$VISUAL

  # history
  export HISTSIZE=
  export HISTFILESIZE=
  export HISTCONTROL=ignoreboth
  export HISTINGNORE="ls:cd:cd -:pwd;exit:date:* --help"

  # options
  shopt -s histappend
  shopt -s checkwinsize
  shopt -s cmdhist
# }}}

# platform-specific {{{
  case $(uname) in
    "Darwin"|"FreeBSD")
      export CLICOLOR=1
      export GREP_OPTIONS="--color=auto" GREP_COLOR="1;32"

      ql() {
        qlmanage -p "$@" > /dev/null 2>&1
      }

      pvman() {
        for page in "$@"; do
          man -t "$page" | open -f -a Preview
        done
      }
      ;;
    "Linux")
      alias ls='ls --color=auto'
      ;;
  esac
# }}}

# key bindings {{{
  bind '"\e[A"':history-search-backward
  bind '"\e[B"':history-search-forward
# }}}

# configure languages/tools {{{

  # nvm
  [ -d "$HOME/.nvm" ] && export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  # rbenv
  if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
# }}}

# functions {{{
  datauri() {
    for file in "$@"; do
      echo "data:$(file -b --mime "$file" | tr -d ' ');base64,$(openssl base64 -in "$file" | tr -d '\n')"
    done
  }

  extract() {
    for file in "$@"; do
      case "$file" in
        *.7z)      7z x "$file"          ;;
        *.bz2)     bunzip2 "$file"       ;;
        *.dmg)     hdiutil mount "$file" ;;
        *.gz)      gunzip "$file"        ;;
        *.tar)     tar xfv "$file"       ;;
        *.tar.bz2) tar xjvf "$file"      ;;
        *.tar.gz)  tar xzvf "$file"      ;;
        *.tbz2)    tar xjvf "$file"      ;;
        *.tgz)     tar xzvf "$file"      ;;
        *.rar)     unrar x "$file"       ;;
        *.zip)     unzip "$file"         ;;
        *.Z)       uncompress "$file"    ;;
        *)         echo "extract: unrecognized file type, \`$file'" 1>&2 ;;
      esac
    done
  }

  ip() {
    dig +short myip.opendns.com @resolver1.opendns.com
  }

  serve() {
    if [ "$#" -gt 1 ]; then
      echo "Usage: serve"           2>&1
      echo "       serve file"      2>&1
      echo "       serve directory" 2>&1
    elif [ -n "$1" -a ! -e "$1" ]; then
      echo "serve: \`$1' does not exist" 2>&1
    elif [ -n "$1" ]; then
      ruby -run -e httpd "$1" -p 8080
    else
      ruby -run -e httpd .    -p 8080
    fi
  }
# }}}

# vim:foldmethod=marker
