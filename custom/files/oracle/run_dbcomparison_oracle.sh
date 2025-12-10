#!/bin/bash

# is expected to run from the xstore directory...

# build the zip
./gradlew database:dbmakeZip

# copy the zip to the expected location
cp database/build/distributions/dbmake-26.0.0.0.99999999999999.zip ../../dbcomparison/git/dbcomparison/downloads/

# Go to dbcomparison folder
cd ../../dbcomparison/git/dbcomparison

# ensure the proxy is not set, will cause issues in sqlplus
source ~/unset_proxy.sh

# run the comparison
./gradlew \
    -PdisableRunScripts=false \
    -PpdbAdminPassword=system \
    -PoracleAdminPassword=system \
    -PmssqlAdminPassword=system\!SA3 \
    compareDatabasesOracle \
    --rerun-tasks


