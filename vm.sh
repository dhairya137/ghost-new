#!/bin/bash


if [ "$1" == init ]; then
  echo "Creating VM..."

  terraform apply -auto-approve
  terraform output -json eip > ip.txt
  echo "VM Created Successfully"
fi

if [ "$1" == install ]; then
  echo "Installing Ghost..."
  echo "Pass domain name and email id at the time of executing script"
  cp remote.txt remoteexec.tf
  terraform apply -auto-approve
  # terraform apply -auto-approve -var domain_name="$2" 
  echo "Ghost installed Successfully"
  # > remoteexec.tf 
fi