#!/bin/bash
#Script to get all repositories under a user from remote bitbucket to private bitbucket server
LOGIN_CLOUD=$1
SERVER_TO=$2
PROJECT=$3


createRepo(){
curl -u admin_user:admin_pass -H "Content-Type: application/json"  -X POST  http://$SERVER_TO:7990/rest/api/1.0/projects/$PROJECT/repos -d '{ "name":"'$1'","scmId":"git","forkable":true }'
}

cloneRepo(){
for repo_name in `curl -u ${1}  https://api.bitbucket.org/1.0/users/${1} | awk -F':|}|,' '{ for (x=1;x<=NF;x++) if ($x~"\"slug\"") print $(x+1) }'| sed 's/"//g' `
do
	echo "$repo_name"
	git clone --mirror  ssh://git@bitbucket.org/${1}/$repo_name &>/dev/null
	cd  ''$repo_name'.git'
 	pwd	
	createRepo "$repo_name"
	git push --mirror 'ssh://git@'$SERVER_TO':7999/'$PROJECT'/'$repo_name'.git'
	cd ..
	rm -rf ''$repo_name'.git'
done
}

cloneRepo $LOGIN_CLOUD


