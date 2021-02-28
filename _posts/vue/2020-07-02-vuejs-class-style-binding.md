---
layout: post
cover: "assets/images/cover1.jpg"
navigation: True
title: Vue.js 클래스와 스타일 바인딩 적용하기
date: 2020-07-02
tags: vuejs
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: vue.js
comments: true
---

## 하고 싶은 것

![이미지](/assets/images/vuejs/vue-class-style-1.png){: width="700"}

쇼핑몰 프로젝트 진행 도중 장바구니 기능 구현에서 상품의 상태에 따라 구매 가능 유무를 사용자에게 보여주도록 했습니다. <br>
하지만 별다른 스타일 없는 밋밋한 텍스트는 의미를 파악하는데 있어서 확 와닿지가 않다고 생각해서 상태별로 스타일을 적용하는 것을 고려하던 찰나 <br>
다행히도 Vue.js 에서는 `동적 클래스 및 스타일 바인딩` 을 지원해주고 있어서 이번 포스트에서는 해당 기능을 활용해보겠습니다. <br>

## 클래스와 스타일 동적 바인딩

Vue.js 에서는 데이터를 동적으로 랜더링하기 위해 `v-bind` 를 지원하고 있습니다. <br>
따라서 특정 컴포넌트의 스타일 혹은 클래스를 동적으로 할당해주기 위해서는 해당 기능을 활용하면 됩니다. <br><br>

크게 객체를 통해 지정하는 방법과 배열을 통해 지정하는 방법으로 나뉘게 되는데 <br>
클래서를 동적으로 할당하기 위한 샘플 코드를 공식 문서를 통해 살펴보고 이번 프로젝트에 적용해보도록 하겠습니다. <br>
(스타일 랜더링은 실제 프로젝트 적용 과정에서 사용하도록 하겠습니다.) <br>

두 가지는 상황에 따라 본인에게 편리한 방법을 선택해서 활용하면 됩니다.<br>

### 객체 구문

객체 구문에서는 `v-bind` 값에 클래스들을 `Object` 형태로 정의해주면 됩니다. 다음과 같은 코드를 살펴보겠습니다.<br>

```html
<div class="static" v-bind:class="{ active: isActive, error: hasError }"></div>
```

이 경우 `isActive` 값이 `true` 일 때만 `active` 라는 클래스가 바안딩됩니다. (`error` 도 마찬가지) <br>
따라서 두 값이 모두 `true` 일때 최종 랜더링 되는 컴포넌트는 다음과 같습니다. <br>

```html
<div class="static active error"></div>
```

> 이때 static은 바인딩 되어 있지 않은 정적인 클래스이므로 isActive의 유무와 관계없이 추가됩니다.

### 배열 구문

배열 구문은 여러개의 클래스 혹은 스타일을 배열 형태로 정의하여 나타내는 것입니다. <br>
한가지 차이점은 동적으로 랜더링하고 싶다면 `삼항 연산자 혹은 객체 구문` 을 같이 활용해야 한다는 점입니다. <br><br>

조건이 없는 클래스 나열은 다음과 같습니다. <br>

```html
<div v-bind:class="[activeClass, errorClass]"></div>
```

```javascript
data: {
  activeClass: 'active',
  errorClass: 'text-danger'
}
```

만약 조건부 랜더링이 필요하다면 다음과 같이 내부에 `삼항 연산자` 를 사용하거나 `객체 구문` 을 같이 사용하면 됩니다. <br>

#### 삼항 연산자

```html
<div v-bind:class="[isActive ? activeClass : '', errorClass]"></div>
```

#### 내부에 객체 구문 활용

```html
<div v-bind:class="[{ active: isActive }, errorClass]"></div>
```

## 프로젝트에 적용하기

현재 각 상품에 대한 정보는 별도의 컴포넌트로 랜더링해주고 있는 상황입니다. <br>
각각의 카드는 부모 컴포넌트로부터 `props` 로 상품에 대한 정보를 전달받고 있으므로 <br>
이중 현재 상품의 판매 유무를 나타내는 `status` 값을 활용해 동적으로 랜더링해주도록 하겠습니다. <br>
이번에는 `클래스 바인딩` 이 아닌 `스타일 바인딩` 을 적용해보도록 하겠습니다. <br>

스타일 바인딩의 경우 적용하고자 하는 스타일을 `Camel case` 로 작성해서 Javascript 객체 형태로 전달해줘야합니다. <br>

### 스타일 객체 선언

현재 상품이 판매중일때는 초록색, 그렇지 않다면 붉은색을 적용하도록 하겠습니다. <br>

```javascript
data() {
    return {
      onSale: {
        color: 'darkseagreen',
      },
      soldOut: {
        color: 'crimson',
      },
    }
  },
```

### 템플릿 코드

기존에는 아직 스타일이 적용 안된 단순한 `span` 태그입니다. <br>

{% raw %}
<span>{{ statusMessage }}</span>
{% endraw %}

이제 위 코드를 아래와 같이 바꿔줍니다. <br>

{% raw %}
<span :style="[status ? soldOut : onSale]">{{ statusMessage }}</span>
{% endraw %}

### 결과 화면

![이미지](/assets/images/vuejs/vue-class-style-2.png){: width="700"}

## 참고 자료

- https://kr.vuejs.org/v2/guide/class-and-style.html
