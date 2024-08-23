/* VIEW
 * 
 * 	- 논리적 가상 테이블
 * 	-> 테이블 모양을 하고는 있지만, 실제로 값을 저장하고 있진 않음.
 * -- 조회 결과를 찾아서 참조하는 값을 계속 모아둔 느낌
 * 
 *  - SELECT문의 실행 결과(RESULT SET)를 저장하는 객체
 * -- 긴 SELECT 를 저장해서 쓰게 함 == WITH 와 비슷한 개념 
 * 
 * 
 * ** VIEW 사용 목적 **
 *  1) 복잡한 SELECT문을 쉽게 재사용하기 위해.
 *  2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리.
 * 
 * ** VIEW 사용 시 주의 사항 **
 * 	1) 가상의 테이블(실체 X)이기 때문에 ALTER 구문 사용 불가.
 * 	2) VIEW를 이용한 DML(INSERT,UPDATE,DELETE)이 가능한 경우도 있지만
 *     제약이 많이 따르기 때문에 조회(SELECT) 용도로 대부분 사용.
 * 
 * 
 *  ** VIEW 작성법 **
 *  CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [컬럼 별칭]
 *  AS 서브쿼리(SELECT문)
 *  [WITH CHECK OPTION]
 *  [WITH READ OLNY];
 * -- 대괄호 생략 가능하다는 의미
 *  AS 서브쿼리 (SELECT 문) 테이블 복사와 비슷한 형태가 된다
 * 
 * -- 알면 좋은 것들 : OR REPLACE , WITH READ ONLY
 * 
 *  1) OR REPLACE 옵션 : 
 * 		기존에 동일한 이름의 VIEW가 존재하면 이를 변경
 * 		없으면 새로 생성 
 *  -- 만들거나 또는 변경하겠다!
 * 
 *  2) FORCE | NOFORCE 옵션 : 
 *    FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
 *    NOFORCE(기본값): 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성
 *    
 *  3) 컬럼 별칭 옵션 : 조회되는 VIEW의 컬럼명을 지정
 * 
 *  4) WITH CHECK OPTION 옵션 : 
 * 		옵션을 지정한 컬럼의 값을 수정 불가능하게 함.
 * 
 *  5) WITH READ OLNY 옵션 :
 * 		뷰에 대해 SELECT만 가능하도록 지정.
 *  -- 실수 방지하기 위해 붙이면 좋음 == 읽기 전용
 * */


/* VIEW를 생성하기 위해서는 권한이 필요하다 !!!!*/
-- (관리자 계정 접속)]

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- SESSION : 접속, 방문 이라는 뜻 (현재 연결된 계정의 값을 수정) -- 옛날 방식
-- 계정명이 언급되는 상황에서 위의 구문 반드시 실행

-- VIEW 생성 권한 부여
GRANT CREATE VIEW TO KH_JSH;

-- KH 계정 접속 
-- VIEW 생성 구문 (기초적 방법)
CREATE VIEW V_EMP
AS SELECT * FROM EMPLOYEE; -- 권한이 불충분하다 (처음)
-- 권한 부여 후 다시 KH 계정으로 실행하면 가능

-- 사번, 이름, 부서명, 직급명 쉽게 조회하기 위한 VIEW 생성

-- 이미 기존 객체가 이름을 사용한다는 오류
-- > OR REPLACE 옵션 사용해서 해결
CREATE OR REPLACE VIEW V_EMP
AS
SELECT EMP_ID 사번,
 EMP_NAME 이름,
 NVL(DEPT_TITLE, '없음') 부서명,
 JOB_NAME 직급명
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
ORDER BY 사번 ASC;

SELECT 
	EMP_ID 사번,
	EMP_NAME 이름,
	NVL(DEPT_TITLE, '없음') 부서명,
	JOB_NAME 직급명
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
ORDER BY 사번 ASC;

-- VIEW 이용해서 조회하기
SELECT * FROM V_EMP; -- RESULT SET을 보여주는 가상테이블


-- V_EMP 에서 대리 직원들을 이름 오름차순 조회
-- VIEW 조회 결과로 보이는 컬럼명을 이용해야 한다!

