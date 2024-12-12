#!/bin/bash

# npm 패키지들 설치치
echo "필요 npm 패키지들 설치"
for i in express mysql2 bcrypt express-session body-parser mysql cors; do npm install $i; done

# 설치 완료 메시지
echo "npm 패키지 설치 완료"