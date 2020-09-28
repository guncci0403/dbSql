REPORT GROUP FUNCTION
GROUP BY의 확장 : SUBGROUP을 자동을 생성하여 하나의 결과로 합쳐준다
1. ROLLUP(col1, col2....)
    . 기술된 컬럼을 오른쪽에서 부터 지워 나가며 서브 그룹을 생성
2. GROUPING SETS ((col1, col2), col3)
    . , 단위로 기술된 서브 그룹을 생성
    
3. CUBE(col1, col2....)
    . 컬럼의 순서는 지키되, 가능한 모든 조합을 생성한다
    
GROUP BY CUBE(job, deptno) ==> 4개
    job     deptno
     0        0     ==> GROUP BY job, deptno
     0        X     ==> GROUP BY job
     X        0     ==> GROUP BY deptno (ROLLUP에는 없던 서브 그룹)
     X        X     ==> GROUP BY 전체
     
GROUP BY ROLLUP(job, deptno) ==> 3개

SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY CUBE(job, deptno);

CUBE의 경우 가능한 모든 조합으로 서브 그룹을 생성하기 때문에
2의 기술한 컬럼 개수 승 만큼의 서브 그룹이 생성된다
CUBE(col1, col2) : 4
CUBE(col1, col2, col3) : 8
CUBE(col1, col2, col3, col4) : 16


REPORT GROUP FUNCTION 조합
GROUP BY job, ROLLUP(deptno), CUBE(mgr)
                deptno         mgr
                 전체           전체
                 
           job,  deptno, mgr
           job,  deptno
           job,  mgr
           job,  전체
           
SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

상호 연관 서브 쿼리를 이용한 업데이트
1. EMP_TEST 테이블 삭제
2. EMP테이블을 사용하여 EMP_TEST 테이블 생성(모든 컬럼, 모든 데이터)
3. EMP_TEST테이블에는 DNAME 컬럼을 추가( VARCHAR2(14) )
4. 상호 연관 서브쿼리를 이용하여 EMP_TEST테이블의 DNAME 컬럼을 DEPT을 이용하여 UPDATE
DESC dept;

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

ALTER TABLE emp_test ADD (dname VARCHAR2(14));

SELECT *
FROM emp_test;

UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE deptno = emp_test.deptno);
COMMIT;

DELETE dept_test;
DROP TABLE dept_test;


sub_a1]
SELECT *
FROM dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

UPDATE dept_test SET empcnt =
                            (SELECT COUNT(*)
                               FROM emp
                              WHERE deptno = dept_test.deptno);
COMMIT;

rollback;

sub_a2]
INSERT INTO dept_test (deptno, dname, loc) VALUES (99, 'it1', 'daejeon');
INSERT INTO dept_test (deptno, dname, loc) VALUES (98, 'it2', 'daejeon');
commit;

SELECT deptno, dname
FROM dept_test;

부서에 속한 직원이 없는 부서를 삭제하는 쿼리를 작성하세요
DELETE dept_test WHERE 0 = (SELECT COUNT(*) FROM emp WHERE deptno = dept_test.deptno);

DELETE dept_test WHERE deptno NOT IN (SELECT deptno
                                        FROM emp);
DELETE dept_test WHERE NOT EXISTS (SELECT 'X'
                                     FROM emp
                                    WHERE deptno = dept_test.deptno);
sub_a3 과제
+월요일날 자신이 틀렸던 문제 나와서 다시 풀기

UPDATE emp_test SET sal = sal+200
WHERE sal < (SELECT AVG(sal)
        FROM emp_test
        WHERE deptno = emp_test.deptno);

SELECT *
FROM emp_test;

rollback;

SELECT *
FROM emp;



SELECT *
FROM emp, dept;

WITH(ppt 48)

달력만들기 : 행을 열로 만들기 - 레포트 쿼리에서 자주 사용하는 형태
주어진 것 : 년월 (수업시간에는 '202009'문자열을 사용)

SELECT dual.*, LEVEL
FROM dual
CONNECT BY LEVEL <= 30;

SELECT SYSDATE + LEVEL , LEVEL
FROM dual
CONNECT BY LEVEL <= 30;

'202009' ==> 30
'202008' ==> 31
I==> 20200801
SELECT TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD')
FROM dual; 

SELECT TO_DATE('202002', 'YYYYMM') + LEVEL -1 day,
       TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL -1, 'D') d
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD');


SELECT day, d, DECODE(d, 1, day) sun,DECODE(d, 2, day) mon, DECODE(d, 3, day) tue, DECODE(d, 4, day) wed, DECODE(d, 5, day) thu, DECODE(d, 6, day) fri, DECODE(d, 7, day) sat
FROM
(SELECT TO_DATE('202002', 'YYYYMM') + LEVEL -1 day,
       TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL -1, 'D') d
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD'));

SELECT To_CHAR(sysdate, 'iw') FROM dual;

SELECT  DECODE(d, 1, iw+1, iw), MIN(DECODE(d, 1, day)) sun,MIN(DECODE(d, 2, day)) mon,
            MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed,
            MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri,
            MIN(DECODE(d, 7, day)) sat
FROM
(SELECT TO_DATE('202002', 'YYYYMM') + LEVEL -1 day,
       TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL -1, 'D') d,
         TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL -1, 'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);
--------------------------------------------------------------------------------
SELECT      MIN(DECODE(d, 1, day)) sun,MIN(DECODE(d, 2, day)) mon,
            MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed,
            MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri,
            MIN(DECODE(d, 7, day)) sat
FROM
(SELECT TO_DATE('202002', 'YYYYMM') + LEVEL -1 day,
       TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL -1, 'D') d,
         TO_CHAR(TO_DATE('202002', 'YYYYMM') + LEVEL -1, 'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);
-----------------------------------------------------------------------------
SELECT     DECODE(d, 1, iw+1, iw),
            MIN(DECODE(d, 1, day)) sun,MIN(DECODE(d, 2, day)) mon,
            MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed,
            MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri,
            MIN(DECODE(d, 7, day)) sat
FROM
(SELECT TO_DATE(:yyyymm, 'YYYYMM') + LEVEL -1 day,
       TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL -1, 'D') d,
         TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') + LEVEL -1, 'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);

SELECT TO_CHAR(TO_DATE('20191229', 'YYYYMMDD'), 'iw'),
        TO_CHAR(TO_DATE('20191230', 'YYYYMMDD'), 'iw'),
        TO_CHAR(TO_DATE('20191231', 'YYYYMMDD'), 'iw')
FROM dual;

SELECT SUM(sales)
FROM sales
GROUP BY TO_CHAR(DT,'yyyymm')
SELECT *
FROM sales;
DESC sales;

SELECT  MAX(NVL(DECODE(mm,'01', sales),0)) JAN,
        NVL(MIN(DECODE(mm,'02', sales)),0) FEB,
        NVL(MIN(DECODE(mm,'03', sales)),0) MAR,
        NVL(MIN(DECODE(mm,'04', sales)),0) APR,
        NVL(MIN(DECODE(mm,'05', sales)),0) MAY,
        NVL(MIN(DECODE(mm,'06', sales)),0) JUN
FROM 
(SELECT TO_CHAR(DT,'mm') mm, SUM(sales) sales
FROM sales
GROUP BY TO_CHAR(DT,'mm'));
================================================================================
계층쿼리
자기참조
oracle 계층쿼리
데이터의 상하 관계를 표현하는 쿼리
시작 위치를 선정하여
다음 계층과의 연결을 표현

SELECT deptcd, deptnm, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ', LEVEL*3) || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

프리오더!(ppt 79)