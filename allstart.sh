#!/bin/bash

# 스크립트 실행 로그
echo "Ubuntu에서 Node.js와 MySQL 설치를 시작합니다..."

# 패키지 목록 업데이트
echo "패키지 목록을 업데이트 중입니다..."
sudo apt update -y
sudo apt-get upgrade -y

# 필수 패키지 설치
echo "curl과 software-properties-common 설치 중..."
sudo apt install -y curl software-properties-common gnupg

# Node.js 설치
echo "Node.js 설치 중..."
sudo apt-get install -y nodejs

# npm 최신 버전으로 업데이트
echo "npm 최신 버전으로 업데이트 중..."
sudo npm install -g npm@latest

# Node.js 설치 확인
echo "Node.js 버전 확인:"
node -v
echo "npm 버전 확인:"
npm -v


# MySQL 설치
echo "MySQL 설치 중..."
sudo apt install -y mysql-server

# MySQL 설치 확인
echo "MySQL 서비스 상태 확인:"
sudo systemctl status mysql | grep "active (running)"

# MySQL 보안 설정
echo "MySQL 보안 설정을 수행합니다..."
sudo mysql_secure_installation

# MySQL root 비밀번호 설정
echo "MySQL root 비밀번호를 설정합니다..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '3433';"

# 권한 플러시
sudo mysql -e "FLUSH PRIVILEGES;"

# MySQL 서비스 상태 확인
echo "MySQL 서비스 상태 확인:"
sudo systemctl status mysql | grep "active (running)"

echo "MySQL 설치 및 root 계정 설정이 완료되었습니다."

# 설치 완료 메시지
echo "Node.js와 MySQL 설치가 완료되었습니다."

# 실행할 파일 목록
SCRIPTS=("dbsetting.sh" "npm_install.sh")

# 각 스크립트를 순서대로 sudo 권한으로 실행
for script in "${SCRIPTS[@]}"; do
  sudo ./"$script"
done

# 설치 완료 메시지지
echo "db & npm 패키지 설치가 완료 되었습니다"

# Node.js 애플리케이션 실행
echo "Node.js 애플리케이션 실행 중..."
node app.js