---
layout: post
cover: "assets/images/cover1.jpg"
navigation: True
title: Vue-router 네비게이션 가드 활용하기
date: 2020-06-29
tags: vuejs
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: vue.js
comments: true
---

## Navigation Guard?

### 전역 가드

`router.beforeEach` 를 사용해서 모든 라우터 객체에 가드를 적용합니다. <br>
따라서 네비게이션이 트리거 될 때마다 어떤 라우트가 발생했는지 알 필요가 있는데 이를 위해 다음 세 가지 인자를 전달받습니다. <br>

- to : `to` 에 해당하는 라우트 객체로 다음에 이동
- from : 현재 라우터로 오기 이전의 라우트
- next : 훅을 해결하기 위해 호출됩니다. 동작 방식은 `next` 에 전달하는 인자에 따라 달라집니다.

`next()` 함수의 경우 호출되지 않으면 훅이 절대 불러지지 않으므로 반드시 가드 내에서 호출해야합니다. <br>

```javascript

const router = new VueRouter({ ... })

router.beforeEach((to, from, next) => {
  // ...
})

```

### 라우트 별 가드

`beforeEnter` 를 라우트 객체에 직접 정의하여 해당 라우트가 발생하기 이전에 원하는 로직을 처리할 수 있습니다. <br>

```javascript
const router = new VueRouter({
  routes: [
    {
      path: "/foo",
      component: Foo,
      beforeEnter: (to, from, next) => {
        // ...
      },
    },
  ],
});
```

### 컴포넌트 내부 가드

컴포넌트 내부에서 `beforeRouteEnter`, `beforeRouteUpdate`, `beforeRouteLeave` 세 가지로 네비게이션 가드를 설정할 수 있습니다. <br>
`beforeRouteEnter` 는 아직 컴포넌트가 랜더링 되지 않았기 때문에 `this` 객체에 접근할 수 없지만 나머지 두 개는 접근이 가능합니다. <br>

```javascript
const Foo = {
  template: `...`,
  beforeRouteEnter(to, from, next) {
    // ...
  },
  beforeRouteUpdate(to, from, next) {
    // ...
  },
  beforeRouteLeave(to, from, next) {
    // ...
  },
};
```

하지만 `next` 함수에 콜백 함수를 지정할 경우 콜백에 전달받는 인자로 컴포넌트 인스턴스에 접근하여 `this` 에 직접 접근할 수 있습니다. <br>

```javascript

beforeRouteEnter (to, from, next) {
  next(vm => {
    // `vm`을 통한 컴포넌트 인스턴스 접근
  })
}

```

## beforeEnter를 통한 라우트 별 권한 체크

이번 포스팅에서는 라우트 객체 내부에 네비게이션 가드를 설정하여 사용자 권한을 체크해줬습니다. <br>
만약 사용자가 상품 게시글 생성 페이지에 로그인을 안한 상태에서 접근하여고 한다면 `alert` 로 알람을 띄워준 뒤 홈 화면으로 리다이렉트 합니다. <br>

### routes/index.js

```javascript
// import components
// ...

// import store for navigation gurad
import store from "../store/index";

export const router = new VueRouter({
  routes: [
    // ...
    {
      // 상품 게시글 생성 페이지
      path: "/product/new",
      component: ProductCreateView,
      beforeEnter: (to, from, next) => {
        // 만약 로그인 상태라면
        if (store.state.email !== "" && store.state.token !== "") {
          return next();
        }
        alert("로그인이 필요한 서비스입니다.");
        next("/");
      },
    },
  ],
});
```

## 참고 자료

- https://router.vuejs.org/kr/guide/advanced/navigation-guards.html
