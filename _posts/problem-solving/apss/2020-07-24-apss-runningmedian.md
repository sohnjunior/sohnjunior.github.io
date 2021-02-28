---
layout: post
cover: "assets/images/cover2.jpg"
navigation: True
title: ALGOSPOT 변화하는 중간 값
date: 2020-07-24
tags: [알고리즘 문제해결 전략]
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: algorithm
comments: true
---

## 풀이 과정

난수 생성기를 통해 각 입력이 주어질때마다 수열의 중간 값을 구해서 그 합을 구하는 문제입니다. <br>
이를 위해 생성되는 수열 `S` 를 두 구간으로 나눠서 생각하도록 합니다. <br>
정렬된 수열 `S` 를 나열했을 때 앞의 절반을 `최대 힙` 에 넣고 뒤에 절반을 `최소 힙` 에 넣으면 됩니다. <br>
중간값을 찾기 위한 규칙으로서 `최대 힙` 은 `최소 힙` 보다 작거나 같은 값을 가져야 하도록 하고 <br>
`최대 힙` 의 크기는 `최소 힙` 의 크기보다 1개 크거나 같게 한다면 중간 값은 항상 `최대 힙의 top` 이 됩니다. <br>

## 코드

```python

import sys
import heapq


def solution(N, a, b):
    max_pq = []
    min_pq = []
    rand = 1983
    ans = 0

    for i in range(N):
        # 최대힙이 비어있거나 같거나 작은 값이 들어오는 경우
        if not max_pq or -max_pq[0] >= rand:
            heapq.heappush(max_pq, -rand)
        # 그 외의 경우에는 최소힙에 넣어줍니다
        else:
            heapq.heappush(min_pq, rand)

        # 최대힙이 최소힙보다 1개 많거나 같다는 조건을 어길 경우 재조정해줍니다.
        if len(max_pq) - len(min_pq) > 1:
            heapq.heappush(min_pq, -heapq.heappop(max_pq))
        elif len(min_pq) - len(max_pq) >= 1:
            heapq.heappush(max_pq, -heapq.heappop(min_pq))

        rand = (rand * a + b) % 20090711
        ans = (ans + -max_pq[0]) % 20090711

    return ans


if __name__ == '__main__':
    T = int(input())
    for _ in range(T):
        N, a, b = list(map(int, sys.stdin.readline().split()))
        ans = solution(N, a, b)
        print(ans)

```
