---
layout: post
title: Django에서 history mode 사용하는 법
excerpt: "Django에서 Vue.js Router history 모드 적용을 위해 필요한 작업들에 대해 살펴보자"
categories: [django, vue.js]
tags: [django, vue.js]
modified: 2020-05-04
comments: true
---


## History mode?

## 문제점

## Django에서 History mode 지원을 위한 작업



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