1]
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'yyyymmdd')
  AND hiredate <= TO_DATE('19830101', 'yyyymmdd');
2]
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= TO_DATE('19810601', 'yyyymmdd');
3]
SELECT *
FROM emp
WHERE deptno NOT IN (10)
  AND hiredate >= TO_DATE('19810601', 'yyyymmdd');
4]
SELECT *
FROM (SELECT ROWNUM, empno, ename
        FROM emp
        ORDER BY empno)
ORDER BY ROWNUM;

SELECT ROWNUM, empno, ename
FROM emp;
5]
SELECT *
FROM emp
WHERE deptno IN (10, 30)
  AND sal > 1500
ORDER BY ename DESC;
6]
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal
FROM emp
GROUP BY deptno;

7]
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.sal > 2500
  AND emp.empno > 7600
  AND dept.dname IN ('RESEARCH')
ORDER BY ename;

SELECT empno, ename, sal, emp.deptno, dname
FROM emp , dept
WHERE emp.deptno = dept.deptno
  AND sal > 1500 AND empno > 7600 AND dname = 'RESEARCH';
8]
SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.deptno IN (10, 30)
ORDER BY empno;

SELECT empno, ename, emp.deptno, dname
FROM emp , dept
WHERE emp.deptno = dept.deptno
  AND dept.deptno IN (10,30)
ORDER BY empno;
9]
SELECT e.ename, m.ename mgr
FROM emp e,emp m
WHERE e.mgr = m.empno(+);

10]
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');

11]
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
12]
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
                FROM emp);
13]
INSERT INTO dept VALUES(99, 'ddit', '대전');
SELECT *
FROM dept;
14]
UPDATE dept SET dname = 'ddit_modi', loc = '대전_modi'
WHERE deptno = 99;
15]
DELETE dept
WHERE deptno = 99;
16]
CREATE TABLE dept(DEPTNO NUMBER(2), DNAME VARCHAR2(14),
                    LOC VARCHAR(13), CONSTRAINT pk_dept PRIMARY KEY (deptno));
                    
CREATE TABLE emp(ENAME NUMBER(4), EMPNO VARCHAR2(10), JOB VARCHAR2(9),
                    MGR NUMBER(4), HIREDATE DATE, SAL NUMBER(7,2), COMM NUMBER(7,2),
                    DEPTNO NUMBER(2), CONSTRAINT PK_emp PRIMARY KEY (empno),
                    CONSTRAINT FK_emp_dept FOREIGN KEY(deptno) REFERENCES dept (deptno));
17]
SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);
18]
SELECT ename, sal, deptno, hiredate,
       RANK()OVER(PARTITION BY deptno ORDER BY sal DESC) dept_sal_rank
FROM emp;
SELECT ename, sal, deptno, hiredate,
      ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) dept_sal_rank
FROM emp;
19]
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER (ORDER BY sal DESC)
FROM emp;

20]
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal, empno) c_sum
FROM emp;