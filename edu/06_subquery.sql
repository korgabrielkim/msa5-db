-- subQuery
-- 
-- <where절에서 사용>
-- 단일 행 서브 쿼리
-- 서브쿼리가 단일 행 비교 연산자와 함께 사용할 때는
-- 반드시 서브쿼리의 결과 수가 1건 이어야 함.
-- 결과가 2건 이상일 경우 오류가 발생.
-- D001 부서장의 사번과 이름을 출력해주세요.
SELECT
	emp.`emp_id`
	, emp.`name`
FROM employees AS emp -- 사번과 이름을 출력하니까 employees 테이블을 잡은 것임.
WHERE
	emp.emp_id = (
	select
		emp_id
	FROM department_managers AS depm
	where
		depm.dept_code = 'D001'
		AND depm.end_at IS NULL -- subQuery의 값이 하나일 때 사용함.
	)
;
-- (결과 값이) 다중 행 서브쿼리
-- 서브쿼리의 결과가 2건 이상을 반환할 경우
-- 반드시 다중 행 비교연산자(in, all, any, some, exists)를 사용
-- 현재 부서장인 사원의 사번과 이름을 출력
SELECT
	emp.emp_id
	,emp.`name`
FROM employees emp
WHERE
-- IN 연산자 : 다수의 지정한 값과 일치하는 데이터 조회
	emp.emp_id IN (SELECT
						depm.emp_id
						FROM department_managers AS depm
						WHERE
						end_at IS NULL)
;
-- (결과 값이) 다중 열 서브 쿼리 
-- 현재 'D002' 부서장이 해당 부서에 소속된 날짜를 출력
SELECT
	depe.start_at
FROM department_emps as depe
WHERE -- 메인 쿼리의 출력 순서와 서브 쿼리의 결과값을 맞춰줘야 함.
	(depe.emp_id, depe.dept_code) IN (SELECT
												depm.emp_id
												, depm.dept_code
											FROM department_managers as depm
											WHERE
												depm.dept_code = 'D002'
												AND depm.end_at IS NULL)
;
-- 연관 서브쿼리 : CPU나 메모리를 많이 사용하는 성능 이슈가 있음. 그래서 현업에서는 지양한다고 함.
-- 서브쿼리 내에서 메인쿼리의 컬럼이 사용된 서브쿼리.
-- 부서장직을 지냈던 경력이 있는 사원의 정보를 출력
SELECT
	emp.*
FROM employees AS emp
WHERE
	emp.emp_id IN(
		select
			depm.emp_id
		FROM department_managers as depm
		where
			depm.emp_id = emp.emp_id
	)
;
-- 위의 코드를 조인문으로 표현했을 때!
SELECT
 emp.*
FROM employees as emp
	JOIN department_managers as depm
		ON emp.emp_id = depm.emp_id
;
-- <select절에서 사용>
-- 사원별 역대 전체 급여 평균
SELECT -- 속도가 너무 느림. 차라리 Group By 절을 사용하는게 합리적임.
	emp.emp_id
	, (select
			AVG(sal.salary)
		FROM salaries AS sal
		WHERE sal.emp_id = emp.emp_id
		) AS avg_sal	
FROM employees as emp
;
-- <from절에서 사용>
SELECT
	tmp.*
FROM (
	select
		emp.emp_id
		,emp.`name`
	FROM employees AS emp
	where
		fire_at Is NOT NULL
	) AS tmp
; -- db서버를 충분하지 못할 때, cpu(하드웨어)를 소모해서 대처할 때 사용하면 됨. 즉 기회비용을 생각해서 join문과 비교 활용!
-- <insert문에서 사용>
-- 내가 조회한 결과를 특정 컬럼의 값으로 사용하고 싶을 때 사용.
INSERT INTO employees (
	employees.emp_id, employees.`name`, employees.birth, employees.gender, employees.hire_at 
)
VALUES(
	(SELECT MAX(emp.emp_id) +1 FROM employees AS emp), '고둘리', '1983-04-22', 'M', NOW()
);
-- <update문에서 사용>
-- 퇴사한 사원의 직급 테이블의 직급 종료일을 퇴사일로 갱신해주세요.
UPDATE title_emps 
SET
	title_emps.end_at = (
		SELECT employees.fire_at
		FROM employees
		where
			employees.emp_id = 100014
		)
WHERE
	title_emps.emp_id = 100014
	AND title_emps.end_at Is NULL
;
