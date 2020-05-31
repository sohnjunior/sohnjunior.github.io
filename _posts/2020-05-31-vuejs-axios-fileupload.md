---
layout: post
title: Vue.js와 Vuetify 활용해서 axios로 파일 업로드하기
excerpt: "Vue.js에서 Vuetify file input을 활용해서 서버에 파일 업로드하는 방법"
categories: [vue.js]
tags: [vue.js]
modified: 2020-05-31
comments: true
---


## Vuetify?
Vuetify는 Vue.js를 위한 디자인 프레임워크입니다. <br>
이번 포스팅에서는 Vue.js와 Vuetify 를 활용해서 서버에 파일을 업로드하는 방법에 대해 알아보고자 합니다. <br>

> 해당 포스팅은 사전에 파일 업로드를 처리할 수 있는 백엔드 서버가 구성되어있다는 전재하에 진행됩니다. 

## Vuetify File input 컴포넌트 사용
Vuetify 에서는 기존의 HTML `input` 태그 역할을 하는 여러가지 입력 전용 컴포넌트들이 존재합니다. <br>
이중 저희는 파일 업로드를 위한 `v-file-input` 태그를 활용합니다. <br>

### Product.vue

#### v-file-input 컴포넌트
`v-file-input` 은 선택된 파일에 변경이 있다면 `change` 이벤트를 통해 원하는 작업을 수행할 수 있습니다. <br>
해당 이벤트 핸들링 함수를 등록해준 뒤 선택된 파일을 추적할 수 있도록 합니다. <br>
~~~ html
<template>
  <div>
    상품 등록하기

    <v-file-input label="File input" @change="selectFile"></v-file-input>

    <v-btn @click="submit">서버에 전송하기</v-btn>
  </div>
</template>
~~~

#### 파일 정보를 저장할 데이터 선언
선택된 파일 객체를 관리할 데이터 속성을 선언해줍니다. <br>
~~~ javascript
data() {
    return {
      image: '',
    }
  },
~~~

#### 파일 선택 이벤트 처리
앞서 `change` 이벤트 핸들러 함수로 등록한 `selectFile` 함수에서는 인자로 선택된 파일 객체를 전달받습니다. <br>
해당 객체를 `data` 의 `image` 에 할당해줍니다. <br>

~~~ javascript
  // 파일 변경 시 이벤트 핸들러
  selectFile(file) {
    this.image = file;
  },
~~~

#### axios 로 서버에 파일 업로드하기
이제 선택된 파일을 전송하기 위해 `formData` 를 생성합니다. <br>
`axios` 의 요청 인자로 서버 api 주소를 지정하고 Node.js의 `multer` 모듈을 위해 `Content-Type` 을 `multipart/form-data` 로 지정해줬습니다. <br>


~~~ javascript
async submit() {
      const formData = new FormData();
      formData.append('image', this.image);

      try {
        const { data } = await axios.post('http://127.0.0.1:3000/product/create', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
            }
          });
        console.log(data);
      } catch(err) {
        console.log(err);
      }
  }
~~~

#### 전체 코드
~~~ html
<template>
  <div>
    상품 등록하기

    <v-file-input label="File input" @change="selectFile"></v-file-input>

    <v-btn @click="submit">서버에 전송하기</v-btn>
  </div>
</template>
~~~

~~~ javascript
import axios from 'axios';

export default {
  data() {
    return {
      image: 'test image',
    }
  },

  methods: {
    async submit() {
      const formData = new FormData();
      formData.append('image', this.image);

      try {
        const { data } = await axios.post('http://127.0.0.1:3000/product/create', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
            }
          });
        console.log(data);
      } catch(err) {
        console.log(err);
      }
    },

    // 파일 변경 시 이벤트 핸들러
    selectFile(file) {
      this.image = file;
    },
  }
}
~~~

## 실행 결과(서버 로그)
~~~ bash
POST /product/create 200 11.313 ms - 129
OPTIONS /product/create 204 0.205 ms - 0
{
  image: 'profile-1590918594170.jpg',
}
~~~

## 참고 자료
* https://router.vuejs.org/kr/guide/essentials/nested-routes.html
