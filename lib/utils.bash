#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/containerd/nerdctl"
GH_API_REPO="https://api.github.com/repos/containerd/nerdctl"

TOOL_NAME="nerdctl"
TOOL_TEST="-v"
PLATFORM=$(uname | tr '[:upper:]' '[:lower:]')

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

arch() {
  arch="$(uname -m)"
  if [[ $arch == "x86_64" ]]; then
    arch="amd64"
  fi
  echo $arch
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if <YOUR TOOL> is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}
