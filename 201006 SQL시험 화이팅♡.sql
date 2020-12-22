1. 
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD')
AND  hiredate <= TO_DATE( '1983/01/01','YYYY/MM/DD') ;

2.
SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD') ;

3.
SELECT *
FROM emp
WHERE deptno NOT IN(10)
AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');  

4.
SELECT ROWNUM, empno, ename
FROM emp;

5. 
SELECT *
FROM emp
WHERE (deptno = 10 OR deptno = 30) 
AND sal >1500
ORDER BY ename DESC;

6. 
SELECT deptno , MAX(sal) max_sal, MIN(sal) min_sal , ROUND(AVG(sal),2) avg_sal
FROM emp 
GROUP BY deptno;

7.
SELECT empno, ename, sal, emp.deptno, dname
FROM emp , dept
WHERE emp.deptno = dept.deptno
  AND sal > 1500 AND empno > 7600 AND dname = 'RESEARCH';

8. 
SELECT empno, ename, emp.deptno, dname
FROM emp , dept
WHERE emp.deptno = dept.deptno
  AND dept.deptno IN (10,30)
ORDER BY empno;

9.
SELECT e.ename, m.ename mgr  
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

10. 
SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp 
GROUP BY TO_CHAR(hiredate,'YYYYMM');

11.  
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp 
                 WHERE  ename IN ('SMITH','WARD')) ;
                
12.
SELECT * 
FROM emp
WHERE sal > (SELECT  AVG(sal)
             FROM emp);
           
13. 
INSERT INTO dept VALUES ( 99, 'ddit', '대전');

14. 
UPDATE dept SET dname = 'ddit_modi', loc = '대전_modi'
WHERE deptno =99;

15. 
DELETE dept WHERE deptno = 99;

16. 
CREATE TABLE dept(DEPTNO NUMBER(2), DANME VARCHAR2(14), 
                    LOC VARCHAR2(13),CONSTRAINT PK_dept PRIMARY KEY (deptno));

CREATE TABLE emp(ENAME NUMBER(4), EMPNO VARCHAR2(10), JOB VARCHAR2(9),
                 MGR NUMBER(4), HIREDATE DATE, SAL NUMBER(7,2), COMM NUMBER(7,2), 
                 DEPTNO NUMBER(2), CONSTRAINT PK_emp PRIMARY KEY (empno),
                 CONSTRAINT FK_emp_dept FOREIGN KEY (detpno) REFERENCES dept (deptno);

17. 
SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP(deptno);

18. 
SELECT ename, sal, deptno, hiredate,
      ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) dept_sal_rank
FROM emp;

19.
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER (ORDER BY sal DESC)
FROM emp;

20.
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal,empno) c_sum
FROM emp;