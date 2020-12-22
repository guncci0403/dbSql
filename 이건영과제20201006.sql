
emp테이블에서 7369번 사원의 sal 정보를 조회하여
sal 값이 1000보다 크면 sal*1.2값을
sal 값이 900보다 크면 sal*1.3값을
sal 값이 800보다 크면 sal*1.4값을
위 세가지 조건을 만족하지 못할 때는 sal*1.6값을
v_sal 변수에 담고 emp 테이블의 sal 컬럼에 업데이트
단 case 표현식을 사용할 것

1. 7369번 사번의 sal 정보를 조회하여 변수에 담는다
2. 1번에서 담은 변수값을 case 표현식을 이용하여 새로운 sal 값을 구하고 v_sal 변수에 할당
3. 7369번 사원의 sal 컬럼을 v_sal값으로 업데이트

DECLARE
    v_sal emp.sal%TYPE;
BEGIN
    SELECT sal INTO v_sal
    FROM emp
    WHERE empno = 7369;
    
v_sal := CASE
        WHEN v_sal > 1000 THEN v_sal*1.2
        WHEN v_sal > 900 THEN v_sal*1.3
        WHEN v_sal > 800 THEN v_sal*1.4
        ELSE v_sal*1.6
    END;
    
    UPDATE emp SET sal = v_sal WHERE empno = 7369;
END;
/
SELECT *
FROM emp;
rollback;