
/*
 * DCL (Data Control Language) 데이터 제어 언어
 * 
 * - 계정별로 DB 또는 DB 객체에 대한 
 *  접근(제어) 권한을 부여(GRANT), 회수(REVOKE)하는 언어
 * 
 * */	

/* 계정(사용자)

* 관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정.
                모든 권한과 책임을 가지는 계정.
                ex) sys(최고관리자), system(sys에서 권한 몇개 제외된 관리자)


* 사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의
                작업을 수행할 수 있는 계정으로
                업무에 필요한 최소한의 권한만을 가지는 것을 원칙으로 한다.
                ex) KH계정(각자 이니셜 계정), workbook계정 등
*/


/* 권한의 종류

1) 시스템 권한 : DB접속, 객체 생성 권한

CRETAE SESSION   : 데이터베이스 접속 권한
CREATE TABLE     : 테이블 생성 권한
CREATE VIEW      : 뷰 생성 권한
CREATE SEQUENCE  : 시퀀스 생성 권한
CREATE PROCEDURE : 함수(프로시져) 생성 권한
CREATE USER      : 사용자(계정) 생성 권한
DROP USER        : 사용자(계정) 삭제 권한
DROP ANY TABLE   : 임의 테이블 삭제 권한


2) 객체 권한 : 특정 객체를 조작할 수 있는 권한

  권한 종류                 설정 객체
    SELECT              TABLE, VIEW, SEQUENCE
    INSERT              TABLE, VIEW
    UPDATE              TABLE, VIEW
    DELETE              TABLE, VIEW
    ALTER               TABLE, SEQUENCE
    REFERENCES          TABLE
    INDEX               TABLE
    EXECUTE             PROCEDURE
*/


-------------------------------------------------------------

/* (관리자 계정 접속) -> 사용자 계정 생성 + 권한 부여하기 */

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--> 계정명을 있는 그대로 쓸 수 있게 함 

-- 사용자 계정 생성하기
-- 작성법 : CREATE USER 계정명 IDENTIFIED BY 비밀번호;

CREATE USER TEST_USER IDENTIFIED BY TEST1234;
--> 계정 생성 성공하면
-- 왼쪽에 있는 데이터베이스 내비게이터에서
-- TEST_USER 접속 방법 추가해서 연결 테스트 해보기

-- ORA-01045: 사용자 TEST_USER는 CREATE SESSION 권한을 가지고있지 않음; 로그온이 거절되었습니다

-- CREAT SESSION은 접속 권한

/* 관리자 계정으로 해야 함 */
/* TEST_USER 계정에 접속권한 추가 */

-- 권한 부여 방법 : GRANT 권한, 권한 ... TO 계정명;

GRANT CREATE SESSION TO TEST_USER;

-- 접속권한을 부여했기 때문에 로그온(커넥션) 가능

/* 현재 TEST_USER에는 데이터베이스 접속 권한인 CREATE SESSION만 부여됨
 * 
 * -> 객체를 다루거나 생성하는 권한이 하나도 없어서
 *  할 수 있는 일이 없다!!
 * 
 * ---> 객체를 생성할 수 있는 공간(TABLESPACE) 할당
 *      + 기본 객체 제어 권한 부여
 *   */


-- TEST_USER 계정이 생성한 객체는
--USERS 폴더(스토리지)에 만들어지고
--사용가능한 용량은 10M 로 제한했다
-- (테이블이 만들어질 수 있는 공간)
ALTER USER TEST_USER
DEFAULT TABLESPACE USERS
QUOTA 10M ON USERS;


-- 기본 객체 제어 권한 부여
GRANT RESOURCE TO TEST_USER;


/* ROLE : 역할 == 역할에 맞는 권한의 묶음
 * 
 * RESOURCE(자원) : 8개 객체 제어 권한을 묶어둔 ROLE
 * 
 * CUNNECT(접속 : DB 접속 권한
 * 
 * 
 * */
-- RESOURCE ROLE : 8개 객체 제어 권한을 묶어둔 ROLE 
/*CREATE SEQUENCE
CREATE PROCEDURE
CREATE CLUSTER
CREATE INDEXTYPE
CREATE OPERATOR
CREATE TYPE
CREATE TRIGGER
CREATE TABLE*/

-- ROLE 권한 확인
SELECT * 
FROM ROLE_SYS_PRIVS 
WHERE ROLE = 'RESOURCE';
-- ROLE 8개를 한 번에 부여함

--------------------------------------------------------------------

/* KH 계정 접속*/

/* 객체 권한 테스트 */
-- KH 계정이 가지고 있는 테이블 중 
-- EMPLOYEE 테이블에 대한 SELECT 권한을
-- TEST_USER 계정에 부여하기

GRANT SELECT ON EMPLOYEE
TO TEST_USER;

/* TEST_USER 계정 접속 (이름 안 바꿔서 LOCAL HOST로 되어 있음) */
--> SELECT 권한 부여 받은 KH계정의 EMPLOYEE 테이블 조회

SELECT *
FROM EMPLOYEE; -- 테스트 계정이 가지고 있는 테이블을 보겠다는 뜻

SELECT *
FROM KH_JSH.EMPLOYEE; -- 가능

-- 다른 테이블 조회도 되는지 확인
SELECT *
FROM KH_JSH.JOB; -- 불가능
 -- > 조회 권한이 없어서 테이블 존재 유무조차 몰라서 발생하는 에러
 
---------------------------------------------------------

/* KH 계정으로 접속 */

/* SELECT 권한 회수 (REVOKE) */
REVOKE 
	SELECT ON EMPLOYEE
	FROM TEST_USER;
	
-- 줄 때는 TO, 가져올 때에는 FROM

/* TEST USER 접속 */
/* SELECT 확인 */
SELECT *
FROM KH_JSH.EMPLOYEE; -- 불가능

----------------------------------------------------------

/* 관리자 계정 접속 */

ALTER SESSION SET "_ORACLE_SCRIPT"= TRUE;

/* 계정 삭제 DROP USER 계정명 */

DROP USER TEST_USER;
-- SQL Error [1940] [42000]: ORA-01940: 현재 접속되어 있는 사용자는 삭제할 수 없습니다
-- 디비버가 접속하고 있는 상태 : 연결 종료하고 실행
 -- > 데이터베이스 네비게이터에서 
 -- TEST USER 계정에 접속 중이라서 삭제 불가 -> 연결 종료 

 