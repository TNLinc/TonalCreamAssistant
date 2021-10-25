#!/bin/sh

set -x
set -e

EXEC="${1}"

terraform --version
terraform init
terraform validate

if [[ "${EXEC}" == "apply" ]]
then
    terraform apply -auto-approve -input=false
fi


if [[ "${EXEC}" == "plan" ]]
then
    terraform plan -input=false
fi