SELECT 이름, 직급명
FROM V_EMP
WHERE 직급명 = '대리'
ORDER BY 이름 ASC;
-- 적혀져 있는 그대로 작성

----------------------------
/* VIEW를 이용해서 DML 사용하기 + 문제점 확인 */
-- DEPARTMENT 테이블을 복사한 DEPT_COPY2 생성

CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPARTMENT;
-- >만들어진 DEPT_COPY2 테이블 확인

SELECT * FROM DEPT_COPY2;
--> 만들어진 DEPT_COPY2 테이블 확인해 보면
-- DEPT_TITLE 컬럼만 NULL이 허용됨

-- DEPT_COPY2 테이블에서 DEPT_ID, LOCATION_ID 컬럼만 이용해서
-- V_DCOPY2 VIEW 생성

CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID
FROM DEPT_COPY2;

-- V_DCOPY2 VIEW 생성 확인
SELECT * FROM V_DCOPY2;

-- V_DCOPY2 VIEW 이용해서 INSERT 수행
INSERT INTO V_DCOPY2
VALUES ('D0', 'L2');
-- 가상 테이블 VIEW인데 INSERT 성공함!?

-- INSERT 결과 확인 - V_DCOPY2 VIEW 확인
SELECT * FROM V_DCOPY2 ;
-- D0    L2

--  DEPT_COPY2 원본 테이블 확인
SELECT * FROM DEPT_COPY2;
-- D0  NULL L2 
-- > VIEW에 INSERT를 수행했지만
-- VIEW를 만들 때 사용한 원본 테이블에
-- 값이 INSERT 됨을 확인함 !!!

 --> 하지만 모든 컬럼 값이 INSERT 된 것이 아니라 
 -- VIEW 를 생성할 때 사용된 컬럼에만 값이 INSERT 되어
 -- 반대로 사용되지 않은 컬럼에는 NULL 이 들어감을 확인 
 ---> NULL은 DB의 무결성을 약하게 만드는 주요 원인이므로
    -- 가능하면 의도되지 않은 NULL은 존재하지 않게 하자

 -- 무결성 지킬 때
 -- 중복 안됨!!  
 -- NULL 이 많으면 안 됨!!
 -- 이 두 개를 지키는 것이 가장 중요하다


/* WITH READ ONLY 옵션 사용하기 */
-- 왜 사용할까?
--> VIEW 를 이용해서 DML (INSERT, UPDATE, DELETE) 하지 말라고!

CREATE OR REPLACE VIEW V_DCOPY2
AS SELECT DEPT_ID, LOCATION_ID
FROM DEPT_COPY2
WITH READ ONLY; -- 읽기전용

-- INSERT 수행
INSERT INTO V_DCOPY2
VALUES ('D0', 'L3');
-- SQL Error [42399] [99999]: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
-- 무결성 침해하지 않도록 아예 막아두자

 
----------------------------------------------------------------

/* SEQUENCE(순서, 연속) *** 꼭 알아야 함!! 
 * - 순차적으로 일정한 간격의 숫자(번호)를 발생시키는 객체
 *   (번호 생성기)
 * 
 * *** SEQUENCE 왜 사용할까?? ***
 * PRIMARY KEY(기본키) : 테이블 내 각 행을 구별하는 식별자 역할
 * 						 NOT NULL + UNIQUE의 의미를 가짐
 * 
 * PK가 지정된 컬럼에 삽입될 값을 생성할 때 SEQUENCE를 이용하면 좋다!
 * 
 *   [작성법]
  CREATE SEQUENCE 시퀀스이름
  [STRAT WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 자동 1이 기본
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승 -1)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정
  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트
	-- 시퀀스의 캐시 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
	-- --> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
	--     매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.
 * 
 * 
 * ** 사용법 **
 * 
 * 1) 시퀀스명.NEXTVAL : 다음 시퀀스 번호를 얻어옴.
 * 						 (INCREMENT BY 만큼 증가된 수)
 * 						 단, 생성 후 처음 호출된 시퀀스인 경우
 * 						 START WITH에 작성된 값이 반환됨.
 * 
 * 2) 시퀀스명.CURRVAL : 현재 시퀀스 번호를 얻어옴.
 * 						 단, 시퀀스가 생성 되자마자 호출할 경우 오류 발생.
 * 						== 마지막으로 호출한 NEXTVAL 값을 반환
 * */

