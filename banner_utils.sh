# Gradient banner
# params 1) base_color 2) color_delta
function __show_gradient_banner {
  local filename=~/.bash_extra/bash_banner.txt
  if [ -f "$filename" ]
  then
    local col=${1}
    while IFS='' read -r line
    do
      printf "%s\n" "[38;5;${col}m${line}"
      ((col+=${2}))
    done < "$filename"
    printf "%s" "[0m"
  fi
}