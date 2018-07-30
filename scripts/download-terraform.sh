#!/bin/bash -e

if [ ! -f $1/terraform ]; then
  echo "Downloading terraform from ${2} to ${1}"
  curl $2 -o terraform.zip
  mkdir -p $1
  unzip terraform.zip -d $1
else
  echo "Terraform already exists in ${1}"
fi
$1/terraform -version