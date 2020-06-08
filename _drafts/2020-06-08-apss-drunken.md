---
layout: post
title: ALGOSPOT 음주운전 단속
excerpt: "[알고리즘 문제 해결 전략] 도서 수록 문제 풀어보기(Python, C++)"
categories: [Algorithm]
tags: [Algorithm]
modified: 2020-05-16
comments: true
---

## 문제
[알고스팟 - 음주운전 단속](https://algospot.com/judge/problem/read/DRUNKEN)


## 풀이 과정
Python3 으로 제출해봤지만 도무지 시간 초과를 해결할 수 없어서 C++로 다시 풀어서 제출했습니다. <br>
 

## 코드

~~~ python

import sys

INF = sys.maxsize
V, E = list(map(int, sys.stdin.readline().split()))
police = list(zip(range(V), list(map(int, sys.stdin.readline().split()))))
police.sort(key=lambda x: x[1])

adj = [[INF] * V for _ in range(V)]
for _ in range(E):
    frm, to, weight = list(map(int, sys.stdin.readline().split()))
    adj[frm-1][to-1] = weight
    adj[to-1][frm-1] = weight

T = int(input())
test_case = []
for _ in range(T):
    test_case.append(list(map(int, sys.stdin.readline().split())))


def floyd():
    W = [[INF]*V for _ in range(V)]

    for u in range(V):
        for v in range(V):
            if u == v:
                W[u][v] = 0
            else:
                W[u][v] = adj[u][v]

    for k, delay in police:
        for u in range(V):
            if adj[u][k] != INF:
                for v in range(V):
                    adj[u][v] = min(adj[u][v], adj[u][k] + adj[k][v])
                    W[u][v] = min(W[u][v], adj[u][k] + adj[k][v] + delay)

    return W


def solution():
    W = floyd()
    for test in test_case:
        ans = W[test[0]-1][test[1]-1]
        print(ans)


solution()

~~~

~~~ C++

~~~

