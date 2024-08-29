#!/bin/bash

source ./common.sh

check_root

echo "Enter DB password:ExpenseApp@1"
read -s mysql_root_password


dnf module disable nodejs -y &>>LOG_FILE
#VALIDATE $? "Disable nodejs"

dnf module enable nodejs:20 -y &>>LOG_FILE
#VALIDATE $? "Enable nodejs"

dnf install nodejs -y &>>LOG_FILE
#VALIDATE $? "Install nodejs"

id expense &>>LOG_FILE

if [ $? -eq 0 ]
then 
    echo -e "expense user already present $Y SKIPPING $N"
else 
    useradd expense &>>LOG_FILE
    #VALIDATE $? "useradd expense"
fi    

mkdir -p /app &>>LOG_FILE
rm -rf /app/* &>>LOG_FILE
#VALIDATE $? "App directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>LOG_FILE
#VALIDATE $? "Copy the backend code to temp"

cd /app &>>LOG_FILE
#VALIDATE $? "Moved to App directory"

unzip /tmp/backend.zip &>>LOG_FILE
#VALIDATE $? "backend temp"

npm install &>>LOG_FILE
#VALIDATE $? "npm install"


cp -rf /home/ec2-user/expense-shell1/backend.service /etc/systemd/system/backend.service &>>LOG_FILE
#VALIDATE $? "Backend service"

systemctl daemon-reload &>>LOG_FILE
#VALIDATE $? "daemon-reload"

systemctl start backend &>>LOG_FILE
#VALIDATE $? "start backend"

systemctl enable backend &>>LOG_FILE
#VALIDATE $? "enable backend"

dnf install mysql -y &>>LOG_FILE
#VALIDATE $? "install mysql"

mysql -h db.narendra.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>LOG_FILE
#VALIDATE $? "schema load"

systemctl restart backend &>>LOG_FILE
#VALIDATE $? "restart backend"






