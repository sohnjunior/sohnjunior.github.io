---
layout: post
cover: "assets/images/cover1.jpg"
navigation: True
title: Vue.js 에서 반응형(Reactivity)을 다루는 방법
date: 2020-07-18
tags: vuejs
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: vue.js
comments: true
---

## 들어가며

이번 포스팅에서는 `Vue.js` 의 반응형 시스템에 대해 알아보고자 합니다. <br>
최근 진행하고 있는 `Avocado` 프로젝트에서 컴포넌트의 `data` 에 변경을 해줘도 `props` 로 자식에게 전달해준 값이 갱신되지 않는 문제가 발생했습니다. <br>
혹시나 해서 찾아보니 바로 `reactivity` 를 고려하지 않았던 것이 원인이 되었다는 것을 알게되었습니다. <br>

## 반응형이란?

![이미지](/assets/images/vuejs/vue-reactivity-diagram.png){: width="400"}

`Vue.js` 에서는 어떻게 컴포넌트 인스턴스의 `data` 속성 값을 추적하여 화면에 랜더링을 해줄 수 있는 것일까요? <br>
이는 바로 각 컴포넌트 인스턴스마다 할당된 `watcher` 를 통해 변경 사항을 추적 및 관리하기 때문에 가능한 일입니다. <br>
`Vue.js` 는 인스턴스 초기화 단계에서 `data` 의 모든 속성에 `getter / setter` 를 추가하여 관리 및 갱신에 필요한 연산을 수행합니다. <br><br>

또 한가지 중요한 사실은 `Vue.js` 는 `DOM` 업데이트를 `비동기` 로 수행한다는 것입니다. <br>
따라서 데이터 변경이 발생하여 `DOM` 을 업데이트 해야할 경우 큐를 열고 모든 데이터 변경을 버퍼에 기록합니다. <br>
이후 해당 변경 사항들은 이벤트 루프 `tick` 에서 대기열을 비우고 실제 변경 작업을 수행합니다. <br>

## 리스트 렌더링 시 주의사항

`Vue.js` 는 배열에 인덱스로 항목을 직접 설정하는 경우나 배열 길이를 수정하는 경우 <b>변경 사항을 추적할 수 없습니다.</b> <br>
하지만 그 외 아래의 변이 메소드같은 경우는 래핑되어 뷰 갱신을 추적할 수 있습니다. <br>

- push(), pop()
- shift(), unshift()
- splice()
- sort()
- reverse()

## 문제 발생 원인은 무엇일까?

### 리스트 렌더링 이슈

```javascript
export default {
  data() {
    return {
      current: 0, // 현재 배열 인덱스
      answer: [], // 사용자 입력 값들을 저장하는 배열
      userInput: "", // 사용자 입력 값
    };
  },

  methods: {
    handleNext() {
      // currnt(인덱스) 증가, answer 가 추가된 이후 실행됨
    },

    saveData(data) {
      this.answer[this.current] = data;
      this.handleNext();
    },
  },
};
```

그렇다면 기존 코드를 살펴보며 무엇이 문제였는지 파악해보겠습니다. <br>
기존에는 사용자가 입력한 단어들을 저장하는 배열 `answer` 가 위와 같이 `data` 에 선언되어 있습니다. <br>
또한 사용자가 단어를 입력할 경우 발생하는 이벤트 핸들러인 `saveData` 함수의 경우 현재 배열의 인덱스값에 있는 값을
새로운 값으로 대체하는 작업을 하고 있죠. <br>
그런데 위에서 살펴봤듯이 `Vue.js` 는 인덱스로 직접적인 접근을 통해 값을 변경할 경우 이 변경사항을 추적할 수 없기 때문에 다시 랜더링이 발생하지 않습니다. <br>
따라서 아래와 같이 `Vue` 에서 제공하는 `set` 메소드나 `splice` 를 활용하여 값을 변경해줍니다. <br>

```javascript
  saveData(data) {
    this.$set(this.answer, this.current, data);
    this.handleNext();
  }
```

### 비동기 처리 이슈

아직 한 가지 문제점이 남아있습니다. <br>
위 코드를 보시면 데이터를 갱신하고 인덱스를 증가시키는 `handleNext` 함수를 수행하는 것을 알 수 있습니다. <br>
하지만 그대로 실행시킬 경우 다음과 같이 단어가 잘려서 입력되는 문제가 발생하는 것을 확인할 수 있습니다. <br>

![이미지](/assets/images/vuejs/vue-async.png){: width="600"}

이는 `Vue.js` 의 `비동기 처리 방식` 때문에 인덱스가 증가함과 동시에 데이터가 변경되어 발생한 일입니다. <br>
따라서 데이터 변경을 마친 후 `DOM` 업데이트를 마칠 때까지 기다리기 위해 `Vue.nextTick(콜백)` 을 사용하도록 합니다. <br>

```javascript
saveData(data) {
  this.$set(this.answer, this.current, data);
  this.$nextTick(() => {
    this.handleNext();
  })
}
```

## 참고 자료

- https://vuejs.org/v2/guide/reactivity.html
- https://kr.vuejs.org/v2/guide/list.html#nav
- https://laracasts.com/discuss/channels/vue/vuejs-component-rendering-after-prop-update
