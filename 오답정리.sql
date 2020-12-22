SQL-성취도-평가-2-오답노트

8.
SELECT *
FROM emp
WHERE deptno NOT IN (10, 20);

SELECT *
FROM emp
WHERE deptno != 10 AND deptno != 20;

10.
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'x'
                FROM emp m
                WHERE e.mgr = m.empno);
                
11.
SELECT *
FROM (SELECT ROWNUM rn, a.*
        FROM (SELECT *
                FROM emp
              ORDER BY hiredate, ename) a)
WHERE rn BETWEEN (:page-1) * :pagesize + 1 AND :page * :pagesize;
14.
SELECT COUNT(*)
  FROM emp
  WHERE deptno = (SELECT deptno
                    FROM emp
                    WHERE ename = 'SMITH');
16.
SELECT m.empno, m.ename, e.empno, e.ename
FROM emp m , emp e
WHERE m.mgr = e.empno(+);

17.
SELECT *
FROM emp, dept;

18.
SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno;

19.
SELECT emp.empno, emp.ename,
    (SELECT 'x'
     FROM dept
     WHERE deptno = emp.deptno)d
FROM emp;