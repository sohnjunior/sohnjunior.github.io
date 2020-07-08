---
layout: post
title: ALGOSPOT 소방차
excerpt: "[알고리즘 문제 해결 전략] 도서 수록 문제 풀어보기(Python, C++)"
categories: [Algorithm]
tags: [알고리즘 문제해결 전략]
modified: 2020-05-16
comments: true
---

## 문제
[알고스팟 - 소방차](https://algospot.com/judge/problem/read/FIRETRUCKS)


## 풀이 과정
도서에도 나와있듯이 입력의 크기가 크기 때문에 각 소방서 혹은 화재 지점을 기준으로 최단경로를 계산해서 답을 구하면 시간 초과가 발생한다. <br>
따라서 이를 대신해 각 화재 지점에 도달할 수 있는 최단 경로를 구하는 방법을 생각해내야 한다. <br>
다익스트라 알고리즘이 한 정점으로부터 다른 모든 정잠까지의 최단 경로를 구하는 알고리즘이므로 우리는 모든 소방서와 연결되어있는 임의의 정점을 생성한 뒤 <br>
해당 정점으로부터 다른 모든 정점까지의 최단 경로를 구하면 임의의 소방서로부터 해당 화재 지점에 도달하는 최단 경로를 구할 수 있다. <br>
단, 이를 위해서는 임의의 정점과 소방서들간의 거리 비용을 0으로 해야한다. <br>

다음은 임의의 그래프를 기준으로 위의 알고리즘 동작 과정을 도식화한 것이다.

![이미지](/img/apss/firetrucks.png){: width="500"}

실제 구현에서는 정점의 번호가 1번부터 시작하므로 0번 정점을 각 소방서와 인접해있는 임의의 정점으로 사용했다. <br>

## 코드

~~~ python

import sys
from queue import PriorityQueue


def dijkstra(graph, V):
    pq = PriorityQueue()
    pq.put((0, 0))  # 0번 정점에서 시작하는 다익스트라
    dist = [sys.maxsize for _ in range(V+1)]

    while not pq.empty():
        here = pq.get()

        if here[0] > dist[here[1]]:
            continue

        for next, cost in graph[here[1]]:
            nextDist = here[0] + cost
            if nextDist < dist[next]:
                dist[next] = nextDist
                pq.put((nextDist, next))

    return dist


if __name__ == '__main__':
    testcase = int(input())
    for case in range(testcase):
        V, E, n, m = list(map(int, sys.stdin.readline().split()))

        adj = [[] for _ in range(1001)]
        for e in range(E):
            frm, to, cost = list(map(int, sys.stdin.readline().split()))
            adj[frm].append((to, cost))  # (to, cost)
            adj[to].append((frm, cost))

        fires = list(map(int, sys.stdin.readline().split()))
        station = list(map(int, sys.stdin.readline().split()))

        # 각 소방서와 임의의 정점(0번 정점)과의 연결
        for s in station:
            adj[0].append((s, 0))
            adj[s].append((0, 0))

        cost = dijkstra(adj, V)
        ret = 0
        for fire in fires:
            ret += cost[fire]
        print(ret)

~~~


