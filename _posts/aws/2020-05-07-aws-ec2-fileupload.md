---
layout: post
cover: "assets/images/cover5.jpg"
navigation: True
title: AWS EC2에 원격 접속 및 파일 업로드하기
date: 2020-05-07
tags: aws
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: aws
comments: true
---

## AWS EC2 인스턴스 연결

AWS EC2 인스턴스에 원격으로 접속하기 위해서는 `SSH 클라이언트`를 사용해야합니다. <br>
터미널을 열고 다음과 같은 명령어를 입력해줍니다. <br>

```sh
$ ssh -i [키페어 경로] [ec2 계정이름]@[퍼블릭 DNS주소]
```

예시

```sh
$ ssh -i ~/.ssh/awskey.pem ubuntu@ec2-198-51-100-1.compute-1.amazonaws.com
```

## SCP를 통한 파일 업로드

`SCP(Secure Copy Ptorocol)`은 로컬 컴퓨터에서 Linux 인스턴스로 파일을 전송할 수 있도록 해줍니다. <br>
Linux, Mac 등에는 기본적으로 SCP 클라이언트가 내장되어있지만 Window OS의 경우에는 별도의 클라이언트 프로그램을 설치해줘야합니다. <br><br>
[Window SCP Client 사용법](https://chp747.tistory.com/129){:target="\_blank"}

SCP 클라이언트 구성을 마쳤다면 이제 로컬 환경에서 새로운 터미널을 열고 <br>
다음과 같은 명령어를 통해 파일을 전송할 수 있습니다. <br>

```sh
$ scp -i [키페어 경로] [전송할 파일 경로] [ec2 계정이름]@[퍼블릭 DNS 주소]:[전송할 EC2 경로]
```

예시

```sh
$ scp -i ~/.ssh/awskey.pem ./sample.txt ubuntu@ec2-198-51-100-1.compute-1.amazonaws.com:~
```

이 경우 현재 디렉토리에 존재하는 텍스트 파일이 EC2 인스턴스의 ~ 에 해당하는 경로(홈 디렉토리)에 전송됩니다. <br>

### 참고 자료

- https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html
