---
layout: post
title: 프로그래머스 Level 3 - 네트워크
excerpt: "프로그래머스 Level 3 네트워크 with Python"
categories: [Algorithm]
tags: [Programmers]
modified: 2020-07-10
comments: true
---

## 문제
[프로그래머스 - 네트워크](https://programmers.co.kr/learn/courses/30/lessons/43162)


## 풀이 과정
주어진 인접행렬을 기반으로 그래프 내의 컴포넌트 개수를 세는 문제입니다. <br>
각 정점별로 `DFS` 탐색을 통해 방문 가능한 모든 정점을 방문해주면 해당 정점이 속한 컴포넌트를 구할 수 있습니다. <br>
따라서 총 `DFS` 탐색이 몇번 수행되었는지 파악한다면 네트워크의 개수를 구할 수 있습니다. <br>


## 코드
~~~ python

def dfs(n, adj, visit, here):
    visit[here] = 1
    
    for there in range(n):
        if adj[here][there] and not visit[there]:
            dfs(n, adj, visit, there)
        
        
def solution(n, computers):
    visit = [0 for _ in range(n)]

    network = 0
    for v in range(n):
        if not visit[v]:
            dfs(n, computers, visit, v)
            network += 1
    
    return network

~~~

