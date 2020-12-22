sub_a3 과제

CREATE TABLE emp_test AS
SELECT *
FROM emp;

UPDATE emp_test SET sal = sal+200
WHERE sal < (SELECT AVG(sal)
        FROM emp_test
        WHERE deptno = emp_test.deptno);