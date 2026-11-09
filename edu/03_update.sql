-- update 문
-- DML 중 하나로 저장되어 있는 기존 데이터를 수정하기 위해 사용하는 쿼리
-- <기본 형태>
-- update 테이블명
-- set
-- 	컬럼1 = 값1
--		[,컬럼 2 = 값 2...]
-- [where 절];

-- 100,005 사원의 이름을 변경하고 싶다.
UPDATE employees
SET
	`name` = '미어캣'
	, `gender` = 'f'
WHERE
	emp_id = 100005
;
-- 주의할 점 where절의 조건을 부여하지 않으면 전부다 변경됨.
-- update문을 이용할 때에는 set을 비워두고 where절을 먼저 작성 후, 따로 select 문에서 where 절이 적합한지 테스트 후, set 절을 적는것이 안전함.

-- 실습 예제 : 100005번 사원의 생일을 '2020-01-01', 이름은 '마이콜'로 변경해 주세요.
UPDATE employees
SET
	`name` = '마이콜',
	`birth` = '2020-01-01'
WHERE
	emp_id = 100005
;
