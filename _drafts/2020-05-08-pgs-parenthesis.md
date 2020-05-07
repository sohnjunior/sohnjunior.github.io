---
layout: post
title: 프로그래머스 Level 4 - 올바른 괄호의 개수
excerpt: "프로그래머스 Level 4 올바른 괄호의 개수 with Python"
categories: [Algorithm]
tags: [Algorithm]
modified: 2020-05-08
comments: true
---

## 출처
[프로그래머스 - 올바른 괄호의 개수](https://programmers.co.kr/learn/courses/30/lessons/17676)


## 문제



## 풀이 과정
(의 개수와 )의 개수가 같을 경우에는 무조건 ( 가 배치되어야 하고 
(가 더 적을 경우에는 (나 )나 상관 없다는 점을 활용하였다. 
이를 도식화하면 다음과 같다.

괄호를 다 사용했을 경우 1을 반환해서 총 가능한 경우의 수를 세줬다.

## 코드
~~~ python

def dfs(left, right):
    if left == 0 and right == 0:
        return 1

    ret = 0
    if left == right:
        ret += dfs(left-1, right)
    else:
        if left >= 1:
            ret += dfs(left-1, right)
        if right >= 1:
            ret += dfs(left, right-1)

    return ret


def solution(n):
    answer = dfs(n, n)
    return answer


n = 2
print(solution(n))

~~~

