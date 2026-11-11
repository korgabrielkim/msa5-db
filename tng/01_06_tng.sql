-- 1. 직급테이블의 모든 정보를 조회해주세요.
SELECT
	*
FROM 
	titles
;

-- 2. 현재 급여가 60,000,000 이하인 사원의 사번을 조회해 주세요.
SELECT
	salaries.emp_id
FROM salaries
WHERE
	salary <= 60000000
	AND end_at IS null
;

-- 3. 현재 급여가 60,000,000에서 70,000,000인 사원의 사번을 조회해 주세요.
SELECT
	salaries.emp_id
FROM salaries
WHERE
	salary >= 60000000
	AND salary <= 70000000
	AND end_at IS null
;

-- 4. 사원번호가 10001, 10005인 사원의 사원테이블의 모든 정보를 조회해 주세요.
SELECT
	*
FROM employees
WHERE
	emp_id = 10001
	OR emp_id = 10005
;

-- 5. 직급에 '사'가 포함된 직급코드와 직급명을 조회해 주세요.
SELECT
	titles.title_code
	, titles.title
FROM titles
WHERE
	titles.title LIKE '%사%'
;

-- 6. 사원(퇴사자 포함) 이름 오름차순으로 정렬해서 조회해 주세요.
SELECT
	employees.name
FROM	employees
WHERE
	fire_at Is null
ORDER BY employees.name
;

-- 7. 사원별(톼사자 포함) 전체 급여의 평균을 조회해 주세요.
SELECT
	salaries.emp_id
	,ceil(AVG(salaries.salary)) AS avg_sal
FROM salaries
GROUP BY salaries.emp_id
;

-- 8. 사원별(퇴사자 포함) 전체 급여의 평균이 30,000,000 ~ 50,000,000인,
--   사원번호와 평균급여를 조회해 주세요.
SELECT
	salaries.emp_id
	, AVG(salaries.salary)
FROM salaries
GROUP BY salaries.emp_id
	HAVING AVG(salaries.salary) BETWEEN 30000000 AND 50000000
;

-- 9. 사원별(재직중인 사원만) 전체 급여 평균이 70,000,000이상인,
--   사원의 사번, 이름, 성별을 조회해 주세요.
SELECT
	emp.emp_id
	, emp.`name`
	,emp.gender
FROM employees AS emp
WHERE
	emp.emp_id in (
						select
							salaries.emp_id
						FROM salaries
						GROUP BY salaries.emp_id
							HAVING AVG(salaries.salary) >= 70000000
							 )
	and emp.fire_at IS NULL
		
ORDER BY emp_id
;

-- 10. 현재 직급이 'T005'인,
--   사원(재직중인 사원만)의 사원번호와 이름을 조회해 주세요.
SELECT
	emp.emp_id
	, emp.`name`
FROM employees AS emp
WHERE
	emp.fire_at IS null
	AND emp.emp_id IN (
							SELECT
								title_emps.emp_id 
							FROM title_emps 
							WHERE title_emps.title_code = 'T005'
								AND title_emps.end_at IS null
							)
; 
