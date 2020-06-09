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
이 문제는 최악의 경우에도 시간이 가장 적게 걸리는 경로를 찾아야합니다. <br>
단순히 경로의 길이가 짧다고 해서 최단 경로라는 보장이 없으므로 정점을 하나씩 늘려가면서 음주 단속에 따른 지연시간도 고려해줘야합니다. <br>
따라서 음주 운전 단속 시간이 짦은 정점의 오름차순으로 경유지를 추가하면서 계산되는 최단 경로값을 이용해 최종 도달 가능 시간을 계산해야합니다. <br>

이를 위해서 다음과 같은 새로운 점화식을 추가합니다. <br>

> W[u][v] = min(C[u][w] + C[w][v] + delay[w])

여기서 `w` 는 경유점으로 각 지점을 오름차순으로 검사하므로 최악의 경우에 대해 최단 경로값을 계산할 수 있게됩니다. <br> 
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
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

#define INF 987654321
int V, E;
int adj[500][500];
int W[500][500];
vector<int> polices;


void floyd() {
	vector<pair<int, int>> order;
	for (int i = 0; i < V; i++)
		order.push_back(make_pair(polices[i], i));
	sort(order.begin(), order.end());

	for (int i = 0; i < V; i++) {
		for (int j = 0; j < V; j++) {
			if (i == j) {
				adj[i][j] = 0;
				W[i][j] = 0;
			}
			else 
				W[i][j] = adj[i][j];
		}
	}


	for (int k = 0; k < V; k++) {
		int w = order[k].second;
		int delay = order[k].first;
		for (int u = 0; u < V; u++) {
			for (int v = 0; v < V; v++) {
				adj[u][v] = min(adj[u][v], adj[u][w] + adj[w][v]);
				W[u][v] = min(W[u][v], adj[u][w] + adj[w][v] + delay);
			}
		}
	}
}


int main() {
	cin >> V >> E;
	polices = vector<int>(V, 0);
	for (int i = 0; i < V; i++)
		cin >> polices[i];

	fill(&adj[0][0], &adj[499][500], INF);

	for (int i = 0; i < E; i++) {
		int frm, to, weight;
		cin >> frm >> to >> weight;

		adj[frm-1][to-1] = weight;
		adj[to-1][frm-1] = weight;
	}

	floyd();

	int T;
	cin >> T;
	for (int test = 0; test < T; test++) {
		int start, end;
		cin >> start >> end;

		cout << W[start-1][end-1] << endl;
	}


	return  0;
}
~~~

