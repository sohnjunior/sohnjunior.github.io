---
layout: post
cover: "assets/images/cover3.jpg"
navigation: True
title: React 컴포넌트에서 타이머 설정하기 (with Hooks)
date: 2020-07-25
tags: reactjs
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: react.js
comments: true
---

## 들어가며

![이미지](/assets/images/reactjs/react-timer.png){: width="400"}

`React` 를 활용해서 오목 게임을 구현하던 중에 위와 같이 화면 왼쪽 상단에 타이머를 설정해주고 싶었습니다. <br>
사용자가 바둑돌을 놓으면 타이머가 재설정되어야 하기 때문에 `Timer` 컴포넌트를 `state` 에 따라 `useEffect` 를 활용하여 다시 설정해주는 방법을 사용하기로 했습니다. <br>

현재 `hooks` 을 이용해서 컴포넌트를 작성하고 있었기 때문에 이번 포스팅에서는 타이머 리랜더링 로직은 제외하고 <br>
`React Hooks` 을 활용하여 간단한 타이머를 설정하는 방법을 알아보겠습니다. <br>

## 자바스크립트 타이머 설정 함수

자바스크립트에는 타이머를 설정할 수 있는 함수가 두 가지 존재합니다. <br>
하나는 `setTimeout` 이고 나머지 하나는 `setInterval` 로 두 함수는 목적에 맞게 사용하면 됩니다. <br>
이번 포스팅에서 사용할 `setInterval` 함수는 인자로 실행시킬 함수 `F` 와 실행 전 대기 시간 `T` 를 받아 호출 스케줄링을 합니다. <br>

```javascript
let timerId = setInterval(() => {
  console.log("2초마다 실행");
}, 2000);

setTimeout(() => {
  clearInterval(timerId);
}, 7000);
```

## useEffect 를 활용한 타이머 설정

`useEffect` 는 `React Hook` 으로 컴포넌트를 설계할 때 라이프 사이클 중 `componentDidMount` 와 `componentDidUpdate` <br> 그리고 `componentWillUnmount` 를 아우르는 역할을 담당하고 있습니다. <br>
이번 포스팅에서는 타이머가 `DOM`에 랜더링 되는 시점에 설정되고 삭제될 때 해제되도록 하기 위해 `useEffect` 를 활용합니다. <br>

```javascript
import React, { useEffect } from "react";

const App = () => {
  useEffect(() => {
    const timerId = setTimeout(() => {
      // do something ...
    }, 1000);
    return () => clearTimeout(timerId);
  }, []);

  return <div>타이머 예제</div>;
};

export default App;
```

위와 같이 `useEffect` 의 두번째 인자를 빈 배열로 설정할 경우 의존성이 존재하는 요소가 없기 때문에 화면에 한번 랜더링 된 이후 다시 호출되지 않습니다. (`componentDidMount` 의 역할) <br>
한 가지 주의할 점은 반환 값으로 함수를 지정해 컴포넌트가 마운트 해제되는 시점에 타이머를 해제해주도록 하는 것입니다. <br>
이렇게 해주지 않으면 타이머는 비동기로 진행되기 때문에 컴포넌트가 마운트 해제되더라도 타이머는 없어지지 않는 상황이 발생합니다. <br>

## 프로젝트 적용

이제 이를 활용해서 실제 프로젝트에 3분의 타이머를 구현해보겠습니다. <br>
초 단위로 시간값을 계산해서 화면에 랜더링해줍니다. <br>
초기 랜더링 시 타이머를 설정한 뒤, 만료가 될 경우 이벤트를 발생시키도록 설계하였습니다. <br>
이때 해당 컴포넌트 자체가 다시 랜더링 되는 경우나 타임 아웃되는 경우 타이머를 해제해주기 위해 각각 `clearInterval` 을 수행했습니다. <br>
여기서 눈여겨볼 점은 `useEffect` 의 `dependencies` 에 `time` 대신 `sec` 으로 지정해준 것입니다. <br>
이는 `useRef` 는 값이 변화하더라도 리랜더링을 발생시키지 않기 때문에 `useEffect` 를 절대 호출하지 않기 때문입니다. <br>

```javascript
const Timer = () => {
  const [min, setMin] = useState(3);
  const [sec, setSec] = useState(0);
  const time = useRef(180);
  const timerId = useRef(null);

  useEffect(() => {
    timerId.current = setInterval(() => {
      setMin(parseInt(time.current / 60));
      setSec(time.current % 60);
      time.current -= 1;
    }, 1000);

    return () => clearInterval(timerId.current);
  }, []);

  useEffect(() => {
    // 만약 타임 아웃이 발생했을 경우
    if (time.current <= 0) {
      console.log("타임 아웃");
      clearInterval(timerId.current);
      // dispatch event
    }
  }, [sec]);

  return (
    <div className="timer">
      {min} 분 {sec} 초
    </div>
  );
};
```

## 참고 자료

- https://ko.javascript.info/settimeout-setinterval
- https://upmostly.com/tutorials/settimeout-in-react-components-using-hooks
