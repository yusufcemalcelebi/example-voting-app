#!/bin/bash -xe

APP_NAME=$1
BUILD_TAG=$2
PROBE_ENABLED=${3:-true}
SERVICE_ENABLED=${4-true}
MAIN_DIR="./"
WORK_DIR="${MAIN_DIR}/cd"

AWS_ACCOUNT_ID="130575395405"
AWS_REGION="us-east-1"
REMOTE_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
REMOTE_REPO="${REMOTE_REGISTRY}/${APP_NAME}"

echo "Working directory is $WORK_DIR"
cd $WORK_DIR

helm upgrade -i $APP_NAME voting-app --set image.repository="${APP_NAME}" \
                                --set image.registry="$REMOTE_REGISTRY" \
                                --set image.tag="${BUILD_TAG}" \
                                --set probes.liveness.enabled=${PROBE_ENABLED} \
                                --set probes.readiness.enabled=${PROBE_ENABLED} \
                                --set service.enabled=${SERVICE_ENABLED}