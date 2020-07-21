#!/bin/bash

today=`date +%Y-%m-%d`
config=~/.42seoul_back_up_config.txt

if [ -f $config ]
then
	echo "config 파일이 존재합니다."
	echo "config 파일에 있는 url로 백업 설정을 시작합니다."
	git_url=`cat $config`
	if [ -d ~/goinfre/42seoul-back-up/.git ]
	then
		if [ -h ~/.git ]
		then
			echo "|--------------------|"
			echo "|------git 확인-------|"
			echo "|--------------------|"
		else
			ln -s ~/goinfre/42seoul-back-up/.git ~/.git
			echo "|--------------------|"
			echo "|------git  확인------|"
			echo "|--------------------|"
		fi
		cd ~
		git pull origin master
	else
		git clone $git_url ~/goinfre/42seoul-back-up
		if [ -h ~/.git ]
		then
			echo "|--------------------|"
			echo "|---git clone 완료----|"
			echo "|--------------------|"
		else
			ln -s ~/goinfre/42seoul-back-up/.git ~/.git
			echo "|--------------------|"
			echo "|---git clone 완료----|"
			echo "|--------------------|"
		fi
		cd ~
		git pull origin master
	fi
	echo "|--------------------|"
	echo "|-----git add 시작----|"
	echo "|----경고가 떠도 무시----|"
	echo "|--------------------|"

	git add --force .
	echo "|--------------------|"
	echo "|-----git add 완료----|"
	echo "|--------------------|"

	git commit -m "$today"
	echo "|--------------------|"
	echo "|---git commit 완료---|"
	echo "|--------------------|"

	git push -u origin master
	echo "|--------------------|"
	echo "|----git push 완료----|"
	echo "|--------------------|"
else
echo -e "처음 사용하는거라면 1을, 기존에 사용해왔다면 2를 입력해주세요: "
read option
	if [ $option == "1" ]
	then
		echo "git.innovationacademy.kr에서 빈 레포지토리를 하나 만들어주세요"
		echo -e "git의 url을 입력해주세요 : "
		read git_url
		cd ~
		rm -rf ~/.git/
		git init
		echo "|--------------------|"
		echo "|----git init 완료----|"
		echo "|--------------------|"

		mv ~/.git ~/goinfre/42seoul-back-up/
		ln -s ~/goinfre/42seoul-back-up/.git ~/.git
		echo "|--------------------|"
		echo "|-----git add 시작----|"
		echo "|----경고가 떠도 무시----|"
		echo "|--------------------|"

		git add --force .
		echo "|--------------------|"
		echo "|-----git add 완료----|"
		echo "|--------------------|"

		git commit -m "$today"
		echo "|--------------------|"
		echo "|---git commit 완료---|"
		echo "|--------------------|"

		git remote add origin $git_url
		git push -u origin master
		echo "|--------------------|"
		echo "|----git push 완료----|"
		echo "|--------------------|"

		echo $git_url >> .42seoul_back_up_config.txt
		echo "|--------------------|"
		echo "|---config 저장 완료---|"
		echo "|--------------------|"
	elif [ $option == "2" ]
	then
		echo -e "git의 url을 입력해주세요 : "
		read git_url
		rm -rf ~/.git
		rm ~/.git
		rm -rf ~/goinfre/42seoul-back-up/
		git clone $git_url ~/goinfre/42seoul-back-up
		echo "|--------------------|"
		echo "|---git clone 완료----|"
		echo "|--------------------|"
		ln -s ~/goinfre/42seoul-back-up/.git ~/.git
		cd ~
		git pull origin master

		echo "|--------------------|"
		echo "|-----git add 시작----|"
		echo "|----경고가 떠도 무시----|"
		echo "|--------------------|"
		git add --force .
		echo "|--------------------|"
		echo "|-----git add 완료----|"
		echo "|--------------------|"

		git commit -m "$today"
		echo "|--------------------|"
		echo "|---git commit 완료---|"
		echo "|--------------------|"

		git push -u origin master
		echo "|--------------------|"
		echo "|----git push 완료----|"
		echo "|--------------------|"

		echo $git_url >> .42seoul_back_up_config.txt
		echo "|--------------------|"
		echo "|---config 저장 완료---|"
		echo "|--------------------|"
	else
		echo "잘못 입력하셨습니다. 숫자로만 입력해주세요"
	fi
fi
