function __promptline_cwd {
  local formatted_cwd=""
 
  local cwd="${PWD/#$HOME/$tilde}"
  local first_char part_count=0

  # get first char of the path, i.e. tilde or slash
  [[ -n ${ZSH_VERSION-} ]] && first_char=$cwd[1,1] || first_char=${cwd::1}

  # remove leading tilde
  cwd="${cwd#\~}"

  while [[ "$cwd" == */* && "$cwd" != "/" ]]; do
    # pop off last part of cwd
    local part="${cwd##*/}"
    cwd="${cwd%/*}"

    formatted_cwd="$dir_sep$part$formatted_cwd"
    part_count=$((part_count+1))

    [[ $part_count -eq $dir_limit ]] && first_char="$truncation" && break
  done

  printf "%s" "$first_char$formatted_cwd"
}

function __promptline_git_status {
  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return 1

  local added_symbol="✚ "
  local unmerged_symbol="⨴ "
  local modified_symbol="✎ "
  local clean_symbol="✔"
  local has_untracked_files_symbol="…"

  # local ahead_symbol="↑"
  # local behind_symbol="↓"

  local unmerged_count=0 modified_count=0 has_untracked_files=0 added_count=0 is_clean=""

  # set -- $(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
  # local behind_count=$1
  # local ahead_count=$2

  # Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R), changed (T), Unmerged (U), Unknown (X), Broken (B)
  while read line; do
    case "$line" in
      M*) modified_count=$(( $modified_count + 1 )) ;;
      U*) unmerged_count=$(( $unmerged_count + 1 )) ;;
    esac
  done < <(git diff --name-status)

  while read line; do
    case "$line" in
      *) added_count=$(( $added_count + 1 )) ;;
    esac
  done < <(git diff --name-status --cached)

  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    has_untracked_files=1
  fi

  if [ $(( unmerged_count + modified_count + has_untracked_files + added_count )) -eq 0 ]; then
    is_clean=1
  fi

  local leading_whitespace=""
  # [[ $ahead_count -gt 0 ]]         && { printf "%s" "$leading_whitespace$ahead_symbol$ahead_count"; leading_whitespace="$sec_split"; }
  # [[ $behind_count -gt 0 ]]        && { printf "%s" "$leading_whitespace$behind_symbol$behind_count"; leading_whitespace="$sec_split"; }
  [[ $modified_count -gt 0 ]]      && { printf "%s" "$leading_whitespace$modified_symbol$modified_count"; leading_whitespace="$sec_split"; }
  [[ $unmerged_count -gt 0 ]]      && { printf "%s" "$leading_whitespace$unmerged_symbol$unmerged_count"; leading_whitespace="$sec_split"; }
  [[ $added_count -gt 0 ]]         && { printf "%s" "$leading_whitespace$added_symbol$added_count"; leading_whitespace="$sec_split"; }
  [[ $has_untracked_files -gt 0 ]] && { printf "%s" "$leading_whitespace$has_untracked_files_symbol"; leading_whitespace="$sec_split"; }
  [[ $is_clean -gt 0 ]]            && { printf "%s" "$leading_whitespace$clean_symbol"; leading_whitespace="$sec_split"; }
}