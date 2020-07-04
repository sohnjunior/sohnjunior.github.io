---
layout: post
title: 프로그래머스 Level 2 - 큰 수 만들기
excerpt: "프로그래머스 Level 2 큰 수 만들기 with Python"
categories: [Algorithm]
tags: [Programmers]
modified: 2020-07-03
comments: true
---

## 문제
[프로그래머스 - 큰 수 만들기](https://programmers.co.kr/learn/courses/30/lessons/42883)


## 풀이 과정
k 개의 숫자를 제거하여 만들 수 있는 수 중에서 가장 큰 수를 찾는 문제입니다. <br>
만약 `브루트 포스` 로 접근한다면 최대 


## 코드
~~~ python

def solution(number, k):
    stack = []
    pop_count = 0

    for num in number:
        if not stack or stack[-1] >= num:
            stack.append(num)
        elif stack[-1] < num:
            while pop_count < k and stack and stack[-1] < num:
                stack.pop()
                pop_count += 1
            stack.append(num)

    if pop_count < k:
        for _ in range(k-pop_count):
            stack.pop()

    return ''.join(stack)


number = '1924'
k = 2

print(solution(number, k))  # 94

~~~

