---
layout: post
title: ALGOSPOT 트리 순회 순서 변경
excerpt: "[알고리즘 문제 해결 전략] 도서 수록 문제 풀어보기(Python)"
categories: [Algorithm]
tags: [알고리즘 문제해결 전략]
modified: 2020-07-19
comments: true
---


## 풀이 과정
트리의 중위 순회와 전위 순회 결과가 주어질 때, 이를 기반으로 후위 순회 결과를 만드는 문제입니다. <br>
우선 전위 순회의 결과에서 가장 앞에 있는 요소는 해당 트리의 루트 노드라는 사실을 알 수 있습니다. <br>
또한 중위 순회는 `왼쪽 서브트리 -> 루트노드 -> 오른쪽 서브트리` 순으로 순회를 하기 때문에 <br>
중위 순회 결과에서 루트 노드를 찾으면 그 양옆의 결과가 각각 `왼쪽 서브트리` 와 `오른쪽 서브트리` 의 순회 결과라는 사실을 알 수 있습니다.<br>
이를 통해 각 서브트리 노드의 개수를 알 수 있으므로 이를 전위 순회 결과에서 각 서브트리의 크기 만큼 배열을 잘라내면 잘려진 배열의 맨 앞 요소가 또한 각 서브트리의 루트 노드가 됩니다. <br>
이 과정을 재귀적으로 반복하면 우리가 찾는 `후위 순회` 결과를 얻을 수 있습니다.

## 코드

~~~ python

import sys


def post_order(pre_order, in_order, ans):
    if not pre_order:
        return

    root = pre_order[0]
    left_count = in_order.index(root)

    post_order(pre_order[1:left_count+1], in_order[:left_count], ans)
    post_order(pre_order[left_count+1:], in_order[left_count+1:], ans)

    ans.append(root)


def solution(pre_order, in_order):
    ans = []
    post_order(pre_order, in_order, ans)
    return ' '.join(map(str, ans))


if __name__ == '__main__':
    T = int(input())
    for _ in range(T):
        N = int(input())
        preorder = list(map(int, sys.stdin.readline().split()))
        inorder = list(map(int, sys.stdin.readline().split()))
        print(solution(preorder, inorder))

~~~
