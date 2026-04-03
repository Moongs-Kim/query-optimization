-- 게시글 작성 최신순 쿼리
SELECT
	b.board_id,
	b.title,
	b.view_count,
	b.created_date,
	m.name 
FROM 
	board b 
JOIN 
	member m ON m.member_id=b.member_id 
WHERE 
	b.deleted_at IS NULL
ORDER BY 
	b.created_date DESC LIMIT 0,10;


-- Explain Analyze
-> Limit: 10 row(s)  (cost=256310 rows=10) (actual time=2002..2003 rows=10 loops=1)
    -> Nested loop inner join  (cost=256310 rows=992104) (actual time=2002..2003 rows=10 loops=1)
        -> Sort: b.created_date DESC  (cost=105334 rows=992104) (actual time=2002..2002 rows=10 loops=1)
            -> Filter: (b.deleted_at is null)  (cost=105334 rows=992104) (actual time=15.2..1264 rows=900311 loops=1)
                -> Table scan on b  (cost=105334 rows=992104) (actual time=15.2..1183 rows=1e+6 loops=1)
        -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.522 rows=1) (actual time=0.153..0.153 rows=1 loops=10)

