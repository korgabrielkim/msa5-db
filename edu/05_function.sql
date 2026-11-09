-- 내장 함수(function) 
--
-- <데이터 타입 변환 함수>
-- 
SELECT
	1234
 	,CAST(1234 AS char(6)) -- 이렇게 바꿔도 되고
 	, CONVERT(1234, CHAR(6)) -- 이렇게 바꿔도 된다는 의미임.
;
SELECT CONVERT(emp_id, char(20))
FROM employees
WHERE emp_id = 100005
;
-- 
-- <제어 흐름 함수>
-- 
-- if(수식, 참일 경우의 값, 거짓일 경우의 값)
SELECT
	`name`
	, `gender`
	, if(`gender`='M','남자','여자') as kor_gender
FROM employees
;
-- ifnull(수식1, 수식2)
-- 수식1이 null이면 수식2를 반환, 아니면 수식 1을 반환함.
SELECT
	`name`
	,IFNULL(
		fire_at
		, '재직중'
		) AS employed
from employees
;
-- nullif(수식1, 수식2)
-- 수식1과 수식2를 비교해서, 같으면 Null을 반환, 다르면 수식 1을 반환.
SELECT
	NULLIF(`gender`,'M')
FROM employees
;
-- 
-- case ~ when ~ else ~ end
SELECT
	case `gender`
		when 'M' then '남자'
		when 'F' then '여자'
		ELSE '기타'
	END AS K_Gender
FROM employees
;
-- 내장함수는 대부분 select문에 작성을 하는 경우가 많다고 함.
-- 
-- <문자열 함수>
-- 
-- 문자열 연결
SELECT CONCAT('안녕',' ','하세요.');
SELECT CONCAT(`name`,' & ', `gender`) FROM employees;
-- 구분자로 문자열을 연결
SELECT CONCAT_WS('포기, ','자바','JS','HTML'); -- 첫번째 콜럼 안의 문자는 각 단어를 이어줄 때 그 사이에 들어가는 문자라고 보면 됨.
SELECT CONCAT_WS('입니다',`name`,`gender`) FROM employees;
--  숫자에 자릿수(,) 및 소수점 자리수 표시
SELECT
	FORMAT(`salary`, 0)
FROM salaries
;
-- 문자열의 왼쪽/오른쪽부터 길이만큼 잘라 반환
SELECT
LEFT('123456',2) left_2nd
, RIGHT('123456',2) right_2nd
;
-- 문자열의 조 or 우에 문자열 길이만큼 채울 문자열을 삽입
SELECT
LPAD('123',6,'0') -- LPAD('원본값',글자수,'채울글자');
, RPAD('123',6,'0');
-- 문자열의 좌 or 우 공백 제거
SELECT
	'	   			test'
	, TRIM('		   		test')
	, LTRIM('	   			test')
	,RTRIM('		   		test')
;
SELECT
	TRIM(BOTH 'a' FROM 'abcdefa');
SELECT
	TRIM(leading 'a' FROM 'abcdefa'); -- 앞쪽에 있는 것만 지우는 것.
SELECT
	TRIM(trailing 'a' FROM 'abcdefa'); -- 뒷쪽에 있는 것만 지우는 것.
-- 문자열을 시작위치에서 길이만큼 잘라서 반환
SELECT
	SUBSTRING('123456', 3, 2); -- ('원본, 자르기 시작할 위치(포함), 자를 갯수)
-- 왼쪽부터 구분자가 n번째 만큼 나오면 그 이후를 버림
SELECT
	SUBSTRING_INDEX(
	'abc_test_123.txt'
	,'_',2) txt -- ('원본값', '기준 문자', 몇번째까지만 가져올지 지정할  수(※ 참고로 -숫자는은 우측편에서 부터임))
;
-- 영어 대소문자 변경
SELECT
	UPPER('navernevernaver15856')
	, LOWER('sfsdfwersdWERWEFSDFWERDGHDHSsdgdfgs')
;
SELECT
	CONCAT(
		UPPER(SUBSTRING('test',1,1))
		,LOWER(SUBSTRING('test',2,3))
		) first_Upper
;
-- 
-- <수학 함수>
-- 올림, 반올림, 버림
SELECT
	CEIL(3.14)
	,FLOOR(3.14)
	,ROUND(3.14)
;
-- 절대값
SELECT
	ABS(`birth`), ABS(1)
FROM employees
;
-- 소수점을 기준으로 특정 자리수까지 구하고 나머지는 버리고 싶을 때
SELECT
	TRUNCATE(1.19,0)
;
-- 현재 날짜 및 시간 반환(yyyy-mm-dd hh:mi:ss)
SELECT NOW();
-- 연월일만 반환 yyyy-mm-dd
SELECT DATE(NOW());
SELECT
	DATE(`created_at`)
FROM employees
;
-- 날짜의 단위 기간에 따라 더한 날짜/시간을 반환
SELECT
	ADDDATE(NOW(),INTERVAL 1 year) -- month, day, hour, minute, second, microsecond
;

-- 
-- 순차함수
-- 
-- <기본 형식>
-- rank() over(order By 컬럼 ASC/DESC)
-- 지정한 컬럼을 기준으로 순위를 매겨 반환
-- 동일한 값이 있는 경우 동일한 순위를 부여
SELECT
	emp_id
	, salary
	, RANK() OVER(ORDER BY salary DESC) AS `rank`
FROM salaries
WHERE
	end_at IS NULL
; -- 동일한 값인 경우, 공동 랭킹으로 나오고 공동 랭킹 수만큼 뒷 랭킹이 사라짐.
-- row_number() over(order by 컬럼 asc/desc)
-- 레코드에 순위를 매겨 반환
-- 동일한 값이 잇는 경우에도 각 행에 고유한 번호를 부여.-> 중복된 랭킹이 존재하지 않음.
SELECT
	emp_id
	, salary
	, row_number() OVER(ORDER BY salary DESC, emp_id) AS `rank` -- desc 뒤에 emp_id를 붙이면 동일 값에서 emp_id 값을  오름차순으로 순위를 정리함
FROM salaries
WHERE
	end_at IS NULL
	AND salary >= 80000000
;
SELECT
	emp_id
	, salary
	, DENSE_RANK() OVER(ORDER BY salary DESC, emp_id asc)
from salaries
WHERE
	end_at IS NULL
;