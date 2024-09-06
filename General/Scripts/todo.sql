CREATE TABLE TO_DO (
TODO_NO NUMBER CONSTRAINT TO_DO_PK PRIMARY KEY,
TODO_SUB VARCHAR2(1000) NOT NULL,
TODO_COMPL CHAR(1) NOT NULL
CONSTRAINT TODO_COM_CHECK
  CHECK (TODO_COMPL IN ('O', 'X')),
TODO_DATE DATE DEFAULT CURRENT_DATE,
TODO_CONTENT VARCHAR2(4000) NOT NULL
);

COMMENT ON COLUMN TO_DO.TODO_NO IS '번호';
COMMENT ON COLUMN TO_DO.TODO_SUB IS '제목';
COMMENT ON COLUMN TO_DO.TODO_COMPL IS '완료여부';
COMMENT ON COLUMN TO_DO.TODO_DATE IS '작성일';
COMMENT ON COLUMN TO_DO.TODO_CONTENT IS '내용';


CREATE SEQUENCE SEQ_TODO_NO NOCACHE;
INSERT INTO TO_DO
VALUES(SEQ_TODO_NO.NEXTVAL, '테스트작성', 'O', DEFAULT, '할일 목록 테스트용도');
 
SELECT * FROM TO_DO;

COMMIT;
 

SELECT
	TODO_NO,
	TODO_SUB,
	TODO_COMPL,
	TO_CHAR(TODO_DATE, 'YYYY"년" MM"월" DD"일"') TODO_DATE,
	TODO_CONTENT
FROM TO_DO
WHERE TODO_NO = '2';