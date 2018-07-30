#!/bin/bash

echo "*********** Initialize backend"
echo 'access_key = "$(ARM_ACCESS_KEY)"' > ../backend.tfvars
$(TerraformPath)/terraform init -backend-config=../backend.tfvars -no-color

echo "*********** Create or select workspace"
if [ $($(TerraformPath)/terraform workspace list | grep $(Release.EnvironmentName) | wc -l) -eq 0 ]; then
  echo "Create new workspace $(Release.EnvironmentName)"
  $(TerraformPath)/terraform workspace new $(Release.EnvironmentName) -no-color
else
  echo "Switch to workspace $(Release.EnvironmentName)"
  $(TerraformPath)/terraform workspace select $(Release.EnvironmentName) -no-color
fi

echo "*********** Run 'plan'"
$(TerraformPath)/terraform plan --var-file=../global.tfvars --var-file=../release.tfvars -var="release=$(Release.ReleaseName)" --out=./tf.plan -no-color -input=false

echo "*********** Run 'apply'"
$(TerraformPath)/terraform apply -no-color -input=false -auto-approve ./tf.plan