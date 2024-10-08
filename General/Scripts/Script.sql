
-- 김영희와 같은 지역에 사는 회원들의 지역명, 아이디, 이름, 등급명 오름차순 조회
SELECT  A.AREA_NAME 지역명, 
				M.MEMBER_ID 아이디, 
				M.MEMBER_NAME 이름, 
				G.GRADE_NAME 등급명
FROM TB_MEMBER M
JOIN TB_GRADE G ON(M.GRADE = G.GRADE_CODE)
JOIN TB_AREA A ON (M.AREA_CODE = A.AREA_CODE)
WHERE A.AREA_CODE = 
( SELECT AREA_CODE
FROM TB_MEMBER 
WHERE MEMBER_NAME = '김영희')
ORDER BY 이름 ASC;

------------------------

SELECT AREA_NAME 지역명, MEMBER_ID 아이디, MEMBER_NAME 이름, GRADE_NAME 등급명
FROM TB_MEMBER
JOIN TB_GRADE ON(GRADE = GRADE_CODE)
JOIN TB_AREA ON (AREA_CODE = AREA_CODE)
WHERE AREA_CODE = (
SELECT AREA_CODE 
FROM TB_MEMBER
WHERE 이름 = '김영희')
ORDER BY 이름 DESC;

----------------------------

SELECT AREA_CODE FROM TB_MEMBER
WHERE 이름 = '김영희';

SELECT AREA_CODE
FROM TB_MEMBER 
WHERE MEMBER_NAME = '김영희';

 SELECT MEMBER_NAME 
	FROM TB_MEMBER
	WHERE MEMBER_NAME = '김영희'