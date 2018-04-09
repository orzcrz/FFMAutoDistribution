#!/bin/bash

function error_exit() {
    echo "$1" 1>&2
    exit $2
}

# 文件夹不存在则创建
function createFolderIfNotExist() {
    if [[ ! -x "$1" ]]; then
        mkdir -p "$1" || error_exit "------------------------ 创建文件夹失败 ------------------------" 30
    fi
}

function checkoutCodeFromGitLab() {
    local git="/usr/bin/git"
    if [[ ! -d "$git_folder" ]] && [[ ! -d "$git_folder/.git" ]]; then
        echo "--------- 首次使用脚本，将会从gitlab克隆项目，需要等待10-15分钟 ---------"
        $git clone --progress $remote_repo $git_folder
    fi
	cd $git_folder
	$git checkout master
	$git branch -D $branch_name
	$git fetch && $git checkout -b $branch_name origin/$branch_name
	$git branch
	echo "----------------------- 切换至分支 $branch -----------------------"
}

function podInstall() {
    cd $project_path

    export LC_ALL="en_US.UTF-8"
    /usr/local/bin/pod install --no-repo-update

}

function initProjectBuildConfigure() {    

    project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
    local project_plist="${project_path}/${project_name}/SupportingFiles/Info.plist"
    local extension_notification_plist="${project_path}/NotificationService/Info.plist"

    short_version=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_plist}")
    local pre_bundle_version=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_plist}")

    output_path="${backup_path}/${short_version}/$project_name $(date "+%Y-%m-%d %H-%M-%S")"
    createFolderIfNotExist "$output_path"
	ipa_path="${output_path}/${project_name}.ipa"

    bundle_version=$(echo $(date "+%m%d.%H%M") | sed s'/^0//')

    /usr/libexec/PlistBuddy -c "set CFBundleVersion ${bundle_version}" ${project_plist}
    /usr/libexec/PlistBuddy -c "set CFBundleVersion ${bundle_version}" ${extension_notification_plist}

    echo "------------------------ 项目信息汇总 ------------------------"
    echo "签名方式 : $sign_mode"
    echo "编译方式 : $build_config"
    echo "工程路径 : $project_path"
    echo "工程名 : $project_name"
    echo "线上版本号 : $short_version"
    echo "原内部版本号 : $pre_bundle_version"
    echo "修改后的内部版本号 : $bundle_version"
    echo "--------------------------------------------------------------"

}

function building() {
	local build_path="${project_path}/build"
	echo "------------------------ 删除bulid目录 ------------------------"
	if [ -d ${build_path} ];then
		rm -rf ${build_path} || error_exit "------------------------ 删除bulid目录失败 ------------------------" 32
		echo "已删除目录${build_path}" 
	fi

	echo "------------------------ 开始构建... ------------------------"
	set -o pipefail && xcodebuild clean \
	archive \
	-workspace $project_name.xcworkspace \
    -scheme $project_name \
    -configuration "$build_config" \
    -allowProvisioningUpdates \
	-archivePath "${build_path}/${project_name}.xcarchive" \
    | /usr/local/bin/xcpretty \
	&& echo "------------------------ 构建成功 ------------------------" \
	|| error_exit "------------------------ 构建失败 ------------------------" 777 

	echo "------------------------ 正在导出ipa包... ------------------------" 
	set -o pipefail && xcodebuild -exportArchive \
	-archivePath "${build_path}/${project_name}.xcarchive" \
	-exportOptionsPlist "$plist_path" \
	-exportPath "${build_path}" \
	-allowProvisioningUpdates \
    | /usr/local/bin/xcpretty \
	&& echo "------------------------ 导出ipa成功 ------------------------" \
	|| error_exit "------------------------ 导出ipa失败 ------------------------" 888

	echo "------------------------ 复制到$output_path ------------------------" 
	cp -f -p ${build_path}/${project_name}.ipa "${ipa_path}" || error_exit "------------------------ 复制生成文件失败 ------------------------" 33
	cp -f -p -r ${build_path}/${project_name}.xcarchive "${output_path}/${project_name}.xcarchive" || error_exit "------------------------ 复制生成文件失败 ------------------------" 33
}

branch_name=$1
sign_mode=$2
build_config=$3
local_repo=$4
remote_repo=$5
plist_path=$6

cd $local_repo

git_folder="$local_repo/qukan-ios"

project_path="$git_folder/QuKan"

checkoutCodeFromGitLab

podInstall

initProjectBuildConfigure

building

