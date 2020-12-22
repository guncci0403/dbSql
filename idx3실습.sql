내가 했던거 idx3]
CREATE UNIQUE INDEX idx_emp_u_01
 ON emp (empno);

CREATE UNIQUE INDEX idx_emp_u_02
 ON emp (ename);
CREATE INDEX idx_emp_n_03 ON emp(deptno, empno);

CREATE INDEX idx_emp_n_04 ON emp(deptno, sal);
CREATE INDEX idx_emp_n_05 ON emp(deptno, mgr, empno);
CREATE INDEX idx_emp_n_06 ON emp(deptno, TO_CHAR(hiredate, 'yyyymm'));


정답 idx3]
1) empno(=) (1)
2) ename(=)
3) deptno(=), empno(LIKE :empno || '%') (1)
4) deptno(=), sal(BETWEEN)
5) deptno(=), mgr컬럼이 있을경우 테이블 액세스 불필요
   empno(=)
6) deptno, hiredate 컬럼으로 구성된 인덱스가 있을 경우 테이블 엑세스 불필요

CREATE UNIQUE INDEX idx_emp_u_01 ON emp (empno, deptno);
CREATE INDEX idx_emp_n_02 ON emp (ename);
CREATE INDEX idx_emp_n_03 ON emp (deptno, sal, mgr, hiredate);

인덱스 사용에 있어서 중요한점
인덱스 구성컬럼이 모두 NULL이면 인덱스에 저장을 하지 않는다
즉 테이블 접근을 해봐야 해당 행에 대한 정보를 알 수 있다
가급적이면 컬럼에 값이 NULL이 들어오지 않을경우는 NOT NULL 재약을 적극적으로 활용
==> 오라클 입장에서 실행계획을 세우는데 도움이 된다
1.
SELECT *
FROM EMP
WHERE empno = :empno;
2.
SELECT *
FROM EMP
WHERE ename = :ename;
3.
SELECT *
FROM EMP, DEPT
WHERE EMP.deptno = DEPT.deptno
AND   EMP.deptno = :deptno
AND   EMP.empno LIKE :empno || '%';
4.
SELECT *
FROM EMP
WHERE sal BETWEEN :st_sal AND :ed_sal
AND   deptno = :deptno;
5.
SELECT b.*
FROM EMP A, EMP B
WHERE A.mgr = B.empno
AND A.deptno = :deptno;
6.
SELECT deptno, TO_CHAR(hiredate, 'yyyymm'),
       COUNT(*) cnt
FROM emp
GROUP BY deptno, TO_CHAR(hiredate, 'yyyymm');