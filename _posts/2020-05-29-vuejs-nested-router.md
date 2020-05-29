---
layout: post
title: Vue.js Nested Router 사용하기
excerpt: "Vue.js에서 중첩된 라우터를 사용해 다양한 컴포넌트를 조작해보자"
categories: [vue.js]
tags: [vue.js]
modified: 2020-05-29
comments: true
---


## 원하는 URL 패턴
쇼핑몰 프로젝트를 진행하면서 다수의 컴포넌트로 이루어진 화면 랜더링이 필요한 상황이 생겼습니다. <br>
유저 관련 정보들을 위한 대시보드를 구현하면서 화면 설계를 다음과 같이 했습니다. <br>

{% raw %}
    /board                                /board/wishlist
    +------------------+                  +-----------------+
    | board            |                  | board           |
    | +--------------+ |                  | +-------------+ |
    | | main         | |  +------------>  | | wishlist    | |
    | |              | |                  | |             | |
    | +--------------+ |                  | +-------------+ |
    +------------------+                  +-----------------+
{% endraw %}

이를 위해서는 특정 URL별로 화면을 구성하는 컴포넌트를 랜더링할 수 있도록 해야합니다. <br>
다행히도 Vue.js 에서는 이를 위한 `중첩 라우팅` 을 지원하고 있으니 이를 잘 활용하기만 하면 됩니다. <br>

## 중첩된 라우터
중첩된 라우터는 여러 단계로 중첩 된 컴포넌트를 다루기 위해 Vue.js에서 제공하는 라우팅 기능입니다. <br>
개발자는 이를 통해 특정 URL 패턴에 따라 원하는 자식 컴포넌트를 랜더링할 수 있습니다.<br>

### 자식 컴포넌트 정의
우선 부모 컴포넌트 하위에 랜더링될 자식 컴포넌트들을 정의합니다. <br>

#### components/DashBoard.vue
~~~ javascript
  <template>
    <div>
      대시보드 메인
    </div>
  </template>

  <script>
  export default {}
  </script>

  <style>
  </style>
~~~

#### components/WishList.vue
~~~ javascript
  <template>
    <div>
      ss
    </div>
  </template>

  <script>
  export default {}
  </script>

  <style>
  </style>
~~~

### 부모 컴포넌트 정의
부모 컴포넌트에서는 `<router-view/>` 를 통해 자식 컴포넌트를 원하는 위치에 랜더링합니다. <br>

#### views/DashBoardView.vue
~~~ javascript
  <template>
    <div>
      대시보드<br>
      <router-view></router-view>
    </div>
  </template>

  <script>
  export default {}
  </script>

  <style>
  </style>
~~~

### 컴포넌트 로드 및 라우터 정의
이제 앞서 정의한 컴포넌트를 불러와 각각의 URL 패턴에 맞도록 정의해줍니다. <br>
자식 컴포넌트를 랜더링하기 위해서는 `children` 속성을 활용해야합니다. <br>
`children` 속성 하위에 원하는 자식 컴포넌트들을 정의하고 해당 URL 패턴을 매치시켜줍니다. <br>
이때 `path: ""`는 `/dashboard/`와 같이 자식 컴포넌트가 존재하지 않은 URL일 경우를 위한 라우팅입니다. <br>

#### routes/index.js
~~~ javascript
import DashBoardView from '../views/DashBoardView.vue';

// sub component for Dashboard
import DashBoard from '../components/DashBoard.vue';
import WishList from '../components/WishList.vue';

Vue.use(VueRouter);


export const router = new VueRouter({
         routes: [
           {
             // 홈 화면
             path: "/",
             component: MainView,
           },
           {
             // 유저 대시보드
             path: "/dashboard",
             component: DashBoardView,
             children: [
               {
                 // 자삭 컴포넌트 없을 경우
                 path: "",
                 component: DashBoard,
               },
               {
                 // 위시 리스트
                 path: "wishlist",
                 component: WishList,
               },
               {
                 // ... 기타 child 컴포넌트 정의
               }
             ],
           },
         ],
       });
~~~

## 참고 자료
* https://router.vuejs.org/kr/guide/essentials/nested-routes.html
