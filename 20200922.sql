VIEW를 사용하는 사례
1. 데이터 노출을 방지 (emp 테이블의 sal, comm을 제외하고 view를 생성, HR계정에게 view를 조회할 수 있는 권한을 부여.
                    HR계정에서는 emp테이블을 직접 조회하지 못하지만 v_emp는 가능
                    ==> V_EMP 에는 sal, comm컬럼이 없기 때문에 급여관련 정보를 감출 수 있었다)
2. 자주 사용되는 쿼리를 view 만들어서 재사용
    ex : emp 테이블은 dept 테이블이랑 조인되서 사용되는 경우가 많음
        view를 만들지 않을 경우 매번 조인 쿼리를 작성해야하나, view로 만들면 재사용이 가능
3. 쿼리가 간단해진다
emp테이블과 dept테이블을 deptno가 같은 조건으로 조인한 결과를 v_emp_dept 이름으로 view생성        
view 생성
CREATE OR REPLACE VIEW v_emp_dept AS 
SELECT emp.*, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = DEPT.DEPTNO;

SELECT *
FROM v_emp_dept;

view 삭제
DROP view 뷰이름;
DROP VIEW v_emp_dept;

CREATE VIEW v_emp_cnt AS
SELECT deptno, count(*) cnt
FROM emp
GROUP BY deptno;

SELECT *
FROM v_emp_cnt
WHERE deptno = 10;

SELECT *
FROM v_emp;

UPDATE emp SET JOB = 'RANGER'
WHERE empno = 7369;

UPDATE v_emp SET JOB = 'RANGER'
WHERE empno = 7369;
SELECT *
FROM v_emp;

ROLLBACK;

sequence : 중복되지 않는 정수값을 만들어내는 오라클 객체
    java : UUID 클래스를 통해 중복되지 않는 문자열을 생성 할 수 있다.
V_
SEQ_사용할테이블이름;

문법 : CREATE SEQUENCE 시퀀스 이름;

CREATE SEQUENCE SEQ_emp;

사용방법 : 함수를 생각하자
함수 테스트 : DUAL
시퀀스 객체명.nextval : 시퀀스 객체에서 마지막으로 사용한 다음 값을 반환
시퀀스 객체명.currval : nextval 함수를 실행하고 나서 사용할 수 있다
                      nextval 함수를 통해 얻어진 값을 반환
SELECT seq_emp.nextval
FROM dual;

SELECT seq_emp.currval
FROM dual;

사용예
INSERT INTO emp (empno, ename, hiredate) 
    VALUES (seq_emp.nextval, 'brown', sysdate);
            
SELECT *
FROM emp;

의미가 있는 값에 대해서는 시쿼스만 갖고는 만들 수 없다
시퀀스를 통해서는 중복되지 않는 값을 생성 할 수 있다

시퀀스는 롤백을 하더라도 읽은 값이 복원되지 않는다

CREATE SEQUENCE SEQ_emp;
CREATE SEQUENCE 

테이블의 특징
테이블 객체에는 데이터를 저장/조회시 순서를 보장하지 않음
-보편적으로 데이터가 입력된 순서대로 조회됨
-데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않는다
-데이터가 삭제되고, 다른 데이터가 들어 올 수도 있음

INDEX : TABLE의 일부 컬럼을 기준으로 미리 정렬해둔 객체
ROWID : 테이블에 저장된 행의 위치를 나타내는 값

SELECT ROWID, empno, ename
FROM emp;

만약 ROWID를 알 수만 있으면 해당 테이블의 모든 데이터를 뒤지지 않아도
해당 행에 바로 접근을 할 수가 있다
SELECT *
FROM emp
WHERE ROWID = 'AAAE/YAAFAAAACLAAV';


INDEX (ppt 69,70,71 참고)
테이블의 일부 컬럼을 기준으로 데이터를 정렬한 객체
테이블의 row를 가리키는 주소를 갖고 있다(rowid)
정렬된 인덱스를 기준으로 해당 row의 위치를 빠르게 검색하여
테이블의 원하는 행에 빠르게 접근
테이블에 데이터를 입력하면 인덱스 구조도 갱신된다
*인덱스 구성컬럼이 모두 NULL일 경우 해당 ROW는 인덱스에 저장되지 않는다 -> NOT NULL 제약의 중요성

BLOCK : 오라클의 기본 입출력 단위
block의 크기는 데이터베이스 생성시 결정, 기본값 8K byte
DESC emp;
emp 테이블 한행은 최대 54byte
block 하나에는 emp 테이블을  8000/54 = 160행이 들어갈 수 있음
사용자가 한행을 읽어도 해당 행이 담겨져 있는 block을 전체로 읽는다
DB I/O의 기본단위

SELECT *
FROM user_constraints
WHERE table_name = 'EMP';
EMP 테이블의 empno 컬럼에 primary key 추가

PRIMARY KEY(UNIQUE + NOT NULL), UNIQUE 제약을 생성하면 해당 컬럼으로 인덱스를 생성한다
==>인덱스가 있으면 값을 빠르게 찾을 수 있다
    해당 컬럼에 중복된 값을 빠르게 찾기 위한 제한사항
ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY (empno);
ALTER TABLE emp DROP CONSTRAINT PK_EMP;
ALTER TABLE dept ADD CONSTRAINT PK_dept PRIMARY KEY (deptno);
ALTER TABLE dept DROP CONSTRAINT PK_DEPT;
ALTER TABLE dept ADD CONSTRAINT FK_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);
ALTER TABLE dept DROP CONSTRAINT FK_EMP_DEPT;
ALTER TABLE emp ADD CONSTRAINT FK_emp_emp FOREIGN KEY (mgr) REFERENCES emp (empno);
ALTER TABLE emp DROP CONSTRAINT FK_EMP_EMP;

