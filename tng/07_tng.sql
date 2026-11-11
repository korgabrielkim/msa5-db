-- 1. 사원의 사원번호, 이름, 직급코드를 출력해 주세요.
SELECT
	emp.emp_id
	,emp.`name`
	,(tite.title_code)
FROM	employees AS emp
	JOIN title_emps AS tite
		ON emp.emp_id = tite.emp_id
			AND emp.fire_at IS null
			AND tite.end_at IS null
;

-- 2. 사원의 사원번호, 성별, 현재 연봉을 출력해 주세요.
SELECT
	emp.emp_id
	,emp.gender
	,sal.salary
FROM employees AS emp
	JOIN salaries AS sal
		ON emp.emp_id = sal.emp_id
			AND emp.fire_at IS null
			AND sal.end_at IS null
;

-- 3. 10010 사원의 이름과 과거부터 현재까지 연봉 이력을 출력해 주세요.
SELECT
	emp.`name`
	,sal.salary
FROM employees AS emp
	JOIN salaries AS sal
		ON emp.emp_id = sal.emp_id
WHERE
	emp.emp_id = 10010
-- '10010'을 넣으면 안되는 이유? datetype을 맞춰줘야 함. HeidiSQL에서는 자동 치환이 되지만, JAVA에서는 어림없음.
ORDER BY sal.start_at asc
;

-- 4. 사원의 사원번호, 이름, 소속부서명을 출력해 주세요.
SELECT
	emp.emp_id
	,emp.`name`
	,dep.dept_name	
FROM employees AS emp
	JOIN department_emps AS depe
		ON emp.emp_id = depe.emp_id
			AND depe.end_at Is null
			AND emp.fire_at IS null
	JOIN departments AS dep
		ON depe.dept_code = dep.dept_code
;

-- 5. 현재 연봉의 상위 10위까지 사원의 사번, 이름, 연봉을 출력해 주세요.
SELECT
	emp.emp_id
	, emp.`name`
	,sal.salary
FROM employees AS emp
	JOIN salaries AS sal
		ON emp.emp_id = sal.emp_id
			AND sal.end_at IS null
			AND emp.fire_at Is null
-- WHERE sal.salary >= (
--     SELECT AVG(sal.salary)
--     FROM salaries AS sal
-- )
ORDER BY sal.salary desc
LIMIT 10
;
-- ↓↓↓↓↓ 속도 개선 버전(공간 복잡도는 증가할 수 있음)
SELECT
	emp.emp_id
	,emp.`name`
	,tmp_sal.salary
FROM employees emp
	JOIN (
		SELECT
			sal.emp_id
			,sal.salary
		FROM salaries sal
		WHERE
			sal.end_at IS NULL
		ORDER BY sal.salary DESC
		LIMIT 10
	) tmp_sal
		ON emp.emp_id = tmp_sal.emp_id
			AND emp.fire_at IS NULL
ORDER BY tmp_sal.salary DESC
;

-- 6. 현재 각 부서의 부서장의 부서명, 이름, 입사일을 출력해 주세요.
SELECT
	dep.dept_name
	, emp.`name`
	, emp.hire_at
FROM employees AS emp
	JOIN department_managers AS depm
		ON emp.emp_id = depm.emp_id
			AND emp.fire_at Is NULL
			AND depm.end_at IS null
	JOIN departments AS dep
		ON depm.dept_code = dep.dept_code
			AND dep.end_at IS null
;

-- 7. 현재 직급이 "부장"인 사원들의 각각의 연봉 평균을 출력해 주세요.
SELECT
	tite.emp_id
	,truncate(AVG(sal.salary),0)
FROM title_emps AS tite
	JOIN salaries AS sal
		ON tite.emp_id = sal.emp_id
		AND tite.end_at IS null
	JOIN titles AS tit
		ON tit.title_code = tite.title_code
			AND tit.title = '부장'
GROUP BY tite.emp_id
order BY tite.emp_id 
;

-- 7-1. (보너스)현재 각 부장별 이름, 연봉평균
SELECT
	emp.`name`
	, truncate(AVG(sal.salary),0)
FROM title_emps AS tite
	JOIN salaries AS sal
		ON tite.emp_id = sal.emp_id
			AND tite.end_at IS null
	JOIN titles AS tit
		ON tite.title_code = tit.title_code
			AND tit.title = '부장'
	JOIN employees AS emp
		ON emp.emp_id = tite.emp_id
GROUP BY emp.`name`
ORDER BY tite.emp_id
;

-- 8. 부서장직을 역임했던 모든 사원의 이름과 입사일, 사번, 부서번호를 출력해 주세요.
SELECT
	emp.`name`
	,emp.hire_at
	,emp.emp_id
	,depm.dept_code	
FROM employees AS emp
	JOIN department_managers AS depm
		ON emp.emp_id = depm.emp_id
	JOIN departments AS dep
		ON dep.dept_code =depm.dept_code
;

-- 9. 현재 각 직급별 평균연봉 중 60,000,000이상인 직급의 직급명, 평균연봉(정수)를을 평균연봉 내림차순으로 출력해 주세요.

SELECT
	tit.title
	, truncate(AVG(sal.salary),0)
FROM salaries AS sal
	JOIN title_emps AS tite
		ON sal.emp_id = tite.emp_id
		AND sal.end_at IS null
		AND tite.end_at IS null
	JOIN titles AS tit
		ON tite.title_code = tit.title_code
GROUP BY tite.title_code HAVING AVG(sal.salary) >= 60000000
ORDER BY truncate(AVG(sal.salary),0) desc
;

SELECT
    tit.title,
    TRUNCATE(AVG(sal.salary), 0) AS avg_salary
FROM salaries AS sal
JOIN title_emps AS tite
    ON tite.emp_id = sal.emp_id
    AND tite.end_at IS NULL
JOIN titles AS tit
    ON tit.title_code = tite.title_code
WHERE sal.end_at IS NULL
GROUP BY tite.title_code
HAVING AVG(sal.salary) >= 60000000
ORDER BY avg_salary DESC
;

-- 10. 성별이 여자인 사원들의 직급별 사원수를 출력해 주세요.
SELECT
	tite.title_code
	,tit.title
	,COUNT(tite.title_code)
FROM employees AS emp
	JOIN title_emps AS tite
		ON emp.emp_id = tite.emp_id
			AND emp.fire_at Is null
			AND tite.end_at IS null
	JOIN titles AS tit
		ON tite.title_code = tit.title_code
where emp.gender = 'f'
GROUP BY tite.title_code, tit.title 
ORDER BY tite.title_code
;
-- ------------------------------
-- 전체 평균 급여보다 높은 급여를 받은 기록을 조회
-- 사번, 이름, 현재급여를 조회
SELECT
	emp.emp_id
	,emp.`name`
	,sal.salary
FROM salaries AS sal
	JOIN employees AS emp
		ON sal.emp_id = emp.emp_id
		AND sal.salary >= (
								 select
								 	avg(salaries.salary)
								 FROM salaries
								)
		AND sal.end_at IS null
		AND emp.fire_at IS null
;	
		
	
	


-- 가장 높은 급여를 받은 이력이있는 사원의 사번과 급여를 조회
SELECT
	salary
	,emp_id
FROM salaries
ORDER BY salary DESC
LIMIT 1
;