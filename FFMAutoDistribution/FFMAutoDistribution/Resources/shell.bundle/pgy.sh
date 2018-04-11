#!/bin/bash

# 流程控制代码
function exitControl() {
	if [ $? -eq 0 ]; then  
		echo "------------------------ $1 ------------------------" 
	else
		echo "------------------------ $2 ------------------------" 
		exit $3
	fi
}

# git 推送内部版本号改动
function pushBundleVersionModification() {
    local git="/usr/bin/git"

	$git add .
	$git commit -m "build $bundle_version"
	$git push origin

	$git checkout master
	$git branch -D $branch
	$git branch
}

# 解析json
function parse_json() {
    local code=$(awk -F ',"message":' '{print $1}' $1 | awk -F '{"code":' '{print $2}')
    if [[ $code -eq "0" ]]; then
        echo "------------------------ 发布成功 ------------------------" 
        # grep --color "appShortcutUrl" $1
        local api=$(awk -F 'appShortcutUrl":"' '{print $2}' $1 | awk -F '",' '{print $1}')
        local build_number=$(awk -F 'appBuildVersion":"' '{print $2}' $1 | awk -F '",' '{print $1}')
        echo "##############################################################" 
        echo "https://www.pgyer.com/$api"
        echo "${short_version} (build $build_number) (${bundle_version} ${build_config})"
        local IFS_tmp=$IFS
        IFS=$'\n'
        local content
        for content in $change_log
        do
        echo $content
        done
        IFS=$IFS_tmp
        echo "##############################################################" 
    else
    	error_exit "------------------------ 发布失败 ------------------------" 999
    fi
}

# 上传到蒲公英
function uploadToPgy() {
    local temp_path="$local_repo/temp/"
    createFolderIfNotExist $temp_path
    local upload_response="$temp_path/uploadResponse"

    local pgy_upload_url="https://qiniu-storage.pgyer.com/apiv1/app/upload"
	echo "------------------------ 开始发布 ------------------------" 
	curl --progress-bar -F "file=@${ipa_path}" \
    -F "uKey=${pgy_uk}" \
    -F "_api_key=${pgy_ak}" \
    -F "updateDescription=${change_log}" \
    $pgy_upload_url > "${upload_response}" || error_exit "------------------------ 上传ipa失败 ------------------------" 998

    parse_json "${upload_response}"
}

######## START ########

change_log=$9

pgy_ak=${10}
pgy_uk=${11}

source "$(cd $(dirname $0); pwd)/packing.sh" $1 $2 $3 $4 $5 $6 $7 $8

uploadToPgy

pushBundleVersionModification

