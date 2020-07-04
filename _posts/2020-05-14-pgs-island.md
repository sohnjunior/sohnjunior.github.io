---
layout: post
title: 프로그래머스 Level 3 - 섬 연결하기
excerpt: "프로그래머스 Level 3 섬 연결하기 with Python"
categories: [Algorithm]
tags: [Programmers]
modified: 2020-05-14
comments: true
---

## 문제
[프로그래머스 - 섬 연결하기](https://programmers.co.kr/learn/courses/30/lessons/42861)


## 풀이 과정
모든 정점을 연결하는 최소 신장 트리(MST)를 구하는 문제이다. <br>
프림과 크루스칼 알고리즘을 활용할 수 있는데 이번에는 크루스칼을 사용했다. <br>
크루스칼 알고리즘은 간선 정보들을 오름차순으로 정렬해준 다음, 사이클을 형성하지 않는 간선들을 탐욕적으로 선택해준다. <br>
이를 위한 union-find 자료구조만 신경써서 구현하면 무난히 풀 수 있는 문제이다. <br>

## 코드
~~~ python

def union(p, u, v):
    u, v = find(p, u), find(p, v)
    if u == v:
        return
    p[u] = v


def find(p, u):
    if p[u] == u:
        return u
    p[u] = find(p, p[u])
    return p[u]


def kruskal(v, edges):
    answer = 0
    parent = [i for i in range(v)]
    edges.sort(key=lambda x: x[2])

    for edge in edges:
        # 이미 같은 컴포넌트라면 pass
        u, v = find(parent, edge[0]), find(parent, edge[1])
        if u == v:
            continue

        union(parent, u, v)
        answer += edge[2]
    return answer


def solution(n, costs):
    answer = kruskal(n, costs)
    return answer


n = 5
costs = [
    [0, 1, 1],
    [1, 2, 2],
    [3, 4, 3],
    [2, 3, 7],
]
print(solution(n, costs))

~~~

