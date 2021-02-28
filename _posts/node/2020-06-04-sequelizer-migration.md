---
layout: post
cover: "assets/images/cover4.jpg"
navigation: True
title: Sequelize ORM - migration
date: 2020-06-04
tags: nodejs
subclass: "post"
logo: "assets/images/ghost.png"
author: sohnjunior
categories: node.js
comments: true
---

## Sequelize를 통한 DB 접근

프로젝트 진행 도중 유저 모델에 관리자 유무 컬럼을 추가하는 것을 깜빡해 이를 수정해야할 일이 생겼습니다. <br>
DB를 다시 생성하는 방법도 존재하겠지만 그렇게 하면 기존의 데이터들의 복구가 힘들기 때문에 다른 방법을 사용하기로 했습니다. <br>
이럴때 유용하게 사용할 수 있는 것이 `sequelize` 의 `migration` 입니다. <br>

## 컬럼 추가하기

현재 `User` 테이블은 `admin` 이라는 컬럼이 존재하지 않습니다. <br>
따라서 `migration` 파일을 생성한 뒤 이를 기존의 DB에 반영하도록 하겠습니다. <br>

### migration 파일 생성

우선 컬럼을 추가할 `migration` 파일을 생성해줍니다. <br>
아래 명령어를 수행하면 `migrations` 디렉토리 하위에 `addColumn.js` 파일이 생성됩니다. <br>

```bash
$ sequelize migration:create –-name addcolumn
```

### migration 용 js 파일 수정

`migration` 파일을 생성했으면 이제 기존 테이블애 새로운 컬럼을 추가하기 위한 코드를 작성합니다. <br>
`queryInterface` 의 `addColumn` 메소드를 통해 `user` 테이블에 `admin` 컬럼을 추가합니다. <br>
이때 해당 컬럼의 속성은 객체 형태로 정의한 뒤 인자값으로 넘겨줍니다. <br>

#### migrations/addColumn.js

```javascript
"use strict";

module.exports = {
  up: (queryInterface, Sequelize) => {
    /*
      Add altering commands here.
      Return a promise to correctly handle asynchronicity.
    */
    return queryInterface.addColumn("users", "admin", {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    });
  },

  down: (queryInterface, Sequelize) => {},
};
```

### migrate 하기

`addColumn.js` 파일 편집을 마쳤다면 이제 변경사항을 실제 DB에 반영해주기 위해 `migrate` 작업을 수행합니다. <br>
저는 현재 개발환경에서 DB를 조작하고 있어서 인자로 `development` 를 설정했습니다. (config 설정을 따름) <br>
이후 DB 스키마를 조회해보면 `User` 테이블에 `admin` 컬럼이 추가된 것을 확인할 수 있습니다. <br>

```bash
$ sequelize db:migrate --env development
```

### 다중 마이그레이션

여러개의 마이그레이션 작업이 필요할 경우는 해당 작업들을 `Promise` 배열 형태로 반환해주면 됩니다. <br>
예시로 다음과 같이 새로운 컬럼을 추가하거나 변경하는 작업이 가능합니다. <br>

```javascript
"use strict";

module.exports = {
  up: (queryInterface, Sequelize) => {
    return Promise.all([
      queryInterface.addColumn("users", "admin", {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      }),
      queryInterface.changeColumn("users", "password", {
        type: Sequelize.STRING(30),
        allowNull: false,
        unique: false,
      }),
    ]);
  },

  down: (queryInterface, Sequelize) => {
    /*
      Add reverting commands here.
      Return a promise to correctly handle asynchronicity.

      Example:
      return queryInterface.dropTable('users');
    */
  },
};
```

## 참고 자료

- https://devonaws.com/back-end/node-js/node-js-orm-sequelize-add-column/
- https://stackoverflow.com/questions/49890998/how-to-add-column-in-sequelize-existing-model
