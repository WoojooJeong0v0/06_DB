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
	


-- 6번
-- 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다.
-- 그럼 춘 기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;


-- 7번
-- 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 과목들은
-- 어떤 과목인지 과목 번호를 조회하시오.
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;





-- 3- 1 학생 이름과 주소지를 조회
-- 출력헤더는 "학생 이름", "주소지"
-- 이름 오름차순 정렬

 SELECT STUDENT_NAME "학생 이름", STUDENT_ADDRESS "주소지"
 FROM TB_STUDENT
 ORDER BY "학생 이름" ASC;

-- 3-2 휴학 중인 학생들 이름과 주민번호를 나이가 적은 순 조회하기
SELECT STU.STUDENT_NAME "이름", SSN.STUDENT_SSN "주민번호"
FROM TB_STUDENT STU
LEFT JOIN TB_STUDENT SSN 
ON (STU.STUDENT_SSN = SSN.STUDENT_SSN)
WHERE STU.ABSENCE_YN = 'Y'
ORDER BY SUBSTR(SSN.STUDENT_SSN, 1, 6) ASC;
-- *  SELECT에서도 별칭을 적어줘야 정확한 열을 알 수 있음
-- ** 나이가 적은 순으로 정렬할 때에는 MIN으로 최소값 찾을 필요 없이
-- 		주민번호 6자리 잘라서 ASC로 정렬해보라고 해도 됨
--		좀더 정확하게 하고 싶으면 TO_DATE 써서 날짜로 바꿔서 하면 됨

-- 사실 join 안 해도 됨..

-- 3-3 주소지가 강원도나 경기도 학생 중 1900년대 학번을 가진 학생들의
-- 이름과 학번, 주소를 이름 오름차순으로 조회
-- 단, 출력헤더에는 "학생이름", "학번", "거주지 주소" 
SELECT 
STUDENT_NAME "학생 이름", 
STUDENT_NO "학번", 
STUDENT_ADDRESS "거주지 주소"
FROM TB_STUDENT
--WHERE STUDENT_ADDRESS IN ('강원%', '경기%')
--AND   STUDENT_NO LIKE '9%'
WHERE STUDENT_ADDRESS LIKE '강원%'
OR    STUDENT_ADDRESS LIKE '경기%'
ORDER BY STUDENT_NAME ASC;
-- 왜... 아무것도 안 뜨는 걸까 
--* IN 에서는 %를 못 쓰고, LIKE 절에서만 %를 사용할 수 있다

SELECT STUDENT_NO
FROM TB_STUDENT;

SELECT STUDENT_ADDRESS
FROM TB_STUDENT;


-- 3-4 현재 법학과 교수 이름, 주민번호를 나이가 많은 순서로 조회
SELECT P.PROFESSOR_NAME "교수 이름", P.PROFESSOR_SSN "주민 번호"
FROM TB_PROFESSOR P
JOIN TB_CLASS_PROFESSOR CP ON (P.PROFESSOR_NO = CP.PROFESSOR_NO)
LEFT JOIN TB_CLASS C USING (CLASS_NO)
WHERE CLASS_NAME LIKE '법학%';
--ORDER BY PROFESSOR_SSN DESC;
-- USING 에는 약어 사용 불가

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE TO_DATE('PROFESSOR_SSN', 'RRMMDD');



-- 3-5 
-- 2004 2학기에 'C3118100' 과목 수강한 학생들 학점 조회
-- 학점 높은 학생부터 표시
-- 학점이 같으면 학번이 낮은 학생부터 조회
-- 소수점 아래 2자리까지 0으로 표현 TO_CHAR(NUMBER, 'FM9.00')
-- 조회결과 양쪽 공백 제거
SELECT STUDENT_NO, TO_CHAR(POINT, 'FM9.00')
FROM TB_STUDENT
JOIN TB_GRADE USING (STUDENT_NO)
WHERE CLASS_NO = 'C3118100';
--ORDER BY 2 DESC;

-- FM : 양쪽 공백 제거
-- 9.00 은  9 오른쪽정렬 0은 왼쪽 정렬하여 빈칸에 숫자를 채운다는 뜻으로 포맷을 지정
-- USING 절을 쓰면 별칭 사용이 안 된다는데...
-- 될 때가 있고 안 될 때가 있기 때문에 대체로 USING 말고 ON 으로 쓰자는 추세


-- 3-6
-- 학생 번호, 학생 이름, 학과 이름을 학생 이름 오름차순으로 조회하시오.
SELECT 
	STUDENT_NO,
	STUDENT_NAME, 
	DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME ASC;


-- 3-7
-- 춘 기술대학교의 과목 이름, 해당 과목을 수업하는 학과 이름을 조회하시오.
SELECT 
	CLASS_NAME,
	DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);


-- 3-8
-- 과목, 해당 과목 교수 이름을 조회하시오.
SELECT
	CLASS_NAME,
	PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO);


-- 3-9
-- 8번의 결과 중 '인문 사회' 계열에 속한
-- 과목명, 교수이름을 과목명 오름차순으로 조회하시오
SELECT
	CLASS_NAME,
	PROFESSOR_NAME
FROM TB_CLASS CLA
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO)
JOIN TB_DEPARTMENT DEP ON (CLA.DEPARTMENT_NO = DEP.DEPARTMENT_NO)
WHERE CATEGORY = '인문사회'
ORDER BY CLASS_NAME ASC;


-- 3-10
-- 음악학과 학생들의 학번, 학생이름, 전체 평점 조회
-- 단 평점은 소수점 1자리까지만 반올림

SELECT STU.STUDENT_NO, STUDENT_NAME, ROUND(AVG(POINT), 1)
FROM TB_STUDENT STU
JOIN TB_DEPARTMENT DEP ON (STU.DEPARTMENT_NO = DEP.DEPARTMENT_NO)
JOIN TB_GRADE GRA ON (STU.STUDENT_NO = GRA.STUDENT_NO)
WHERE DEPARTMENT_NAME = '음악학과'
GROUP BY STU.STUDENT_NO, STUDENT_NAME;
-- 별칭 붙일 경우 필요한 모든 구절에 별칭으로 테이블 구분 해줘야 함!

-- 3-11 
-- 학번이 A313047인 학생의 학과 이름, 학생이름, 지도교수 이름 조회
SELECT DEPARTMENT_NAME, STUDENT_NAME, PROFESSOR_NAME
FROM TB_STUDENT STU
JOIN TB_PROFESSOR FRO ON (STU.COACH_PROFESSOR_NO = FRO.PROFESSOR_NO)
JOIN TB_DEPARTMENT DEP ON (STU.DEPARTMENT_NO = DEP.DEPARTMENT_NO)
WHERE STUDENT_NO = 'A313047';


-- 3-12 
-- 07년도 인간관계론 과목을 수강한 학생을 찾아 학생이름과 수강학기 조회하는 SQL작성 
