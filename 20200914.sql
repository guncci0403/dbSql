customer : 고객
cid : customer id
cnm : customer name
SELECT *
FROM customer;

product : 제품
pid : product id : 제품 번호
pnm : product name : 제품 이름
SELECT *
FROM product;

cycle : 고객애음주기
cid : customer id 고객 id
pid : product id 제품 id
day : 1-7(월-토)
cnt : COUNT, 수량
SELECT *
FROM cycle;


SELECT customer.*, cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
  AND customer.cnm IN ('brown', 'sally');

ANSI-SQL
SELECT cid, cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer NATURAL JOIN cycle 
WHERE customer.cnm IN ('brown', 'sally');

SELECT cid, cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle USING(cid) 
WHERE customer.cnm IN ('brown', 'sally');


SELECT customer.cid, cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid) 
WHERE customer.cnm IN ('brown', 'sally');

join5]
SELECT a.cid, a.cnm, a.pid, product.pnm, a.day, a.cnt
FROM
(SELECT customer.*, cycle.pid, cycle.day, cycle.cnt
   FROM customer, cycle
  WHERE customer.cid = cycle.cid
  AND customer.cnm IN ('brown', 'sally')) a, product
WHERE a.pid = product.pid;

SQL : 실행에 대한 순서가 없다
      조인할 테이블에 대해서 FROM 절에 기술한 순으로 테이블을 읽지 않음
      FROM customer, cycle, product ==> 오라클에서는 product 테이블부터 읽을 수도 있다

사람들이 존재
키가 170cm 이상이고 발사이즈가 270mm이상인 사람들의 집합


EXPLAIN PLAN FOR
SELECT customer.*, product.*, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
  AND customer.cnm IN ('brown', 'sally');
SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3215896897
 
----------------------------------------------------------------------------------------------
| Id  | Operation                      | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |             |    10 |  1320 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                  |             |       |       |            |          |
|   2 |   NESTED LOOPS                 |             |    10 |  1320 |     3   (0)| 00:00:01 |
|   3 |    NESTED LOOPS                |             |    10 |   920 |     3   (0)| 00:00:01 |
|   4 |     TABLE ACCESS FULL          | CYCLE       |    15 |   780 |     3   (0)| 00:00:01 |
|*  5 |     TABLE ACCESS BY INDEX ROWID| CUSTOMER    |     1 |    40 |     0   (0)| 00:00:01 |
|*  6 |      INDEX UNIQUE SCAN         | PK_CUSTOMER |     1 |       |     0   (0)| 00:00:01 |
|*  7 |    INDEX UNIQUE SCAN           | PK_PRODUCT  |     1 |       |     0   (0)| 00:00:01 |
|   8 |   TABLE ACCESS BY INDEX ROWID  | PRODUCT     |     1 |    40 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - filter("CUSTOMER"."CNM"='brown' OR "CUSTOMER"."CNM"='sally')
   6 - access("CUSTOMER"."CID"="CYCLE"."CID")
   7 - access("CYCLE"."PID"="PRODUCT"."PID")
 
Note
-----
   - dynamic sampling used for this statement (level=2)

join6,7,8,9~13] ---------과제

OUTER JOIN : 자주 쓰이지는 않지만 중요
JOIN구분
1. 문법에 따른 구분 : ANSI-SQL, ORACLE
2. JOIN 의 형태에 따른 구분 : SELF-JOIN, NONEQUI-JOIN, CROSS-JOIN
3. join 성공여부에 따라 데이터 표시여부
        : INNER JOIN - 조인이 성공했을 때 데이터를 표시
        : OUTER JOIN - 조인이 실패해도 기준으로 정한 테이블의 컬럼정보는 표시
        
사번, 사원의 이름, 관리자 사번, 관리자 이름
KING(PRESIDENT)의 경우 MGR컬럼의 값이 NULL이기 때문에
조인에 실패 ==> 13건 조회
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

ANSI-SQL
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON (e.mgr = m.empno);

ORACLE_SQL : 데이터가 없는 쪽의 컬럼에 (+) 기호를 붙인자
             ANSI-SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다
             WHERE절의 연결조건에 적용 슬라이드 241참고
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

행에 대한 제한 조건 기술시 WHERE절에 기술했을 떄와 ON 절에 기술했을때 결과가 다르다

사원의 부서가 10번인 사람들만 조회되도록 부서 번호 조건을 추가;
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND e.deptno = 10);

조건을 WHERE 절에 기술한 경우 ==> OUTER JOIN이 아닌 INNER 조인 결과가 나온다
SELECT e.empno, e.ename, e.deptno, m.deptno, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10;

SELECT *
FROM emp
ORDER BY deptno;

SELECT e.empno, e.ename, e.deptno, m.deptno, e.mgr, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10;

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno); ==>8명은 누군가의 관리자가 아니다

full outer = left outer + right outer 중복 데이터 제거
UNION은 합집합, MINUS는 차집합, INTERSECT는 교집합
A ={1, 3, 5}, B ={1, 4, 5}
A U B = {1, 3, 4, 5}
SELECT  e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)
INTERSECT
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);

outerjoin1]
SELECT *
FROM prod;

SELECT *
FROM buyprod
WHERE BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD');


SELECT b.BUY_DATE, b.BUY_PROD, p.PROD_ID, p.PROD_NAME, b.BUY_QTY
FROM prod p, buyprod b 
WHERE p.PROD_ID = b.BUY_PROD (+)
  AND b.BUY_DATE (+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

SELECT b.BUY_DATE, b.BUY_PROD, p.PROD_ID, p.PROD_NAME, b.BUY_QTY
FROM prod p LEFT OUTER JOIN buyprod b ON (p.PROD_ID = b.BUY_PROD AND b.BUY_DATE = TO_DATE('2005/01/25', 'YYYY/MM/DD'));