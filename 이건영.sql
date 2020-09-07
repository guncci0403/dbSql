------------------------------------------------------------------------
11,12,13,14 과제  

where11]
SELECT *
FROM emp
WHERE job IN('SALESMAN')
  OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');
  
where12]
SELECT *
FROM emp
WHERE job IN ('SALESMAN')
  OR empno LIKE('78__');
  
where13]
SELECT *
FROM emp
WHERE job IN ('SALESMAN')
  OR (empno >= 7800 AND empno <= 7899) ;

연산자 우선순위
조건 1 OR (조건 2 AND 조건 3)

where 14]
SELECT *
FROM emp
WHERE job IN ('SALESMAN')
   OR empno LIKE('78__')
   AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');
------------------------------------------------------------------------