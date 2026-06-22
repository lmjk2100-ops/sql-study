create database my_shop; -- 데이터베이스 생성 <-정의
use my_shop; -- 생성된 데이터베이스 사용
-- 테이블정의(설계) : 필드 => 상품id, 가격, 상품이름, 재고수량, 출시일
create table sample ( -- (테이블=표) 관계데이터베이스 표 생성 
	pro_id int primary key, -- primary key: 기본키
    p_name varchar(100), --  varchar : 가변길이, 최대 100
    price int,
    quan int,
    re_date date -- date : 날짜타입
    );
desc sample; -- 테이블 구조 확인
show databases; -- 데이터베이스 보기 (s가 있어서 여러개)
show tables; -- 테이블 보기 (s가 있어서 여러개)
-- drop table sample; -- drop : 삭제, 테이블 삭제
-- drop database my_shop; -- 데이터베이스 삭제

-- CRUD(넣다/읽다/수정/삭제) :기본작업 <-조작 (DML)
-- c(입력) : insert
insert into sample (pro_id, p_name, price, quan, re_date)
value (1, '새우깡',3000,100, '2025-5-3');
-- r(읽기) : select
select * from sample;

insert into sample (pro_id, p_name, price, quan, re_date)
values (2, '양파링',2500, 300, '2026-4-1');
select * from sample;
select pro_id, p_name from sample;

-- u(갱신, 수정) : update

update sample set price = 5000 where pro_id=1;
select * from sample;

-- 양파링의 수량 1000개 수정
update sample set price = 1000 where pro_id=2;
select * from sample;

-- d(삭제) : delete
delete from sample where pro_id=2;
select * from sample; 

-- <쇼핑몰 테이블>
/*쇼핑몰 테이블 실전 설계
고객 (customers)
- 고객 id, 이름, 이메일, 비밀번호, 주소, 가입 시각 
상품 (products)
- 상품 id, 상품명, 설명, 가격, 재고 수량 
주문 (orders)
- 주문 id, 주문 고객, 주문 상품, 주문 수량, 주문 시각, 주문 상태  */

use my_shop;
-- 고객 테이블
create table customers(
	customer_id int auto_increment primary key, -- 고객 id
		-- auto_increment: 자동 번호 부여 primary key:기본키
    c_name varchar(50) not null, -- varchar(50):가변 , 최대 50 / char(50):고정
    email varchar(100) not null unique, 
		-- not null: 공백 안됨(꼭 입력), unique: 중복 안됨(고유의 하나)
    passwad varchar(255) not null,
    address varchar(200) not null,
    join_date datetime default current_timestamp -- 가입일시
		-- date: 날짜 , datetime: 날짜/시간
        -- default: 기본값(입력하지 않으면 기본으로 들어가 있는 값)
        -- current_timestamp: 현재 지금 날짜/시간
    );
desc customers; -- desc: 구조
-- drop table customers;

-- 상품 테이블
create table products(
	product_id int auto_increment primary key,
    p_name varchar(100) not null,
	descr text, -- 긴 문자열 (설명)
    price int not null,
    stock_quantity int not null default 0 -- 재고 수량
    );
desc products;

-- 주문 테이블
create table orders(
	order_id int auto_increment primary key,
    customer_id int not null,
    product_id int not null,
    
    quantity int not null, -- 주문 수량
    constraint chk_order_quan check(quantity >= 1),
    -- constraint: 제약조건/ chk_order_quan,
    -- check(quantity >= 1): 수량이 1개 이상 체크
    
    order_date datetime default current_timestamp, 
    o_status varchar(20) not null default '주문접수', 
    
    constraint fk_orders_customers foreign key (customer_id)
		references customers(customer_id)
        -- 주문테이블의 customers(customer_id)(외래키)- 상품테이블의 customer_id 연결
        -- fk_orders_customers: 제약조건마다 이름을 정함(우리가 만든 이름)
        -- references: 참조
        on update cascade, 
        -- update: 수정, 갱신
        -- cascade: 부모테이블이 갱신(수정)/삭제되면 다른 자식테이블도 같이 수정/삭제
        
	constraint fk_orders_products foreign key (product_id)
		references products(product_id)
        on update cascade
	);
