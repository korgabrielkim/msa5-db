-- DML : select, insert, update, delete
-- select가 가장 중요함.
-- 쿼리튜닝을 통해서, 작동 속도의 차이를 만들어 낼 수 있음. 심화 과정.
-- select 문 : DML 중 하나로, 저장되어 있는 데이터를 조회하기 위해 사용하는 쿼리.

-- SELECT 절 : 조회한 데이터 중 특정 컬럼만 출력
-- SELECT [DISTINCT] [컬럼명] FROM [테이블명] WHERE [쿼리 조건] GROUP BY [컬럼명] HAVING [집계함수 조건] ORDER BY [컬럼명 ASC || 컬럼명 DESC] LIMIT [n] OFFSET [n];
SELECT `emp_id`
	, `name`
--  	, `gender` del v2.0
	, `birth` -- add v2.0
FROM employees; 
-- NAME이 자동으로 대문자 및 파란색으로 변경되는 이유는 HeidiSQL에서 사용하는 예약어기 때문에 변하는 것임. 그렇기에 빽틱``으로 감싸주면 좀더 안전하게 컬럼으로 인식시켜  사용이 가능함. 
-- 선택 실행은 내가 드래그 한 영역만 실행함.
-- 현재 쿼리 실행 : 커서를 기준으로 가장 가까운 세미콜론이 있는것 까지 실행함.
SELECT `emp_id`, `name` FROM employees;

-- Asterrisk (= *) : 모든 컬럼 조회
SELECT
	*
from employees;
-- Where 절 : 특정 컬럼의 값이 조건에 맞는 데이터만 조회하기 위해서 사용(필터링)
-- 사번이 10009인 사원의 모든 정보를 조회해 주세요.
SELECT
	*
FROM employees
WHERE `emp_id` = 10009; -- emp_id는 bigint의 속성을 가지고 있음. 그렇기에 속성에 맞춰서 작성해 주는 것이 좋음. MySQL은 '10009'라고 입력을 해도 검색은 됨.
-- 사원명이 "박보람"인 사원의 정보를 조회해 주세요.
SELECT
	emp.birth
FROM employees AS emp
WHERE `name` = "박보람";
-- 생일이 2000-01-01 이후인 사원 모두 찾아주세요.
SELECT
	*
FROM employees
WHERE `birth` >='2000-01-01'; -- 만약 birth의 속성이 시분초까지 있다면 '2000-01-01 00:00:00'
-- 오늘 생일자인 사람 찾아보기 AI
SELECT
	*
FROM employees
WHERE
	MONTH(birth) = MONTH(SUBDATE(NOW(),INTERVAL 5 DAY))
	AND DAY(birth) = DAY(SUBDATE(NOW(),INTERVAL 5 DAY))
;
-- 퇴사하지 않은 사원 정보를 다 주세요.
SELECT
	*
FROM employees
WHERE
	fire_at IS NULL; -- null은 부등호로 비교 연산이 안됨 / 그래서 is null의 작성해줘야 함.

-- 퇴사한 사원 정보를 다 주세요.	
SELECT
	*
FROM employees
WHERE
	fire_at IS not NULL;