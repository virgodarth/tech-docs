# How to Backup And Restore MySQL database
## Reuqirement
- Database names [optional]
- User/ Password
- Host:Port
```
MYSQL_DBS=
MYSQL_USER="virgodarth"
MYSQL_PWD="virgopwd"
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
```

## Prepair
- Create backup directory
```
BACKUPS_DIRECTORY="${HOME}/bakdir"
```

## Create Backup
0. Connection to remote servers use TCP/IP.
This command connects to the server running on *host* using *port* with account *username/password*.
Example: 
- mysql --username *virgodarth* --password *virgopwd_or_empty* --host *virgodarth.com* --port *3306*  # 3306 is mysql default port, it can be changed
or
- mysql -u *virgodarth* -p *virgopwd* -h *virgodarth.com* -P *3306*

1. [Optional] Read database names which has in MySql. This command will get all database names which exists in schema.
```
MYSQL_DBS=$(mysql --username *virgodarth* --password *virgopwd_or_empty* --host *virgodarth.com* --port *3306*  -ANe "select schema_name from information_schema.schemata where schema_name not in ('information_schema', 'mysql', 'performance_schema', 'sys');"|awk '{ print $1 }')
``
Params:
- A (-A, --no-auto-rehash): No automatic rehashing. One has to use 'rehash' to get table and field completion. This gives a quicker start of mysql and disables rehashing on reconnect.
- N (-N, --skip-column-names): Don't write column names in results.
- e (-e, --execute=name): Execute command and quit. (Disables --force and history file.)
- "select schema_name from information_schema.schemata where schema_name not in ('information_schema', 'mysql', 'performance_schema', 'sys');": sql query used to get database name from schema
- awk: pattern scanning and processing language (linux command)

2. Backup Database Schema Structure
```
mysqldump --username *virgodarth* --password *virgopwd_or_empty* --host *virgodarth.com* --port *3306* --add-drop-database --no-data --databases ${MYSQL_DBS} > db_structure.sql
```
params:
- (--add-drop-database): Add a DROP DATABASE before each create.
- no-data (-d, --no-data): No row information.
- databases (-B, --databases): Dump several databases. Note the difference in usage; in
                      this case no tables are given. All name arguments are
                      regarded as database names. 'USE db_name;' will be
                      included in the output.

3. Backup Data
```
mysqldump --username *virgodarth* --password *virgopwd_or_empty* --host *virgodarth.com* --port *3306* --no-create-info --databases ${MYSQL_DBS} > db_data.sql
```
params:
- no-create-info: (-t, --no-create-info): Don't write table creation info.

## Restore
```
$mysql --username *virgodarth* --password *virgopwd_or_empty* --host *virgodarth.com* --port *3306* < db_structure.sql
$mysql --username *virgodarth* --password *virgopwd_or_empty* --host *virgodarth.com* --port *3306* < db_data.sql
```
