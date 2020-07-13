---
layout: post
title: Node.js와 Sequelizer 를 활용해서 DB 연동하기 (MySQL)
excerpt: "Node.js 환경에서 Sequelizer 와 MySQL을 사용해서 DB 연동하기"
categories: [nodejs]
tags: [nodejs]
modified: 2020-07-13
comments: true
---

## MySQL 데이터 베이스 생성
실습을 위한 데이터베이스 생성 후 진행하도록 한다. 

## Sequelizer
Sequelizer는 ORM을 통해 객체 


### 패키지 설치
Node.js 에서 `sequelize` 
sequelize 명령어를 사용하기 위해 `sequelize-cli` 패키지를 전역 범위에 설치해줍니다.

~~~ javascript
$ npm i sequelize mysql2
$ npm i -g sequelize-cli
~~~

### Sequelizer 초기화
~~~ javascript
$ sequelize init
~~~

해당 명령어를 실행하면 프로젝트 폴더 내에 config, migrations, models, seeders 디렉토리가 생성됩니다. <br>
각각의 폴더의 역할은 다음과 같습니다. <br>

* config : 
* migrations : 
* models : 
* seeders : 


## Node.js 작업

### config 파일 수정
우선 config/config.json에서 본인의 테스트 환경에 맞게 DB 설정값들을 수정해줍니다. <br>
`database` 에는 생성한 데이터베이스 이름을 작성해주면 되고 `username` 과 `password` 는 본인의 `MySQL` 접속 계정명과 비밀번호를 입력해줍니다. <br>

~~~ json
"development": {
    "username": "root",
    "password": "password",
    "database": "yangpa",
    "host": "127.0.0.1",
    "dialect": "mysql",
    "operatorsAliases": false
  }
~~~

### model/user.js 생성
~~~ javascript
module.exports = (sequelize, Datatypes) => {
  return sequelize.define('user', {
    email: {
      type: Datatypes.STRING(50),
      allowNull: false,
      unique: true,
    },
    password: {
      type: Datatypes.STRING(100),
      allowNull: false,
    },
    nickname: {
      type: Datatypes.STRING(30),
      allowNull: false,
    },
    phone: {
      type: Datatypes.STRING(30),
      allowNull: true,
    },
    sex: {
      type: Datatypes.STRING(10),
      allowNull: true,
    },
    birthday: {
      type: Datatypes.DATE,
      allowNull: true,
    },
  }, {
        timestamps: true,
        paranoid: true,
        charset: 'utf8',
        collate: 'utf8_general_ci',
  });
};
~~~

### model/post.js 생성
~~~ javascript
module.exports = (sequelize, Datatypes) => {
  return sequelize.define('post', {
    title: {
      type: Datatypes.STRING(100),
      allowNull: false,
    },
    body: {
      type: Datatypes.TEXT,
      allowNull: false,
    },
    hit: {
      type: Datatypes.INTEGER.UNSIGNED,
      allowNull: false,
      defaultValue: 1,
    },
  }, {
        timestamps: true,
        paranoid: true,
        charset: 'utf8',
        collate: 'utf8_general_ci',
  });
};
~~~

### model/index.js 수정
~~~ javascript
const Sequelize = require('sequelize');
const env = process.env.NODE_ENV || 'development';
const config = require('../config/config')[env];

const db = {};

const sequelize = new Sequelize(
  config.database,
  config.username,
  config.password,
  config
);

db.sequelize = sequelize;
db.Sequelize = Sequelize;

// 모델 정의
db.User = require('./user')(sequelize, Sequelize);
db.Post = require('./post')(sequelize, Sequelize);

// User와 Post의 1:N 관계
db.User.hasMany(db.Post);
db.Post.belongsTo(db.User);

module.exports = db;

~~~


### app.js 에 Sequelize 연결

이제 `app.js` 에서 앞서 정의한 모델들을 불러오고 우리의 express app 과 동기화시켜줍니다. <br>

~~~ javascript
// ... 중략
var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

const { sequelize } = require('./models');  // sequelize import 

var app = express();
sequelize.sync(); // sync

~~~

sequelize.sync()에 대한 설명


## 실행 후 결과 확인

이제 서버를 실행시켜 결과를 확인해보겠습니다. <br>

~~~ bash
$ npm start

