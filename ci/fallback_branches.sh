#!/bin/bash

# author: Bruno Romero Costa Zandonai
# version: 1.0.1
# date: 14/11/2024
# description: update all branches, with the compare branch set up to 'master'
# use case: after the release
# execution: sh fallback_branches.sh
# example: sh fallback_branches.sh
# TO.DO(bruno.zandonai): implement logs
#   log_date=$(date +'%Y-%m-%d_%H-%M-%S')
#   LOG="update_branches.log"

set +x


echo "######################";
echo "Branch parameters";
echo "Compare: master";
echo "Target: preprod, release, develop";
echo "######################";
echo "Merge operation on SG3: master->$target";

## declare an array variable
declare -a arr=("preprod" "release" "develop")

###### SG3 ######
# enter directory
echo "Enter directory";
# ajustar de acordo com a máquina que for executar
cd ../../www/sg3 
pwd

# get all the updates from all the branches
echo "Fetching origin branches";
#git fetch origin

# enter the branch who is gonna use on the merge
echo "Checkout compare branch: master";
#git checkout master

# put the compare to the state that is on the origin repository
echo "Reset local compare branch to the origin repository state";
#git reset --hard origin/master

for branch in "${arr[@]}"
do
    echo "$branch"
    
    # enter the branch who is gonna receive the merge
    echo "Checkout target branch: $branch";
    #git checkout $branch
    
    # put the target to the state that is on the origin repository
    echo "Reset local target branch to the origin repository state";
    #git reset --hard origin/$branch

    # execute the merge with no fast forward method
    echo "Executing merge with no fast forward method on master->$branch";
    #git merge $branch --no-ff

    # push the target branch
    echo "Push the merge to the target branch";
    #git push origin $branch

done


echo "######################";
echo "Merge operation on SG3 API: master->$branch";


###### SG3 API ######
cd ../sg3_api
pwd

# get all the updates from all the branches
echo "Fetching origin branches";
#git fetch origin

# enter the branch who is gonna use on the merge
echo "Checkout compare branch: master";
#git checkout master

# put the compare to the state that is on the origin repository
echo "Reset local compare branch to the origin repository state";
#git reset --hard origin/master

for branch in "${arr[@]}"
do
    echo "$branch"
    
    # enter the branch who is gonna receive the merge
    echo "Checkout target branch: $branch";
    #git checkout $branch
    
    # put the target to the state that is on the origin repository
    echo "Reset local target branch to the origin repository state";
    #git reset --hard origin/$branch

    # execute the merge with no fast forward method
    echo "Executing merge with no fast forward method on master->$branch";
    #git merge $branch --no-ff

    # push the target branch
    echo "Push the merge to the target branch";
    #git push origin $branch

done

###### STEPS ######

# git fetch origin -> get all the updates from all the branches
# git checkout COMPARE_BRANCH -> enter the branch who is gonna use on the merge
# git reset --hard origin/COMPARE_BRANCH -> put the COMPARE_BRANCH to the state that is on the origin repository
# git checkout TARGET_BRANCH -> enter the branch who is gonna receive the merge
# git reset --hard origin/TARGET_BRANCH -> put the TARGET_BRANCH to the state that is on the origin repository
# git merge COMPARE_BRANCH --no-ff -> execute the merge with no fast forward method