#!/bin/sh

# install xcode command line tools if necessary {{{
  xcode-select -p > /dev/null || xcode-select --install
# }}}

# install homebrew if necessary {{{
  which brew > /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# }}}

# install homebrew packages {{{
  if brew update && brew doctor; then
    brew upgrade --all

    declare -ra formulas=(
      # languages
      'ghc'
      'lua --with-completion'
      'python'
      'rbenv'
      'ruby-build'

      # libraries
      'glew'
      'homebrew/versions/glfw3'
      'glm'

      # tools
      'autossh'
      'ffmpeg'
      'git'
      'graphicsmagick'
      'jq'
      'tmux'
      'unrar'
      'vim'
      'youtube-dl'
    )

    for formula in "${formulas[@]}"; do
      brew list $formula > /dev/null 2>&1 || brew install $formula
    done

    brew cleanup
  fi;
# }}}

# vim:foldmethod=marker
