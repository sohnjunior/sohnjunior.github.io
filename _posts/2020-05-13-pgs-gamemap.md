---
layout: post
title: 프로그래머스 Level 4 - 게임 맵 최단거리
excerpt: "프로그래머스 Level 4 게임 맵 최단거리 with Python"
categories: [Algorithm]
tags: [Programmers]
modified: 2020-05-13
comments: true
---

## 출처
[프로그래머스 - 게임 맵 최단거리](https://programmers.co.kr/learn/courses/30/lessons/43238)


## 문제
ROR 게임은 두 팀으로 나누어서 진행하며, 상대 팀 진영을 먼저 파괴하면 이기는 게임입니다. <br>
따라서, 각 팀은 상대 팀 진영에 최대한 빨리 도착하는 것이 유리합니다. <br>

지금부터 당신은 한 팀의 팀원이 되어 게임을 진행하려고 합니다. <br>
다음은 5 x 5 크기의 맵에, 당신의 캐릭터가 (행: 1, 열: 1) 위치에 있고, 상대 팀 진영은 (행: 5, 열: 5) 위치에 있는 경우의 예시입니다. <br>

![이미지](/img/programmers/gamemap.png){: width="170"}

위 그림에서 검은색 부분은 벽으로 막혀있어 갈 수 없는 길이며, 흰색 부분은 갈 수 있는 길입니다. <br>
캐릭터가 움직일 때는 동, 서, 남, 북 방향으로 한 칸씩 이동하며, 게임 맵을 벗어난 길은 갈 수 없습니다. <br>
만약, 상대 팀이 자신의 팀 진영 주위에 벽을 세워두었다면 상대 팀 진영에 도착하지 못할 수도 있습니다. <br>
게임 맵의 상태 maps가 매개변수로 주어질 때, 캐릭터가 상대 팀 진영에 도착하기 위해서 지나가야 하는 칸의 개수의 최솟값을 return 하도록 solution 함수를 완성해주세요. <br>
단, 상대 팀 진영에 도착할 수 없을 때는 -1을 return 해주세요. <br>

## 풀이 과정
`BFS` 를 통해 목표지점까지의 최단 거리를 탐색하는 문제이다. <br>
방문여부와 거리 정보를 저장히기 위해서 딕셔너리 자료형을 사용할수도 있지만 게임맵과 동일한 이차원 배열을 선언해서 <br> 
-1일 경우는 아직 방문하지 않은 지점, 그 외의 경우는 이미 방문해서 최단 경로를 구한 지점으로 판단하도록 했다. <br>
이렇게 하면 트리 탐색시간을 절약할 수 있어서 더 빠른 수행시간을 가지게 된다. <br>

## 코드
~~~ python

from collections import deque


dx = [0, 0, 1, -1]
dy = [1, -1, 0, 0]


def bfs(maps, start):
    N, M = len(maps), len(maps[0])
    q = deque()

    dist = [[-1 for _ in range(M)] for _ in range(N)]
    goal = (N-1, M-1)

    q.append(start)
    dist[start[0]][start[1]] = 1

    while q:
        here = q.popleft()
        if here[0] == goal[0] and here[1] == goal[1]:
            return dist[here[0]][here[1]]

        for i in range(4):
            next_x, next_y = here[0] + dx[i], here[1] + dy[i]
            if 0 <= next_x < N and 0 <= next_y < M:
                if maps[next_x][next_y] != 0 and dist[next_x][next_y] == -1:
                    dist[next_x][next_y] = dist[here[0]][here[1]] + 1
                    q.append((next_x, next_y))
    return -1


def solution(maps):
    answer = bfs(maps, (0, 0))
    return answer


maps = [[1,0,1,1,1],[1,0,1,0,1],[1,0,1,1,1],[1,1,1,0,0],[0,0,0,0,1]]
print(solution(maps))

~~~

