# NOTE: For now no specific command, but I'll leave it here just in case :)
if status is-interactive
    # Commands to run in interactive sessions can go here
end

function get_cntlm_proxy
  set -gx http_proxy 127.0.0.1:3128
  set -gx https_proxy 127.0.0.1:3128
end

function unset_cntlm_proxy
  set -e http_proxy
  set -e https_proxy
end

# extra paths
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.pub-cache/bin

# neovim
set -x EDITOR nvim

# the following seems like just a nuisance:
# @fish-lsp-disable 2002
alias nn="nvim"
alias n="nvim"

alias l="ls -l"
alias ll="ls -l"
alias la="ls -l"
alias lla="ls -l"
# @fish-lsp-enable 2002

# fvm
fish_add_path $HOME/fvm/default/bin
fish_add_path $HOME/.pub-cache/bin

starship init fish | source
zoxide init --cmd cd fish | source

# also alias zi due to my muscle memory
if functions -q __zoxide_zi
    alias zi=__zoxide_zi
else
    # hell yeah ascii color codes!
    echo "\e[0;31m[WARNING] zoxide's `zi` function is not defined! \e[0m"
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
