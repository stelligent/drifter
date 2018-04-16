#!/bin/sh

set -e
die () {
    echo >&2 "$@"
    exit 1
}

### Expect argument to be provided with the stack name
[ "$#" -eq 1 ] || die "Usage: $0 [stack_name]"
STACK_NAME=$1

### Initiate drift detection
DRIFT_DETECTION_ID=$(aws cfn detect-stack-drift --stack-name ${STACK_NAME} --query StackDriftDetectionId --output text)

### Wait for detection to complete
echo -n "Waiting for drift detection to complete..."
while true; do
    DETECTION_STATUS=$(aws cfn describe-stack-drift-detection-status --stack-drift-detection-id ${DRIFT_DETECTION_ID} --query DetectionStatus --output text) 
    if [ "DETECTION_IN_PROGRESS" == ${DETECTION_STATUS} ]; then 
        echo -n "."
        sleep 1 
    else
        STACK_DRIFT_STATUS=$(aws cfn describe-stack-drift-detection-status --stack-drift-detection-id ${DRIFT_DETECTION_ID} --query StackDriftStatus --output text) 
        echo ${STACK_DRIFT_STATUS}
        break
    fi
done

### Describe the drift details
if [ "DRIFTED" == ${STACK_DRIFT_STATUS} ]; then 
    aws cfn describe-stack-resource-drifts \
        --stack-name ${STACK_NAME} \
        --query 'StackResourceDrifts[?StackResourceDriftStatus!=`IN_SYNC`].{Type:ResourceType, Resource:LogicalResourceId, Status:StackResourceDriftStatus, Diff:PropertyDifferences}' >&2 
    exit 1 
fi
