#!/bin/bash
work_dir="/home/viaguila/dev/current/git/xstore/data2/test-db/expected/db/oracle"
dest_dir="/home/viaguila/dev/current/git/xstore/dtx/build/dtxGeneration/scripts/db/oracle/"
  
# make a copy of the file
cp -r $work_dir/db-upgrade.sql $dest_dir/db-upgrade_edited.sql
echo "Copy file from [$work_dir/db-upgrade.sql] in to [$dest_dir/db-upgrade_edited.sql]"
  
# Replace placeholders in the SQL file
perl -pi -e 's/\$\(DbTblspace\)/xstore_25_223/g' $dest_dir/db-upgrade_edited.sql
  
perl -pi -e 's/\$\(DbSchema\)/dtv/g' $dest_dir/db-upgrade_edited.sql

perl -pi -e 's/\$\(DbParallel\)//g' $dest_dir/db-upgrade_edited.sql

echo "variables placeholders replaced"
  
# Ensure replaced
# grep -E "\\$\\(" $dest_dir/db-upgrade_edited.sql
  
# Run the SQL script
echo exit | sqlplus dtv/dtv@localhost/xstore_25_223 @$dest_dir/db-upgrade_edited.sql > $dest_dir/result.log
echo "query executed, result at [$dest_dir/result.log], exiting..."
