ORACLE 설치방법
가상화가 도입된 이유
물리적 컴퓨터는 동시에 하나의 OS만 실행가능


join1]
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu
ORDER BY p.prod_id;

prod 테이블 건수?
SELECT COUNT(*)
FROM prod;



join2]
SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM buyer b, prod p
WHERE b.buyer_id = p.prod_buyer
ORDER BY p.prod_id;



SELECT *
FROM cart;
join3]
ANSI-SQL]
테이블 JOIN 테이블 ON ()

SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member JOIN cart ON (mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);


SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name, cart.cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
  AND cart.cart_prod = prod.prod_id;