#!/bin/bash

#######################################################################
thereislambda(){
  aws lambda list-functions | jq '.Functions[].FunctionName' | grep $1
}

createlambda(){
  sleep 3
  FUNCTION_NAME="$1"
  RUNTIME="nodejs14.x"
  ROLE=""

  HANDLER="lambda/$FUNCTION_NAME/index.handler"
  ZIPFILE="fileb://$FUNCTION_NAME.zip"
  SUBNETS="SubnetIds=xxxx,zzz,yyy,SecurityGroupIds=bbb"
  echo -e "\nThere is no Lambda called: $FUNCTION_NAME"
  # nohup zip -r $FUNCTION_NAME $FUNCTION_NAME
      echo -e "\nCreating Lambda $FUNCTION_NAME\n"
  aws lambda create-function --function-name $FUNCTION_NAME --role $ROLE --runtime $RUNTIME --zip-file $ZIPFILE --handler $HANDLER  --memory-size 256 --output json  --vpc-config $SUBNETS --no-paginate
  echo $1 >> created.txt
}

updatelambda(){
  sleep 3
  FUNCTION_NAME=$1
  ZIPFILE="fileb://$FUNCTION_NAME.zip"
  echo -e "\nUpdating Lambda Source"
  # nohup zip -r $FUNCTION_NAME $FUNCTION_NAME
  aws lambda update-function-code  --function-name  $FUNCTION_NAME --zip-file $ZIPFILE --output json --no-paginate
  echo $FUNCTION_NAME >> updated.txt
}

#read line by line lambdas.txt
#verify if functions exist or not
#execute commands to create, delete or update function

if [ -e "lambdas.txt" ] ; then
  while IFS= read -r linha || [[ -n "$linha" ]]; do
    
    thereislambda $linha
    if [[ $? -eq 0 ]]
    then
      echo -e "\nLambda $linha found"
      if [[ $? -eq 0 ]]
      then 
        updatelambda $linha
      fi
    else
      createlambda $linha 
      if [[ $? -eq 0 ]]
        then
          echo -e "\nLambda $linha created"
          echo -e "\n#########################"
        else
          echo -e "Error creating Lambda: $linha"
      fi
    fi
  done < "lambdas.txt"
fi