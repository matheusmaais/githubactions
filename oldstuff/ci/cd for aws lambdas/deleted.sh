rm -f deleted.txt tempmodified.txt


###########################################################
#         Parse string list from github actions           #
###########################################################

#get the string returned from github and turns to array
deleted=$1
read -a myarray <<< $deleted

#if the index have source/lambda prefix, get only the folder name and add to a deleted.txt list file
for i in ${myarray[@]}; do
  if [[ $i =~ "source/lambda/" ]]; then
    echo $i | cut -d '/' -f 3 >> tempmodified.txt
  fi
done
#uniq remove duplicate entries if exists
if [ -e "tempmodified.txt" ] ; then
  uniq tempmodified.txt >> deleted.txt
fi



###########################################################
#                Delete Lambda                            # 
###########################################################
thereislambda(){
  aws lambda list-functions | jq '.Functions[].FunctionName' | grep $1
}

deletelambda(){
  FUNCTION_NAME=$1
  echo -e "Deleting Lambda $FUNCTION_NAME"
  nohup aws lambda delete-function --function-name $FUNCTION_NAME
  echo $FUNCTION_NAME >> deleted.txt
}


if [ -e "deleted.txt" ] ; then
  while IFS= read -r linha || [[ -n "$linha" ]]; do
    thereislambda $linha
    if [[ $? -eq 0 ]]
    then
      echo -e "\nLambda $linha found"
      echo $PWD
      ls "source/lambda/$linha"
      if [[ $? -ne 0 ]]
      then 
        deletelambda $linha
      fi
    fi
  done < "deleted.txt"
fi