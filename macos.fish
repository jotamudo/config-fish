function get_brew_llvm_env
  # TODO: this doesn't clear the f-ing variable for some god forsaken reason :D
  set -eg LDFLAGS
  set -eg CFLAGS
  set -eg CPPFLAGS
  set -eg CXXFLAGS
  set -ax LDFLAGS -L/opt/homebrew/opt/llvm/lib
  set -ax LDFLAGS -L/opt/homebrew/lib
  set -ax CFLAGS -I/opt/homebrew/include
  set -ax CFLAGS -I/opt/homebrew/opt/llvm/include
  set -ax CPPFLAGS -I/opt/homebrew/include
  set -ax CPPFLAGS -I/opt/homebrew/opt/llvm/include
  set -ax CXXFLAGS -I/opt/homebrew/include
  set -ax CXXFLAGS -I/opt/homebrew/opt/llvm/include

  #For compilers to find curl you may need to set:
  set -ax LDFLAGS "-L/opt/homebrew/opt/curl/lib"
  set -ax CPPFLAGS "-I/opt/homebrew/opt/curl/include"
  #For pkg-config to find curl you may need to set:
  set -ax PKG_CONFIG_PATH "/opt/homebrew/opt/curl/lib/pkgconfig"
end

# brew
fish_add_path /opt/local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/llvm/bin
fish_add_path /opt/homebrew/opt/ruby/bin
fish_add_path /opt/homebrew/lib/ruby/gems/3.3.0/bin
fish_add_path /opt/homebrew/opt/ccache/libexec
fish_add_path /opt/homebrew/opt/rustup/
# mysql
fish_add_path /opt/homebrew/opt/mysql-client/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/mysql-client/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/mysql-client/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/mysql-client/lib/pkgconfig"

# the following seems like just a nuisance:
# @fish-lsp-disable 2002
# alias to replace missing nproc command
alias nproc="sysctl -n hw.logicalcpu"
# switch into x86_64 mode
alias rosetta="arch -x86_64 zsh"

# nrf-connect
alias get_nrf_env="source /opt/nordic/ncs/toolchains/b8efef2ad5/env.sh"
# renode
alias renode="mono64 /Applications/Renode.app/Contents/MacOS/bin/Renode.exe"
alias renode-test="mono64 /Applications/Renode.app/Contents/MacOS/tests/renode-test"
# @fish-lsp-enable 2002

# cubemx
set -x STM32CubeMX_PATH /Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources

# for brew completions
if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

# load ssh-key on keychain
ssh-add --apple-load-keychain -q

# export colima docker context
set -x DOCKER_HOST "unix:///Users/$USER/.colima/docker.sock"

# can't remember what broke whithout this
ulimit -n 10240
