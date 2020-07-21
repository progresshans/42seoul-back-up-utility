#!/bin/bash

echo -e "홈디렉토리를 백업하는거라면 1을, goinfre를 백업하는거라면 2를 입력해주세요: "
read option
if [ $option == "1" ]; then
	chmod +x ./home_back_up.sh
	./home_back_up.sh
elif [ $option == "2" ]; then
	echo "2"
else
	echo "잘못 입력하셨습니다. 숫자로만 입력해주세요"
fi
