-- 241114 공지사항 가데이터 등록 진행
SELECT * FROM NOTICE;

CREATE SEQUENCE SEQ_NOTICE_NO NOCACHE;

alter TABLE "NOTICE" ADD
"NOTICE_WRITE_DATE"	DATE	DEFAULT CURRENT_DATE	NOT NULL;

COMMENT ON COLUMN "NOTICE"."NOTICE_WRITE_DATE" IS '공지 작성일';

COMMIT;

		INSERT INTO "NOTICE"
		VALUES(
			SEQ_NOTICE_NO.NEXTVAL,
			SEQ_NOTICE_NO.CURRVAL || '번째 공지 제목',
			SEQ_NOTICE_NO.CURRVAL || '번째 공지 게시글 내용입니다',
			DEFAULT);
			
		
-- 디바이스 샘플 데이터 넣기
		-- 아이폰13 
INSERT INTO "DEVICE"
VALUES (
   SEQ_DEVICE_NO.NEXTVAL,
   TO_DATE ('20210915', 'YYYY-MM-DD'),
   '1090000',
   '222',
   'iOS 15',
   '2532 x 1170',
   '19.5:9 비율 Super Retina XDR Display',
   '1,200만',
   '1,200만 / 1,200만',
   DEFAULT, DEFAULT,
   '173 g',
   '3,227 mAh',
   'iPhone 13',
   '735000', -- 사기
   '570000',  -- 팔기
   'Apple',
   '4',
   '2x Apple Avalanche 3.23 GHz, 4x Apple Blizzard 2.00 GHz',
   '1'
);
-- 아이폰13 PRO 
INSERT INTO "DEVICE"
VALUES (
   SEQ_DEVICE_NO.NEXTVAL,
   TO_DATE ('20210917', 'YYYY-MM-DD'),
   '1350000',
   '222',
   'iOS 15',
   '2532 x 1170',
   '19.5:9 비율 Super Retina XDR Display',
   '1,200만',
   '1,200만 / 1,200만',
   DEFAULT, DEFAULT,
   '203 g',
   '3,095 mAh',
   'iPhone 13 PRO',
   '735000', -- 사기
   '570000',  -- 팔기
   'Apple',
   '4',
   '2x Apple Avalanche 3.23 GHz, 4x Apple Blizzard 2.00 GHz',
   '1' -- 디바이스 디스플레이 코드
);

SELECT *
FROM DEVICE ;
                  
-- 아이폰 13
INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '미드나이트',
   '#181F26',
   '이미지',
   '24'                  -- 기종 번호
);

INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '스타라이트',
   '#fbf7f4',
   '이미지',
   '24'
);

INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '블루',
   '#437691',
   '이미지',
   '24'
);

INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '핑크',
   '#fbe2dd',
   '이미지',
   '12'
);

INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '그린',
   '#556654',
   '이미지',
   '12'
);

-- 아이폰13 PRO
INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '그래파이트',
   '#605e5a',
   '이미지',
   '24'                  -- 기종 번호
);

INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '실버',
   '#e5e6e1',
   '이미지',
   '24'
);

INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '골드',
   '#fcecd5',
   '이미지',
   '24'
);

INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '시에라블루',
   '#abc4db',
   '이미지',
   '24'
);

INSERT INTO COLOR 
VALUES (
   SEQ_COLOR_NO.NEXTVAL,
   '알파인 그린',
   '#576856',
   '이미지',
   '24'
);

-------------------

INSERT INTO "CAPACITY_PRICE"
VALUES (
   12, 2, 0, 0               -- 기종 번호, 용량 코드, 가격
);

INSERT INTO "CAPACITY_PRICE"
VALUES (
   12, 3, 90000, 50000
);

INSERT INTO "CAPACITY_PRICE"
VALUES (
   12, 4, 170000, 90000         
);

INSERT INTO "CAPACITY_PRICE"
VALUES (
   12, 5, 250000, 150000
);

INSERT INTO "CAPACITY_PRICE"
VALUES (
   24, 2, 0, 0               -- 기종 번호, 용량 코드, 가격
);

INSERT INTO "CAPACITY_PRICE"
VALUES (
   24, 3, 90000, 50000
);

INSERT INTO "CAPACITY_PRICE"
VALUES (
   24, 4, 170000, 90000         
);


SELECT * FROM "CAPACITY_PRICE";

SELECT *
FROM GRADE;
            
            
COMMIT;

INSERT INTO "GRADE"
VALUES (
   SEQ_GRADE_NO.NEXTVAL,
   'B', 0, 0, 12                  -- 기종 번호
);

INSERT INTO "GRADE"
VALUES (
   SEQ_GRADE_NO.NEXTVAL,
   'A', 40000, 20000, 12
);

INSERT INTO "GRADE"
VALUES (
   SEQ_GRADE_NO.NEXTVAL,
   'S', 30000, 40000, 12
);

INSERT INTO "GRADE"
VALUES (
   SEQ_GRADE_NO.NEXTVAL,
   'B', 0, 0, 24                  -- 기종 번호
);

INSERT INTO "GRADE"
VALUES (
   SEQ_GRADE_NO.NEXTVAL,
   'A', 40000, 20000, 24
);

INSERT INTO "GRADE"
VALUES (
   SEQ_GRADE_NO.NEXTVAL,
   'S', 30000, 40000, 24
);


--- 1119 이벤트 DB 확인
SELECT *
FROM event;


alter TABLE "EVENT" ADD
"EVENT_TITLE"	VARCHAR2(500)	NOT NULL;

alter TABLE "EVENT" ADD
"EVENT_CONTENT"	VARCHAR2(2000)	NOT NULL;

COMMIT;

-- 이벤트게시판에 썸네일 파일 경로 저장하기 

alter TABLE "EVENT" ADD
"EVENT_THUMBNAIL"	VARCHAR2(2000)	NOT NULL;


-- 1126 메인 배너 추가 

SELECT *
FROM MEMBER;