Executing (default): CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER NOT NULL auto_increment , `email` VARCHAR(50) NOT NULL UNIQUE, `password` VARCHAR(100) NOT NULL, `nickname` VARCHAR(30) NOT NULL, `phone` VARCHAR(30), `sex` VARCHAR(10), `birthday` DATETIME, `createdAt` DATETIME NOT NULL, `updatedAt` DATETIME NOT NULL, `deletedAt` DATETIME, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci;
Executing (default): SHOW INDEX FROM `users` FROM `yangpa`
Executing (default): CREATE TABLE IF NOT EXISTS `posts` (`id` INTEGER NOT NULL auto_increment , `title` VARCHAR(100) NOT NULL, `body` TEXT NOT NULL, `hit` INTEGER UNSIGNED NOT NULL DEFAULT 1, `createdAt` DATETIME NOT NULL, `updatedAt` DATETIME NOT NULL, `deletedAt` DATETIME, `userId` INTEGER, PRIMARY KEY (`id`), FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci;
Executing (default): SHOW INDEX FROM `posts` FROM `yangpa`
~~~

`npm start` 를 통해 서버를 실행시키면 위와 같은 로그가 출력되는 것을 보실 수 있습니다. <br>
그 중에서 `CREATE TABLE IF NOT EXISTS ...` 를 통해 기존에 없던 새로운 테이블이 생겼다는 것을 짐작 할 수 있습니다. <br><br>

이제 MYSQL에 접속해 새로운 레코드를 생성해보고 `SELECT` 문을 통해 조회해보도록 하겠습니다. <br>
우선 현재 DB에 존재하는 테이블 목록입니다. 앞서 `ORM` 으로 정의해준 `Post` 와 `User` 가 새롭게 추가된 것을 보실 수 있습니다.<br>
~~~ bash
mysql> show tables;
+------------------+
| Tables_in_yangpa |
+------------------+
| posts            |
| users            |
+------------------+
~~~

이제 생성된 각 테이블의 내부 속성들을 확인해보겠습니다. <br>
`DESC` 명령어를 통해 테이블의 상세 속성을 확인할 수 있습니다. <br>

~~~ bash
mysql> use yangpa;
mysql> desc posts;
+-----------+--------------+------+-----+---------+----------------+
| Field     | Type         | Null | Key | Default | Extra          |
+-----------+--------------+------+-----+---------+----------------+
| id        | int          | NO   | PRI | NULL    | auto_increment |
| title     | varchar(100) | NO   |     | NULL    |                |
| body      | text         | NO   |     | NULL    |                |
| hit       | int unsigned | NO   |     | 1       |                |
| createdAt | datetime     | NO   |     | NULL    |                |
| updatedAt | datetime     | NO   |     | NULL    |                |
| deletedAt | datetime     | YES  |     | NULL    |                |
| userId    | int          | YES  | MUL | NULL    |                |
+-----------+--------------+------+-----+---------+----------------+

mysql> desc users;
+-----------+--------------+------+-----+---------+----------------+
| Field     | Type         | Null | Key | Default | Extra          |
+-----------+--------------+------+-----+---------+----------------+
| id        | int          | NO   | PRI | NULL    | auto_increment |
| email     | varchar(50)  | NO   | UNI | NULL    |                |
| password  | varchar(100) | NO   |     | NULL    |                |
| nickname  | varchar(30)  | NO   |     | NULL    |                |
| phone     | varchar(30)  | YES  |     | NULL    |                |
| sex       | varchar(10)  | YES  |     | NULL    |                |
| birthday  | datetime     | YES  |     | NULL    |                |
| createdAt | datetime     | NO   |     | NULL    |                |
| updatedAt | datetime     | NO   |     | NULL    |                |
| deletedAt | datetime     | YES  |     | NULL    |                |
+-----------+--------------+------+-----+---------+----------------+
~~~

### SQL 결과
이제 `User` 테이블에 새로운 레코드를 삽입하고 이후 새로운 글을 추가해보겠습니다. <br>
먼저 `User` 테이블에 `INSERT` 문을 통해 새로운 레코드를 삽입해줍니다. <br>
생성이 올바르게 된다면 다음과 같이 `SELECT` 문을 통해 조회가 가능합니다. <br>

~~~ bash
mysql> INSERT INTO users (email, password, nickname, createdAt, updatedAt) VALUES ('test@gmail.com', 'test', 'simpson', '2020-05-26', '2020-05-26');
Query OK, 1 row affected (0.00 sec)

mysql> SELECT * FROM users;
+----+----------------+----------+----------+-------+------+----------+---------------------+---------------------+-----------+
| id | email          | password | nickname | phone | sex  | birthday | createdAt           | updatedAt           | deletedAt |
+----+----------------+----------+----------+-------+------+----------+---------------------+---------------------+-----------+
|  1 | test@gmail.com | test     | simpson  | NULL  | NULL | NULL     | 2020-05-26 00:00:00 | 2020-05-26 00:00:00 | NULL      |
+----+----------------+----------+----------+-------+------+----------+---------------------+---------------------+-----------+
~~~

이후 새롭게 생성된 `simpson` 계정으로 `Post` 테이블에 `INSERT` 문을 활용하여 새로운 `post` 를 생성합니다. <br>
마찬가지로 문제없이 진행되었는지 확인하기 위해 `SELECT` 문으로 조회해봅니다. <br>

~~~ bash
mysql> INSERT INTO posts (title, body, createdAt, updatedAt, userId) VALUES ('test글', 'test 입니다.', '2020-05-26', '2020-05-26', 1);
Query OK, 1 row affected (0.00 sec)

mysql> SELECT * FROM posts;
+----+---------+-----------------+-----+---------------------+---------------------+-----------+--------+
| id | title   | body            | hit | createdAt           | updatedAt           | deletedAt | userId |
+----+---------+-----------------+-----+---------------------+---------------------+-----------+--------+
|  2 | test글  | test 입니다.      |   1 | 2020-05-26 00:00:00 | 2020-05-26 00:00:00  | NULL      |      1 |
+----+---------+-----------------+-----+---------------------+---------------------+-----------+--------+
~~~

## 참고 자료
* https://cresumerjang.github.io/2019/02/08/sequelize-for-nodejs/
* Node.js 교과서