---
layout: post
cover: "assets/images/cover2.jpg"
navigation: True
title: 프로그래머스 Level 2 - 타겟 넘버
date: 2020-07-10
tags: Programmers
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: algorithm
comments: true
---

## 문제

[프로그래머스 - 타겟 넘버](https://programmers.co.kr/learn/courses/30/lessons/43165)

## 풀이 과정

주어진 수에 덧셈과 뺄셈을 활용해서 목표 숫자를 만드는 문제입니다. <br>
최대 20개의 숫자를 사용하고 2가지 연산밖에 사용할 수 없으므로 최대 `2^20` 개의 상태를 방문하게 됩니다. <br>
이는 대략 `1000000` 으로 충분히 시간 내에 수행이 가능하므로 `DFS` 를 활용해 모든 경우의 수를 생성하여 가능한 방법의 수를 세어줬습니다. <br>

## 코드

```python

def dfs(numbers, depth, here, target):
    if depth == len(numbers):
        return 1 if here == target else 0

    ret = 0
    for operand in [-numbers[depth], numbers[depth]]:
        ret += dfs(numbers, depth+1, here + operand, target)

    return ret


def solution(numbers, target):
    start = 0
    ans = dfs(numbers, 0, start, target)
    return ans

```
