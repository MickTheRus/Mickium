#!/usr/bin/env bash
set -euo pipefail

if ! command -v paru >/dev/null 2>&1; then
  echo "error: paru is required for AUR packages (nixd, omnisharp-roslyn-bin)." >&2
  exit 1
fi

packages=(
  lua-language-server
  vscode-json-languageserver
  yaml-language-server
  nixd
  omnisharp-roslyn-bin
)

paru -S --needed --noconfirm "${packages[@]}"

echo
echo "Checking installed language server commands:"

commands=(
  lua-language-server
  vscode-json-languageserver
  yaml-language-server
  nixd
  omnisharp
)

missing=0
for command_name in "${commands[@]}"; do
  if command -v "$command_name" >/dev/null 2>&1; then
    printf 'ok      %s -> %s\n' "$command_name" "$(command -v "$command_name")"
  else
    printf 'missing %s\n' "$command_name"
    missing=1
  fi
done

exit "$missing"
