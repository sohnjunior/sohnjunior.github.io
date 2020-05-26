---
layout: post
title: Node.js와 Multer 모듈을 활용한 파일 업로드 방법
excerpt: "Node.js와 Multer 모듈 활용해서 파일 업로드하기"
categories: [nodejs]
tags: [nodejs]
modified: 2020-05-21
comments: true
---

## 게시판에 이미지 업로드 기능 추가하기

## Multer 모듈
Multer 모듈은 `multipart/form-data` 를 처리하기 위한 node.js 미들웨어입니다. <br>
이번 포스팅에서는 해당 모듈을 사용해서 이미지를 업로드하는 방법에 대해 살펴보겠습니다. <br> 

현재 게시판 글쓰기 필드에는 다음과 같이 이미지 업로드 기능이 없는 상태라서 `multer` 모듈을 통해 게시글마다 이미지를 업로드하고 데이터베이스에 저장하도록 하겠습니다. <br>

![이미지](/img/nodejs/multer-write-init.png){: width="250"}

### 패키지 설치
~~~ bash
$ npm i multer
~~~

## MySQL 컬럼 추가
기존의 게시글 테이블은 다음과 같은 형태를 띄고 있습니다. <br>
~~~ bash
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| idx        | int unsigned | NO   | PRI | NULL    | auto_increment |
| creator_id | varchar(100) | NO   |     | NULL    |                |
| title      | varchar(100) | NO   |     | NULL    |                |
| content    | mediumtext   | NO   |     | NULL    |                |
| passwd     | varchar(100) | NO   |     | NULL    |                |
| hit        | int unsigned | NO   |     | 0       |                |
+------------+--------------+------+-----+---------+----------------+
~~~

이제 각 게시글마다 이미지를 추가적으로 관리해야하므로 이미지 경로를 저장할 컬럼을 새로 만들어줍니다. <br>
바이너리 데이터로 DB에 저장할 경우 부하가 크기 때문에 이미지 경로만 저장해놓고 서버에서 로드해서 제공해주는 형태로 한 것입니다. <br>
~~~ bash
mysql> ALTER TABLE board ADD image VARCHAR(200) NOT NULL DEFAULT '';
~~~

이제 다시 게시글 테이블을 확인해보면 다음과 같이 새로운 컬럼이 추가된 것을 확인할 수 있습니다. <br>
~~~ bash
mysql> desc board;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| idx        | int unsigned | NO   | PRI | NULL    | auto_increment |
| creator_id | varchar(100) | NO   |     | NULL    |                |
| title      | varchar(100) | NO   |     | NULL    |                |
| content    | mediumtext   | NO   |     | NULL    |                |
| passwd     | varchar(100) | NO   |     | NULL    |                |
| hit        | int unsigned | NO   |     | 0       |                |
| image      | varchar(200) | NO   |     |         |                |
+------------+--------------+------+-----+---------+----------------+
~~~

## 파일 업로드 폼 생성

이제 기존의 글 작성 폼에서 이미지 업로드를 위한 파일 선택 창을 새로 추가해줍니다. <br>
form 태그의 속성으로 `enctype="multipart/form-data"` 가 지정되어야 함에 유의합니다. <br>

### write.ejs
~~~ html
    <form action="/board/write" method="post" enctype="multipart/form-data">
      <table border="1">
        <!-- 중략 -->
        <tr>
          <td>이미지</td>
          <td><input type="file" name="image"></td>
        </tr>
        <tr>
          <td colspan="2">
            <button type="submit">글쓰기</button>
          </td>
        </tr>
      </table>
    </form>
~~~

## router & multer 설정
게시글 업로드를 담당하는 라우트 파일에 가서 몇 가지 설정을 해줍니다. <br>
파일이 저장될 경로나 파일명을 변경해주기 위해서는 `multer` 객체의 옵션을 변경해주면 됩니다. <br>
여기서는 현재 날짜를 파일명에 추가하여 중복된 사진이 생성되는 것을 방지하도록 하겠습니다. <br>
이미지 업로드를 담당하는 라우터 파일 상단에 다음과 같은 코드를 통해 설정을 해줍니다. <br>
express 프로젝트 생성 시 기본적으로 제공되는 `public/images` 디렉토리 하위에 이미지들을 저장해주도록 하겠습니다. <br> 

