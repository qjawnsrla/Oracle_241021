SELECT * FROM DEPT_TEMP;

UPDATE DEPT_TEMP 
	SET loc = 'SUWON'
WHERE DEPTNO = 60;

COMMIT;

DELETE DEPT_TEMP 
WHERE DEPTNO = 50;

-- DDL(Data Definition Language) : 데이터베이스에 데이터를 보관하기 위해 제공되는 생성, 변경, 삭제 관련 기능을 수행
-- CREATE : 새로운 데이터베이스를 개체(Entity) 를 생성 - 테이블, 뷰, 인덱스
-- ALTER : 기존 데이터베이스의 개체(Entity)를 수정
-- DROP : 데이터베이스 개체(Entity)를 삭제
-- TRUNCATE : 모든 데이터를 삭제하지만 테이블 구조는 남겨 둠
-- Table 이란? : 데이터베이스의 기본 데이터 저장 단위인 테이블은 사용자가 접근 가능한 데이터를 보유하며 레코드(행)와 컬럼(열)로 구성
-- 테이블과 테이블의 관계를 표현하는 데 외래키(Foreign Key)를 사용

CREATE TABLE emp_ddl(
	empno NUMBER(4),		-- 숫자형 데이터 타입, 4자리로 선언, 최대 크기로 38자리까지의 숫자 지정
	ename VARCHAR2(10),		-- 가변문자 데이터 타입, 4000바이트, 실제 입력된 크기만큼 차지 
	job VARCHAR(9),
	mgr NUMBER(4),
	hiredate DATE, 			-- 날짜와 시간을 지정하는 날짜형 데이터 타입
	sal NUMBER(7, 2),		-- 전체 범위가 7자리에 소수점 이하가 2자리 (정수부는 5자리가 됨)
	comm NUMBER(7, 2),
	deptno NUMBER(2)
);

SELECT * FROM emp_ddl;

-- 기존 테이블의 열 구조와 데이터를 복사하여 새 테이블 생성하기
CREATE TABLE dept_ddl
	AS SELECT * FROM dept;
	
SELECT * FROM dept_ddl;

CREATE TABLE emp_alter
	AS SELECT * FROM emp;
	
SELECT * FROM emp_alter;


-- 열 이름을 추가하는 add : 기존 테이블에 새로운 칼럼을 추가하는 명령, 칼럼값은 NULL로 입력
ALTER TABLE EMP_ALTER
	ADD HP varchar2(20);

-- 열 이름을 변경하는 rename
ALTER TABLE emp_alter
	RENAME COLUMN hp TO tel;

-- 열의 자료형을 변경하는 modify
-- 자료형 변경 시 데이터가 이미 존재하는 경우 크기를 크게하는 경우는 문제가 되지 않으나 크기를 줄이는 경우 저장되어 있는 데이터 크기에 따라 변경되지 않을 수 있음
ALTER TABLE emp_alter
	MODIFY empno number(5);

-- 특정 열을 삭제하는 drop 
ALTER TABLE emp_alter
	DROP COLUMN tel;

SELECT * FROM emp_alter;


-- 테이블 이름을 변경하는 RENAME
RENAME TABLE EMP_ALTER TO EMP_RENAME;

ALTER TABLE EMP_ALTER
      RENAME TO emp_rename;


SELECT * FROM emp_rename;

-- 테이블의 데이터를 삭제하는 TRUNCATE : 테이블의 모든 데이터 삭제, 테이블 구조에 영향 주지않음
-- DDL 명령어이기 때문에 ROLLBACK 불가
DELETE FROM emp_rename;		-- DELETE 는 DML 이기 때문에 ROLLBACK 가능
ROLLBACK;
TRUNCATE  TABLE emp_rename;

-- 테이블을 삭제하는 DROP
DROP TABLE EMP_RENAME;

-- 제약 조건 : 데이터의 무결성(정확하고 일관된 값)을 보장하기 위해 테이블에 설정되는 규칙
-- NOT NULL : 지정한 열에 값이 있어야함 
-- UNIQUE : 값이 유일해야 함, 단 null 허용
-- Primary Key(PK) : 값이 유일해야하고 null이면 안됨
-- Foreign Key(FK) : 다른 테이블의 열을 참조하여 존재하는 값을 입력할 수 있음
-- CHECK : 설정한 조건식을 만족하는 데이터만 입력가능
CREATE TABLE table_notnull(
	login_id varchar2(20) NOT NULL,
	login_pw varchar2(20) NOT NULL,
	tel varchar2(20) NOT NULL
);

SELECT * FROM table_notnull;

INSERT INTO table_notnull(login_id, login_pw, tel)
	values('곰돌이사육사', 'qwer1234', '010-1234-56778');

UPDATE table_notnull
	SET login_pw = 'test1234' 
WHERE login_id = '곰돌이사육사';

UPDATE table_notnull
	SET tel = '12345678'
WHERE login_id = '곰돌이사육사';

-- 이미 만들어진 테이블에 제약조건 지정하기
ALTER TABLE table_notnull
	MODIFY tel NOT NULL;

-- UNIQUE 제약조건 : 중복허용하지 않는 특성
CREATE TABLE table_unique (
	login_id varchar2(20) UNIQUE,
	login_pwd varchar2(20) NOT NULL,
	tel varchar2(20) 
);
	
INSERT INTO table_unique (login_id, login_pwd, tel)
	VALUES('안유진', 'pwd12345', '010-1234-5678');

INSERT INTO table_unique (login_id, login_pwd, tel)
	VALUES('장원영', 'pwd45678', '010-1234-5678');

