제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

1.부서 테이블에 PRIMARY KEY 제약조건 추가
2.사원 테이블에 PRIMARY KEY 제약조건 추가
3.사원 테이블-부서테이블간 FOREIGN KEY 제약조건 추가

제약조건 삭제시는 데이터 입력과 반대로 자식부터 먼저 삭제
3 - (1, 2)
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test;
ALTER TABLE dept_test DROP CONSTRAINT PK_dept_test;
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

제약조건 생성
1. dept_test 테이블의 deptno컬럼에 PRIMARY KEY 제약조건 추가
ALTER TABLE dept_test ADD CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno);
2. emp_test 테이블의 empno컬럼에 PRIMARY KEY 제약 조건 추가
ALTER TABLE emp_test ADD CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno);
3. emp_test 테이블의 deptno컬럼이 dept_test 컬럼의 deptno컬럼을
   참조하는 FOREIGN KEY 제약 조건 추가
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test
    FOREIGN KEY(deptno) REFERENCES dept_test(deptno);
    
제약조건 활성화 - 비활성화 테스트
테스트 데이터 준비 : 부모 - 자식 관계가 있는 테이블에서는 부모 테이블에 데이터를 먼저 입력
dept_test ==> emp_test
INSERT INTO dept_test VALUES(10, 'ddit');

dept_test와 emp_test 테이블간 FK가 설정되어 있지만 10번 부서는 dept_test에 존재하기 때문에 정상입력
INSERT INTO emp_test VALUES(9999, 'brown', 10);

20번 부서는 dept_test 테이블에 존재하지 않느 데이터이기 때문에 FK에 의해 입력 불가
INSERT INTO emp_test VALUES(9998, 'sally', 20);

FK를 비활성화 한후 다시 입력
SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test_dept_test;
INSERT INTO emp_test VALUES(9998, 'sally', 20);
COMMIT;

dept_test : 10
emp_test : 9999(99) brown 10, 9998(98) sally 20 ==> 10, NULL, 삭제
DELETE emp_test
WHERE empno = 9998;

SELECT *
FROM emp_test;

FK 제약조건 재 활성화
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test_dept_test;

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

테이블, 컬럼 주석(comments) 생성가능
테이블 주석 정보확인
user_tables, user_constraints, user_tab_comments
테이블 주석 확인 방법
SELECT *
FROM user_tab_comments;

테이블 주석 작성 방법
COMMENT ON TABLE 테이블명 IS '주석';

EMP 테이블에 주석(사원) 생성하기;
COMMENT ON TABLE emp IS '사원';

컬럼 주석 확인
SELECT *
FROM user_col_comments
WHERE TABLE_NAME = 'EMP';

컬럼 주석 다는 문법
COMMENT ON COLUMN 테이블명. 컬럼명 IS '주석';


comment on column emp.EMPNO is '사번';       
comment on column emp.ENAME is '사원이름';       
comment on column emp.JOB is '담당역할';         
comment on column emp.MGR is '매니저사번';         
comment on column emp.HIREDATE is '입사일자';    
comment on column emp.SAL is '급여';         
comment on column emp.COMM is '성과급';        
comment on column emp.DEPTNO is '소속부서번호';      
SELECT *
FROM user_tab_comments
WHERE table_name = 'EMP';



SELECT *
FROM user_tab_comments
WHERE table_name = 'CYCLE';
SELECT *
FROM user_tab_comments
WHERE table_name = 'DAILY';
SELECT *
FROM user_tab_comments
WHERE table_name = 'PRODUCT';

comment on column CUSTOMER.CID is '고객번호';       
comment on column CUSTOMER.CNM is '고객명';
comment on column CYCLE.CID is '고객번호';
comment on column CYCLE.PID is '제품번호';
comment on column CYCLE.DAY is '요일';
comment on column CYCLE.CNT is '수량';
comment on column DAILY.CID is '고객번호';         
comment on column DAILY.PID is '제품번호';
comment on column DAILY.DT is '일자';
comment on column DAILY.CNT is '수량';
comment on column PRODUCT.PID is '제품번호';
comment on column PRODUCT.PNM is '제품명';

comment1]
SELECT t.*, c.column_name, c.comments
FROM user_tab_comments t, user_col_comments c
WHERE t.TABLE_NAME = c.TABLE_NAME
  AND t.table_name IN ('CUSTOMER', 'CYCLE', 'DAILY', 'PRODUCT');
  
과제 emp,dept테이블 제약조건 4가지 추가
SELECT *
FROM user_constraints
WHERE table_name IN ('EMP', 'DEPT');

ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY (empno);
ALTER TABLE emp DROP CONSTRAINT PK_EMP;
ALTER TABLE dept ADD CONSTRAINT PK_dept PRIMARY KEY (deptno);
ALTER TABLE dept DROP CONSTRAINT PK_DEPT;
ALTER TABLE dept ADD CONSTRAINT FK_emp_dept FOREIGN KEY (deptno) REFERENCES dept (deptno);
ALTER TABLE dept DROP CONSTRAINT FK_EMP_DEPT;
ALTER TABLE emp ADD CONSTRAINT FK_emp_emp FOREIGN KEY (mgr) REFERENCES emp (empno);
ALTER TABLE emp DROP CONSTRAINT FK_EMP_EMP;


View 생성/변경
VIEW : VIEW는 쿼리이다 (VIEW 테이블은 잘못된 표현)
. 물리적인 데이터를 갖고 있지 않고,논리적인 데이터 정의 집합이다(SELECT 쿼리)
. VIEW가 사용하고 있는 테이블의 데이터가 바뀌면 VIEW 조회 결과도 같이 바뀐다

문법
CREATE IN REPLACE VIEW 뷰이름 AS
SELECT 쿼리;

emp테이블에서 sal, comm 컬럼 두개를 제외한 나머지 6개 컬럼으로 v_emp이름으로 VIEW생성
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

GRANT CONNECT, RESOURCE TO 계정명;
VIEW에 대한 생성권한은 RESOURCE에 포함되지 않는다.

GUNCCI 계정에게 VIEW 객체를 생성할 수 있는 권한을 부여(시스템)
GRANT CREATE VIEW TO guncci;

SELECT *
FROM v_emp;

SELECT *
FROM(SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp);

View는 쿼리다
물리적인 데이터가 아니다
논리적인 데이터 정의 집합
view가 참조하는 테이블을 수정하면 view에도 영향을 미친다

DELETE emp
WHERE deptno = 10;
emp테이블에서 10번 부서에 속하는 3명을 지웠기 때문에 아래 View의 조회 결과도 3명이 지워진 11명만 나온다
SELECT *
FROM v_emp;
ROLLBACK;

GUNCCI 계정에 있는 V_EMP 뷰를 HR계정에게 조회할 수 있도록 권한 부여
GRANT SELECT ON v_emp TO hr;
SELECT *
FROM guncci.v_emp;