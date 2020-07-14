#!/bin/sh

date_with_time=`date "+%m-%d-%Y-%H-%M-%S"`

ssh_key_name="github-$date_with_time"

ssh_key_output_file="$HOME/.ssh/$ssh_key_name"

read -p 'Enter your email address: ' email

ssh-keygen -t rsa -b 4096 -C $email -f $ssh_key_output_file

echo 'New SSH key generation successfully finished.'

eval "$(ssh-agent -s)"

echo 'Started the ssh-agent in the background.'

ssh-add $ssh_key_output_file

echo 'Added the SSH private key to the ssh-agent.'

read -p 'Enter your personal access token with write:public_key scope: ' personal_access_token

echo 'Adding the SSH key to your GitHub account...'

ssh_public_key=`cat $ssh_key_output_file.pub`

curl -d "{ \"title\": \"$ssh_key_name\", \"key\": \"$ssh_public_key\" }" \
     -H "Authorization: token $personal_access_token" \
     -H 'Content-Type: application/json' \
     https://api.github.com/user/keys \
     > /dev/null

echo 'SSH key succesfully added to your GitHub account.'
