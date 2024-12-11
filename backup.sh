# SQL 백업하는 스크립트⇒ 경로가 raid구성한 디스크

#!/bin/bash

# 설정
DB_USER="root"
DB_PASSWORD="3433"
DB_NAME="userDB"
BACKUP_DIR="/mnt/sqlraid"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql"

# 백업 디렉토리 생성 (존재하지 않으면)
mkdir -p "${BACKUP_DIR}"

# 데이터베이스 백업 실행
mysqldump -u "${DB_USER}" -p"${DB_PASSWORD}" "${DB_NAME}" > "${BACKUP_FILE}"

# 백업 결과 확인
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: ${BACKUP_FILE}"
else
    echo "Backup failed!" >&2
    exit 1
fi