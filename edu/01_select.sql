-- DML : select, insert, update, delete
-- select가 가장 중요함.
-- 쿼리튜닝을 통해서, 작동 속도의 차이를 만들어 낼 수 있음. 심화 과정.
-- select 문 : DML 중 하나로, 저장되어 있는 데이터를 조회하기 위해 사용하는 쿼리.

-- SELECT 절 : 조회한 데이터 중 특정 컬럼만 출력
-- SELECT [DISTINCT] [컬럼명]
-- FROM [테이블명]
-- WHERE [쿼리 조건]
-- GROUP BY [컬럼명] HAVING [집계함수 조건]
-- ORDER BY [컬럼명 ASC || 컬럼명 DESC]
-- LIMIT [n] OFFSET [n];
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
	fire_at IS NULL -- null은 부등호로 비교 연산이 안됨 / 그래서 is null의 작성해줘야 함.
;
-- 퇴사한 사원 정보를 다 주세요.	
SELECT
	*
FROM employees
WHERE
	fire_at IS not NULL
;
-- 1990년생인 사원을 조회해 주세요.
SELECT
	*
FROM employees
WHERE
	YEAR(birth) = 1990
;
SELECT
	*
FROM employees
WHERE
	`birth` >= '1990-01-01'
	AND `birth` <= '1999-12-31'
;
-- 이름이 '김철수' 또는 '정유리'인 사원을 조회해 주세요.
SELECT
	*
FROM employees
WHERE
	`name`="김철수"
	OR `name`="정유리"
;
-- 1990년생 이거나, 이름이 '정유리'인 사원을 조회해 주세요.
SELECT
	*
FROM employees
WHERE
	YEAR(birth) = 1990
	OR `name` = "정유리";
	SELECT
	*
FROM employees

WHERE -- and와 or을 같은 조건에 사용을 하면 논리 오류가 발생할 수 있다. 수학 연산시()와{}가 혼재 된 느낌. MySQL에서는 or 연산자 보다 and 연산자를 선순위로 인식한다고 함.
	(`birth` >= '1990-01-01'
	AND `birth` <= '1990-12-31')
	OR `name` = "정유리"
;

-- and와 or의 잘못된 예시 : 1990년 이후에 태어난, '정유리' 또는 '박보람'을 검색해 주시오.
SELECT
	*
FROM employees
WHERE
	birth >= '1990-01-01'
	AND `name` = '정유리'
	OR `name` = '박보람'; -- 이러면 1970년대 생인 '정유리'와 '박보람'이 함께 출력됨.
SELECT
	*
FROM employees
WHERE
	birth >= '1990-01-01'
	AND (`name` = '정유리'
	OR `name` = '박보람');
-- between 연산자 : 지정한 범위 내의 데이터를 조회.
SELECT
 *
FROM employees
WHERE
	birth >= '1990-01-01'
	AND birth <= '1990-12-31'
;
SELECT
	*
FROM employees
WHERE
	birth BETWEEN '1990-01-01' AND '1990-12-31'
; -- between 문법은 구버전의 오라클과 같이  SQL 프로그램에서 조금 느리게 작동 할 수 있다고 함.(퍼포먼스 이슈)
-- In 연산자 : 다수의 지정한 값과 일치하는 데이터를 조회
SELECT
	*
FROM employees
WHERE
	`name`="박보람"
	OR `name`="정유리"
;
SELECT
	*
FROM employees
WHERE
	`name` IN("박보람","정유리","김민수")
-- 위에 작성한 or 코드랑 동일한 효과를 발생하는 코드라고 보면 됨. 다수의 데이터를 불러올 때 or 보다 유리.
-- but, in 연산자도 퍼포먼스 이슈가 있다고 함.
;
SELECT
	*
FROM employees
WHERE
	`emp_id` IN(10001,10005,10006)
;
-- like 절 : 문자열의 내용을 조회 반듯이 문자열 데이터에만 사용하는 것을 추천함. text, longtext 속성에서 사용하면 속도가 엄청 느림.
-- % 사용 : 글자수와 상관없이 조회할 경우 사용하는 기호.
-- 이름이 '우'로 끝나는 사원 조회
SELECT
	*
FROM employees
WHERE
	`name` LIKE("%우%");
-- %우%는 어느 곳에 상관 없이 이름에 '우'가 포함되어 있으면 다들어옴.
-- %우는 '우' 앞에 몇글자가 오던지 상관 없음.
-- 우%는 '우'로 시작하는 이름을 출력함.
SELECT
	*
FROM employees
WHERE
	`name` LIKE "%우";
-- (_): 언더바의 개수만큼 글자수를 허용해서 조회.
SELECT
	*
