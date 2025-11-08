#!/bin/bash
work_dir="/home/viaguila/dev/current/git/xstore/data2/test-db/expected/db/mssql/"
dest_dir="/home/viaguila/dev/current/git/xstore/dtx/build/dtxGeneration/scripts/db/mssql/"
schema_name=xstore_25_223

# make a copy of the file
cp -r $work_dir/db-upgrade.sql $dest_dir/db-upgrade_edited.sql
echo "Copy file from [$work_dir/db-upgrade.sql] in to [$dest_dir/db-upgrade_edited.sql]"

# Run the SQL script
sqlcmd -r 1 -V 1 -C -S localhost -Usa -P'system!SA3' -d $schema_name -i "$dest_dir/db-upgrade_edited.sql" -o $dest_dir/result.log
echo "query executed, result at [$dest_dir/result.log], exiting..."
