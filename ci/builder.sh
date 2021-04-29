#!/bin/bash -xe

APP_NAME=$1
BUILD_NUMBER=$2
MAIN_DIR="./"
WORK_DIR="${MAIN_DIR}/${APP_NAME}"

AWS_ACCOUNT_ID="130575395405"
AWS_REGION="us-east-1"
REMOTE_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
REMOTE_REPO="${REMOTE_REGISTRY}/${APP_NAME}"

echo "Working directory is $WORK_DIR"
cd $WORK_DIR

aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin $REMOTE_REGISTRY

docker build -t "${APP_NAME}:latest" .

docker tag "${APP_NAME}:latest" "${REMOTE_REPO}:${BUILD_NUMBER}"

docker push "${REMOTE_REPO}:${BUILD_NUMBER}"