### routes/board.js
~~~ javascript
const multer = require('multer');
const path = require('path');

var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'public/images/');
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname);
    cb(null, path.basename(file.originalname, ext) + '-' + Date.now() + ext);
  }
})

var upload = multer({ storage: storage })
~~~

또한 게시글 하나에는 하나의 이미지가 존재하므로 `upload.single('image')` 로 이미지 처리를 위한 미들웨어를 생성합니다. <br>
여기서 `image` 는 `input` 태그의 `name` 속성값입니다. <br>
아까와 동일하게 `board.js` 의 파일 업로드를 담당하는 라우터에 미들웨어를 설정해줍니다. <br>

### routes/board.js
~~~ javascript
// ... 중략

// 파일 업로드 라우터
router.post('/write', upload.single('image'), (req, res, next) => {
  const creator_id = req.body.creator_id;
  const title = req.body.title;
  const content = req.body.content;
  const passwd = req.body.passwd;
  const image = `/images/${req.file.filename}`;  // image 경로 만들기
  const datas = [creator_id, title, content, passwd, image];

  const sql = 'INSERT INTO board(creator_id, title, content, passwd, image) values(?, ?, ?, ?, ?)';
  connection.query(sql, datas, (err, rows) =>{
    if(err) {
      console.error('err : ' + err);
    } else {
      console.log('rows: ' + JSON.stringify(rows));

      res.redirect('/board');
    }
  })
});
~~~

## 이미지 저장 확인
이제 터미널을 열고 새로운 게시글을 작성한 뒤 쿼리문을 통해 레코드를 확인해보면 다음과 같이 이미지 경로가 저장된 것을 확인할 수 있습니다. <br>
기존에 이미지가 없는 게시글들은 기본값이 설정되어 있는 것을 확인할 수 있습니다. <br> 

~~~ bash
mysql> select * from board;
+-----+------------+----------------------+---------------------+--------+-----+----------------------------------------+
| idx | creator_id | title                | content             | passwd | hit | image                                  |
+-----+------------+----------------------+---------------------+--------+-----+----------------------------------------+
|  12 | simpson    | springfield          | 게시글 작성            | 3020   |   0 |                                        |
|  15 | apple      | lenna                | lenna test          | 3020   |   0 | /images/lenna-1589908536559.png        |
+-----+------------+----------------------+---------------------+--------+-----+----------------------------------------+
~~~

또한 로컬 환경에 이미지가 올바르게 저장되었는지 확인해봅시다. <br>
`public/images/` 하위에 다음과 같이 저장된 시간과 함께 새로운 파일명을 만든 뒤 저장되어있는 것을 확인할 수 있습니다. <br>
![이미지](/img/nodejs/multer-save.png){: width="350"}

## 게시글 이미지 출력
현재는 게시글 조회 시 저장된 이미지를 출력하지 못하는 상태입니다. <br>
![이미지](/img/nodejs/multer-read-before.png){: width="300"}


이제 게시글 조회 시 이미지를 같이 출력해줄 수 있도록 기존의 라우터를 수정하겠습니다. <br>
기존 쿼리문의 요청 필드에 `image` 를 추가해줍니다. <br>

### routes/board.js
~~~ javascript
router.get('/read/:idx', (req, res, next) => {
  const idx = req.params.idx;
  const sql = 'SELECT idx, creator_id, title, content, hit, image FROM board WHERE idx=?';
  connection.query(sql, [idx], (err, row) => {
    if(err) {
      console.error(err);
    } else {
      res.render('read', {title: '글 조회', row: row[0]});
    }
  });
});
~~~

그리고 ejs 파일에서 `img` 태그를 통해 정적 파일을 화면에 출력하도록 합니다. <br>
이때 이미지 소스는 서버로부터 전달받은 `row` 객체에서 가져오도록 합니다. <br>

### read.ejs
~~~ html
<table>
  <!-- 중략 -->
  <tr>
    <td>이미지</td>
    <td><img src="<%= row.image %> " alt="이미지" width="300"></td>
  </tr>
</table>
~~~

### 결과 확인
![이미지](/img/nodejs/multer-result.png){: width="350"}


## 참고 자료
* https://velog.io/@josworks27/2020-01-18-0001-%EC%9E%91%EC%84%B1%EB%90%A8-qrk5iamlmv
* https://github.com/expressjs/multer/blob/master/doc/README-ko.md