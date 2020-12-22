sub7]
SELECT CYCLE.CID, c.cnm, p.pid, day, cnt
FROM cycle, customer c, product p 
WHERE cycle.cid = 1
  AND cycle.cid = c.cid
  AND cycle.pid = p.pid
  AND cycle.pid IN ( SELECT pid
                       FROM cycle
                      WHERE cid = 2);

select *
from fastfood;

순위  시도  시군구   도시발전지수    kfc     맥날      버거킹     롯리
1   서울시  서초구      4.5        3       4         5        6
2   서울시  강남구      4.3
3   부산시  해운대구    4.1
*HINT
SELECT sido, sigungu, gb, count(*)
FROM fastfood
WHERE gb = '맥도날드'
  AND sido = '강원도'
  AND sigungu = '강릉시'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;

*ANS

SELECT sido, sigungu, gb
FROM fastfood
ORDER BY sido, sigungu, gb;

SELECT sido, sigungu, gb, count(*) cnt
FROM fastfood
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;

KFC-66 롯데리아- 버거킹- 맥도날드-
SELECT sido, sigungu, gb, count(*) cnt
FROM fastfood
WHERE gb = 'KFC'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;



SELECT a.sido, a.sigungu, a.cnt, b.cnt, ROUND(a.cnt/b.cnt, 2) di
FROM
(SELECT sido, sigungu, count(*) cnt
FROM fastfood
WHERE gb IN ('KFC', '맥도날드', '버거킹')
GROUP BY sido, sigungu) a,


(SELECT sido, sigungu,  count(*) cnt
 FROM fastfood
 WHERE gb = '롯데리아'
 GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
  AND a.sigungu = b.sigungu
ORDER BY di DESC;


SELECT sido, sigungu, 
       ROUND((NVL(SUM(DECODE(gb, 'KFC', cnt)), 0) +
       NVL(SUM(DECODE(gb, '버거킹', cnt)),0) +
       NVL(SUM(DECODE(gb, '맥도날드', cnt)),0)) /
       NVL(SUM(DECODE(gb, '롯데리아', cnt)), 1), 2) di
FROM
(SELECT sido, sigungu, gb, count(*) cnt
 FROM fastfood
 WHERE gb IN('KFC', '롯데리아', '버거킹', '맥도날드')
 GROUP BY sido, sigungu, gb)
GROUP BY sido, sigungu
ORDER BY di DESC;

SELECT sido, sigungu, ROUND(sal/people) p_sal
FROM tax
ORDER BY p_sal DESC;

도시발전지수 1 - 세금1위
도시발전지수 2 - 세금2위
도시발전지수 3 - 세금3위

