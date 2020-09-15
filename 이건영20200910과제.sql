grp5]
SELECT TO_CHAR(hiredate,'YYYY') hire_yyyy , COUNT(*)cnt
FROM emp
group by TO_CHAR(hiredate,'YYYY');


grp6]
SELECT COUNT(*)cnt
FROM dept;


grp7] 직원이 속한 부서의 개수를 구하기
1. 부서가 몇개 존재하는지 ?? ==> 3행
SELECT count(*)
FROM( SELECT deptno
      FROM emp
    GROUP BY deptno) a;

SELECT COUNT(COUNT(deptno)) cnt
FROM emp
GROUP BY deptno;

JOIN 0]
SELECT  e.empno, e.ename, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY e.deptno ASC;

JOIN 0_1]
SELECT  e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND  e.deptno IN (10, 30)
ORDER BY e.deptno ASC;

JOIN 0_2]
SELECT  e.empno, e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND e.sal > 2500
ORDER BY e.deptno ASC;

JOIN 0_3]
SELECT  e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND e.sal > 2500 AND e.empno > 7600
ORDER BY e.deptno ASC;

JOIN 0_4]
SELECT  empno, ename, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND e.sal > 2500 AND e.empno > 7600 AND d.dname='RESEARCH'
ORDER BY e.deptno ASC;



