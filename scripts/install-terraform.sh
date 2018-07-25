#!/bin/bash

# vim: filetype=sh:tabstop=2:shiftwidth=2:expandtab

readonly PROGNAME=$(basename $0)
readonly PROGDIR="$( cd "$(dirname "$0")" ; pwd -P )"
readonly ARGS="$@"

# pull in utils
source "${PROGDIR}/utils.sh"


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