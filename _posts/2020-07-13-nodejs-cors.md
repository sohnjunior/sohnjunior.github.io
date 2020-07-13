---
layout: post
title: Node.js CORS(Cross Origin Resource Sharing) 설정
excerpt: "Node.js 에서 CORS 문제 해결하기"
categories: [nodejs]
tags: [nodejs]
modified: 2020-07-13
comments: true
---

## CORS?
`CORS(Cross Origin Resource Sharing)` 는 추가적인 HTTP 헤더를 사용해서 한 출처에서 실행 중인 웹 애플리케이션이 <br>
다른 출처의 자원에 접근할 수 있는 권한을 관리하는 체제입니다. <br>

![이미지](/img/nodejs/cors-example.png){: width="400"}

즉 위와 같이 `domain-a.com` 에서 같은 주소의 `domain-a.com` 에 접근하여 자원을 요청할때는 문제가 발생하지 않지만, <br>
`domain-b.com` 에 요청할 경우 도메인이 다르기 때문에 보안상의 이유로 제한됩니다. <br>

![이미지](/img/nodejs/cors-error.png){: width="800"}

만약 서버에서 올바른 CORS 헤더를 포함한 응답을 반환하지 않으면 위와 같은 오류가 발생하게 됩니다. <br>
위 예시에서는 자원을 가지고 있는 서버단의 도메인인 `http://127.0.0.1:3000` 과 자원을 요청한 `http://localhost:8080` 의 출처가 다르기 때문에 발생한 오류입니다. <br>

## Node.js에서 CORS 설정
### CORS 패키지 설치
우선 CORS 미들웨어를 사용하기 위해 패키지를 설치합니다. <br>

~~~ bash
$npm i cors
~~~

### 모든 CORS Request 허용하기
모든 요청을 허용할 경우 다음과 같이 간단하게 미들웨어를 불러와서 추가해주는 것으로 해결할 수 있습니다. <br>

#### app.js
~~~ javascript

var express = require('express')
var cors = require('cors')
var app = express()

app.use(cors())  // CORS 미들웨어 등록

// ... 

~~~

### Whitelist로 특정 주소만 허용하기
모든 CORS 요청을 허용해주는 것이 때로는 보안상의 문제로 이어질 수 있습니다. <br>
만약 특정 호스트만 CORS 요청을 허용해주고 싶다면 다음과 같이 `whitelist` 를 추가해서 검증하는 방법을 사용할 수 있습니다. <br>
요청을 허용할 주소를 담은 `whitelist` 를 생성해주고 요청 HTTP 헤더의 `Origin` 속성을 확인해서 일치하는 항목이 있을 경우 허용해주는 방식입니다. <br>

#### app.js
~~~ javascript
var express = require('express')
var cors = require('cors')
var app = express()

const whitelist = ["http://localhost:8080"];
const corsOptions = {
  origin: function(origin, callback) {
    if (whitelist.indexOf(origin) !== -1) { callback(null, true); }
    else { callback(new Error('Not Allowed Origin!')); }
  }
};

app.use(cors(corsOptions));  // 옵션을 추가한 CORS 미들웨어 추가 

// ...

~~~

## 참고 자료
* https://expressjs.com/en/resources/middleware/cors.html
* https://developer.mozilla.org/ko/docs/Web/HTTP/CORS
