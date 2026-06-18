#!/bin/bash

WORK_DIR="/home/viaguila/dev/current/git/xstore/"

cd $WORK_DIR

$WORK_DIR/config/download/prepare-payload.sh
$WORK_DIR/gradlew xst_pos:dataloader


echo "***************************************************************"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

LOG_FILE="$WORK_DIR/config/log/xstore.log"                             # log file to inspect

SEARCH_TEXT="Local] UPDATE prc_deal_item SET qty_min = 1"    # text that must appear in the log
echo "Gradle task finished. Checking log [$LOG_FILE] for: $SEARCH_TEXT"
if grep -qF "$SEARCH_TEXT" "$LOG_FILE"; then
  echo -e "${GREEN}PASS: found expected text in log${NC}"
else
  echo -e "${RED}FAIL: expected text not found in log${NC}"
  exit 1
fi

SEARCH_TEXT="Local] UPDATE prc_deal_item SET deal_action = "    # text that must appear in the log
echo "Gradle task finished. Checking log [$LOG_FILE] for: $SEARCH_TEXT"
if grep -qF "$SEARCH_TEXT" "$LOG_FILE"; then
  echo -e "${GREEN}PASS: found expected text in log${NC}"
else
  echo -e "${RED}FAIL: expected text not found in log${NC}"
  exit 1
fi

exit 0
