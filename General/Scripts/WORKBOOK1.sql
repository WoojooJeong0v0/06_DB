-- 1 학과 이름과 계열 조회
-- 출력헤더 학과 명, 계열로 표시
SELECT
	DEPARTMENT_NAME "학과 명",
	CATEGORY "계열"
FROM TB_DEPARTMENT;

-- 2 학과 학과 정원을 다음과 같은 형태로 조회
-- 국어국문학과의 정원은 20명 입니다
SELECT
	DEPARTMENT_NAME || '의 정원은' ||
	CAPACITY || '명입니다.' "학과별 정원"
FROM TB_DEPARTMENT;

-- 3 "국어국문학과"에 다니는 여학생 중 현재 휴학중인 여학생을 조회

SELECT
	STUDENT_NAME,
--	INSTR(ABSENCE_YN, 'Y')
	DECODE(SUBSTR(STUDENT_SSN, 8, 1), '2', '여자')
FROM TB_STUDENT
WHERE DEPARTMENT_NO = '001';

-- 4  대출 도서 장기 연체자들을 찾아 이름을 게시
-- 대상자들 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 작성
-- A513079, A513090, A513091, A513110, A513119

SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT;
--WHERE STUDENT_NO IN ('%A5');


-- 5 입학 정원이 20명 이상 30명 이하 학과 이름과 계열 조회

SELECT 
 DEPARTMENT_NAME "학과 명", 
 CAPACITY "정원",
 CATEGORY "계열"
FROM TB_DEPARTMENT
WHERE CATEGORY BETWEEN '20' AND '30';


-- 6 총장 제외 교수 소속학과 있다
-- 총장 이름을 확인할 문장 작성 
 SELECT PROFESSOR_NAME
 FROM TB_PROFESSOR
 WHERE DEPARTMENT_NO IS NULL;
 

-- 7 수강신청, 선수과목이 존재하는 과목들은 어떤 과목인지 과목 번호 조회


-- 8 어떤 계열이 있는지 조회
 SELECT DISTINCT(CATEGORY)
 FROM TB_DEPARTMENT;
 
-- 9 02학번 전주 거주자 모임
-- 휴학 사람 제외 학번, 이름, 주민번호 조회
SELECT 
	STUDENT_NO,
	STUDENT_NAME,
	STUDENT_SSN
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '%전주%'
			AND ABSENCE_YN LIKE 'N';
--			AND STUDENT_NO LIKE '%02';
			
		
-- 2-1 영어영문학과 (학과코드 002) 학생들의 학번, 이름, 입학 년도 
		-- 입학 년도가 빠른 순으로 표시
	SELECT
	 STUDENT_NO "학번",
	 STUDENT_NAME "이름",
	 ENTRANCE_DATE "입학년도"
	FROM TB_STUDENT
	WHERE DEPARTMENT_NO = '002'
	ORDER BY ENTRANCE_DATE ASC;
	
-- 2-2 교수 이름 중 이름이 세 글자가 아닌 교수 두 명
 -- 이름과 주민번호 조회
	SELECT 
		PROFESSOR_NAME,
		PROFESSOR_SSN
	FROM TB_PROFESSOR
	WHERE PROFESSOR_NAME LIKE '____%';
	
	-- 2-3 남 교수들 이름과 나이 오름차순 조회
 -- 단 교수 중 2000 이후 출생자 없고 나이는 만 계산
