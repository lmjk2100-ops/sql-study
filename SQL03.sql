CREATE DATABASE db_ex;
use db_ex;
-- 학생 테이블
CREATE TABLE 학생(
	학번 int PRIMARY KEY,
    이름 VARCHAR(30) not null,
    학과코드 VARCHAR(30),
    선배 INT,
    성적 INT
    );

CREATE TABLE 학과(
	학과코드 VARCHAR(30) PRIMARY	key,
    학과명 varchar(30) not null
    );

CREATE TABLE 성적등급(
	등급 CHAR PRIMARY KEY,
    최저 int not null,
    최고 int not null
    );

DESC 학생;
DESC 학과;
DESC 성적등급;

-- 학생 데이터 
INSERT INTO 학생 VALUES (15, '한다맨', 'com', NULL, 83);
INSERT INTO 학생 VALUES (16, '이서영', 'han', NULL, 96);
INSERT INTO 학생 VALUES (17, '장효정', 'com', 15, 95);
INSERT INTO 학생 VALUES (19, '주연국', 'han', 16, 75);
INSERT INTO 학생 VALUES (37, '신동진', null, 17, 55);

-- 학과 데이터 
INSERT INTO 학과 VALUES ('com', '컴퓨터');
INSERT INTO 학과 VALUES ('han', '국어');
INSERT INTO 학과 VALUES ('eng', '영어');


-- 성적 데이터
INSERT INTO 성적등급 VALUES ('A',90,100);
INSERT INTO 성적등급 VALUES ('B',80,89);
INSERT INTO 성적등급 VALUES ('C',60,79);
INSERT INTO 성적등급 VALUES ('D',0,59);

SELECT * FROM 학생;
SELECT * FROM 학과;
SELECT * FROM 성적등급;

-- EQUL 조인 (=)
-- 1)where
SELECT 학번, 이름, 학생.학과코드, 학과명
FROM 학생,학과
WHERE 학생.학과코드 = 힉과.학과코드;
-- natural join
SELECT 학번, 이름, 학생.학과코드, 학과명
from 학생 NATURAL JOIN 학과;
-- natural join : 반드시 해당테이블들에 같은 값이 있어야 함
-- 조건을 쓰지 않아도 자동으로 같은 것끼리 연결

-- 3) join~using
SELECT 학번, 이름, 학생.학과코드, 학과명
FROM 학생 join 학과 using(학과코드);

-- non-equl 조인
SELECT 학번, 이름, 등급 from 학생,성적등급
where 학생.성적 between 성적등급.최저 and 성적등급.최고;

-- left outer join
SELECT 학번, 이름, 학생.학과코드, 학과명
from 학생 left outer join 학과
on 학생.학과코드 = 학과.학과코드;
-- 왼쪽 테이블(학생) 전부 가져옴,
-- 오른쪽 테이블(학과)는 학과코드가 같은 것만 추출

-- SELECT 학번, 이름, 학생.학과코드, 학과명
-- FROM 학생, 학과
-- where 학생.학과코드 = 학과.학과코드(+);

-- right outer join(실무에서는 왼쪽보다는 잘안쓰임)
SELECT 학번, 이름, 학생.학과코드, 학과명
FROM 학과 right outer join 학생
on 학생.학과코드 = 학과.학과코드;
-- 오른쪽테이블(학과) 전부 나옴
-- 왼쪽테이블은 학과코드와 같은 것만 추출

-- SELECT 학번, 이름, 학생.학과코드, 학과명
-- FROM 학생, 학과
-- where 학생.학과코드(+) = 학과.학과코드;


SELECT 학번, 이름, 학생.학과코드, 학과명
from 학생
left join 학과 on 학생.학과코드 = 학과.학과코드;

SELECT 학번, 이름, 학생.학과코드, 학과명
from 학생
right join 학과 on 학생.학과코드 = 학과.학과코드;

-- self join
-- : 같은 테이블에서 2개의 속성을 연결하여 EQUI JOIN 하는 JOIN 방법
SELECT a.학번, a.이름, b.이름 as 선배
from 학생 a join 학생 b
on a.선배 = b.학번;
-- 하나의 테이블로 조인
-- 학생 텡이블을 가상으로 하나 복사하여 사영하는 것처럼 사용
-- 학생테이블 a / b (a,b는 사실 같은 테이블) 
-- 학생 a-> 후배 테이블
-- 학생 b-> 선배 테이블

create user  'text_user'@'localhost' IDENTIFIED by 'sql12345';
-- 새로운 아이디와 비밀번호 부여
-- localhost: 
-- 새로운 아이디와 비밀번호 부여
GRANT SELECT
-- grant: 권한을 주는 명령어(권한 부여)
-- GRANT SELECT: 조회를 할 수 있는 권한 부여, select:검색,조회
on my_shop.* -- my.shop 데이터베이스 - 모든 테이블 대상
to 'text_user'@'localhost';

-- 권한 새로고침
FLUSH PRIVILEGES; -- PRIVILEGES: 권한

REVOKE SELECT
on my_shop.*
from 'test_user'@'localhost';

FLUSH PRIVILEGES;

show GRANTS for 'text_user'@'localhost';

GRANT all PRIVILEGES
on my_shop.*
to 'text_user'@'localhost';

FLUSH PRIVILEGES;

SELECT * from sample;
set sql_safe_updates =0; -- 수정/삭제 할 수 있도록 비활성화
START TRANSACTION; -- 취소가 가능하도록 안전구역 설정
DELETE from sample; -- 모든 데이터 삭제
select * from sample;
ROLLBACK; -- 실행 취소
SELECT * from sample;

DELETE from sample;
commit; -- 확정
SELECT * from sample;

set sql_safe_updates = 1;