FROM employees
WHERE
	`name` LIKE "_우%";
	SELECT
	*
FROM employees
WHERE
	`birth` LIKE "____-12-%";
-- 나중에 풀택스트 서치를 공부해 보라는 멘트 있었음.
-- 밑에 코드는 아직 몰라도 됨.
-- SELECT
-- 	*
-- FROM employees
-- WHERE
-- 	MATCH(`name`) AGAINST('우우우' IN NATURAL LANGUAGE MODE); -- in natural language mode는 자연어라는 의미임. 모드는 다양하게 존재한다고 함. 한글에서는 세글자 이하의 단어에서는 오류가 발생한다고 함.
-- ALTER TABLE employees ADD FULLTEXT INDEX fi_employees_name (`name`);
-- order by 절 : 조회한 데이터를 정렬.
SELECT
	*
FROM employees
ORDER BY `name` ASC-- ASC 오름차순 , DESC 내림차순, 생략하면 defualt 값이 오름차순으로 잡혀 있음.
;
-- 정렬기준을 여러개를 잡고 싶을 때
SELECT
	*
FROM employees
ORDER BY `name` ASC, `birth` -- 선행 작성한 컬럼이 우선순위를 가짐. MySQL은 속성값이 null이라면 가장 우선적으로 가져옴 / 오라클은 가장 후순위로 가져옴
;
-- 가장 동명이인이 많은 이름 찾기.
SELECT
    `name`,
    COUNT(*) AS cnt
FROM employees
GROUP BY `name`
ORDER BY `name`, cnt DESC
; 
-- 데이터 베이스의 각 컬럼들은 순서성을 가지고 있지 않음. 즉, 스키마를 만들때 먼저 작성한 속성이 앞에 나온다고 볼 수 있음.
-- limit 키워드, offset 키워드 문 : 출력의 개수를 제한.
SELECT
	*
FROM employees
LIMIT 5 OFFSET 1; -- defualt가 0임. 컴퓨터 언어라고 생각하면 기억하기 쉬울 것 같음.

SELECT
	*
FROM employees
LIMIT 1, 5 -- 이 경우 위의 코드와 결과는 동일. 대신 앞쪽이 offset값이고 뒷쪽이 limit값임.
;
-- 집계함수
-- sum(컬럼) : 조회 된 해당 컬럼의 모든 값의 합계를 반환
-- 전 사원의 지금 급여 합 출력.
SELECT
	SUM(`salary`) AS sum_sal
FROM salaries
WHERE
	end_at IS NULL; -- ※ 마지막 급여가 없는 것이 가자 최근 급여로 설정해 두었음.
-- max(컬럼)
SELECT
	max(`salary`) AS max_sal
FROM salaries
WHERE
	end_at IS NULL;
-- min(컬럼)
SELECT
	min(`salary`) AS min_sal
FROM salaries
WHERE
	end_at IS NULL;
-- avg(컬럼)
SELECT
	avg(`salary`) AS avg_sal
FROM salaries
WHERE
	end_at IS NULL;
-- count(컬럼)
-- 현재 재직중인 사원수를 산출하기.
SELECT
	COUNT(*) AS cnt -- count는 null을 집계하지 않음.
FROM employees
WHERE
	fire_at Is NULL;
-- distinct 키워드 : 검색결과에서 중복된 레코드를 없이 출력. 레코드 단위로 중복된걸 줄여준다는게 포인트, 만약 기본키와 같이 넣으면 모두 뜸.
SELECT DISTINCT -- distinct는 select 바로 옆에 작성함.
	name
FROM employees
ORDER BY `name`;
-- group by 절, having 절 : 그룹으로 묶어서 조회를 할 때 사용.
-- 부서별 사원수 출력
SELECT
	dept_code
	, COUNT(dept_code) as cnt_emps -- as 생략 가능함.
	 -- group by를 사용할 경우, select에 적을 수 있는 컬럼은 1. 집계 함수이거나 2. group by에 사용한 컬럼명이 와야함. (SQL 표준 문법)
FROM department_emps
WHERE
	end_at IS null
GROUP BY
	dept_code -- 이 컬럼을 기준으로 그룹을 묶는다.
ORDER BY
	cnt_emps desc
LIMIT 0,3
;
-- 직급별 사원수가 10,000명 이상(그룹하는 방법에 규칙이 들어갈 때에는 having절에 줘야 함)인 직급을 조회해 주세요.
SELECT
	COUNT(emp_id) AS cnt_title
FROM title_emps
WHERE
	end_at IS null
GROUP BY
	title_code
		HAVING cnt_title >= 10,000
;
-- where 절 : 데이터를 가져올때 필터링 조건 vs having 절 : 그룹핑에 조건을 줄 때
