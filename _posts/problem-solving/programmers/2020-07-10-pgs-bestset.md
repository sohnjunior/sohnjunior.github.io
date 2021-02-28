---
layout: post
cover: "assets/images/cover2.jpg"
navigation: True
title: 프로그래머스 Level 3 - 최고의 집합
date: 2020-07-10
tags: Programmers
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: algorithm
comments: true
---

## 문제

[프로그래머스 - 최고의 집합](https://programmers.co.kr/learn/courses/30/lessons/12938)

## 풀이 과정

자연수 n 개를 사용해서 총합이 S가 되며 동시에 각 원소의 곱이 최대인 집합을 `최고의 집합` 이라고 표현합니다. <br>
입력으로 주어지는 합 S가 1억이고 자연수 n의 개수는 최대 10,000 이기 때문에 모든 조합을 만들어보는 방법은 시간내에 수행이 불가능합니다. <br><br>

좀 더 효율적인 방법은 없을까요? 바로 `탐욕적인 선택` 으로 최적의 답을 구할 수 있습니다. 이를 증명하기 위해 다음과 같이 생각해봤습니다. <br>
우선 총 k 개의 j 합이 S 를 만족한다고 가정하겠습니다. <br>

{% raw %}
j j j ... j => 총 k 개이며 합이 S, 따라서 j\*k = S
{% endraw %}

합이 S가 되는 숫자의 조합은 상당히 다양하므로 이번에는 j에 임의의 양의 정수 l 만큼 값이 차이가 나는 경우를 따져보겠습니다. <br>

{% raw %}
j-l j j j .... j+l => 합은 여전히 S
{% endraw %}

이 경우 모든 원소의 합이 S 이기 때문에 한 원소에서 l 만큼 감소했으므로 다른 원소에서 l 만큼 값이 더해졌을 것입니다. <br>
그렇다면 모든 원소를 곱했을 경우 어떻게 될까요? <br>
기존에는 `j*k` 였지만 두 원소의 값이 달라져서 `(j-l)(j+l)(j*(k-2))` 가 되었습니다. <br>
따라서 차이가 발생하는 두 원소만 비교하자면 `j^2-l^2 < j^2` 이기 때문에 모든 값이 균등한 첫 번째 경우가 모든 원소의 곱이 더 크다는 것을 알 수 있습니다. <br>
그러므로 최고의 집합을 찾기 위해서는 `모든 원소를 최대한 균등하게 분배해줘야한다` 라는 사실을 알 수 있습니다. <br>

코드로 구현할때는 S를 n으로 나눈 몫을 n 개 만큼 할당한 뒤 S 에서 n을 나눴을때 발생한 나머지 값을 각 원소에 균등하게 나눠주면 됩니다. <br>
구현 코드 자체는 짧았지만 많은 것을 생각해볼 수 있는 문제였습니다. <br>

## 코드

```python

def solution(n, s):
    if s < n:
        return [-1]

    quo, remain = divmod(s, n)
    answer = [quo] * n

    # 나머지를 균등하게 분배한다
    idx = n-1
    for i in range(remain):
        answer[idx - i] += 1

    return answer

```
