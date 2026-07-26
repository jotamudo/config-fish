if test "$(uname)" != Linux
  return
end

if command -q keychain
  keychain -q --eval ~/.ssh/id_ed25519 | source
else
  echo 'Keychain is not installed, you\'ll have to type your ssh password...'
end
