#!/bin/bash

WORK_DIR="/home/viaguila/dev/current/git/xstore/"

cd $WORK_DIR

$WORK_DIR/config/download/prepare-payload.sh
$WORK_DIR/gradlew xst_pos:dataloader


echo "***************************************************************"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

FAILURES_FILE="$WORK_DIR/config/download/failures.dat"

echo "Gradle task finished. Checking for failures file [$FAILURES_FILE]"
if [[ -f "$FAILURES_FILE" ]]; then
  echo -e "${RED}FAIL: failures file exists${NC}"
  exit 1
else
  echo -e "${GREEN}PASS: failures file does not exist${NC}"
fi

exit 0