/* 시퀀스 삭제하기 */
DROP SEQUENCE SEQ_TEST_NO;

/* 시퀀스 생성하기 */
CREATE SEQUENCE SEQ_TEST_NO
START WITH 100 -- 시작 번호 100
INCREMENT BY 5 -- NEXTVAL 호출 시 5씩 증가
MAXVALUE 150 -- 증가 가능한 최대값 150
NOMINVALUE -- 최소값 없음
NOCYCLE -- 반복 안함
NOCACHE ; -- 미리 만들어둔 스퀀스 번호 없음

-- 시퀀스 테스트할 테이블 생성
CREATE TABLE TB_TEST (
	TEST_NO NUMBER PRIMARY KEY,
	TEST_NAME VARCHAR2(30) NOT NULL
);

-- 현재 시퀀스 번호 확인하기
SELECT SEQ_TEST_NO.CURRVAL -- CURRENT VALUE 
FROM DUAL; 
-- SQL Error [8002] [72000]: ORA-08002: 시퀀스 SEQ_TEST_NO.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
-- > 발생 원인 : CURRVAL의 정확한 의미는 
-- 가장 최근 호출된 NEXTVAL의 값을 반환한다는 것
-- > NEXTVAL을 호출한 적 없어서 오류가 발생함!

-- 해결 방법 : NEXTVAL를 호출하면 해결!

SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;
-- 시퀀스 생성 후 첫 NEXTVAL == START WITH 값인 100
SELECT SEQ_TEST_NO.CURRVAL -- CURRENT VALUE 
FROM DUAL; 

-- NEXTVAL 호출할 때마다
-- INCREMENT BY에 작성된 수만큼 증가

SELECT SEQ_TEST_NO.NEXTVAL FROM DUAL;
-- 처음 : 100
-- 1회 : 105
-- 2회 : 110
-- 3회 : 115
-- 4회 : 120 

-- TB_TEST 테이블에 PK값을 SEQ_TEST_NO 시퀀스로 생성하기
INSERT INTO TB_TEST
VALUES(SEQ_TEST_NO.NEXTVAL , '짱구'); -- PK 125
INSERT INTO TB_TEST
VALUES(SEQ_TEST_NO.NEXTVAL , '철수'); -- PK 130
INSERT INTO TB_TEST
VALUES(SEQ_TEST_NO.NEXTVAL , '유리'); -- PK 135
-- 시퀀스 이용하면 PK 만들기 편함!! 중복이 안 되며 NULL값이 아니다


SELECT * FROM TB_TEST;


---

/* UPDATE 에서 시퀀스 사용하기 */

-- '짱구'의 PK 컬럼 값을 SEQ_TEST_NO 시퀀스의 다음 생성값으로 변경하기

UPDATE TB_TEST
SET	
	TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NAME = '짱구';

SELECT * FROM TB_TEST; -- 짱구 140됨

UPDATE TB_TEST
SET	
	TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NAME = '짱구';
UPDATE TB_TEST
SET	
	TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NAME = '짱구';

SELECT * FROM TB_TEST; -- 짱구 150까지 증가

--> 다시 한 번 더 수행
UPDATE TB_TEST
SET	
	TEST_NO = SEQ_TEST_NO.NEXTVAL
WHERE TEST_NAME = '짱구';
--SQL Error [8004] [72000]: ORA-08004: 시퀀스 SEQ_TEST_NO.NEXTVAL exceeds MAXVALUE은 사례로 될 수 없습니다
--> MAXVALUE 150보다 증가할 수 없어서 나는 에러

--------------------------------

-- SEQUENCE 변경(ALTER)
--> START WITH 제외 모두 변경 가능!!

/*
 [작성법]
  ALTER SEQUENCE 시퀀스이름
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승 -1)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정
  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트
*/	

-- SEQ_TEST_NO의 MAXVALUE 값을 200으로 수정

