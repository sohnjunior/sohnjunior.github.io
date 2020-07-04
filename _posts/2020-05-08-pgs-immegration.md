---
layout: post
title: 프로그래머스 Level 3 - 입국 심사
excerpt: "프로그래머스 Level 3 입국 심사 with Python"
categories: [Algorithm]
tags: [Programmers]
modified: 2020-05-08
comments: true
---

## 출처
[프로그래머스 - 입국 심사](https://programmers.co.kr/learn/courses/30/lessons/43238)


## 문제
`n` 명이 입국심사를 위해 줄을 서서 기다리고 있습니다. 각 입국심사대에 있는 심사관마다 심사하는데 걸리는 시간은 다릅니다. <br>

처음에 모든 심사대는 비어있습니다. 한 심사대에서는 동시에 한 명만 심사를 할 수 있습니다. <br>
가장 앞에 서 있는 사람은 비어 있는 심사대로 가서 심사를 받을 수 있습니다. <br>
하지만 더 빨리 끝나는 심사대가 있으면 기다렸다가 그곳으로 가서 심사를 받을 수도 있습니다. <br>

모든 사람이 심사를 받는데 걸리는 시간을 최소로 하고 싶습니다. <br>

입국심사를 기다리는 사람 수 `n`, 각 심사관이 한 명을 심사하는데 걸리는 시간이 담긴 배열 `times` 가 매개변수로 주어질 때, <br>
모든 사람이 심사를 받는데 걸리는 시간의 최솟값을 return 하도록 solution 함수를 작성해주세요. <br>


## 풀이 과정
이 문제는 입력값이 매우 크게 주어져 있기 때문에 일반적인 방법으로 탐색을 수행하면 타임 아웃이 발생하므로 다른 방법이 필요합니다. <br><br>

효율성을 고려하지 않고 처음 떠올린 해법은 `times` 배열과 크기가 같은 `jobs` 배열을 생성한 뒤, 해당 배열에는 현재 손님의 업무가 끝나는 시간을 기록하고 <br>
다음번 손님의 입국 심사대를 고를때는 각 심사대의 시간을 `jobs` 배열에 각각 더해본 다음 가장 짧은 심사대로 배치시키는 것입니다. <br>
하지만 이 방법은 배열의 크기에 비례하여 시간 복잡도가 증가하므로 보다 효울적인 탐색을 위해 `이진 탐색` 을 활용하기로 했습니다. <br>

최악의 경우 소요되는 시간은 얼마일까요? 그건 바로 모든 손님이 가장 느린 심사대에서 심사를 받는 것입니다. <br>
따라서 `hi` 를 이 값으로 설정해준 다음, `mid` 에 해당하는 시간에 손님을 전부 감당할 수 있다면 탐색 범위를 더 작은 쪽으로, <br>
만약 감당이 불가능하다면 탐색 범위를 더 큰 쪽으로 옮겨서 최적의 시간을 찾아냈습니다. <br>

이때 주어진 시간에 손님을 전부 처리할 수 있는지 확인하는 과정에서는 각 심사관마다 주어진 시간 내에 처리할 수 있는 손님의 수를 합해서 <br>
목표 손님수에 도달했다면 바로 `True` 를 반환하도록 하여 불필요한 탐색 시간을 줄였습니다. <br>

## 코드
~~~ python

def can_work(times, due, goal):
    for time in times:
        goal -= (due // time)
        if goal <= 0:
            return True
    return False


def solution(n, times):
    answer = 0
    lo = 1
    hi = n * max(times)

    while lo < hi:
        mid = (lo + hi) // 2
        if can_work(times, mid, n):
            answer = mid
            hi = mid
        else:
            lo = mid + 1

    return answer


n = 6
times = [7, 10]
print(solution(n, times))  # 답은 28

~~~

