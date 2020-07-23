#!/bin/bash

today=`date +%Y-%m-%d`
goinfre_config=~/.42seoul_back_up_goinfre_config.txt

function echo_string {
	echo "-------------------------------------------------------------"
	for string in "$*"
	do
		printf '%-10s %-50s %-10s\n' "|" "$string" "|"
	done
	echo "-------------------------------------------------------------"
}

function git_choice {
	echo -e "git 업로드라면 1을, git에 있는 것을 가져오려면 2를, git에 있는 것을 강제로 가져오려면 3을 입력하세요 : "
	read git_option
	if [ $git_option = 1 ]; then
		git_add_commit_push
	elif [ $git_option = 2 ]; then
		git_pull
	elif [ $git_option = 3 ]; then
		git_pull_force
	else
		echo "잘못 입력하셨습니다. 숫자로만 입력해주세요"
	fi
}

function git_pull_force {
	echo_string "git pull(강제) 시작"
	git fetch --all
	git reset --hard origin/master
	git pull origin master
	echo_string "git pull(강제) 완료"
}

function git_pull {
	echo_string "git pull 시작"
	git pull origin master
	echo_string "git pull 완료"
}

function git_add_commit_push {
	echo_string "git add 시작! 경고가 떠도 무시하세요!"
	git add --force .
	echo_string "git add 완료"
	git commit -am "$today"
	echo_string "git commit 완료"
	git push -u origin master
	echo_string "git push 완료"
}

if [ ! -f ~/goinfre/.gitignore ]; then
	cd ~/goinfre
	echo "42seoul-back-up/" >> .gitignore
fi

if [ -f $goinfre_config ]; then
	echo "goinfre_config 파일이 존재합니다."
	echo "goinfre_config 파일에 있는 url로 백업 설정을 시작합니다."
	git_url_for_goinfre=`cat $goinfre_config`
	if [ -d ~/goinfre/42seoul-back-up/goinfre/.git ]; then
		if [ ! -h ~/goinfre/.git ]; then
			ln -s ~/goinfre/42seoul-back-up/goinfre/.git/ ~/goinfre/.git
		fi
		echo_string "git 확인"
		cd ~/goinfre/
		git pull origin master
	else
		git clone $git_url_for_goinfre ~/goinfre/42seoul-back-up/goinfre
		if [ ! -h ~/goinfre/.git ]; then
			ln -s ~/goinfre/42seoul-back-up/goinfre/.git/ ~/goinfre/.git
		fi
		echo_string "git clone 완료"
		cd ~/goinfre/
		git pull origin master
	fi
	git_choice
else
echo -e "처음 사용하는거라면 1을, 기존에 사용해왔다면 2를 입력해주세요: "
read option
	if [ $option == "1" ]; then
		echo "git.innovationacademy.kr에서 빈 레포지토리를 하나 만들어주세요"
		echo -e "git의 url을 입력해주세요 : "
		read git_url_for_goinfre
		cd ~/goinfre
		rm -rf ~/goinfre/.git/
		git init
		git remote add origin $git_url_for_goinfre
		echo_string "git init 완료"

		mv ~/goinfre/.git ~/goinfre/42seoul-back-up/goinfre/
		ln -s ~/goinfre/42seoul-back-up/goinfre/.git/ ~/goinfre/.git
		git_choice

		cd ~
		echo $git_url_for_goinfre >> .42seoul_back_up_goinfre_config.txt
		echo_string "goinfre_config 저장 완료"
	elif [ $option == "2" ]; then
		echo -e "git의 url을 입력해주세요 : "
		read git_url_for_goinfre
		rm -rf ~/goinfre/.git
		rm ~/goinfre/.git
		rm -rf ~/goinfre/42seoul-back-up/goinfre/
		git clone $git_url_for_goinfre ~/goinfre/42seoul-back-up/goinfre
		echo_string "git clone 완료"
		ln -s ~/goinfre/42seoul-back-up/goinfre/.git/ ~/goinfre/.git
		cd ~/goinfre
		git pull origin master
		git_choice
		cd ~
		echo $git_url_for_goinfre >> .42seoul_back_up_goinfre_config.txt
		echo_string "goinfre_config 저장 완료"
	else
		echo "잘못 입력하셨습니다. 숫자로만 입력해주세요"
	fi
fi