ALTER SEQUENCE SEQ_TEST_NO
MAXVALUE 200;

-- 200까지 증가시켜서 변경 확인

SELECT SEQ_TEST_NO.NEXTVAL
FROM DUAL;
-- 200까지 증가 되는 걸 확인



-----------------------------------------------------

-- VIEW, SEQUENCE 삭제
-- 객체를 지울 때는 DROP을 씀

-- V_DCOPY2 VIEW 삭제
DROP VIEW V_DCOPY2;

-- SEQ_TEST_NO SEQUENCE 삭제
DROP SEQUENCE SEQ_TEST_NO;

------------------------------------------------------------------------
 
/* INDEX(색인) *** 실무에서 알아두면 좋다!!!
 * - SQL 구문 중 SELECT 처리 속도를 향상 시키기 위해 
 *   컬럼에 대하여 생성하는 객체
 * --  번호로 위치를 알 수 있음 
 * 
 * - 인덱스 내부 구조는 B* 트리 형식으로 되어있음. (알고리즘)
 * 
 *  
 * ** INDEX의 장점 **
 * - 이진 트리 형식으로 구성되어 '자동 저렬' 및 '검색 속도' 증가.
 * 
 * - 조회 시 테이블의 전체 내용을 확인하며 조회하는 것이 아닌
 *   인덱스가 지정된 컬럼만을 이용해서 조회하기 때문에
 *   시스템의 부하가 낮아짐.
 * 
 * ** 인덱스의 단점 **
 * - 데이터 변경(INSERT,UPDATE,DELETE) 작업 시 
 * 	 이진 트리 구조에 변형이 일어남
 *    -> DML 작업이 빈번한 경우 시스템 부하가 늘어 성능이 저하됨.
 * 
 * - 인덱스도 하나의 객체이다 보니 별도 저장공간이 필요(메모리 소비)
 * 
 * - 인덱스 생성 시간이 필요함.
 * 
 * 
 * 
 *  [작성법]
 *  CREATE [UNIQUE] INDEX 인덱스명
 *  ON 테이블명 (컬럼명[, 컬럼명 | 함수명]);
 * 
 *  DROP INDEX 인덱스명;
 * 
 * 
 *  ** 인덱스가 자동 생성되는 경우 **
 *  -> PK 또는 UNIQUE 제약조건이 설정된 컬럼에 대해 
 *    UNIQUE INDEX가 자동 생성된다. 
 * */


/* 인덱스 성능 확인용 테이블 생성 */
CREATE TABLE TB_IDX_TEST(
	TEST_NO NUMBER PRIMARY KEY, -- 자동으로 UNIQUE INDEX가 생성됨
	TEST_ID VARCHAR2(20) NOT NULL
);


/* 관리자 계정 접속 */
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 할당된 저장공간 용량 변경
ALTER USER KH_JSH
DEFAULT TABLESPACE USERS
QUOTA 200M ON USERS;

/* 다시 KH 계정 접속 */

-- TB_IDX_TEST 테이블에
-- 샘플 데이터 100만개 삽입 (PL/SQL 사용) *절차적 언어 SQL -- C언어처럼 사용하기

BEGIN
	FOR I IN 1..1000000
	LOOP
		INSERT INTO TB_IDX_TEST
		VALUES(I , 'TEST'||I);
	END LOOP;
	
	COMMIT;
END;

SELECT COUNT(*)
FROM TB_IDX_TEST;

/*-- 인덱스 사용해서 검색하는 방법
 * 
 * -> WHERE 절에 INDEX가 지정된 컬럼을 언급하기!!
 * 
 * */

/*인덱스 사용 안 했을 때*/
-- TEST_ID 가 'TEST500000'인 행 조회하기
SELECT * FROM TB_IDX_TEST
WHERE TEST_ID = 'TEST500000';
-- 0.023 에서 0.014

/*인덱스 사용 했을 때*/
-- TEST_NO 가 500000인 행 조회하기
SELECT * FROM TB_IDX_TEST
WHERE TEST_NO = 500000;
-- 0.004 
-- 보통 검색 속도가 10~30배 차이 

