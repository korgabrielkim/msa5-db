-- 연습 : 레코드 추가하기
INSERT INTO employees(
 `name`,`birth`,`gender`,`hire_at`)
VALUE ('김블루','2010-11-09','M',NOW())
	, ('김핑크','2010-11-09','F',NOW())
	, ('김블랙','2010-11-09','M',NOW())
	, ('김레드','2010-11-09','W',NOW()) -- 잘못 기입. 성별을 F로 바꿔야함.
;

-- 연습 : 레코드 수정하기 + transaction
START TRANSACTION;
UPDATE employees
SET `gender`="F"
WHERE
	emp_id=100012
;
COMMIT;

-- 연습 : 김블랙씨 레코드를 삭제하기
DELETE FROM employees
WHERE emp_id=100011
;

-- <GPT 예제 1.>
-- employees 테이블에 다음 사원 정보를 추가해 보세요.
-- 이름: 김철수
-- 생년월일: 1995-05-20
-- 성별: M
-- 입사일: 현재 날짜와 시간
-- 조건: 자동으로 생성되는 사번과 기본값이 설정되는 컬럼은
-- 직접 입력하지 마세요.
INSERT INTO employees(`name`,birth,gender,hire_at)
VALUE ("김철수","1995-05-20","M",NOW())
;

-- <GPT 예제 2.>
-- 사번이 100005인 사원의 정보를 다음과 같이 변경하세요.
-- 이름: 남길순
-- 성별: F
UPDATE employees
SET
	`name` = "남길순"
	,`gender` = "F"
WHERE
	emp_id = 100005
;

-- 연습 : employees의 데이터를 title_emps에 추가 시키기 isert - select
START TRANSACTION;
INSERT INTO title_emps(emp_id,title_code,start_at)
SELECT
	emp_id, "T001", employees.hire_at
FROM employees
WHERE
	`hire_at` >= "2026-11-09"
;
COMMIT;

-- <GPT 예제 3.>
-- title_emps 테이블에서 시작일(start_at)이 2026-11-09 이후인 데이터만 삭제하는 SQL문을 작성하세요.
DELETE FROM title_emps
WHERE `start_at` >= "2026-11-09"
;
-- SELECT * FROM title_emps WHERE `start_at` >= '2026-11-09';

-- <GPT 예제 4.>
-- employees 테이블에서 다음 정보를 조회하세요.
-- 사번
-- 이름
-- 성별
-- 성별이 M이면 남자, F이면 여자로 표시하는 kor_gender 컬럼
SELECT
	`emp_id`
	,`name`
	,if(`gender`='M',"남자","여자") AS kor_gender
FROM employees
;

-- <GPT 예제 5.>
-- employees 테이블에서 다음 정보를 조회하세요.
-- 사번
-- 이름
-- 퇴사일(fire_at)
-- 퇴사일이 NULL이면 '재직중', 그렇지 않으면 퇴사일을 표시하는
-- employed 컬럼
SELECT
	`emp_id`
	, `name`
	, IFNULL(`fire_at`,'재직중')
FROM employees
;
	