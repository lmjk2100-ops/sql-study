-- 산술 연산
SELECT p_name, price, stock_quantity, price*stock_quantity as 재고금액
-- as(alias에 별칭(약자))
from products;

-- 상품 가격에 택배비 3000원을 추가하여 실제구매금액 구함
SELECT p_name,price,'재고금액',price+3000 as 실제구매금액
from products;

-- 상품 가격을 10으로 나누어 10개월 무이자할부시 월 납부액을 구함
-- 상품명, 가격, 월 납부액
SELECT p_name, price, price/10 as `월 납부액` -- 백틱(`), 필드명의 별칭을 바꿀때 빈칸을주고 싶을때 씀
from products;

-- 문자열 함수
-- concat: 문자 연결
SELECT c_name, email from customers;

SELECT
	concat(c_name,'(', email,')') as `이름과 메일`
from customers;

SELECT email, upper(email) as 대문자메일
from customers;

SELECT c_name, char_length(c_name) as 글자수,
length(c_name) as 바이트수
-- length: 바이트 수 , char_length: 글자수
from customers;
-- utf-8: 한글 1글자 3바이트
SELECT p_name, ifnull(descr, '상품설명없음') as 설명
from products;
-- ifnull (설명이 nill이면, '상품설명없을' 반환(이 문구를 나오게 해라, 반환))

SELECT email,
substring_index(email, '@',1) as 아이디
-- substring_index: 쪼갬(인덱스 즉 배열을 쪼갬)
from customers;
-- 1: 왼쪽 , -1: 오른쪽

--  주문통계 테이블
CREATE TABLE order_stat (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    category VARCHAR(50), -- 카테고리
    product_name VARCHAR(100),
    price INT,
    quantity INT,
    order_date DATE
);
desc order_stat;
INSERT INTO order_stat (customer_name, category, product_name, price, quantity, order_date) VALUES
('이순신', '전자기기', '프리미엄 기계식 키보드', 150000, 1, '2025-05-10'),
('세종대왕', '도서', 'SQL 마스터링', 35000, 2, '2025-05-10'),
('신사임당', '가구', '인체공학 사무용 의자', 250000, 1, '2025-05-11'),
('이순신', '전자기기', '고성능 게이밍 마우스', 80000, 1, '2025-05-12'),
('세종대왕', '전자기기', '4K 모니터', 450000, 1, '2025-05-12'),
('장영실', '도서', '파이썬 데이터 분석', 40000, 3, '2025-05-13'),
('이순신', '문구', '고급 만년필 세트', 200000, 1, '2025-05-14'),
('세종대왕', '가구', '높이조절 스탠딩 데스크', 320000, 1, '2025-05-15'),
('신사임당', '전자기기', '노이즈캔슬링 블루투스 이어폰', 180000, 1, '2025-05-15'),
('장영실', '전자기기', '보조배터리 20000mAh', 50000, 2, '2025-05-16'),
('홍길동', NULL, 'USB-C 허브', 65000, 1, '2025-05-17');
SELECT * from order_stat;
SELECT count(customer_name) from order_stat;
-- count(표현식): 개수(null 제외)
SELECT count(category) from order_stat;
SELECT count(*) from order_stat;
-- count(*): 전체 개수
-- sum(), avg()
SELECT
sum(price * quantity) as 총매출액,
round(avg(price * quantity),1) as 평균매출액
from order_stat;
-- TRUNCATE TABLE : 테이블구조는 그대로 내용만 전부 삭제
-- TRUNCATE(avg(price * quantity),1): 소수이하 버리는 함수
-- 집계함수: (count, sum, avg, max, min~~)
SELECT
min(order_date) as 최초주문일,
max(order_date) as 최근주문일
from order_stat;

SELECT
count(customer_name) as 총주문건수,
count(DISTINCT customer_name) as 순수고객수
from order_stat;

-- group by: 그룹으로 묶기
-- 카테고리별 주문 건수
SELECT
	category,
    count(*) as `카테고리별 주문건수`
from order_stat -- 테이블명
GROUP BY category; -- 카테고리별 묶음
-- 고객별로 총 몇번 주문했는지(주문접수)

-- 1단계: 고객별 총 주문ㅁ 횟수 집계하기
-- 2단계: HAVING절을 추가하여 주문 획수 3회 이상인 그룹 필터링하기
-- HAVING: 그룹에 대한 조건을 필터링(걸러냄)

SELECT
	customer_name,
    count(*) as `주문횟수`
from order_stat -- 테이블명
GROUP BY customer_name
HAVING COUNT(*) >= 3;

SELECT -- (5) 카테고리, 횟수 조회
	category,
    count(*) as '구분별 주문횟수'
FROM order_stat -- (1)
where price >= 100000 -- (2)가격이 10만원 이상
group by category -- (3) 10만원 이상인걸로 카테고리별로 그룹
having COUNT(*) >= 2; -- (4) 그룹 별로 개수가 2개 이상

SELECT -- 5
	customer_name,
   --  price,
--     quantity,
    sum(price * quantity) as 총구매금액
from order_stat -- 1
where order_date <= '2025-05-14' --2
GROUP BY customer_name -- 3
having count(*) >= 2 -- 4
order by 총구매금액 desc -- 6
limit 1;

-- group by 나올때

