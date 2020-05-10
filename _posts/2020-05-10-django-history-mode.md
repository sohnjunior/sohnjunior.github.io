---
layout: post
title: Vue-Router history mode 지원을 위한 Django 설정방법
excerpt: "Django에서 Vue.js Router history 모드 적용을 위해 필요한 작업들에 대해 살펴보자"
categories: [django, vue.js]
tags: [django, vue.js]
modified: 2020-05-10
comments: true
---


## Vue-router와 Django
Vue.js에서 `vue-router` 를 사용할 경우 기본적으로 URL에 # 가 포함되어 있습니다. <br>
해시를 제거하기 위해서는 히스토리 모드를 적용해야 하는데 Django를 백엔드 서버로 두고 그대로 사용할 경우 문제가 생깁니다. <br>

## 문제점
만약 Vue.js에서 히스토리 모드를 적용한 후 `npm build` 를 통해 생성한 빌드 파일을 <br> 
Django의 `index.html` 로 설정한 다음 직접 URL로 특정 페이지를 요청할 경우 404 에러를 확인할 수 있습니다. <br>

이는 Vue.js가 SPA(Single Page Application)이라서 Django 서버는 클라이언트에서 사용하는 특정 URL 패턴을 알 수 없는 상황에서 벌어진 일입니다. <br>

그렇다면 Django에서 히스토리 모드를 사용하기 위해서는 어떻게 해야할까요? <br>

## Django에서 History mode 지원을 위한 작업
Django에서 히스토리 모드를 사용하기 위해서는 약간의 트릭을 이용해야합니다. <br>

다음과 같이 `urls.py` 에서 가장 마지막 url 패턴을 정규표현식을 활용해 추가해주면 됩니다. <br>
이렇게 하면 매칭되지 못한 URL은 다시 SPA 내에서 원하는 페이지를 찾을 수 있게 되는 것이죠. <br>

### config/urls.py

~~~ python

from django.contrib import admin
from django.urls import path, include, re_path

from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='index.html')),
    path('admin/', admin.site.urls),

    # shopping app urls
    path('shopping/', include('shopping.urls')),
    # ... rest of your urls
]

# history mode 지원
urlpatterns += [
     re_path('^.*$', TemplateView.as_view(template_name='index.html')),
]

~~~



### 참고 자료

* https://stackoverflow.com/questions/42864641/handling-single-page-application-url-and-django-url