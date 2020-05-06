---
layout: post
title: 프로그래머스 Level 4 - 쿠키 구입
excerpt: "프로그래머스 Level 4 쿠키 구입 with Python"
categories: [Algorithm]
tags: [Algorithm]
modified: 2020-05-03
comments: true
---

## 출처
[프로그래머스 - 쿠키 구입](https://programmers.co.kr/learn/courses/30/lessons/17676)


## 문제



## 풀이 과정



## 코드
~~~ python



def partial_sum(arr):
    psum = [0 for _ in range(len(arr))]
    psum[0] = arr[0]

    for i in range(1, len(arr)):
        psum[i] = psum[i-1] + arr[i]
    return psum


def solution(cookie):
    answer = 0

    buckets = len(cookie)
    partial = partial_sum(cookie)
    limit = partial[-1] // 2

    # 첫번째 아들 기준으로 탐색
    for l in range(buckets-1):
        for m in range(l, buckets-1):
            if l == m:
                first = cookie[l]
            else:
                first = partial[m] - partial[l] + cookie[l]
            if first > limit:
                break
            if first <= answer:
                continue
            for r in range(m+1, buckets):
                second = partial[r] - partial[m]
                if second <= answer:
                    continue
                if first < second:
                    break
                elif first == second and first > answer:
                    answer = first
    return answer


cookie = [1, 1, 2, 3]
print(solution(cookie))

~~~

