#!/bin/bash
USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%M-%H-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


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

cp -rf /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>LOG_FILE
VALIDATE $? "Copy code"

systemctl restart nginx &>>LOG_FILE
VALIDATE $? "start nginx"

