---
layout: post
cover: "assets/images/cover2.jpg"
navigation: True
title: 프로그래머스 Level 3 - 추석 트래픽
date: 2020-05-03
tags: Programmers
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: algorithm
comments: true
---

## 출처

[프로그래머스 - 추석 트래픽](https://programmers.co.kr/learn/courses/30/lessons/17676)

## 문제

이번 추석에도 시스템 장애가 없는 명절을 보내고 싶은 어피치는 서버를 증설해야 할지 고민이다. <br>
장애 대비용 서버 증설 여부를 결정하기 위해 작년 추석 기간인 9월 15일 로그 데이터를 분석한 후 초당 최대 처리량을 계산해보기로 했다. <br>
초당 최대 처리량은 요청의 응답 완료 여부에 관계없이 임의 시간부터 1초(=1,000밀리초)간 처리하는 요청의 최대 개수를 의미한다. <br>

![이미지](/assets/images/programmers/holiday-traffic.png){: width="300"}
위의 타임라인 그림에서 빨간색으로 표시된 1초 각 구간의 처리량을 구해보면 (1)은 4개, (2)는 7개, (3)는 2개임을 알 수 있다. <br>
따라서 초당 최대 처리량은 7이 되며, 동일한 최대 처리량을 갖는 1초 구간은 여러 개 존재할 수 있으므로 이 문제에서는 구간이 아닌 개수만 출력한다. <br>

## 풀이 과정

주어진 문자열을 적절히 변환한 뒤 일정 크기의 윈도우와 최대한 많이 겹치는 트래픽의 수를 구하면 된다. <br>

### 문자열 처리하기

밀리세컨드 단위의 시간 계산은 처음이라서 어떻게 해줘야할지 고민하다가 `float` 형으로 변환하여 사용하면 효율적일 것 같아서 이 방법을 사용했다. <br>
다만 전날부터 트래픽이 시작 되었을 경우 `트래픽 종료 시간 - 소요된 시간`이 음수가 되는 경우가 있어서 이 부분에 대한 예외처리는 따로 해줘야 했다. <br>

또한 `float`형으로 변환하고 산술연산을 수행하면 소수점 자리에 예상하지 못한 값들이 출력되는 경우가 있어서 <br>
`round` 함수를 통해 소수점 자리수를 고정시켜주는 작업이 필요했다. <br>

### 최대 처리량 계산하기

최대 처리량을 구하는 부분이 예상보다 좀 까다로웠다. <br>
처음에는 첫 트래픽을 기준으로 `밀리세컨드 단위`로 윈도우를 증가시키면서 전체 탐색을 수행했지만 `시간초과`가 발생했다.<br>
최적화를 위해 Greedy한 방법으로 접근해서 끝나는 시간을 기준으로 트래픽 갯수를 체크하려고 했지만 <br>
이 경우에 검사를 못하고 지나치는 부분이 있어서 몇 가지 테스트케이스에 대해 잘못된 결과를 출력함에 따라 다른 방법이 필요했다. <br>

도무지 최적화 방법이 떠오르지 않아 카카오 문제 해설을 참고하여 트래픽이 새로 들어오거나 끝나는 부분에서만 <br>
윈도우와 겹치는 트래픽 갯수를 세어주면 된다는 것을 알게 되었다. <br>

문제를 차근차근 따져보는 연습이 아직 많이 필요한 것 같다. <br>

## 코드

```python


# 시작시간과 끝나는 시간을 반환
def parse_time(traffic_change, time_str):
    end, duration = time_str.split()[1:]
    duration = float(duration.split('s')[0])

    end_h, end_m, end_s = list(map(float, end.split(':')))

    end = 3600 * end_h + 60 * end_m + end_s
    start = end - duration + 0.001
    if start < 0:
        start = 0

    traffic_change.add(round(start, 3))
    traffic_change.add(round(end, 3))
    return round(start, 3), round(end, 3)


def solution(lines):
    answer = 0

    traffic_change = set()
    timeline = []
    for line in lines:
        timeline.append(parse_time(traffic_change, line))

    # 끝나는 시간으로 오름차순 정렬 - 시작하는 시간으로 정렬해도 상관 없을 듯 하다.
    timeline.sort(key=lambda x: x[1])

    for point in traffic_change:
        window = point
        window_end = round(window + 1.0 - 0.001, 3)

        hit = []
        for traffic in timeline:
            traffic_start = traffic[0]
            traffic_end = traffic[1]

            # 현재 window 에 해당하지 않는다면
            if traffic_start > window_end or traffic_end < window:
                continue
            else:
                hit.append(traffic)
        answer = max(answer, len(hit))

    return answer


lines = [
    "2016-09-15 20:59:57.421 0.351s",
    "2016-09-15 20:59:58.233 1.181s",
    "2016-09-15 20:59:58.299 0.8s",
    "2016-09-15 20:59:58.688 1.041s",
    "2016-09-15 20:59:59.591 1.412s",
    "2016-09-15 21:00:00.464 1.466s",
    "2016-09-15 21:00:00.741 1.581s",
    "2016-09-15 21:00:00.748 2.31s",
    "2016-09-15 21:00:00.966 0.381s",
    "2016-09-15 21:00:02.066 2.62s"
]

print(solution(lines))  # 결과는 7


```
