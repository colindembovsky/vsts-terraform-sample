#!/bin/bash -

readonly TERRAFORM_VERSION="0.11.7"
readonly INSTALL_DIR="/usr/local/bin"
readonly DOWNLOAD_DIR="/tmp"
readonly DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
readonly DOWNLOADED_FILE="$DOWNLOAD_DIR/terraform.zip"

# Get distro data from /etc/os-release
readonly DISTRO_VER=$(awk -F'=' '/VERSION_ID/ {print $2}' /etc/os-release | tr -d '"')
readonly DISTRO_ID=$(awk -F'=' '/ID/ {print $2; exit}' /etc/os-release | tr '[:upper:]' '[:lower:]')


function warn() {
  echo -e "\033[1;33mWARNING: $1\033[0m"
}

function error() {
  echo -e "\033[0;31mERROR: $1\033[0m"
}

function inf() {
  echo -e "\033[0;32m$1\033[0m"
}

function follow() {
  inf "Following docker logs now. Ctrl-C to cancel."
  docker logs --follow $1
}

function run_command() {
  inf "Running:\n $1"
  eval $1 &> /dev/null
}

# Given a relative path, calculate the absolute path
absolute_path() {
  pushd "$(dirname $1)" > /dev/null
  local abspath="$(pwd -P)"
  popd > /dev/null
  echo "$abspath/$(basename $1)"
}