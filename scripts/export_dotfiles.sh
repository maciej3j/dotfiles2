#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git -C "$(dirname "${BASH_SOURCE[0]}")/.." rev-parse --show-toplevel)
output_file="$repo_root/output.txt"

{
  while IFS= read -r -d '' path; do
    file="$repo_root/$path"

    printf '%s: ' "$path"
    if [[ ! -s "$file" ]] || grep -Iq . "$file"; then
      cat "$file"
    else
      # Keep binary dotfiles representable in the text export.
      printf 'base64:'
      base64 --wrap=0 "$file"
      printf '\n'
    fi
    printf '\n'
  done < <(git -C "$repo_root" ls-files -z -- '.*' 'dot_*')
} >"$output_file"
