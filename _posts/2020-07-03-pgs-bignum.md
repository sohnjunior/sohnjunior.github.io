---
layout: post
title: 프로그래머스 Level 2 - 큰 수 만들기
excerpt: "프로그래머스 Level 2 큰 수 만들기 with Python"
categories: [Algorithm]
tags: [Programmers]
modified: 2020-07-03
comments: true
---

## 문제
[프로그래머스 - 큰 수 만들기](https://programmers.co.kr/learn/courses/30/lessons/42883)


## 풀이 과정
k 개의 숫자를 제거하여 만들 수 있는 수 중에서 가장 큰 수를 찾는 문제입니다. <br>
만약 `브루트 포스` 로 접근해 모든 조합을 만들어 본다면 최대 문자열의 길이 때문에 시간내에 수행이 불가능합니다. <br>
대신에 큰 수를 구성하기 위한 조건으로 각 숫자를 `탐욕적인 선택` 에 따라 제거해준다면 선형 시간내에 수행이 가능합니다. <br><br>

이를 위해서는 `탐욕적인 선택` 에 따라 우리가 절대 손해보는 일이 없음을 증명해야합니다. <br>
어떤 숫자가 가장 큰 수가 되기 위해서는 가장 높은 자리수부터 큰 수를 가져야함은 자명합니다. <br>
따라서 우리는 큰 자리수 부터 탐색을 수행하며 (인덱스로 따지면 0 부터) 가장 큰 수가 되기 위한 각 숫자들의 정당성을 따져도록 합니다. <br>
어떤 수를 제거한다는 의미는 제거되는 숫자 다음 자리수가 해당 자리수를 대체한다는 의미입니다. <br>
따라서 숫자가 제거된 후 전체 자리수가 하나 줄어든 상황에서 가장 큰 수를 유지하기 위해서는 제거되는 숫자 다음에 오는 수가 해당 수보다 커야합니다. <br>
그러므로 `스택` 을 통해 각 자리수를 저장하면서 현재 `top` 에 존재하는 수보다 큰 수가 입력으로 들어올 경우 `pop` 연산을 통해 `top` 에는 항상 가장 큰 수가 유지되도록 해줍니다. <br>
이때 `pop` 되는 횟수가 목표 제거 횟수에 미치지 못할 경우 현재 숫자는 내림차순으로 구성되어있기 때문에 뒷 자리부터 부족한 개수 만큼 제거해주면 되는 것입니다. <br>

## 코드
~~~ python

def solution(number, k):
    stack = []
    pop_count = 0

    for num in number:
        if not stack or stack[-1] >= num:
            stack.append(num)
        elif stack[-1] < num:
            while pop_count < k and stack and stack[-1] < num:
                stack.pop()
                pop_count += 1
            stack.append(num)

    if pop_count < k:
        for _ in range(k-pop_count):
            stack.pop()

    return ''.join(stack)


number = '1924'
k = 2

print(solution(number, k))  # 94

~~~