desc orders;

use my_shop;

	desc customers;
    desc products;
    desc orders;
    
-- alter table: 이미 만든 테이블 구도 변경
-- 열추가: add column (열을 column이라고 함)
alter table customers
add column point int not null default 0; -- 속성 추가
desc customers;
select * from customers;
-- select: 데이터를 선택하여 가져옴
-- *: 모든 컬럼(열) 이라는 뜻
-- from: 어디 테이블에서 가져올지 지정하는 키워드 -> 현재 customers 테이블에서 가져옴

-- 열(속성,필드) 변경 : modify
alter table customers
modify column address varchar(300) not null;
desc customers;

-- 열 삭제: drop column
alter table customers
drop column point;
desc customers;

alter table orders
alter o_status set default '주문접수 완료';
-- o_status 컬럼의 기본값을 set으로 주문접수 완료로 갱신(수정)함
desc orders;

-- c(입력)
insert into customers
(c_name, email, passwad, address, join_date) values
-- 기본키인 customer_id는 auto_increment을 입력하여 자동적으로 번호가 부여되어 쓸 일이 없음
('이순신', 'sunsin@naver.com', 'password123', '서울특별시 중구 세종대로', '2026-05-01 10:30:00'),
('세종대왕', 'sejong@naver.com', 'password456', '서울특별시 종로구 사직로', '2025-04-01'),
('장영실', 'young@naver.com', 'password789', '부산광역시 동래구 복천동', '2026-03-10');
desc customers;

-- select * from customers;
-- alter table customers
-- rename column passwad to pass;
-- desc customers;

show tables;
use my_shop;
select * from customers;
desc customers;
insert into customers
(c_name, email, passwad, address) values
('강감찬', 'kang@naver.com', 'password777', '인천 남동구 구월동');
select * from customers;
desc products;

insert into products
(p_name, descr, price, stock_quantity) values
('갤럭시', '최신 AI 기능이 탑재된 고성능 스마트폰', 100000, 55);
select * from products;
INSERT INTO products (p_name, descr, price, stock_quantity) VALUES
('LG 그램', '초경량 디자인과 강력한 성능을 자랑하는 노트북', 500000, 35),
('아이폰', '직관적인 사용자 경험을 제공하는 스마트폰', 800000, 55),
('에어팟', '편리한 사용성의 무선 이어폰', 200000, 110),
('알뜰폰', NULL, 300000, 100);
select * from products;

truncate table orders;
truncate table products;

desc orders;
insert into orders
(customer_id, product_id, quantity) values
(1, 1, 1);
select * from orders;
insert into orders
(customer_id, product_id, quantity) values
(2,2,1),
(3,3,1),
(1,4,2),
(2,2,1);
select * from orders;

set foreifn_key_checks = 1;
desc table product;
show tables;
select * from customers;
select * from products;
select * from orders;
insert into orders
(customer_id, product_id, quantity) values
(2,2,1),
(3,3,1),
(1,4,2),
(2,2,1);
select * from orders;
 -- 1. 외래키 체크 비활성화
SET FOREIGN_KEY_CHECKS = 0;

-- 2. 테이블 비우기
TRUNCATE TABLE products;

-- 3. 외래키 체크 다시 활성화 (필수!)
SET FOREIGN_KEY_CHECKS = 1;

insert into customers 
 (c_name, email, pass, address) values
 ('강감찬', 'kang@naver.com', 'password777', '인천 남동구 구월동');
 insert into customers 
 (c_name, email, pass, address, join_date) values
 ('이순신', 'sunsin@naver.com', 'password123', '서울특별시 중구 세종대로', '2026-05-01 10:30:00'),
