function callback() {
  NEXT_CI_STATUS=$3

  zle-reset-prompt
}

function main() {
  local git=$(git -C $1 rev-parse --is-inside-work-tree 2> /dev/null)

  if [[ $git == true ]]; then
    local ci=$(hub -C $1 ci-status)
    
    if [[ $ci == "success" ]]; then
      print "%{$fg[green]%}$ci %{$reset_color%}"
    elif [[ $ci == "failure" ]]; then
      print "%{$fg[red]%}$ci %{$reset_color%}"
    else
      print "%{$fg[yellow]%}$ci %{$reset_color%}"
    fi
  fi
}

function ci_status() {
  async_init
  async_start_worker ci_status_worker -n
  async_register_callback ci_status_worker callback
  async_job ci_status_worker main $1
}