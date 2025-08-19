#!/bin/bash

if [[ -z $1 || -z $2 ]]; then
    echo "Usage: $0 <bucket-name> <region>"
    exit 1
fi

if [[ $1 =~ " " || $2 =~ " " ]]; then
  echo "The bucket and region cannot contain spaces"
  exit 1
fi

echo "[INFO] Creating S3 bucket..."

aws s3 mb "s3://$1" --region "$2"

if [[ $? != 0 ]]; then
    echo "[ERROR] Failed to create S3 bucket"
    exit 1
fi

echo "[SUCCESS] S3 bucket created successfully"