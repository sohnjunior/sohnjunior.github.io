---
layout: post
title: Django + Vue.js 애플리케이션 Heroku로 배포하기
excerpt: "Django와 Vue.js로 구성된 애플리케이션을 Heroku를 통해 배포해봅시다"
categories: [django]
tags: [django, heroku, vue.js]
modified: 2020-05-04
comments: true
---


## Heroku?

## 현재 프로젝트 구조

## Django와 Vue.js 배포를 위한 단계

## Vue.js Webpack 수정
Vue.js 빌드 파일을 생성할 경로를 수정해주기 위해 vue.config.js 파일을 생성한 다음 아래의 코드를 작성한다. 이는 현재 프로젝트 구조가 frontend와 backend로 나누어져 있기 때문에 이 방식을 사용한 것이다.

### vue.config.js
~~~ javascript
const path = require("path");

module.exports = {
  outputDir: path.resolve(__dirname, "../backend/templates"),
  assetsDir: "../static"
}
~~~

## Heroku app 생성

### build pack 설정
만약 본인의 github 프로젝트가 subdirectory로 구성되었을 경우 아래 글을 참고하라 <br>
https://medium.com/@timanovsky/heroku-buildpack-to-support-deployment-from-subdirectory-e743c2c838dd

### 환경변수 설정
Secret Key등 보안상 외부로 유출되면 안되는 정보들을 설정해준다. <br>
기존의 Django 프로젝트에서 secrets.json 등의 파일에 기록된 내용들을 적어주면 된다. <br>

#### Heroku
[사진]

#### Django
~~~ python
    SECRET_KEY = os.environ.get("SECRET_KEY")
    DATABASE_NAME = os.environ.get("DATABASE_NAME")
    DATABASE_USER = os.environ.get("DATABASE_USER")
    DATABASE_PASSWORD = os.environ.get("DATABASE_PASSWORD")
    S3_ACCESS_KEY = os.environ.get("S3_ACCESS_KEY")
    S3_SECRET_KEY = os.environ.get("S3_SECRET_KEY")
~~~

## Heroku 배포를 위한 Django 앱 수정

### 필요한 패키지 설치
~~~ python
pip install gunicorn whitenoise
~~~

### DEBUG 및 ALLOWED_HOST 수정
~~~ python 
# 배포전 DEBUG 확인!
DEBUG = bool(os.environ.get('DJANGO_DEBUG', True))
ALLOWED_HOSTS = ['*']
~~~


### Procfile 작성
Github 저장소의 root 폴더에 Procfile을 확장자없이 생성한다. 
config/wsgi.py의 설정 정보를 활용해 gunicorn을 구동시킨다는 의미이다.

~~~ 
web: gunicorn --pythonpath backend config.wsgi --log-file -
~~~

본인의 프로젝트 폴더 구조에 맞도록 경로를 설정해줘야 한다. 아래 글 참고
https://stackoverflow.com/questions/57587490/couldnt-find-wsgi-module-deploying-heroku

### Gunicorn 설치


### Database 설정
다음 코드를 settings.py 맨 밑에 붙여넣자 <br>
heroku는 기본적으로 postgresql을 사용하므로 이에 대한 설정이 필요하다. <br>

~~~ python
import dj_database_url
db_from_env = dj_database_url.config(conn_max_age=500)
DATABASES['default'].update(db_from_env)
~~~

### Whitenoise를 통한 Static file 지원
Heroku 사용시에는 Whitenoise를 활용하여 gunicorn 상에서 정적 리소스를 제공하는 것을 추천한다.

#### setting.py 수정
~~~ python
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',  # Heroku white noise 설정
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'corsheaders.middleware.CorsMiddleware',  # django-cors-header 설정
]

STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
~~~

#### 옵션
django의 runserver는 기본적으로 정적파일을 관리해주는 기능을 포함하고 있습니다. <br>
하지만 개발환경에서도 whitenoise를 통해 정적파일들을 다루고 싶다면 어떻게 해야할까요?

~~~python
INSTALLED_APPS = [
    'whitenoise.runserver_nostatic',  # django.contrib.staticfiles 보다 더 위에!
    'django.contrib.staticfiles',
    # ...
]
~~~

### Python package requirement.txt 생성

~~~ python
pip freeze > requirements.txt
~~~

pytorch 등의 무거운 라이브러리를 사용할 경우 cpu만 사용하는 라이브러리로 설정해줘야 slug size 에러가 발생안한다.
아래 글 참고
https://stackoverflow.com/questions/59122308/heroku-slug-size-too-large-after-installing-pytorch

> requirement.txt에 별도로 psycopg2==2.7 를 꼭 추가해줘야합니다.

### runtime.txt 생성
heroku에서 사용할 python 버전을 명시할 수 있습니다.
python-3.7.6
https://devcenter.heroku.com/articles/python-support#supported-python-runtimes

### 배포하기

Github에 모든 변경사항을 반영한 다음 deploy 하면 된다.


### 참고 자료

* https://stackoverflow.com/questions/48851677/how-to-direct-vue-cli-to-put-built-project-files-in-different-directories
* http://whitenoise.evans.io/en/stable/django.html
* https://medium.com/@williamgnlee/simple-integrated-django-vue-js-web-application-configured-for-heroku-deployment-c4bd2b37aa70