#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
test_root=$(mktemp -d "${TMPDIR:-/tmp}/profile-tests.XXXXXX")
trap 'rm -rf -- "$test_root"' EXIT
repo="$test_root/repo with spaces"
test_home="$test_root/home with spaces"
mkdir -p "$repo/profile" "$test_home/.config/nvim" "$test_home/.source"
cp "$root/setup" "$repo/setup"
cp -R "$root/profile/Common" "$repo/profile/"
printf 'old bashrc\n' > "$test_home/.bashrc"
printf 'old editor\n' > "$test_home/.config/nvim/init.vim"
printf 'old helper\n' > "$test_home/.source/enable.sh"
printf 'j() { printf "old jump\\n"; }\n' > "$test_home/.source/autojump.sh"
printf 'unrelated\n' > "$test_home/.config/nvim/keep.txt"
printf '[user]\n name = Test User\n email = test@example.com\n[core]\n editor = personal-editor\n' > "$test_home/.gitconfig"

run_setup() { env HOME="$test_home" TMPDIR="$test_root" bash "$repo/setup" "$@"; }
assert() { "$@" || { printf 'Assertion failed: %s\n' "$*" >&2; exit 1; }; }

run_setup plan Common > "$test_root/plan.log"
assert test ! -d "$test_home/.profile-backups"
if run_setup home Missing > "$test_root/missing.log" 2>&1; then exit 1; fi
if run_setup home > "$test_root/empty.log" 2>&1; then exit 1; fi
run_setup home Common
assert test ! -L "$test_home/.bashrc"
assert test -f "$test_home/.config/nvim/init.lua"
assert test ! -e "$test_home/.config/nvim/init.vim"
assert test ! -e "$test_home/.source/enable.sh"
assert test ! -e "$test_home/.source/autojump.sh"
assert test -f "$test_home/.config/nvim/keep.txt"
assert test "$(env HOME="$test_home" git config --global user.email)" = test@example.com
assert test "$(env HOME="$test_home" git config --global core.editor)" = personal-editor
assert test "$(env HOME="$test_home" git config --global --includes alias.st)" = status
backup=$(find "$test_home/.profile-backups" -mindepth 1 -maxdepth 1 -type d | head -n 1)
assert grep -q 'old bashrc' "$backup/.bashrc"
assert grep -q 'old editor' "$backup/.config/nvim/init.vim"
assert grep -q 'old helper' "$backup/.source/enable.sh"
assert grep -q 'old jump' "$backup/.source/autojump.sh"
before=$(find "$test_home/.profile-backups" -type f | wc -l)
run_setup home Common
assert test "$before" = "$(find "$test_home/.profile-backups" -type f | wc -l)"
assert test "$(env HOME="$test_home" git config --global --get-all include.path | wc -l | tr -d ' ')" = 1

# Fresh staging and matching script names must not leak or hide other profiles.
mkdir -p "$repo/profile/First/pre" "$repo/profile/Second/pre" "$repo/profile/Second/home"
printf 'printf first >> "$HOME/order"\n' > "$repo/profile/First/pre/tools.sh"
printf 'printf second >> "$HOME/order"\n' > "$repo/profile/Second/pre/tools.sh"
printf 'second\n' > "$repo/profile/Second/home/.bashrc"
run_setup pre First Second
assert test "$(cat "$test_home/order")" = firstsecond
run_setup home Common Second
assert grep -q '^second$' "$test_home/.bashrc"
run_setup home Common
assert cmp "$test_home/.bashrc" "$root/profile/Common/home/.bashrc"

mkdir -p "$repo/profile/Failure/pre" "$repo/profile/Failure/home"
printf 'false\nprintf masked > "$HOME/masked"\n' > "$repo/profile/Failure/pre/failure.sh"
printf 'should not install\n' > "$repo/profile/Failure/home/not-installed"
if run_setup install Failure > "$test_root/failure.log" 2>&1; then exit 1; fi
assert test ! -e "$test_home/masked"
assert test ! -e "$test_home/not-installed"
assert grep -q 'Failed (1)' "$test_root/failure.log"
if run_setup script "$test_root/missing.sh" > /dev/null 2>&1; then exit 1; fi

# Symlink migration: snapshot contents and preserve unrelated directory files.
mkdir -p "$test_root/linked-config/nvim"
printf 'keep linked content\n' > "$test_root/linked-config/nvim/unrelated"
printf 'original linked config\n' > "$test_root/linked-bashrc"
if ln -s "$test_root/linked-config" "$test_home/link-test" 2>/dev/null && [[ -L $test_home/link-test ]]; then
  rm "$test_home/link-test"
  mv "$test_home/.config" "$test_home/saved-config"
  ln -s "$test_root/linked-config" "$test_home/.config"
  rm "$test_home/.bashrc"
  ln -s "$test_root/linked-bashrc" "$test_home/.bashrc"
  run_setup home Common
  assert test ! -L "$test_home/.config"
  assert test ! -L "$test_home/.bashrc"
  assert grep -q 'keep linked content' "$test_home/.config/nvim/unrelated"
  assert grep -q 'original linked config' "$test_root/linked-bashrc"
  assert test ! -e "$test_root/linked-config/nvim/init.lua"
else
  printf 'SKIP: native symlinks unavailable on this host.\n'
fi

# Empty local directories and absent optional tools must not break startup.
mkdir -p "$test_home/.bashrc.d"
printf 'export PROFILE_TEST_OVERRIDE=loaded\n' > "$test_home/.bashrc.d/local.sh"
env HOME="$test_home" PATH=/usr/bin:/bin bash --noprofile --rcfile "$test_home/.bashrc" -i -c 'test "$PROFILE_TEST_OVERRIDE" = loaded' > "$test_root/shell.log" 2>&1
if grep -E 'command not found|No such file|unbound variable' "$test_root/shell.log"; then exit 1; fi
printf 'Bash installer regression tests passed.\n'
