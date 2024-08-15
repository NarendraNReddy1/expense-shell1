#!/bin/bash

#!/bin/bash
USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%M-%H-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
# echo "Enter DB password:ExpenseApp@1"
# read -s mysql_root_password

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

dnf module disable nodejs -y &>>LOG_FILE
VALIDATE $? "Disable nodejs"

dnf module enable nodejs:20 -y &>>LOG_FILE
VALIDATE $? "Enable nodejs"

dnf install nodejs -y &>>LOG_FILE
VALIDATE $? "Install nodejs"

id expense &>>LOG_FILE

if [ $? -eq 0 ]
then 
    echo "expense user already present"
else 
    useradd expense &>>LOG_FILE
    VALIDATE $? "useradd expense"
fi    

mkdir -p /app &>>LOG_FILE
rm -rf /app/* &>>LOG_FILE
VALIDATE $? "App directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>LOG_FILE
VALIDATE $? "Copy the backend code to temp"

cd /app &>>LOG_FILE
VALIDATE $? "Moved to App directory"

unzip /tmp/backend.zip &>>LOG_FILE
VALIDATE $? "backend temp"


