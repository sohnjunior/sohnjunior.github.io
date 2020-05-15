---
layout: post
title: ALGOSPOT 신호 라우팅
excerpt: "[알고리즘 문제 해결 전략] 도서 수록 문제 풀어보기(Python, C++)"
categories: [Algorithm]
tags: [Algorithm]
modified: 2020-05-14
comments: true
---

## 문제
[알고스팟 - 신호 라우팅](https://algospot.com/judge/problem/read/ROUTING)


## 풀이 과정
간선의 가중치가 모두 양수이므로 다익스트라 알고리즘을 활용해서 시작 정점으로부터 모든 정점까지의 최단 거리를 구하면 된다. <br>
64MB의 메모리 제한이 있어서 V*V 크기의 인접 행렬로 그래프를 표현하면 메모리 초과 오류가 발생한다. <br>

Python으로 풀어봤지만 도무지 시간 초과를 해결할 수 없어서 C++로 다시 제출한 문제이다. <br>
C++로 구현할때 최단거리 INF 값을 double형으로 안해주니까 정수형과 실수형간의 값 비교 과정에서 문제가 발생한 것인지 제출 시 오답이 발생했다. <br>

책에는 가중치 곱을 로그 덧셈으로 바꿔서 계산해줬지만 그냥 곱셈으로해도 어차피 결과는 같게 나온다. <br>

## 코드
### Python
~~~ python

import sys
from queue import PriorityQueue


def dijkstra(graph, n, start):
    pq = PriorityQueue()
    dist = [sys.maxsize for _ in range(n)]
    dist[start] = 1
    pq.put((1, start))

    while not pq.empty():
        here = pq.get()

        if here[0] > dist[here[1]]:
            continue

        for there, cost in graph[here[1]]:
            nextDist = here[0] * cost
            if nextDist < dist[there]:
                dist[there] = nextDist
                pq.put((nextDist, there))

    return dist[n-1]


if __name__ == '__main__':
    testcase = int(input())
    for case in range(testcase):
        n, m = list(map(int, sys.stdin.readline().split()))
        adj = [[] for _ in range(n)]
        for _ in range(m):
            frm, to, noise = sys.stdin.readline().split()
            adj[int(frm)].append([int(to), float(noise)])
            adj[int(to)].append([int(frm), float(noise)])

        print(dijkstra(adj, n, 0))

~~~

### C++
~~~ c++
#include <iostream>
#include <vector>
#include <queue>
#include <limits>
using namespace std;

const double INF = numeric_limits<double>::max();

vector<pair<double, int>> adj[10000];


double dijkstra(int n, int start) {
	vector<double> dist(n, INF);
	priority_queue<pair<double, int>> pq;
	pq.push(make_pair(-1.0, 0));
	dist[start] = 1.0;

	while (!pq.empty()) {
		double cost = -pq.top().first;
		int here = pq.top().second;	pq.pop();

		if (cost > dist[here])
			continue;

		for (int i = 0; i < adj[here].size(); i++) {
			int there = adj[here][i].second;

			double nextDist = cost * adj[here][i].first;
			if (nextDist < dist[there]) {
				dist[there] = nextDist;
				pq.push(make_pair(-nextDist, there));
			}
		}
	}

	return dist[n - 1];
}

int main() {
	int testcase;
	cin >> testcase;

	for (int i = 0; i < testcase; i++) {
		int n, m;
		cin >> n >> m;

		for (int i = 0; i < n; i++)
			adj[i].clear();

		for (int i = 0; i < m; i++) {
			int from, to;
			double noise;
			cin >> from >> to >> noise;

			adj[from].push_back(make_pair(noise, to));
			adj[to].push_back(make_pair(noise, from));
		}

		cout << fixed;
		cout.precision(10);
		cout << dijkstra(n, 0) << endl;
	}

	return 0;
}
~~~