('세종대왕', 'sejong@naver.com', 'password456', '서울특별시 종로구 사직로', '2025-04-01'),
('장영실', 'young@naver.com', 'password789', '부산광역시 동래구 복천동', '2026-03-10');
INSERT INTO products (p_name, descr, price, stock_quantity) VALUES
('갤럭시', '최신 AI 기능이 탑재된 고성능 스마트폰', 1000000, 55),
('LG 그램', '초경량 디자인과 강력한 성능을 자랑하는 노트북', 500000, 35),
('아이폰', '직관적인 사용자 경험을 제공하는 스마트폰', 800000, 55),
('에어팟', '편리한 사용성의 무선 이어폰', 200000, 110),
('알뜰폰', NULL, 300000, 100);
INSERT INTO orders (customer_id, product_id, quantity) VALUES
(1, 1, 1), -- 이순신 고객이 갤럭시 1개 주문
(2, 2, 1), -- 세종대왕 고객이 LG 그램 1개 주문
(3, 3, 1), -- 장영실 고객이 아이폰 1개 주문
(1, 4, 2), -- 이순신 고객이 에어팟 2개 추가 주문
(2, 2, 1); -- 세종대왕 고객이 LG 그램 1개 주문(추가 주문)

select * from customers;
select * from products;
select * from orders;
desc table customers;
alter table customers
rename column passward to pass;

update customers set customer_id=10
where customer_id=4;
select * from customers;

update customers set pass = 'password100'
where customer_id=10;
select * from customers;

/*delete from customers
where customer_id=10;*/

insert into customers (email, pass, address)
values ('aaa@naver.com', 'pass111', '인천 미추출구 용현동');
desc customers;
select * from customers;

desc orders;
insert into orders (customer_id, product_id, quantity)
values (12, 1, 1);

update customers set pass= 'password333'
where c_name= '장영실';
SET SQL_SAFE_UPDATES = 1; -- 안전 모드 해제 (0 = OFF)

-- 인덱스 생성
create index i_pricee on products(price);
select * from products where price >= 500000;

-- view(뷰) : 데이터를 따로 저장 안함, 필요한 것만 꺼내와서 사용자에게 보여줌
create view v_masking as
-- as: "~라는 이름으로", "~로써"
	select
     customer_id,
     c_name,
     email,
     join_date
	from customers;
select * from view v_masking;

create view v_seoul as
	select customer_id, c_name, address
    from customers
    where address like '%서울%';
    -- like: ~와 같다, %: 모든 문자를 대체함(공백도 대체)
select * from v_seoul;

create view pro_view as
	select 
    p_name,
    descr,
    price
    from products
    where descr='%ai%';
select * from pro_view;

create view v_order_details as
select
	o.order_id,
	c.c_name as 고객이름,
	p.p_name as 상품명,
	o.order_date as 주문일시,
	o.o_status as 주문상태
	from orders o
    join customers c on o.customer_id = c.customer_id
    -- join: 합치다
    join products p on o.product_id = p.product_id;
    
select * from v_order_details;

-- orders => a customers => begin
-- order_id, customer_id, c_name, quantity
	-- => 주분번호, 고객번호, 고객명, 수량
    -- 주문 테이블의 고객번호 = 고객테이블의 고객번호
    
select * from order_view;
create view order_view as
select
	 a.order_id as 주문번호,
     b.customer_id 고객번호,
     b.c_name as 고객명,
     a.quantity as 수량
     
from orders a
    join customers b on a.customer_id = b.customer_id;
select * from order_view;

drop view v_masking;

select c_name, address from customers;
select * from products where price >= 700000;
--  customers => join_date가 2026-1-1 이후 조회
select join_date from customers where join_date >= '2026-1-1';
-- 또는 select * from customers where join_date >= '2026-1-1'; (o)

-- price이 50만원 이상이면서 (stock_ quantity)재고수량이 50 이상
select * from products
where price >= 500000 and stock_quantity >= 50;
-- where: 조건
select * from products
where price between 500000 and 1000000;
-- between 0 and 10 : 간격(범위)

-- in: 포함 ,  not in: 포함안됨
select * from products
where p_name in ('갤럭시','아이폰','에어팟');
-- where p_name in ('갤럭시','아이폰','아이폰18'); 이라고 하면 아이폰18은 없어서 안나옴
select * from products
where p_name not in ('갤럭시','아이폰','아이폰18');
select * from customers
where c_name like '강%';

select * from customers
where c_name like '%윤%';

-- _(맡줄): 밑줄 하나당 한 글자
select * from customers
where c_name like '이__'; 

select * from customers
where address not like '서울특별시%';

     