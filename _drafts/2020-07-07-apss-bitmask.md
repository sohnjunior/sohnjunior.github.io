---
layout: post
title: 비트마스크 활용 방법 with Python
excerpt: "Python으로 비트마스크 활용하기"
categories: [Algorithm]
tags: [Algorithm 이론 및 구현]
modified: 2020-07-07
comments: true
---


## 풀이 과정





## 예시 코드

~~~ python


# 3개의 토핑을 가진 피자 생성
fullPizza = (1 << 3) - 1  # 111

# 토핑 개수 출력 (집합의 크기 구하기)
print(bin(fullPizza).count('1'))  # 1이 3개 있으므로 3 출력

# 새로운 토핑 추가
fullPizza |= (1 << 4)
print(bin(fullPizza))  # 10111

# 토핑이 제대로 추가되었는지 확인하자 (주의! 토핑이 있다면 (1 << 4), 없으면 0을 반환합니다)
if fullPizza & (1 << 4):
    print('토핑이 추가되었습니다')  # 토핑이 존재하므로 출력됩니다.

# 오래된 두번째 토핑을 제거합니다.
fullPizza &= ~(1 << 1)
print(bin(fullPizza))  # 10101

# 네번째 토핑이 존재하면 제거하고 만약 없다면 새로 추가합니다. (토글)
fullPizza ^= (1 << 3)
print(bin(fullPizza))  # 11101

# 최소 원소 지우기
fullPizza &= (fullPizza - 1)
print(bin(fullPizza))  # 11100

# 모든 부분 집합 순회하기
"""
아래와 같은 순서로 출력됩니다.
111
110
101
100
011
010
001
"""
print("subset!!")
subset = 7
while subset:
    print(bin(subset))
    subset = (subset-1) & 7

~~~

## 참고자료
* https://stackoverflow.com/questions/9829578/fast-way-of-counting-non-zero-bits-in-positive-integer
