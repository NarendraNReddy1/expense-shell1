#!/bin/bash
USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%M-%H-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
echo "Enter DB password:ExpenseApp@1"
read -s mysql_root_password

VALIDATE()
{
    if [ $1 -ne 0 ]
    then
        echo -e "$2 $R $FAILURE $N"
    else 
        echo -e "$2 $G SUCCESS $N"


    fi
}




if [ $USER_ID -ne 0 ]
then
    echo "Please be a super user"
    exit 1
else 
    echo "You are super user"
fi



dnf install mysql-server -y &>>LOG_FILE
VALIDATE $? "Instllation of mysql-server"

systemctl enable mysqld &>>LOG_FILE
VALIDATE $? "enable mysqld"

systemctl start mysqld &>>LOG_FILE
VALIDATE $? "start mysqld"


mysql -h db.narendra.shop -uroot -p${mysql_root_password} -e "Sshow databases" &>>LOG_FILE

if [ $? -eq 0 ]
then 
    echo "Password already set $Y SKIPPING $N"
else 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>LOG_FILE
    VALIDATE $? "start mysqld"

fi

