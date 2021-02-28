---
layout: post
cover: "assets/images/cover2.jpg"
navigation: True
title: ALGOSPOT 선거 공약
date: 2020-06-25
tags: [알고리즘 문제해결 전략]
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: algorithm
comments: true
---

## 문제

[알고스팟 - 선거 공약](https://algospot.com/judge/problem/read/PROMISES)

## 풀이 과정

`플로이드 알고리즘` 을 활용하는 마지막 문제입니다. <br>
기존의 플로이드 알고리즘은 경유점을 하나씩 늘려가며 최단 거리를 갱신하는 방법을 사용합니다. <br>
하지만 여기서 경유점 대신에 그래프에 존재하는 모든 간선들을 하나씩 추가하며 최단 거리를 갱신하더라도 정당성은 변하지 않음을 알 수 있습니다. <br>
따라서 기존의 점화식을 다음과 같은 형태로 바꿔줍니다. <br>

> D(A, B) = min(D'(A, B), D'(A, u) + D'(v, B) + w(u, v), D'(A, v) + D'(u, B) + w(v, u))

이때 간선의 경우 정점과는 다르게 어느 방향으로 타고 가는지에 따라 값이 달라질 수 있으므로 위와 같이 3가지 상황을 고려해줘야 합니다. <br>

## 코드

```python

import sys

INF = sys.maxsize
adj = []


def update(u, v, c):
    if c >= adj[u][v]:
        return False

    for a in range(V):
        for b in range(V):
            adj[a][b] = min(adj[a][b], adj[a][u] + adj[v][b] + c, adj[a][v] + adj[u][b] + c)

    return True


if __name__ == '__main__':
    T = int(input())
    for _ in range(T):
        V, M, N = list(map(int, sys.stdin.readline().split()))
        adj = [[INF]*V for _ in range(V)]

        # 현재 존재하는 간선
        for _ in range(M):
            frm, to, weight = list(map(int, sys.stdin.readline().split()))
            adj[frm-1][to-1] = weight
            adj[to-1][frm-1] = weight

        # 자기 자신을 향하는 가중치는 0
        for i in range(V):
            adj[i][i] = 0

        ans = 0
        for _ in range(N):
            frm, to, weight = list(map(int, sys.stdin.readline().split()))
            if not update(frm-1, to-1, weight):
                ans += 1

        print(ans)

```
