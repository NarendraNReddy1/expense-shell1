#!/bin/bash

source ./common.sh 

check_root

dnf install nginx -y &>>LOG_FILE
VALIDATE $? "Install nginx"

systemctl enable nginx &>>LOG_FILE
VALIDATE $? "Enable nginx"

systemctl start nginx &>>LOG_FILE
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>LOG_FILE
VALIDATE $? "start nginx"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>LOG_FILE
VALIDATE $? "start nginx"

cd /usr/share/nginx/html &>>LOG_FILE
VALIDATE $? "Moved to HTML"

unzip /tmp/frontend.zip &>>LOG_FILE
VALIDATE $? "Unzip the code"

cp -rf /home/ec2-user/expense-shell1/expense.conf /etc/nginx/default.d/expense.conf &>>LOG_FILE
VALIDATE $? "Copy code"

systemctl restart nginx &>>LOG_FILE
VALIDATE $? "start nginx"

