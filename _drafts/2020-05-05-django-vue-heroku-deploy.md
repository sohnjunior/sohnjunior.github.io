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


### vue.config.js
~~~ javascript
const path = require("path");

module.exports = {
  outputDir: path.resolve(__dirname, "../backend/templates"),
  assetsDir: "../static"
}
~~~



### 참고 자료

* https://stackoverflow.com/questions/48851677/how-to-direct-vue-cli-to-put-built-project-files-in-different-directories
* https://dev.to/shakib609/deploy-your-django-react-js-app-to-heroku-2bck
* https://medium.com/@williamgnlee/simple-integrated-django-vue-js-web-application-configured-for-heroku-deployment-c4bd2b37aa70