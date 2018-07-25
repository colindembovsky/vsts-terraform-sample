#!/bin/bash

# vim: filetype=sh:tabstop=2:shiftwidth=2:expandtab

readonly PROGNAME=$(basename $0)
readonly PROGDIR="$( cd "$(dirname "$0")" ; pwd -P )"
readonly ARGS="$@"

#################
# pull in utils #
#################
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
#################

# Make sure we have all the right stuff
prerequisites() {
  local curl_cmd=`which curl`
  local unzip_cmd=`which unzip`

  if [ -z "$curl_cmd" ]; then
    error "curl does not appear to be installed. Please install and re-run this script."
    exit 1
  fi

  if [ -z "$unzip_cmd" ]; then
    error "unzip does not appear to be installed. Please install and re-run this script."
    exit 1
  fi

  # we want to be root to install / uninstall
  if [ "$EUID" -ne 0 ]; then
    error "Please run as root"
    exit 1
  fi
}


# Install Terraform
install_terraform() {
  echo ""
  echo "Downloading Terraform zip'd binary"
  curl -o "$DOWNLOADED_FILE" "$DOWNLOAD_URL"

  echo ""
  echo "Extracting Terraform executable"
  unzip "$DOWNLOADED_FILE" -d "$INSTALL_DIR"
  
  rm "$DOWNLOADED_FILE"
}


main() {
  # Be unforgiving about errors
  set -euo pipefail
  readonly SELF="$(absolute_path $0)"
  prerequisites
  cd "${PROGDIR}" || exit 1
  bash uninstall-terraform.sh || exit 1
  install_terraform
}

[[ "$0" == "$BASH_SOURCE" ]] && main