---
layout: post
title: ALGOSPOT 요새
excerpt: "[알고리즘 문제 해결 전략] 도서 수록 문제 풀어보기(Python)"
categories: [Algorithm]
tags: [알고리즘 문제해결 전략]
modified: 2020-07-23
comments: true
---


## 풀이 과정
각 요새의 성벽을 트리의 노드라고 한다면 문제에서 요구하는 답은 가장 거리가 먼 두 노드 사이의 거리값을 찾는 문제가 됩니다. <br>
따라서 각 원 사이의 거리 관계를 기준으로 포함 관계를 파악한 뒤, 트리를 형성해줍니다. <br>
트리에서 거리값이 가장 먼 두 노드 사이의 거리를 구하기 위해서는 전역 변수 `longest` 를 유지하며 트리의 높이를 구함과 동시에 `잎 - 잎 노드 사이의 거리 최대값` 을 구합니다.<br>
최종적으로 `트리의 높이` 와 `잎-잎 노드 사이의 거리 최대값` 중 더 큰 값이 두 노드 사이의 거리의 최대값이 됩니다. <br>

## 코드

~~~ python

import sys


longest = 0
walls = []


class TreeNode:
    def __init__(self):
        self.child = []


def dist(a, b):
    return (walls[a][0] - walls[b][0]) ** 2 + (walls[a][1] - walls[b][1]) ** 2


def include(a, b):
    return walls[a][2] > walls[b][2] and dist(a, b) < (walls[a][2] - walls[b][2]) ** 2


def is_child(parent, child):
    if not include(parent, child):
        return False

    for i in range(len(walls)):
        if i != parent and i != child:
            if include(i, child) and include(parent, i):
                return False

    return True


def make_tree(root):
    ret = TreeNode()

    for v in range(len(walls)):
        if is_child(root, v):
            ret.child.append(make_tree(v))

    return ret


def height(root):
    global longest

    # 자식들 중에서 가장 높이값이 큰 2개를 고른다
    heights = []
    for child in root.child:
        heights.append(height(child))

    if not heights:
        return 0

    heights.sort(reverse=True)

    if len(heights) >= 2:
        longest = max(longest, heights[0] + heights[1] + 2)

    return heights[0] + 1


def solution():
    # 트리를 생성합니다.
    root = make_tree(0)

    # 트리의 가장 긴 경로를 구합니다.
    h = height(root)
    return max(longest, h)


if __name__ == '__main__':
    T = int(input())
    for _ in range(T):
        N = int(input())
        walls = [list(map(int, sys.stdin.readline().split())) for _ in range(N)]

        longest = 0
        ans = solution()
        print(ans)

~~~
