---
layout: post
title: ALGOSPOT 재하의 금고
excerpt: "[알고리즘 문제 해결 전략] 도서 수록 문제 풀어보기(Python)"
categories: [Algorithm]
tags: [알고리즘 문제해결 전략]
modified: 2020-07-06
comments: true
---


## 풀이 과정
문자열 검색 알고리즘인 `KMP` 를 응용하여 환형 시프트 연산을 구현하는 문제입니다. <br>
원본 문자열 `H` 를 시계 방향 혹은 반시계 방향으로 shift한 문자열이 `N` 일 때, 그 횟수를 구하는 가장 간단한 방법은 `H(혹은 N) 에서 N(혹은 H) 를 찾는 것` 입니다. 
이를 위해서 부분 일치 테이블과 kmp 알고리즘을 구현 한 뒤, 가장 처음 매칭되는 인덱스 값이 곧 필요한 이동 횟수이므로 이 값을 누적하여 계산하면 됩니다. <br>


## 코드

~~~ python

import sys


def partial(N):
    pi, matched = [0] * len(N), 0

    for i in range(1, len(N)):
        while matched > 0 and N[i] != N[matched]:
            matched = pi[matched-1]

        if N[i] == N[matched]:
            matched += 1
            pi[i] = matched

    return pi


def kmp(H, N):
    pi, ret, matched = partial(N), [], 0

    for i in range(len(H)):
        while matched > 0 and H[i] != N[matched]:
            matched = pi[matched-1]

        if H[i] == N[matched]:
            matched += 1
            if matched == len(N):
                ret.append(i - len(N) + 1)
                matched = pi[matched-1]

    return ret


if __name__ == '__main__':
    T = int(input())
    for _ in range(T):
        N = int(input())
        before = sys.stdin.readline().strip()
        ans = 0
        for i in range(N):
            after = sys.stdin.readline().strip()
            if i % 2:
                # 짝수 번째 - 반시계 방향
                ans += kmp(before * 2, after)[0]
            else:
                # 홀수 번째 - 시계 방향
                ans += kmp(after * 2, before)[0]
            before = after
        print(ans)


~~~
