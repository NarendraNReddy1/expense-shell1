#!/bin/bash

source ./common.sh 

check_root

echo "Enter DB password:ExpenseApp@1"
read -s mysql_root_password

dnf install mysql-server -y &>>LOG_FILE
#VALIDATE $? "Instllation of mysql-server"

systemctl enable mysqld &>>LOG_FILE
#VALIDATE $? "enable mysqld"

systemctl start mysqld &>>LOG_FILE
#VALIDATE $? "start mysqld"


mysql -h db.narendra.shop -uroot -p${mysql_root_password} -e "show databases" &>>LOG_FILE


if [ $? -eq 0 ]
then 
    echo -e "Password already set $Y SKIPPING $N"
else 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>LOG_FILE
    #VALIDATE $? "Setting password mysqld"

fi

