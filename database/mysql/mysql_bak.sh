#!/bin/bash
#---------------------------------------------------------
# written by: Virgo Darth
#
# created date: May 18, 2020
# created date: June 4, 2020
#
# usage: backup MySQL data
#---------------------------------------------------------

#===================================== Default config ===================================
# MYSQL Database Account
MYSQL_DBS=
MYSQL_USER="virgodarth"
MYSQL_PWD="virgopwd"
MYSQL_HOST="localhost"
MYSQL_PORT="3306"

# backup directory path
BACKUPS_DIRECTORY="${HOME}/bakdir"
WORKING_DIRECTORY="${HOME}/workdir"

# other
BACKUP_PREFIX="virgodarth"

echo "============================ Start Backup Database -- $(date +%y%m%dT%H%M%S) ==============================="

#================================== Check Work directory ==============================
# check to see if a working folder exists. if not, create it
if [ ! -d ${WORKING_DIRECTORY} ]; then
mkdir -p ${WORKING_DIRECTORY}
echo "created backup working folder ${WORKING_DIRECTORY}"
fi

# check to see if anything is currently in the working folder. if so, delete it all
if [ -f "$WORKING_DIRECTORY/*" ]; then
sudo rm -r $WORKING_DIRECTORY
fi

# check to see if a backups/ folder exists. if not, create
if [ ! -d ${BACKUPS_DIRECTORY} ]; then
mkdir -p ${BACKUPS_DIRECTORY}
echo "created backup folder ${BACKUPS_DIRECTORY}"
fi


#=============================== Backup Database =======================================
NOW="$(date +%y%m%dT%H%M%S)"

MYSQL_BACKUP_DIR="${BACKUP_PREFIX}_mysql_${NOW}"
mkdir ${MYSQL_BACKUP_DIR}

# MySQL Backup
MYSQL_CONN="-u${MYSQL_USER} -p${MYSQL_PWD}"
echo "Backing up MySQL databases"
echo "Reading MySQL database names..."
if [ -z ${MYSQL_DBS} ]; then
MYSQL_DBS=$(mysql ${MYSQL_CONN} -ANe "select schema_name from information_schema.schemata where schema_name not in ('information_schema', 'mysql', 'performance_schema', 'sys');"|awk '{ print $1 }')
fi
echo "Dumping MySQL structure..."
SQL_FILE="${MYSQL_BACKUP_DIR}/mysql_structure_${NOW}.sql"
mysqldump ${MYSQL_CONN} --add-drop-database --no-data --databases ${MYSQL_DBS} > ${SQL_FILE}
echo "Dumping MySQL data..."
SQL_FILE="${MYSQL_BACKUP_DIR}/mysql_data_${NOW}.sql"
mysqldump ${MYSQL_CONN} --no-create-info --databases ${MYSQL_DBS} > ${SQL_FILE}
echo "Completed! MySQL backed up."


echo "============================ End Backup Database -- $(date +%y%m%dT%H%M%S) ==============================="