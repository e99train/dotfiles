_hks() {
    local -a workspaces

    workspaces=("${(@f)$(
        herdr workspace list 2>/dev/null |
            jq -r '
                .result.workspaces[].label
                | select(. != "~")
                | select(. != ".git")
            '
    )}")

    (( ${#workspaces[@]} )) || return 1

    _describe 'Herdr workspace' workspaces
}

compdef _hks hks

#compdef opencode
###-begin-opencode-completions-###
#
# yargs command completion script
#
# Installation: opencode completion >> ~/.zshrc
#    or opencode completion >> ~/.zprofile on OSX.
#
_opencode_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
  IFS=$si
  if [[ ${#reply} -gt 0 ]]; then
    _describe 'values' reply
  else
    _default
  fi
}
if [[ "'${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
  _opencode_yargs_completions "$@"
else
  compdef _opencode_yargs_completions opencode
fi
###-end-opencode-completions-###

