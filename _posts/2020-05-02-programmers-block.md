---
layout: post
title: 프로그래머스 Level 3 - 블록 이동하기
excerpt: "프로그래머스 Level 3 블록 이동하기 with Python"
categories: [Algorithm]
tags: [Algorithm]
modified: 2020-05-01
comments: true
---

## 출처
[프로그래머스 - 블록 이동하기](https://programmers.co.kr/learn/courses/30/lessons/60063)


## 문제
![이미지](/img/programmers/block.jpg){: width="300"}
<br>
무지는 `N×N`크기의 지도 위에서 `2×1`크기의 로봇을 이동하여 목표지점에 도달할 수 있도록 프로그램을 구현하고자 한다. <br>
로봇은 항상 `(1,1)`에서 시작하며 로봇이 차지하고 있는 칸중 어느 하나라도 `(N,N)`위치에 도달하면 된다. <br>
로봇이 움직일때는 현재 상태를 유지하며 이동하고 다음 조건에 따라 90도씩 회전 연산도 가능하다. <br><br><br>
![이미지](/img/programmers/block-rotate.jpg){: width="300"}
<br>
0과 1로 이루어진 지도인 board가 주어질 때, 로봇이 `(N,N)` 위치까지 이동하는데 필요한 최소 시간을 return 하도록 solution 함수를 완성하라.

## 풀이 과정
로봇이 이동할 수 있는 모든 경우를 따져보며 탐색을 수행하면 된다. <br>
최단 경로를 찾으면 바로 탐색을 종료하면되므로 같은 depth의 상태들을 탐색하기 위해 `BFS`를 사용했다. <br>

다만 로봇의 상태와 회전 연산을 구현하는 부분이 매우 까다로웠다..

### 로봇의 상태 나타내기
처음에는 `board`에 로봇의 상태를 표시해주며 이를 탐색에 활용하였지만 얼마 지나지 않아 이 방법이 굉장히 비효율적이라는 것을 알게 되었다. <br>
어차피 `board`는 고정이고 우리는 로봇의 위치만 변경시키면서 탐색을 수행하면 되므로 `board` 대신 로봇의 죄표값을 통해 탐색을 수행하도록 하였다.<br>

> 문제 풀이 후 다른 사람들의 코드도 봤는데 `visited` 배열을 따로 유지하고 Queue에 걸린 시간을 좌표값과 함께 넣어준 것이 인상적이었다. <br> 이렇게 하면 hashable 객체로 바꿔서 딕셔너리에 넣으려고 굳이 list를 tuple로 변경하지 않아도 될 것 같다.

### 로봇 회전시키기
이번 문제에서 가장 까다로웠던 회전 연산을 구현하기 위해서는 상,하,좌,우 이동과 4가지의 회전 연산을 모두 체크해줘야한다.

상하좌우 좌표값들을 검사하는건 다른 문제들과 다른 것이 없지만 회전 연산이 가능한지는 어떻게 알 수 있을까? <br>

생각해보면 회전 연산을 위해서는 회전하고 싶은 방향이 무조건 모두 비어있는 상태여야 한다는 것을 알 수 있다.<br> 
아래와 같이 한군데라도 벽이 있다면 그 쪽으로는 회전이 불가능하다.<br><br>
![이미지](/img/programmers/block-example.png){: width="300"}

따라서 나는 이전에 상,하,좌,우 중에서 이동이 가능했던 연산들을 저장해놓은 다음, 그에 맞는 회전 죄표값들을 생성해줬다. <br>

> 이때 주의할 점은 나의 구현 방식을 기준으로 회전된 좌표값은 로봇의 두 좌표중 항상 왼쪽 or 상단의 좌표가 먼저 나오도록 생성해줘야 한다는 것이다. <br>이거 때문에 처음에 계속 실패했었다..


## 코드
~~~ python

from collections import deque


dx = [0, 0, 1, -1]
dy = [1, -1, 0, 0]


def move(board, here):
    N = len(board)
    movable = []
    movable_dir = []  # 이동 가능한 방향
    # 상하좌우
    for i in range(4):
        next = [0, 0, 0, 0]
        next[0] = here[0] + dx[i]
        next[1] = here[1] + dy[i]
        next[2] = here[2] + dx[i]
        next[3] = here[3] + dy[i]

        if next[0] < 0 or next[0] >= N or next[1] < 0 or next[1] >= N:
            continue
        if next[2] < 0 or next[2] >= N or next[3] < 0 or next[3] >= N:
            continue
        if board[next[0]][next[1]] == 1 or board[next[2]][next[3]] == 1:
            continue
        movable.append(tuple(next))
        movable_dir.append(i)
    # 회전
    axis1 = here[:2]
    axis2 = here[2:]

    # 가로로 놓여있을 경우
    if axis1[0] == axis2[0]:
        # 아래가 다 비어서 이동 가능할 경우
        if 2 in movable_dir:
            there1 = axis1 + (axis2[0] + 1, axis2[1] - 1)
            there2 = axis2 + (axis1[0] + 1, axis1[1] + 1)
            movable.append(there1)
            movable.append(there2)
        # 위에가 다 비어서 이동 가능할 경우
        if 3 in movable_dir:
            there1 = (axis2[0] - 1, axis2[1] - 1) + axis1
            there2 = (axis1[0] - 1, axis1[1] + 1) + axis2
            movable.append(there1)
            movable.append(there2)
    # 세로로 놓여있을 경우
    else:
        # 오른쪽이 다 비어서 이동 가능할 경우
        if 0 in movable_dir:
            there1 = axis1 + (axis2[0] - 1, axis2[1] + 1)
            there2 = axis2 + (axis1[0] + 1, axis1[1] + 1)
            movable.append(there1)
            movable.append(there2)
        # 왼쪽이 다 비어서 이동 가능할 경우
        if 1 in movable_dir:
            there1 = (axis2[0] - 1, axis2[1] - 1) + axis1
            there2 = (axis1[0] + 1, axis1[1] - 1) + axis2
            movable.append(there1)
            movable.append(there2)

    return movable


def solution(board):
    # 처음 로봇 위치
    start = (0, 0, 0, 1)

    N = len(board)
    cost = {}  # 걸린 시간
    q = deque()

    cost[start] = 0
    q.append(start)

    while True:
        here = q[0]
        q.popleft()
        if here[0] == N-1 and here[1] == N-1 or here[2] == N-1 and here[3] == N-1:
            answer = cost[here]
            break

        move_list = move(board, here)
        for there in move_list:
            if there not in cost:
                cost[there] = cost[here] + 1
                q.append(there)

    return answer


board = [[0, 0, 0, 0, 0],[1, 1, 1, 0, 0],[1, 1, 1, 1, 0],[1, 1, 1, 1, 0],[1, 1, 1, 0, 0]]
print(solution(board))  # 결과는 7

~~~

