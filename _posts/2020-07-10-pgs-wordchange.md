---
layout: post
title: 프로그래머스 Level 3 - 단어 변환
excerpt: "프로그래머스 Level 3 단어 변환 with Python"
categories: [Algorithm]
tags: [Programmers]
modified: 2020-07-10
comments: true
---

## 문제
[프로그래머스 - 단어 변환](https://programmers.co.kr/learn/courses/30/lessons/43163)


## 풀이 과정
시작 단어에서 목표 단어로 변형하는 최단 경로(비용)을 찾는 문제입니다. <br>
각 단어는 최대 한 문자만 변경이 가능하고 주어진 리스트에 포함된 단어일 경우에만 해당 단어로 변환을 시도해볼 수 있습니다. <br>
따라서 각 탐색마다 단어의 자리수를 하나씩 탐색하여 `a to z` 중 변환이 가능한 단어가 있는지 따져줍니다. <br>
이때 Python 에서는 `ord & chr` 를 통해서 문자의 아스키코드 값을 활용할 수 있는데 문자열을 쉽게 처리하기 위해 활용하였습니다. <br>
또한 중복된 변환을 피하기 위해 `visit` 은 딕셔너리로 선언하여 `문자열 해싱` 을 통해 이미 변환을 시도했던 단어인지 효율적으로 판단하도록 했습니다. <br> 

## 코드
~~~ python

from collections import deque


def bfs(start, goal, words):
    q = deque()
    visit = dict.fromkeys(words, 0)
    
    q.append((start, 0))
    
    while q:
        here, cost = q.popleft()
        if here == goal:
            return cost
        
        # 각 자리를 순회하며 알파벳 하나를 변경해 만들 수 있는 단어를 탐색해봅니다.
        for i, c in enumerate(here):
            for j in range(ord('a'), ord('z')+1):
                if i != chr(j):
                    new_word = here[:i] + chr(j) + here[i+1:]
                    # 새로 만들어진 단어가 후보 리스트에 존재한다면
                    if new_word in words and not visit[new_word]:
                        visit[new_word] = 1
                        q.append((new_word, cost + 1))
            
    return 0


def solution(begin, target, words):
    ans = bfs(begin, target, words)
    return ans

~~~

