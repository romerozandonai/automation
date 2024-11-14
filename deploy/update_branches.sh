#!/bin/bash

set +x

# execution: sh update_branches.sh -c COMPARE_BRANCH -t TARGET_BRANCH
# example: sh update_branches.sh -c develop -t release

log_date=$(date +'%Y-%m-%d_%H-%M-%S')
LOG="update_branches.log"

while getopts c:t: flag
do
    case "${flag}" in
        c) compare=${OPTARG};;
        t) target=${OPTARG};;
    esac
done

echo "######################";
echo "Branch parameters";
echo "Compare: $compare";
echo "Target: $target";
echo "######################";
echo "Merge operation on SG3: $compare->$target";


###### SG3 ######
# enter directory
echo "Enter directory";
# ajustar de acordo com a máquina que for executar
cd ../../www/sg3 
pwd

# get all the updates from all the branches
echo "Fetching origin branches";
git fetch origin

# enter the branch who is gonna use on the merge
echo "Checkout compare branch: $compare";
git checkout $compare

# put the compare to the state that is on the origin repository
echo "Reset local compare branch to the origin repository state";
git reset --hard origin/$compare

# enter the branch who is gonna receive the merge
echo "Checkout target branch: $target";
git checkout $target

# put the target to the state that is on the origin repository
echo "Reset local target branch to the origin repository state";
git reset --hard origin/$target

# execute the merge with no fast forward method
echo "Executing merge with no fast forward method on $compare->$target";
git merge $compare --no-ff

# push the target branch
echo "Push the merge to the target branch";
git push origin $target

echo "######################";
echo "Merge operation on SG3 API: $compare->$target";

###### SG3 API ######
cd ../sg3_api
pwd

# get all the updates from all the branches
echo "Fetching origin branches";
git fetch origin

# enter the branch who is gonna use on the merge
echo "Checkout compare branch: $compare";
git checkout $compare

# put the compare to the state that is on the origin repository
echo "Reset local compare branch to the origin repository state";
git reset --hard origin/$compare

# enter the branch who is gonna receive the merge
echo "Checkout target branch: $target";
git checkout $target

# put the target to the state that is on the origin repository
echo "Reset local target branch to the origin repository state";
git reset --hard origin/$target

# execute the merge with no fast forward method
echo "Executing merge with no fast forward method on $compare->$target";
git merge $compare --no-ff

# push the target branch
echo "Push the merge to the target branch";
git push origin $target


###### STEPS ######

# git fetch origin -> get all the updates from all the branches
# git checkout COMPARE_BRANCH -> enter the branch who is gonna use on the merge
# git reset --hard origin/COMPARE_BRANCH -> put the COMPARE_BRANCH to the state that is on the origin repository
# git checkout TARGET_BRANCH -> enter the branch who is gonna receive the merge
# git reset --hard origin/TARGET_BRANCH -> put the TARGET_BRANCH to the state that is on the origin repository
# git merge COMPARE_BRANCH --no-ff -> execute the merge with no fast forward method