# Upgrading from the Ironwood Release
The recommended approach to upgrading an existing installation of the Open edX Ironwood release to the Juniper release is to make a fresh installation of the Juniper release on a new machine, and move your data and settings to it.

To move and upgrade your Ironwood data onto a Juniper installation, follow these steps.

1. Be sure that your Ironwood installation is on the latest commit from **open-release/ironwood.master**. This ensures that your database is fully migrated and ready for upgrade to Juniper.

2. Stop all services on the Ironwood machine.

3. Dump the data on the Ironwood machine. Here’s an example script that will dump the MySQL and Mongo databases into a single .tgz file. The script will prompt for the MySQL and Mongo passwords as needed.
```
#!/bin/bash
MYSQL_CONN="-uroot -p"
echo "Reading MySQL database names..."
mysql ${MYSQL_CONN} -ANe "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ('mysql','information_schema','performance_schema', 'sys')" > /tmp/db.txt
DBS="--databases $(cat /tmp/db.txt)"
NOW="$(date +%Y%m%dT%H%M%S)"
SQL_FILE="mysql-data-${NOW}.sql"
echo "Dumping MySQL structures..."
mysqldump ${MYSQL_CONN} --add-drop-database --skip-add-drop-table --no-data ${DBS} > ${SQL_FILE}
echo "Dumping MySQL data..."
# If there is table data you don't need, add --ignore-table=tablename
mysqldump ${MYSQL_CONN} --no-create-info ${DBS} >> ${SQL_FILE}

for db in edxapp cs_comments_service; do
    echo "Dumping Mongo db ${db}..."
    mongodump -u admin -p -h localhost --authenticationDatabase admin -d ${db} --out mongo-dump-${NOW}
done

tar -czf openedx-data-${NOW}.tgz ${SQL_FILE} mongo-dump-${NOW}
```

4. Copy the .tgz data file to the Juniper machine.

5. Stop all services on the Juniper machine.

6. Restore the Ironwood data into the Juniper machine. As an example, you might use the following commands.
```
$ tar -xvf openedx-data-20200411T154750.tgz
$ mysql -uroot -p < mysql-data-20200411T154750.sql
$ mongorestore -u admin -p -h localhost --authenticationDatabase admin --drop -d edxapp mongo-dump-20200411T154750/edxapp
$ mongorestore -u admin -p -h localhost --authenticationDatabase admin --drop -d cs_comment_service mongo-dump-20200411T154750/cs_comment_service_development
```

7. Run the Juniper migrations, which will update your Ironwood data to be valid for Juniper:

8. Copy your configuration files from the Ironwood machine to the Juniper machine.

9. Restart all services.

# Referer
- https://edx.readthedocs.io/projects/edx-installing-configuring-and-running/en/latest/platform_releases/juniper.html
