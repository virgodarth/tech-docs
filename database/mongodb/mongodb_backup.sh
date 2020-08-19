#!/bin/bash
#---------------------------------------------------------
# written by: Virgo Darth
#
# date: May 18, 2020
#
# usage: backup MySQL and MongoDB data stores
# compress into a single tarball and sync to AWS S3
#---------------------------------------------------------

#===================================== Default config ===================================
# MongoDB Database Account (write available)
MONGODB_DBS=(mongodb) # list of databases, separate by comma
MONGODB_USER="mongodb"
MONGODB_PWD="mongodb-pwd"
MONGODB_HOST="localhost"
MONGODB_PORT="27017"

# backup directory path
BACKUPS_DIRECTORY="${HOME}/bakdir"
WORKING_DIRECTORY="${HOME}/workdir"

# other
BACKUP_PREFIX="goamazing"
CURRENT_DIR="${PWD}"

#=============================== Set up log directory =================================
# check to see if a log directory exists. if not, create
# if [ ! -d ${LOG_DIRECTORY} ]; then
# mkdir -p ${LOG_DIRECTORY}
# echo "created log folder ${LOG_DIRECTORY}"
# fi

# LOG_FILE="${LOG_DIRECTORY}/mongodb-bak.log"
# if [ -f ${LOG_FILE} ]; then
# log_file_size=$(stat -c%s ${LOG_FILE})
# if (( $MAX_LOG_SIZE < $log_file_size )); then
# mv ${LOG_FILE} "$(date +%y%m%dT%H%M%S).${LOG_FILE}"
# touch ${LOG_FILE}
# fi
# else
# touch ${LOG_FILE}
# fi

echo "============================ Start Backup Database -- $(date +%y%m%dT%H%M%S) ==============================="

#================================== Check Work directory ==============================
# check to see if a backups/ folder exists. if not, create
if [ ! -d ${BACKUPS_DIRECTORY} ]; then
    mkdir -p ${BACKUPS_DIRECTORY}
    echo "created backup folder ${BACKUPS_DIRECTORY}"
fi

# move to work dir
cd ${WORKING_DIRECTORY}


#=============================== Backup Database =======================================
NOW="$(date +%y%m%dT%H%M%S)"
MONGODB_BACKUP_DIR="${BACKUP_PREFIX}_mongodb_${NOW}"
mkdir ${MONGODB_BACKUP_DIR}
echo "Backing up MongoDB databases"
echo "Reading MySQL database names..."
for db in ${MONGODB_DBS[@]}; do
    echo "Dumping MongoDB ${db}..."
    mongodump --quiet --username ${MONGODB_USER} --password ${MONGODB_PWD} --host ${MONGODB_HOST} --port $MONGODB_PORT --authenticationDatabase ${MONGODB_USER} -d ${db} --out "${MONGODB_BACKUP_DIR}"
done
echo "Completed! MongoDB backed up."

echo "============================ End Backup Database -- $(date +%y%m%dT%H%M%S) ==============================="