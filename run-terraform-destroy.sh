#!/bin/bash

echo "*********** Initialize backend"
echo "access_key = \"${1}\"" > ../backend.tfvars
cat ../backend.tfvars
$2/terraform init -backend-config=../backend.tfvars -no-color

echo
echo "*********** Create or select workspace"
if [ $($2/terraform workspace list | grep $3 | wc -l) -eq 0 ]; then
  echo "Create new workspace $3"
  $2/terraform workspace new $3 -no-color
else
  echo "Switch to workspace $3"
  $2/terraform workspace select $3 -no-color
fi

echo
echo "*********** Run 'plan -destroy'"
$2/terraform plan --var-file=../global.tfvars --var-file=../release.tfvars -var="release=$4" -destroy -no-color -input=false

echo
echo "*********** Run 'destroy'"
$2/terraform destroy --var-file=../global.tfvars --var-file=../release.tfvars -var="release=$4" -auto-approve -no-color -input=false