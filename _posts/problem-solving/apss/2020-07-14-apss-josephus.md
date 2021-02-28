---
layout: post
cover: "assets/images/cover2.jpg"
navigation: True
title: ALGOSPOT 조세푸스 문제
date: 2020-07-14
tags: [알고리즘 문제해결 전략]
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: algorithm
comments: true
---

## 풀이 과정

`연결 리스트` 를 활용한 유명한 문제중 하나인 조세푸스 문제입니다. <br>
Python의 경우 내장된 `list` 가 연결 리스트의 기능을 포함하고 있어서 이를 활용하였습니다. <br>
각 병사들이 원형으로 둘러싸여 있기 때문에 환형 리스트 연산이 필요하여 `모듈러 연산` 을 사용해서 인덱스를 계산해줬습니다. <br>

## 코드

```python

import sys


def solution(N, K):
    soilders = [i+1 for i in range(N)]

    kill = 0
    while len(soilders) > 2:
        soilders.pop(kill)

        kill += (K-1)
        kill %= len(soilders)

    return ' '.join(map(str, soilders))


if __name__ == '__main__':
    T = int(input())
    for _ in range(T):
        N, K = list(map(int, sys.stdin.readline().split()))
        ans = solution(N, K)
        print(ans)

```
