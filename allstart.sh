#!/bin/bash

# 스크립트 실행 로그
echo "Ubuntu에서 Node.js와 MySQL 최신 버전 설치를 시작합니다..."

# 패키지 목록 업데이트
echo "패키지 목록을 업데이트 중입니다..."
sudo apt update -y && sudo apt upgrade -y

# 필수 패키지 설치
echo "curl, gnupg 및 소프트웨어 필수 패키지 설치 중..."
sudo apt install -y curl software-properties-common gnupg lsb-release
#!/bin/bash

# Node.js 및 npm 설치 스크립트
echo "Node.js 및 npm 설치 중..."
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y "deb https://deb.nodesource.com/node_16.x $(lsb_release -sc) main"
sudo apt-get update
sudo apt install -y nodejs
sudo apt-get install npm

# 설치 확인
echo "설치 확인..."
echo "Node.js 버전: $(node -v)"
echo "npm 버전: $(npm -v)"

echo "Node.js 및 npm 설치 완료!"



# MySQL 최신 버전 설치
echo "MySQL 최신 버전 설치 중..."
wget https://dev.mysql.com/get/mysql-apt-config_0.8.26-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.26-1_all.deb
sudo apt update -y
sudo apt install -y mysql-server

# MySQL 서비스 상태 확인
echo "MySQL 서비스 상태 확인:"
sudo systemctl status mysql | grep "active (running)"

# MySQL 패스워드 정책 변경 (패스워드 정책을 LOW로 설정)
echo "MySQL 패스워드 정책을 LOW로 설정합니다..."
sudo mysql -e "SET GLOBAL validate_password.policy = LOW;"
sudo mysql -e "SET GLOBAL validate_password.length = 4;"

# MySQL root 비밀번호 및 인증 방식 설정
MYSQL_ROOT_PASSWORD="3433"
echo "MySQL root 비밀번호 및 인증 방식을 설정합니다..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"
# 권한 플러시
sudo mysql -e "FLUSH PRIVILEGES;"

# 추가 MySQL 사용자 인증 방식 업데이트 (optional, if needed for other users)
USER="root"  # 여기에 변경하려는 사용자의 이름을 입력
echo "MySQL 사용자 $USER의 인증 방식을 mysql_native_password로 업데이트합니다..."
sudo mysql -e "ALTER USER '$USER'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"
sudo mysql -e "FLUSH PRIVILEGES;"

# MySQL 서비스 상태 확인
echo "MySQL 서비스 상태 확인:"
sudo systemctl status mysql | grep "active (running)"

echo "MySQL 설치 및 root 계정 설정이 완료되었습니다."

# 실행할 파일 목록
SCRIPTS=("dbsetting.sh" "npm_install.sh")

# 각 스크립트를 순서대로 sudo 권한으로 실행
for script in "${SCRIPTS[@]}"; do
  if [ -f "$script" ]; then
    echo "실행 중: $script"
    sudo bash "$script"
  else
    echo "$script 파일이 존재하지 않습니다."
  fi
done

# 설치 완료 메시지
echo "Node.js와 MySQL 설치 및 추가 스크립트 실행이 완료되었습니다."

# backup.sh 실행 권한 부여
BACKUP_SCRIPT="backup.sh"
if [ -f "$BACKUP_SCRIPT" ]; then
  echo "$BACKUP_SCRIPT 파일에 실행 권한을 부여합니다..."
  chmod +x "$BACKUP_SCRIPT"
else
  echo "$BACKUP_SCRIPT 파일이 존재하지 않습니다. 실행 권한을 부여할 수 없습니다."
fi

# backup.sh를 주기적으로 실행하도록 cron에 추가
CRON_JOB="0 * * * * $(pwd)/$BACKUP_SCRIPT" # 매 시간 정각에 실행
echo "backup.sh를 cron에 추가합니다..."
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

# 추가된 cron job 확인
echo "현재 설정된 cron job:"
crontab -l

# Node.js 애플리케이션 실행
if [ -f "app.js" ]; then
  echo "Node.js 애플리케이션 실행 중..."
  node app.js
else
  echo "app.js 파일이 존재하지 않습니다. 애플리케이션을 실행할 수 없습니다."
fi
