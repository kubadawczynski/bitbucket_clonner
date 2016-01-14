#!/bin/bash
#Script to get all repositories under a team from bitbucket
LOGIN_CLOUD=$1
TEAM_NAME=$2 
SERVER_TO=$3
PROJECT=$4

createRepo(){
curl -u admin_user:admin_pass -H "Content-Type: application/json"  -X POST  http://$SERVER_TO:7990/rest/api/1.0/projects/OB/repos -d '{ "name":"'$1'","scmId":"git","forkable":true }'
}

cloneRepo(){
for repo_name in `curl -u ${1}  'https://api.bitbucket.org/2.0/repositories/'$TEAM_NAME''  | awk -F':|}|,' '{ for (x=1;x<=NF;x++) if ($x~"\"clone\"") print $(x+9) }'| sed 's/"//g'`
do
	echo "$repo_name"
	git clone --mirror  ssh:$repo_name  &>/dev/null
	repo_name=$(echo $repo_name | grep -Eo '[^/]+/?$' | cut -d / -f1 | sed 's/\.git//g')
	cd  ''$repo_name'.git'
 	pwd	
	createRepo "$repo_name"
	git push --mirror 'ssh://git@'$SERVER_TO':7999/'$PROJECT'/'$repo_name''
	cd ..
	rm -rf ''$repo_name'.git'
done
}

cloneRepo $LOGIN_CLOUD


