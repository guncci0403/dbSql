idx4]
CREATE UNIQUE INDEX idx_emp_u_01 ON emp (empno, deptno);
CREATE INDEX idx_emp_02 ON emp(deptno, sal);
CREATE UNIQUE INDEX idx_dept_u_03 ON dept (deptno, loc);

drop INDEX idx_emp_u_01;
drop INDEX idx_emp_02;
drop INDEX idx_dept_u_03;

SELECT *
FROM TABLE(dbms_xplan.display);
1.
EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE empno = :empno;

2.
EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.empno LIKE :empno || '%';

3.
EXPLAIN PLAN FOR
SELECT *
FROM dept
WHERE deptno = :deptno;

4.
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal between :st_sal AND :ed_sal
AND deptno = :deptno;

5.
EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND dept.loc = :loc;
