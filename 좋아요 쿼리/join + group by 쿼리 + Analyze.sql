-- join + group by 쿼리
SELECT
	b.board_id,
	b.title,
	b.view_count,
	b.created_date,
	m.name,
	count(l.like_id) AS like_count
FROM 
	board b
JOIN
	member m ON m.member_id = b.member_id
LEFT JOIN
	likes l ON l.board_id = b.board_id
WHERE
	b.deleted_at IS NULL
GROUP BY
	b.board_id,
	b.title,
	b.view_count,
	b.created_date,
	m.name
ORDER BY
	like_count DESC
LIMIT 0, 10;


-- join + group by 쿼리 Explain Analyze
-> Limit: 10 row(s)  (actual time=66415..66415 rows=10 loops=1)
    -> Sort: like_count DESC, limit input to 10 row(s) per chunk  (actual time=66415..66415 rows=10 loops=1)
        -> Table scan on <temporary>  (actual time=65355..66271 rows=900311 loops=1)
            -> Aggregate using temporary table  (actual time=65354..65354 rows=900310 loops=1)
                -> Nested loop left join  (cost=10.4e+6 rows=98.4e+6) (actual time=15.8..52592 rows=1.07e+6 loops=1)
                    -> Nested loop inner join  (cost=174045 rows=99210) (actual time=15.2..48213 rows=900311 loops=1)
                        -> Filter: (b.deleted_at is null)  (cost=107376 rows=99210) (actual time=14.8..2090 rows=900311 loops=1)
                            -> Table scan on b  (cost=107376 rows=992104) (actual time=14.8..1901 rows=1e+6 loops=1)
                        -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.572 rows=1) (actual time=0.0509..0.0509 rows=1 loops=900311)
                    -> Covering index lookup on l using uq_board_member (board_id=b.board_id)  (cost=3.89 rows=992) (actual time=0.00427..0.00441 rows=0.193 loops=900311)


-- 인덱스 적용 후(deleted_at 단일 컬럼 인덱스)
-> Limit: 10 row(s)  (actual time=45158..45158 rows=10 loops=1)
    -> Sort: like_count DESC, limit input to 10 row(s) per chunk  (actual time=45158..45158 rows=10 loops=1)
        -> Table scan on <temporary>  (actual time=44576..45070 rows=900311 loops=1)
            -> Aggregate using temporary table  (actual time=44576..44576 rows=900310 loops=1)
                -> Nested loop left join  (cost=51.6e+6 rows=492e+6) (actual time=0.808..37630 rows=1.07e+6 loops=1)
                    -> Nested loop inner join  (cost=418962 rows=496052) (actual time=0.386..35029 rows=900311 loops=1)
                        -> Index lookup on b using idx_board_deleted_at (deleted_at=NULL), with index condition: (b.deleted_at is null)  (cost=74064 rows=496052) (actual time=0.372..2742 rows=900311 loops=1)
                        -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.595 rows=1) (actual time=0.0357..0.0357 rows=1 loops=900311)
                    -> Covering index lookup on l using uq_board_member (board_id=b.board_id)  (cost=3.89 rows=992) (actual time=0.00254..0.00263 rows=0.193 loops=900311)