SELECT empno, ROWID
FROM emp
ORDER BY empno;

TABLE
Table은 입력 순서대로 데이터 저장 : 비 순차적인 블록
DELETE등으로 비 연속적인 블록 구성
대용량 테이블 엑세스 시 과도한 블록 읽기 발생, multi block I/O
INDEX
Index는 최소한의 데이터 블록 읽기룰 통한 성능향상
대표 키와 ROW의 주소정보(ROWID)만 미리 정렬
대표 키 값을 통해 미리 정렬된 인덱스를 통해 검색대상 row만 바로 엑세스
ROWID를 통한 엑세스가 가장 빠른 조회 경로
블록 단위의 엑세스 : 가장 작은 단위 디스크 I/O, single block I/O

시나리오0       
테이블만 있는경우(제약조건, 인덱스가 없는 경우)
SELECT *
FROM emp
WHERE empno = 7782;
==> 테이블에는 순서가 없기 때문에 emp 테이블의 14건의 데이터를
모두 뒤져보고 empno값이 7782인 한건에 대해서만 사용자에게 반환을 한다

시나리오 1
emp 테이블의 empno컬럼에 PK_EMP 유니크 인덱스가 생성된 경우
(우리는 인덱스를 직접 생성하지 않았고 PRIMARY KEY 제약조건에 의해
 자동으로 생성 됨)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE (dbms_xplan.display);



Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 2-1-0순으로 읽음
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   



시나리오2
emp 테이블의 empno 컬럼에 PRIMARY KEY 제약조건이 걸려 있는 경우
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);




Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
   
   

UNIQUE 인덱스 : 인덱스 구성의 컬럼의 중복 값을 허용하지 않는 인덱스 (emp.empno)
NON-UNIQUE 인덱스 : 인덱스 구성 컬럼의 중복 값을 허용하는 인덱스 (emp.deptno, emp.job)

시나리오 3
emp테이블의 empno컬럼에 non-unique 인덱스가 있는 경우
ALTER TABLE emp DROP CONSTRAINT fk_emp_emp;
ALTER TABLE emp DROP CONSTRAINT pk_emp;
IDX_테이블명_U_01
IDX_테이블명_N_02
CREATE INDEX IDX_emp_N_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT  *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);


Plan hash value: 2445276743
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_01 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 2-1-0
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   
   
   
시나리오4
emp 테이블의 job 컬럼으로 non-unique 인덱스를 생성한 경우
CREATE INDEX idx_emp_n_02 ON emp (job);

emp테이블에는 현재 인덱스가 2개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job


EXPLAIN PLAN FOR
SELECT  *
FROM emp
WHERE job = 'MANAGER';
SELECT *
FROM TABLE(dbms_xplan.display);


Plan hash value: 431958961

 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     3 |   114 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     3 |   114 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')



시나리오5
emp 테이블에는 현재 인덱스가 2개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 431958961
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_02 |     3 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%') - filter는 읽고난다음 맞는지 확인함
   2 - access("JOB"='MANAGER')
   


시나리오6
CREATE INDEX idx_emp_n_03 ON emp (job, ename);

emp 테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job
idx_emp_n_03 : job, ename

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';
SELECT *
FROM TABLE(dbms_xplan.display);  

Plan hash value: 2102545684
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_03 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
       
       
시나리오7
DROP INDEX idx_emp_n_03;
CREATE INDEX idx_emp_n_04 ON emp(ename, job);

emp 테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01 : empno
idx_emp_n_02 : job
idx_emp_n_04 : ename, job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
  AND ename LIKE 'C%';
  
SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 860547963
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_N_04 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       
       
       
시나리오8
emp 테이블의 empno 컬럼에 UNIQUE 인덱스 생성
dept 테이블의 deptno 컬럼에 UNIQUE 인덱스 생성

DROP INDEX idx_emp_n_01;
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);

SELECT *
FROM dept;

DELETE dept
WHERE deptno >= 90;

commit;

emp 테이블에는 현재 인덱스가 3개 존재
pk_emp : empno
idx_emp_n_02 : job
idx_emp_n_04 : ename, job
dept 테이블에는 현재 인덱스가 1개 존재
pk_dept : deptno
4         2     8   
emp ==> dept

2         4     8
dept ==> emp

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;
  
SELECT *
FROM TABLE(dbms_xplan.display);    

Plan hash value: 2385808155
 
----------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |     1 |    33 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |         |     1 |    33 |     2   (0)| 00:00:01 |
|   2 |   TABLE ACCESS BY INDEX ROWID| EMP     |     1 |    13 |     1   (0)| 00:00:01 |
|*  3 |    INDEX UNIQUE SCAN         | PK_EMP  |     1 |       |     0   (0)| 00:00:01 |
|   4 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     4 |    80 |     1   (0)| 00:00:01 |
|*  5 |    INDEX UNIQUE SCAN         | PK_DEPT |     1 |       |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------------
 3-2 - 5-4 - 1-0 emp를 먼저 읽는다
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   