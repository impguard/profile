#!/usr/bin/env bash

DOC="Profile setup tool.

Usage:
  ./profile.sh (install|copy) [PROFILES...]
  ./profile.sh (pre|post) [SCRIPT]
  ./profile.sh (ls|reset|info)

Commands:
  install   Installs the entire profile
  copy      Performs copy step and no other step
  pre       Performs pre installation step and no other step, specify script
            with SCRIPT parameter
  post      Performs post installation step and no other step, specify script
            with SCRIPT parameter
  reset     Resets directories
  ls        List all available profiles and installation scripts
  info      Shows information about current system
"

# docopt parser below, refresh this parser with `docopt.sh profile.sh`
# shellcheck disable=2016,1075
docopt() { parse() { if ${DOCOPT_DOC_CHECK:-true}; then local doc_hash
doc_hash=$(printf "%s" "$DOC" | shasum -a 256)
if [[ ${doc_hash:0:5} != "$digest" ]]; then
stderr "The current usage doc (${doc_hash:0:5}) does not match \
what the parser was generated with (${digest})
Run \`docopt.sh\` to refresh the parser."; _return 70; fi; fi; local root_idx=$1
shift; argv=("$@"); parsed_params=(); parsed_values=(); left=(); testdepth=0
local arg; while [[ ${#argv[@]} -gt 0 ]]; do if [[ ${argv[0]} = "--" ]]; then
for arg in "${argv[@]}"; do parsed_params+=('a'); parsed_values+=("$arg"); done
break; elif [[ ${argv[0]} = --* ]]; then parse_long
elif [[ ${argv[0]} = -* && ${argv[0]} != "-" ]]; then parse_shorts
elif ${DOCOPT_OPTIONS_FIRST:-false}; then for arg in "${argv[@]}"; do
parsed_params+=('a'); parsed_values+=("$arg"); done; break; else
parsed_params+=('a'); parsed_values+=("${argv[0]}"); argv=("${argv[@]:1}"); fi
done; local idx; if ${DOCOPT_ADD_HELP:-true}; then
for idx in "${parsed_params[@]}"; do [[ $idx = 'a' ]] && continue
if [[ ${shorts[$idx]} = "-h" || ${longs[$idx]} = "--help" ]]; then
stdout "$trimmed_doc"; _return 0; fi; done; fi
if [[ ${DOCOPT_PROGRAM_VERSION:-false} != 'false' ]]; then
for idx in "${parsed_params[@]}"; do [[ $idx = 'a' ]] && continue
if [[ ${longs[$idx]} = "--version" ]]; then stdout "$DOCOPT_PROGRAM_VERSION"
_return 0; fi; done; fi; local i=0; while [[ $i -lt ${#parsed_params[@]} ]]; do
left+=("$i"); ((i++)) || true; done
if ! required "$root_idx" || [ ${#left[@]} -gt 0 ]; then error; fi; return 0; }
parse_shorts() { local token=${argv[0]}; local value; argv=("${argv[@]:1}")
[[ $token = -* && $token != --* ]] || _return 88; local remaining=${token#-}
while [[ -n $remaining ]]; do local short="-${remaining:0:1}"
remaining="${remaining:1}"; local i=0; local similar=(); local match=false
for o in "${shorts[@]}"; do if [[ $o = "$short" ]]; then similar+=("$short")
[[ $match = false ]] && match=$i; fi; ((i++)) || true; done
if [[ ${#similar[@]} -gt 1 ]]; then
error "${short} is specified ambiguously ${#similar[@]} times"
elif [[ ${#similar[@]} -lt 1 ]]; then match=${#shorts[@]}; value=true
shorts+=("$short"); longs+=(''); argcounts+=(0); else value=false
if [[ ${argcounts[$match]} -ne 0 ]]; then if [[ $remaining = '' ]]; then
if [[ ${#argv[@]} -eq 0 || ${argv[0]} = '--' ]]; then
error "${short} requires argument"; fi; value=${argv[0]}; argv=("${argv[@]:1}")
else value=$remaining; remaining=''; fi; fi; if [[ $value = false ]]; then
value=true; fi; fi; parsed_params+=("$match"); parsed_values+=("$value"); done
}; parse_long() { local token=${argv[0]}; local long=${token%%=*}
local value=${token#*=}; local argcount; argv=("${argv[@]:1}")
[[ $token = --* ]] || _return 88; if [[ $token = *=* ]]; then eq='='; else eq=''
value=false; fi; local i=0; local similar=(); local match=false
for o in "${longs[@]}"; do if [[ $o = "$long" ]]; then similar+=("$long")
[[ $match = false ]] && match=$i; fi; ((i++)) || true; done
if [[ $match = false ]]; then i=0; for o in "${longs[@]}"; do
if [[ $o = $long* ]]; then similar+=("$long"); [[ $match = false ]] && match=$i
fi; ((i++)) || true; done; fi; if [[ ${#similar[@]} -gt 1 ]]; then
error "${long} is not a unique prefix: ${similar[*]}?"
elif [[ ${#similar[@]} -lt 1 ]]; then
[[ $eq = '=' ]] && argcount=1 || argcount=0; match=${#shorts[@]}
[[ $argcount -eq 0 ]] && value=true; shorts+=(''); longs+=("$long")
argcounts+=("$argcount"); else if [[ ${argcounts[$match]} -eq 0 ]]; then
if [[ $value != false ]]; then
error "${longs[$match]} must not have an argument"; fi
elif [[ $value = false ]]; then
if [[ ${#argv[@]} -eq 0 || ${argv[0]} = '--' ]]; then
error "${long} requires argument"; fi; value=${argv[0]}; argv=("${argv[@]:1}")
fi; if [[ $value = false ]]; then value=true; fi; fi; parsed_params+=("$match")
parsed_values+=("$value"); }; required() { local initial_left=("${left[@]}")
local node_idx; ((testdepth++)) || true; for node_idx in "$@"; do
if ! "node_$node_idx"; then left=("${initial_left[@]}"); ((testdepth--)) || true
return 1; fi; done; if [[ $((--testdepth)) -eq 0 ]]; then
left=("${initial_left[@]}"); for node_idx in "$@"; do "node_$node_idx"; done; fi
return 0; }; either() { local initial_left=("${left[@]}"); local best_match_idx
local match_count; local node_idx; ((testdepth++)) || true
for node_idx in "$@"; do if "node_$node_idx"; then
if [[ -z $match_count || ${#left[@]} -lt $match_count ]]; then
best_match_idx=$node_idx; match_count=${#left[@]}; fi; fi
left=("${initial_left[@]}"); done; ((testdepth--)) || true
if [[ -n $best_match_idx ]]; then "node_$best_match_idx"; return 0; fi
left=("${initial_left[@]}"); return 1; }; optional() { local node_idx
for node_idx in "$@"; do "node_$node_idx"; done; return 0; }; oneormore() {
local i=0; local prev=${#left[@]}; while "node_$1"; do ((i++)) || true
[[ $prev -eq ${#left[@]} ]] && break; prev=${#left[@]}; done
if [[ $i -ge 1 ]]; then return 0; fi; return 1; }; _command() { local i
local name=${2:-$1}; for i in "${!left[@]}"; do local l=${left[$i]}
if [[ ${parsed_params[$l]} = 'a' ]]; then
if [[ ${parsed_values[$l]} != "$name" ]]; then return 1; fi
left=("${left[@]:0:$i}" "${left[@]:((i+1))}")
[[ $testdepth -gt 0 ]] && return 0; if [[ $3 = true ]]; then
eval "((var_$1++)) || true"; else eval "var_$1=true"; fi; return 0; fi; done
return 1; }; value() { local i; for i in "${!left[@]}"; do local l=${left[$i]}
if [[ ${parsed_params[$l]} = "$2" ]]; then
left=("${left[@]:0:$i}" "${left[@]:((i+1))}")
[[ $testdepth -gt 0 ]] && return 0; local value
value=$(printf -- "%q" "${parsed_values[$l]}"); if [[ $3 = true ]]; then
eval "var_$1+=($value)"; else eval "var_$1=$value"; fi; return 0; fi; done
return 1; }; stdout() { printf -- "cat <<'EOM'\n%s\nEOM\n" "$1"; }; stderr() {
printf -- "cat <<'EOM' >&2\n%s\nEOM\n" "$1"; }; error() {
[[ -n $1 ]] && stderr "$1"; stderr "$usage"; _return 1; }; _return() {
printf -- "exit %d\n" "$1"; exit "$1"; }; set -e; trimmed_doc=${DOC:0:607}
usage=${DOC:21:116}; digest=5e863; shorts=(); longs=(); argcounts=(); node_0(){
value PROFILES a true; }; node_1(){ value SCRIPT a; }; node_2(){
_command install; }; node_3(){ _command copy; }; node_4(){ _command pre; }
node_5(){ _command post; }; node_6(){ _command ls; }; node_7(){ _command reset
}; node_8(){ _command info; }; node_9(){ either 2 3; }; node_10(){ required 9; }
node_11(){ oneormore 0; }; node_12(){ optional 11; }; node_13(){ required 10 12
}; node_14(){ either 4 5; }; node_15(){ required 14; }; node_16(){ optional 1; }
node_17(){ required 15 16; }; node_18(){ either 6 7 8; }; node_19(){ required 18
}; node_20(){ required 19; }; node_21(){ either 13 17 20; }; node_22(){
required 21; }; cat <<<' docopt_exit() { [[ -n $1 ]] && printf "%s\n" "$1" >&2
printf "%s\n" "${DOC:21:116}" >&2; exit 1; }'; unset var_PROFILES var_SCRIPT \
var_install var_copy var_pre var_post var_ls var_reset var_info; parse 22 "$@"
local prefix=${DOCOPT_PREFIX:-''}; local docopt_decl=1
[[ $BASH_VERSION =~ ^4.3 ]] && docopt_decl=2; unset "${prefix}PROFILES" \
"${prefix}SCRIPT" "${prefix}install" "${prefix}copy" "${prefix}pre" \
"${prefix}post" "${prefix}ls" "${prefix}reset" "${prefix}info"
if declare -p var_PROFILES >/dev/null 2>&1; then
eval "${prefix}"'PROFILES=("${var_PROFILES[@]}")'; else
eval "${prefix}"'PROFILES=()'; fi; eval "${prefix}"'SCRIPT=${var_SCRIPT:-}'
eval "${prefix}"'install=${var_install:-false}'
eval "${prefix}"'copy=${var_copy:-false}'
eval "${prefix}"'pre=${var_pre:-false}'
eval "${prefix}"'post=${var_post:-false}'; eval "${prefix}"'ls=${var_ls:-false}'
eval "${prefix}"'reset=${var_reset:-false}'
eval "${prefix}"'info=${var_info:-false}'; local docopt_i=0
for ((docopt_i=0;docopt_i<docopt_decl;docopt_i++)); do
declare -p "${prefix}PROFILES" "${prefix}SCRIPT" "${prefix}install" \
"${prefix}copy" "${prefix}pre" "${prefix}post" "${prefix}ls" "${prefix}reset" \
"${prefix}info"; done; }
# docopt parser above, complete command for generating this parser is `docopt.sh profile.sh`

eval "$(docopt "$@")"

set -euo pipefail

PROFILE_ROOT="$HOME/.profile.d"
PROFILE_STAGING="$PROFILE_ROOT/staging"
PROFILE_INSTALL="$PROFILE_STAGING/install"

########################################
# Helpers
########################################

RED='\033[0;31m'
GREEN='\033[0;32m'
CLEAR='\033[0m'

function log
{
  local message=$1
  echo -e "$GREEN$message$CLEAR"
}

function logerror
{
  local message=$1
  echo -e "$RED$message$CLEAR"
}

function pushd
{
  command pushd "$@" > /dev/null
}

function popd
{
  command popd > /dev/null
}

function stage
{
  local staging_dir="$PROFILE_ROOT/profile/$1/."
  if [ -d "$staging_dir" ]; then
    cp -vfrs "$PROFILE_ROOT/profile/$1/." "$PROFILE_STAGING"
  fi
}

function link_home_files
{
  log "Linking home files"
  cp -a "$PROFILE_STAGING/home/." "$HOME/"

  log "Linking bin files"
  cp -a "$PROFILE_STAGING/bin/." "$HOME/.bin"

  log "Linking source files"
  cp -a "$PROFILE_STAGING/source/." "$HOME/.source"
}

function perform_install
{
  local type filename

  type=$1

  if [ ! -d "$PROFILE_STAGING/$type" ]; then
    log "Nothing to install from $PROFILE_STAGING/$type"
    return
  fi

  for script in "$PROFILE_STAGING/$type"/*; do
    one_off_install "$type" "$script"
  done
}

function one_off_install
{
  local type script filename workdir

  type=$1
  script=$2

  if [ ! -f "$script" ]; then
    logerror "Not a valid install script $1/$2"
    return
  fi

  filename=$(basename "$script")
  workdir=$PROFILE_INSTALL/$type/$filename

  rm -rf "$workdir"
  mkdir -p "$workdir"
  pushd "$workdir"
  log "Running install: $type/$script"
  $script || logerror "Install failed: $type/$script"
  popd
}

########################################
# Commands
########################################

function install
{
  echo "Installing profile"
  echo "  PROFILE_ROOT=$PROFILE_ROOT"
  echo "  PROFILE_STAGING=$PROFILE_STAGING"
  echo "  PROFILES=${PROFILES[@]}"

  # Stage files
  if [ ${#PROFILES[@]} -eq 0 ]; then
    stage Base
  fi

  for profile in "${PROFILES[@]}"; do
    stage "$profile"
  done

  # Pre Install
  if [ -n "${NO_PRE_INSTALL:-}" ]; then
    log "NO_INSTALL set, not running pre install"
  else
    perform_install pre
  fi

  # Copying home files
  if [ -n "${NO_HOME:-}" ]; then
    log "NO_HOME set, not copying to home dir"
  else
    link_home_files
  fi

  # Post Install
  if [ -n "${NO_POST_INSTALL:-}" ]; then
    log "NO_INSTALL set, not running post install"
  else
    # shellcheck disable=SC1090
    perform_install post
  fi

  log "Installation complete!"
}

function reset
{
  # Reset directories
  rm -rf "$PROFILE_STAGING"
  mkdir -p "$PROFILE_INSTALL"
  mkdir -p "$HOME/.bin"
  mkdir -p "$HOME/.source"
}

if $install; then
  install
elif $copy; then
  NO_PRE_INSTALL=1 NO_POST_INSTALL=1 install
elif $pre; then
  if [ -z "$SCRIPT" ]; then
    NO_HOME=1 NO_POST_INSTALL=1 install
  else
    one_off_install pre "$PROFILE_STAGING/pre/$SCRIPT"
  fi
elif $post; then
  if [ -z "$SCRIPT" ]; then
    NO_HOME=1 NO_PRE_INSTALL=1 install "$@"
  else
    one_off_install post "$PROFILE_STAGING/post/$SCRIPT"
  fi
elif $reset; then
  reset
elif $ls; then
  for profile in $(ls profile); do
    echo "Profile      : $profile"
    echo "Pre Scripts  : $(ls "profile/$profile/pre" 2>/dev/null | tr "\n" " ")"
    echo "Post Scripts : $(ls "profile/$profile/post" 2>/dev/null | tr "\n" " ")"
    echo
  done
elif $info; then
  echo "This lists your platform information, which may inform what you want to install."
  uname
fi
