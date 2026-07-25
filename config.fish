# NOTE: For now no specific command, but I'll leave it here just in case :)
if status is-interactive
    # Commands to run in interactive sessions can go here
end

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

function get_cntlm_proxy
  set -gx http_proxy 127.0.0.1:3128
  set -gx https_proxy 127.0.0.1:3128
end

function unset_cntlm_proxy
  set -e http_proxy
  set -e https_proxy
end

# local binaries
fish_add_path $HOME/.local/bin

# brew
fish_add_path /opt/local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/llvm/bin
fish_add_path /opt/homebrew/opt/ruby/bin
fish_add_path /opt/homebrew/lib/ruby/gems/3.3.0/bin
fish_add_path /opt/homebrew/opt/ccache/libexec
fish_add_path $HOME/.cargo/bin
fish_add_path /opt/homebrew/opt/rustup/
fish_add_path $HOME/.pub-cache/bin
# mysql
fish_add_path /opt/homebrew/opt/mysql-client/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/mysql-client/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/mysql-client/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/mysql-client/lib/pkgconfig"

# neovim
set -x EDITOR nvim

# the following seems like just a nuisance:
# @fish-lsp-disable 2002
alias nn="nvim"
alias n="nvim"

# alias to replace missing nproc command
alias nproc="sysctl -n hw.logicalcpu"
# switch into x86_64 mode
alias rosetta="arch -x86_64 zsh"

# nrf-connect
alias get_nrf_env="source /opt/nordic/ncs/toolchains/b8efef2ad5/env.sh"

alias l="ls -l"
alias ll="ls -l"
alias la="ls -l"
alias lla="ls -l"

# renode
alias renode="mono64 /Applications/Renode.app/Contents/MacOS/bin/Renode.exe"
alias renode-test="mono64 /Applications/Renode.app/Contents/MacOS/tests/renode-test"
# @fish-lsp-enable 2002

# fvm
fish_add_path $HOME/fvm/default/bin
fish_add_path $HOME/.pub-cache/bin

# cubemx
set -x STM32CubeMX_PATH /Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources

starship init fish | source
zoxide init --cmd cd fish | source

# also alias zi due to my muscle memory
if functions -q __zoxide_zi
    alias zi=__zoxide_zi
else
    echo "\e[0;31m[WARNING] zoxide's `zi` function is not defined! \e[0m"
end

# for brew completions
if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

# load .env files
function load-dot-env
    for line in (cat $argv[1])
        set line (string trim $line)
        if test -z $line
        or string match -q "#*" $line
            continue
        end
        set name_value (string split -m 1 = $line)
        set name (string trim $name_value[1])
        set value (string trim $name_value[2])
        #echo "[line=$line,name_value=$name_value,name=$name,value=$value]"
        if string match -q '"*"' $value
        or string match -q "'*'" $value
            set value (string sub -s 2 -e -1 $value)
        end
        if string match -qr '[$][{][A-Za-z_][A-Za-z_0-9]*[}]' $sub1
            set sub1 (string replace '[$][{]([A-Za-z_][A-Za-z_0-9]*)[}]' '$$$1' $sub1)
        else
            set sub1 $value
        end
        if string match -qr '[$][A-Za-z_][A-Za-z_0-9]*' $sub1
            set sub2 (eval "echo $value")
        else
            set sub2 $value
        end
        #echo "[name=$name,value=$value,sub1=$sub1,sub2=$sub2]"
        set -gx $name $sub2
    end
end

# load ssh-key on keychain
ssh-add --apple-load-keychain -q

# export colima docker context
set -x DOCKER_HOST "unix:///Users/$USER/.colima/docker.sock"

# can't remember what broke whithout this
ulimit -n 10240
