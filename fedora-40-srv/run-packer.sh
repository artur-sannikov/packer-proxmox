#!/bin/bash
# Run packer validate or build
# Usage: ./run-packer.sh [command]
credentials="../credentials.pkrvars.hcl"
vars="vars/fedora-40-srv.pkrvars.hcl"

if [ "$1" == "validate" ]; then
  packer validate -var-file="${credentials}" -var-file="${vars}" .
elif [ "$1" == "build" ]; then
  packer build -var-file="${credentials}" -var-file="${vars}" .
else
  echo "Incorrect command"
fi
