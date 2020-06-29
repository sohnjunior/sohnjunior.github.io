---
layout: post
title: Vue-router 네비게이션 가드 활용하기
excerpt: "Vue-router의 네비게이션 가드를 사용해서 라우팅 전 원하는 작업 수행하기"
categories: [vue.js]
tags: [vue.js]
modified: 2020-06-29
comments: true
---


## Navigation Guard?

## beforeEnter를 통한 권한 체크

### routes/index.js
~~~ javascript
// import components
// ...

// import store for navigation gurad
import store from '../store/index';

export const router = new VueRouter({ 
  routes: [
    // ...
     {
        // 상품 게시글 생성 페이지
        path: "/product/new",
        component: ProductCreateView,
        beforeEnter: (to, from, next) => {
          // 만약 로그인 상태라면
          if (store.state.email !== '' && store.state.token !== '') {
            return next();
          }
          alert('로그인이 필요한 서비스입니다.');
          next('/');
        }
      },
  ]
});

~~~



## 참고 자료
* https://router.vuejs.org/kr/guide/advanced/navigation-guards.html
