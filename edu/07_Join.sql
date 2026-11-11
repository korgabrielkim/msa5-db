-- JOIN문
-- 두개 이상의 복수의 테이블을 묶어서 하나의 결과 집합으로 출력.

-- <Inner Join>
-- 복수의 테이블이 공통적으로 만족하는 레코드를 출력
-- 전 사원의 사번, 이름, 현재 급여를 출력해주세요.
SELECT
	emp.emp_id
	, emp.`name`
	, sal.salary
FROM employees AS emp JOIN salaries AS sal
	ON emp.emp_id = sal.emp_id
	and sal.end_at IS NULL
;
-- 재직중인 사원의 사번, 이름, 생일, 부서명을 출력
SELECT
	employees.emp_id
	,employees.`name`
	,employees.birth
	,departments.dept_name
FROM employees
	JOIN department_emps
		ON employees.emp_id = department_emps.emp_id
		AND employees.fire_at IS null
	JOIN departments
		on departments.dept_code = department_emps.dept_code
		AND department_emps.end_at IS NULL
;

-- <Left Join>
-- 재직중인 전 사원 정보를 출력하는데, 현재 부서장인 사원이면, 부서장 정보도 같이 출력해주세요.
SELECT
	emp.emp_id
	, emp.`name`
	, tmp_manager.dept_name
	, tmp_manager.dept_code
FROM employees AS emp
	LEFT JOIN (
		select
			depm.emp_id
			,dep.dept_name
			,dep.dept_code
		FROM departments as dep
			JOIN department_managers as depm
				ON dep.dept_code = depm.dept_code
					AND depm.end_at IS null
	) AS tmp_manager
		ON emp.emp_id = tmp_manager.emp_id
			AND emp.fire_at IS null
ORDER BY tmp_manager.dept_code IS NULL, tmp_manager.dept_code
;

SELECT
	emp.emp_id
	,emp.`name`
	,depm.dept_code
	,dep.dept_name
FROM employees emp
	LEFT JOIN department_managers AS depm
		ON emp.emp_id = depm.emp_id
			AND emp.fire_at IS null
			AND depm.end_at IS null
	LEFT JOIN departments AS dep
		ON dep.dept_code = depm.dept_code
ORDER BY depm.dept_code DESC
; 

SELECT
	emp.emp_id
	,emp.`name`
	,depm.dept_code
	,dep.dept_name
FROM employees emp
	LEFT JOIN (department_managers depm
		JOIN departments dep
			ON dep.dept_code = depm.dept_code
				AND depm.end_at IS NULL
	)
		ON emp.emp_id = depm.emp_id
			AND emp.fire_at IS NULL		
ORDER BY depm.dept_code IS NULL, depm.dept_code
;

-- <Union>
-- 두개 이상의 쿼리의 결과를 합쳐서 출력.
-- union : 중복 레코드를 제거하고 가져옴. 레코드의 단 하나의 컬럼만 달라도 모든 정보를 불러온다고 생각해야 함
-- union을 사용할 때에는 컬럼의 갯수가 동일해야함.
-- union all : 중복 레코드를 제거하지 않음.
SELECT * FROM employees WHERE emp_id IN(1,3)
UNION
SELECT * FROM employees WHERE emp_id IN(1,5)
;

-- <Self Join>
-- 같은 테이블끼리 조인
-- 현재 슈퍼바이저인 사원 정보 출력
-- 댓글의 댓글(대댓글)을 넣는 기능을 실현하기 위해서는 Self Join을 사용할 가능성이 높음.
SELECT
	emp.emp_id AS junior_emp_id
	,emp.`name` AS junior_name
-- 	,emp.sup_id
	,sup.emp_id AS sup_emp_id
	,sup.`name` AS sup_name
FROM employees AS emp
	JOIN employees AS sup
		ON emp.sup_id = sup.emp_id
			AND emp.sup_id IS NOT null
;