INSERT INTO table_unique (login_id, login_pwd, tel)
	VALUES('null', 'pwd3333', '010-1234-5678');

SELECT * FROM table_unique;

-- 유일하게 하나만 있는 값 (Primary key) : Uniquem Not null 제약조건을 모두 가짐
-- PK로 지정하면 자동으로 인덱스가 만들어짐 (PK를 통한 검색속도를 빠르게 하기 위해서)

CREATE TABLE tale_pk(
	login_id varchar2(20) PRIMARY KEY,
	login_pwd varchar2(20) NOT NULL,
	tel varchar2(20) 
);

INSERT INTO TALE_PK values('안유진', 'pwd12345','010-1234-5678');
INSERT INTO TALE_PK values('장원영', 'pwd12345','010-1234-5678');
INSERT INTO TALE_PK values('이서', 'pwd12345','010-1234-5678');
-- INSERT INTO TALE_PK values(NULL, 'pwd12345','010-1234-5678');

SELECT * FROM tale_pk;

DELETE TALE_PK
WHERE login_id = 'null';

-- 다른 테이블과 관계를 맺는 FOREIGN KEY
-- 서로 다른 테이블간 관계를 정의하는데 사용하는 제약 조건
-- 참조하고 있는 기본키의 데이터타입과 일치해야 하며, 외래키에 참조되고 있는 기본키는 삭제 불가
CREATE TABLE dept_fk (
	deptno number(2) primary KEY,
	dname varchar2(14),
	loc varchar2(13)
);

CREATE TABLE emp_fk(
	empno number(4) PRIMARY KEY,
	ename varchar2(10),
	job varchar2(9),
	mgr number(4),
	hiredate DATE,
	sal number(7, 2),
	comm number(7, 2),
	deptno number(2) REFERENCES dept_fk (deptno)
);
INSERT INTO dept_fk df VALUES(10, '아이돌팀', 'SEOUL');
SELECT * FROM dept_fk;

SELECT * FROM emp_fk;

INSERT INTO emp_fk VALUES (2001, '안유진', 'IVE', 1001, '2024/09/01', 9000, 1000, 10);

DELETE FROM EMP_FK
WHERE deptno = 10;

DELETE FROM dept_fk
WHERE deptno = 10;


-- 데이터 형태와 범위를 정하는 CHECK
-- ID 및 PWD 등의 길이제한
-- 유효 범위값 확인 등에 사용
CREATE TABLE table_check (
	login_id varchar2(20) PRIMARY KEY,
	login_pwd varchar2(20) CHECK(LENGTH(login_pwd) > 6),
	tel varchar2(20) 
);

INSERT INTO TABLE_CHECK VALUES ('민지', '1234567', '010-1234-5678');

-- 기본값을 정하는 default : 특정 열에 저장할 값을 지정하지 않는 경우 기본값을 지정
CREATE TABLE table_default (
	login_id varchar2(20) PRIMARY KEY,
	login_pwd varchar2(20) DEFAULT '1234567',
	tel varchar2(20)
);

INSERT INTO table_default VALUES('레이',NULL,'12345678');
INSERT INTO table_default(login_id, tel) values('이서', '123456789');

SELECT * FROM table_default;



-- 데이터 사전 : 데이터베이스를 구성하고, 운영하는데 필요한 모든 정보를 저장하는 특수한 테이블을 의미함
-- 데이터 사전에는 데이터베이스 메모리, 성능, 사용자, 권한, 객체 등등의 정보가 포함됨
SELECT * FROM dictionary;

SELECT * FROM user_indexes;

-- 인덱스 생성 : 오라클에서는 자동으로 생성해주는 인덱스(PK) 외에 사용자가 직접 인덱스를 만들 떄는 CREATE 문을 사용
CREATE INDEX IDX_EMP_SAL ON EMP(sal);

-- 인덱스 삭제
DROP INDEX IDX_EMP_SAL;

-- 테이블 뷰
-- 뷰란 ? 가상 테이블로 부르는 뷰(View)는 하나 이상의 테이블을 조회하는 SELECT문을 저장한 객체를 의미
-- SELECT * FROM VW_EMP20;
SELECT *
FROM (
	SELECT empno, ename, job, deptno
	FROM emp
	WHERE deptno = 20
);

CREATE VIEW vw_emp20
AS (SELECT empno, ename, job, deptno
	FROM emp
	WHERE deptno = 20
); 

SELECT * FROM vw_emp20;

-- 규칙에 따라 순번을 생성하는 시퀀스
-- 시퀀스 : 오라클 데이터베이스에서 특정규칙에 맞는 연속 숫자를 생성하는 객체
CREATE TABLE dept_sequence
AS SELECT * 
	FROM DEPT
	WHERE 1 <> 1;
-- 시퀀스 생성하기
CREATE SEQUENCE seq_dept_sequence
INCREMENT BY 10
START WITH 10
MAXVALUE 90
MINVALUE 0
NOCYCLE 
cache 2;

SELECT * FROM user_sequences;

INSERT INTO dept_sequence (DEPTNO, dname, loc)
	VALUES (seq_dept_sequence.nextval, 'DATABASE', 'SEOUL');
INSERT INTO dept_sequence (DEPTNO, dname, loc)
	VALUES (seq_dept_sequence.nextval, 'JAVA', 'BUSAN');

SELECT * FROM dept_sequence
ORDER BY deptno;

SELECT * FROM dba_users;

GRANT CREATE SESSION, CONNECT, resource TO test12345;

SELECT * FROM all_users WHERE username = 'test12345';

DROP USER TEST12345

