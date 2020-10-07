분석함수를 사용하지 않고 구하기
SELECT empno, ename, sal, emp.deptno, a.avg_sal
FROM emp, 
    (SELECT deptno, ROUND(AVG(sal), 2) avg_sal
     FROM emp
     GROUP BY deptno) a
WHERE emp.deptno = a.deptno ;

ana3]
SELECT empno, ename, sal, deptno, 
       MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

ana4]
max -> min


분석함수정리
1. 순위 : RANK, DENSE_RANK, ROW_NUMBER
2. 집계 : SUM, AVG, MAX, MIN, COUNT
3. 그룹내 행순서 : LAG, LEAD
                현재 행을 기준으로 이전/이후 N번째 행의 컬럼 값 가져오기

사원번호, 사원이름, 입사일자, 급여, 급여순위가 자신보다 한단계 낮은 사람의 급여
(단, 급여가 같을 경우 입사일이 빠른 사람이 높은 우선순위);
SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate ASC;

SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate ASC)
FROM emp;


실습 ana5]
SELECT empno, ename, hiredate, sal,
        LAG(sal) OVER (ORDER BY sal DESC, hiredate ASC)
FROM emp;

ana6] job별로 급여순위가 1단계 높은 사람
SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (partition BY job ORDER BY sal DESC, hiredate ASC) lagsal
FROM emp;

이전/ 이후 n행 값 가져오기
LAG(col [, 건너뛸행수 - default 1] [, 값이 없을 경우 적용할 기본값])
SELECT empno, ename, hiredate, job, sal,
        LAG(sal, 2, 0) OVER (ORDER BY sal DESC, hiredate ASC) lagsal
FROM emp;

현재 행까지의 누적합 구하기
범위지정 : windowing
windowing에서 사용할 수 있는 특수 키워드
1. unbounded preceding : 현재행을 기준으로 선행하는 모든 행
2. CURRENT ROW : 현재행
3. UNBOUNDED FOLLOWING : 현재항을 기준으로 후행하는 모든 행(이후행)
4. n PRECEDING (n은 정수) : n행 이전 부터
5. n FOLLOWING (n은 정수) : n행 이후 까지

현재행 이전의 모든 행부터 ~ 현재까지 ==> 행들을 정렬할 수 있는 기준이 있어야 한다.
SELECT empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal, hiredate ASC
                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum,
        SUM(sal) OVER (ORDER BY sal, hiredate ASC
                       ROWS UNBOUNDED PRECEDING) c_sum2                       
FROM emp;
--ORDER BY sal, hiredate ASC;

선행하는 이전 첫번째 행 부터 후행하는 이후 첫번째 행까지
선행 - 현재행 - 후행 총 3개의 행에 대해 급여 합을 구하기

SELECT empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal, hiredate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;


ana7]
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;




range는 같은값이 나오면 자기자신(같은행)으로 취급함
SELECT empno, ename, deptno, sal,
        SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) rows_sum,
        SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum,
        SUM(sal) OVER (ORDER BY sal) c_sum
FROM emp;

======================================================================
DBMS 입장에서 SQL 처리 순서
1.  요청된 SQL과 동일한 SQL이 이미 실행된 적이 있는지 확인하여 
    실행된 적이 있다면 SHARED POOL에 저장된 실행계획을 재활용한다 
    
    1-2. 만약 SHARED POOL에 저장된 실행 계획이 없다면 (동일한 SQL이 실행된 적이 없음)
         실행계획을 세운다

*** 동일한 SQL이란?
- 결과만 갖다고 동일한 SQL 이 아님
- DBMS 입장에서는 완벽하게 문자열이 동일해야 동일한 SQL임
  다음 SQL은 서로 다른 SQL로 인식한다
  1. SELECT /* SQL_TEST */ * FROM emp;
  2. Select /* SQL_TEST */ * FROM emp;
  3. Select /* SQL_TEST */ *  FROM emp;
  
  10번 부서에 속하는 사원 정보 조회
  ==> 특정 부서에 속하는 사원 정보 조회
    Select /* SQL_TEST */ *  FROM emp WHERE deptno = 10;
    Select /* SQL_TEST */ *  FROM emp WHERE deptno = 20;
    바인드 변수를 왜 사용해야 하는가에 대한 설명
    Select /* SQL_TEST */ *  FROM emp WHERE deptno = :deptno;
    
    
    