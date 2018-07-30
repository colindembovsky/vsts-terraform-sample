#!/bin/bash

echo "*********** Initialize backend"
echo "access_key = \"${1}\"" > ../backend.tfvars
cat ../backend.tfvars
$2/terraform init -backend-config=../backend.tfvars -no-color

echo "*********** Create or select workspace"
if [ $($2/terraform workspace list | grep $3 | wc -l) -eq 0 ]; then
  echo "Create new workspace $3"
  $2/terraform workspace new $3 -no-color
else
  echo "Switch to workspace $3"
  $2/terraform workspace select $3 -no-color
fi

echo "*********** Run 'plan'"
$2/terraform plan --var-file=../global.tfvars --var-file=../release.tfvars -var="release=$4" --out=./tf.plan -no-color -input=false

echo "*********** Run 'apply'"
# $2/terraform apply -no-color -input=false -auto-approve ./tf.plan