# ============== Promptline Utils ==============

[ -f ~/.bash_extra/promptline_utils.sh ] && source ~/.bash_extra/promptline_utils.sh

function __promptline_wrapper {
  # wrap the text in $1 with $2 and $3, only if $1 is not empty
  # $2 and $3 typically contain non-content-text, like color escape codes and separators

  [[ -n "$1" ]] || return 1
  printf "%s" "${2}${1}${3}"
}

# ============== GIT ==============

# Usage: $(branch_color clean_repo_color dirty_repo_color)
function branch_color {
  local color=""
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    if git diff --quiet 2>/dev/null >&2 
    then
      color="$1" #$green
    else
      color="$2" #$red
    fi
  fi
  printf "%s" "${color}"
}

function git_br {
  local branch
  
  if git rev-parse --git-dir >/dev/null 2>&1
  then
    branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
    printf "%s" "${branch_symbol}${branch}"
    return
  fi
}

# ============== PROMPT PRINTER ==============

function __pretty_prompt {
  local comps section_bg section_fg s_fg s_bg sep_fg slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1
  
  printf "%s" "\n"

  for index in ${!sections[*]}
  do
    section_bg=${section_bgs[$index]} section_fg=${section_fgs[$index]}
    s_fg="${wrap}38;5;${section_fg}${end_wrap}" s_bg="${wrap}48;5;${section_bg}${end_wrap}" sep_fg="${wrap}38;5;${section_bg}${end_wrap}"
    slice_prefix="${s_bg}${sep}${s_fg}${s_bg}${space}" slice_suffix="$space${sep_fg}" slice_joiner="${s_fg}${s_bg}${alt_sep}${space}" slice_empty_prefix="${s_fg}${s_bg}${space}"
    [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"

    if [[ ${sections[$index]} == *${sec_split}* ]]
    then
      IFS="${sec_split}" read -a comps <<< "${sections[$index]}"
    else
      comps=( "${sections[$index]}" )
    fi
    for cindex in ${!comps[*]}
    do
      __promptline_wrapper "${comps[$cindex]}" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
    done
  done

  # close sections
  printf "%s" "${reset_bg}${sep}$reset$space"
}

function __pretty_prompt_PS2 {
  local comps section_bg section_fg s_fg s_bg sep_fg slice_prefix slice_empty_prefix slice_joiner slice_suffix is_prompt_empty=1

  section_bg=${section_bgs[0]} section_fg=${section_fgs[0]}
  s_fg="${wrap}38;5;${section_fg}${end_wrap}" s_bg="${wrap}48;5;${section_bg}${end_wrap}" sep_fg="${wrap}38;5;${section_bg}${end_wrap}"
  slice_prefix="${s_bg}${sep}${s_fg}${s_bg}${space}" slice_suffix="$space${sep_fg}" slice_joiner="${s_fg}${s_bg}${alt_sep}${space}" slice_empty_prefix="${s_fg}${s_bg}${space}"
  [ $is_prompt_empty -eq 1 ] && slice_prefix="$slice_empty_prefix"
  __promptline_wrapper "$1" "$slice_prefix" "$slice_suffix" && { slice_prefix="$slice_joiner"; is_prompt_empty=0; }
    
  # close sections
  printf "%s" "${reset_bg}${sep}$reset$space"
}

# ============== START PROMPT ==============

function __promptline {

  # -vvv----------[ Configurations ]------------vvv-
  
  # common
  local sep="⮀"
  local alt_sep="⮁"
  local ps2_symble="➥"

  # for git
  local branch_symbol="⭠ "

  # for pretty path
  local dir_limit="2"
  local truncation="⋯"
  local dir_sep=" ⮁ "
  local tilde="~"

  local sec_split="##"
 
  # sections and their colors
  local sections=( "\u" "$(__promptline_cwd)" "$(git_br)##$(__promptline_git_status)" )
  local section_bgs=( "74" "238" "$(branch_color 120 210)" )
  local section_fgs=( "195" "247" "$(branch_color 28 124)" )

  # -^^^-------[ End of Configurations ]--------^^^-
  
  local space=" "
  local esc=$'[' end_esc=m
  local noprint='\[' end_noprint='\]'
  local wrap="$noprint$esc" end_wrap="$end_esc$end_noprint"
  local reset="${wrap}0${end_wrap}"
  local reset_bg="${wrap}49${end_wrap}"

  PS1="$(__pretty_prompt)"
  PS2="$(__pretty_prompt_PS2 ${ps2_symble})"
}

if [[ ! "$PROMPT_COMMAND" == *__promptline* ]]; then
  PROMPT_COMMAND='__promptline;'$'\n'"$PROMPT_COMMAND"
fi

# ============== START BANNER ==============

function __show_banner {
  local filename=~/.bash_extra/.bash_banner
  if [ -f "$filename" ]
  then
    local col=234
    while IFS='' read -r line
    do
      printf "%s\n" "[38;5;${col}m${line}"
      ((col+=2))
    done < "$filename"
    printf "%s" "[0m"
  fi
}
__show_banner
