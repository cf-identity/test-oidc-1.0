#!/bin/bash
git submodule sync
git submodule foreach --recursive "git submodule sync; git clean -d --force --force"
git submodule update --init --recursive --force

cd uaa
./gradlew clean assemble

cd ..

WAR_PATH=`find $PWD/uaa/uaa/build/libs/ -name '*.war'`
echo $WAR_PATH

cf api --skip-ssl-validation https://api.uaa-acceptance.cf-app.com
cf login -o system -s openid-connect-server -u admin
cf push -f manifest-gcp.yml -p $WAR_PATH
