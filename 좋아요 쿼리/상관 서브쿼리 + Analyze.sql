-- 상관 서브쿼리  
SELECT 
	b.board_id,
	b.title,
	b.view_count,
	b.created_date,
	m.name,
	(SELECT count(*) FROM likes l WHERE l.board_id = b.board_id) AS like_count
FROM 
	board b
JOIN 
	member m on m.member_id = b.member_id
WHERE
	b.deleted_at IS NULL
ORDER BY
	like_count DESC
LIMIT 0, 10;


-- 상관 서브쿼리 Explain Analyze
-> Limit: 10 row(s)  (actual time=122738..122738 rows=10 loops=1)
    -> Sort: like_count DESC, limit input to 10 row(s) per chunk  (actual time=122738..122738 rows=10 loops=1)
        -> Stream results  (cost=176084 rows=99210) (actual time=0.566..121905 rows=900311 loops=1)
            -> Nested loop inner join  (cost=176084 rows=99210) (actual time=0.497..108648 rows=900311 loops=1)
                -> Filter: ((b.deleted_at is null) and (b.member_id is not null))  (cost=107372 rows=99210) (actual time=0.132..3272 rows=900311 loops=1)
                    -> Table scan on b  (cost=107372 rows=992104) (actual time=0.129..2736 rows=1e+6 loops=1)
                -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.593 rows=1) (actual time=0.117..0.117 rows=1 loops=900311)
-> Select #2 (subquery in projection; dependent)
    -> Aggregate: count(0)  (cost=202 rows=1) (actual time=0.00852..0.0086 rows=1 loops=900311)
        -> Covering index lookup on l using uq_board_member (board_id=b.board_id)  (cost=103 rows=992) (actual time=0.00786..0.0079 rows=0.193 loops=900311)


-- 인덱스 적용 후(deleted_at 단일 컬럼 인덱스)
-> Limit: 10 row(s)  (actual time=63319..63319 rows=10 loops=1)
    -> Sort: like_count DESC, limit input to 10 row(s) per chunk  (actual time=63319..63319 rows=10 loops=1)
        -> Stream results  (cost=254470 rows=496052) (actual time=1.5..62780 rows=900311 loops=1)
            -> Nested loop inner join  (cost=254470 rows=496052) (actual time=0.721..53654 rows=900311 loops=1)
                -> Filter: (b.member_id is not null)  (cost=73815 rows=496052) (actual time=0.696..6223 rows=900311 loops=1)
                    -> Index lookup on b using idx_board_deleted_at (deleted_at=NULL), with index condition: (b.deleted_at is null)  (cost=73815 rows=496052) (actual time=0.694..6072 rows=900311 loops=1)
                -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.264 rows=1) (actual time=0.0523..0.0523 rows=1 loops=900311)
-> Select #2 (subquery in projection; dependent)
    -> Aggregate: count(0)  (cost=202 rows=1) (actual time=0.00649..0.00655 rows=1 loops=900311)
        -> Covering index lookup on l using uq_board_member (board_id=b.board_id)  (cost=103 rows=992) (actual time=0.00595..0.00608 rows=0.193 loops=900311)
