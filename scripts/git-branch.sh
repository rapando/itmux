#!/bin/sh
# Prints the git branch (or short commit when detached) for a path, styled for
# the itmux status bar. Prints nothing outside a repository.
dir=${1:-.}
branch=$(git -C "$dir" branch --show-current 2>/dev/null) || exit 0
[ -n "$branch" ] || branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null) || exit 0
printf '#[fg=#8aa4ff]%s #[fg=#c8cedb]%s #[fg=#3a4050]│ ' "" "$branch"
