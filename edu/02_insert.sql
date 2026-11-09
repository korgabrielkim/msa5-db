-- insert문
-- DML 중 하나로 신규 데이터를 저장하기 위해 사용하는 쿼리.
-- insert into 테이블명 [(컴럼명1, 컬럼명2,...)]
-- values(값1, 값2...)의 값1-> 컬럼명1, 값2->컬럼명2...
-- 개발문서에서 []가 들어가는 것은 생략이 가능하다는 의미이지만, 개발 현장에서 실제로 생략하는 경우는 드물다고 보면됨.
INSERT INTO employees(
`name`,birth,gender,hire_at -- null or 자동으로 값이 세팅되는 설정은 굳이 넣어줄 필요가 없음. ex) auto_increment, current_timestamp(현재 시간을 자동으로 업데이트)
) VALUES(
"박병주","2000-01-01","M",NOW()
);
-- 복수의 레코드를 삽입하고 싶을 경우
INSERT INTO employees(
`name`,birth,gender,hire_at 
) VALUES(
"홍길동","1700-01-01","M",NOW()
),
(
"갑돌이","1900-01-01","M",NOW()
);
-- select insert 문 : select한 결과를 가지고 insert를 하고 싶을 때 사용.
INSERT INTO title_emps(
emp_id, title_code, start_at, end_at, created_at, updated_at, deleted_at
)
SELECT
	emp_id, 'T001', NOW(), NULL, NOW(), NOW(), null
FROM employees
WHERE
	emp_id>100000
;
-- 임시 저장 기능을 사용 하려면 {시작부분} start transaction; / {마지막부분}commit;(영구 저장) / rollback;(될돌리기)
START TRANSACTION;
INSERT INTO title_emps(
emp_id, title_code, start_at, end_at, created_at, updated_at, deleted_at
)
SELECT
	emp_id, 'T001', employees.hire_at, NULL, NOW(), NOW(), null
FROM employees
WHERE
	emp_id>100000;
ROLLBACK;