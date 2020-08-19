# How to Backup And Restore MongoDB  database
## Reuqirement
- Database names [optional]
- User/ Password
- Host:Port
```
MONGODB_DB="virgodb" # database name
MONGODB_USER="virgodarth"
MONGODB_PWD="virgopwd"
MONGODB_HOST="virgodarth.com"
MONGODB_PORT="27017"
```

## Prepair
- Create backup directory
```
BACKUPS_DIRECTORY="${HOME}/bakdir"
```

## Action
0. Connection to remote servers use TCP/IP.
This command connects to the server running on *host* using *port* with account *username/password*.
Example: mongo --username *virgodarth* --password *virgopwd_or_empty* --host *virgodarth.com* --port *27017*  # 27017 is mongodb default port, it can be changed

1. Backup Database
```
mongodump --quiet --username ${MONGODB_USER} --password ${MONGODB_PWD} --host ${MONGODB_HOST} --port $MONGODB_PORT --authenticationDatabase ${MONGODB_USER} -d ${MONGODB_DB} --out "${MONGODB_BACKUP_DIR}"
```
params:
- quite: hide all log output
- authenticationDatabase (--authenticationDatabase=<database-name>): database that holds the user's credentials
- d (-d, --db=<database-name>): database to use
- o (-o, --out=<directory-path>): output directory, or '-' for stdout (defaults to 'dump')

2. Restore Data
```
mongorestore --username *virgodarth* --password *virgopwd_or_empty* --host *virgodarth.com* --port *27017* --authenticationDatabase ${MONGODB_USER} --drop -d ${MONGODB_DB} ${MONGODB_BACKUP_DIR}
```
params:
- drop (--drop): drop each collection before import
