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

-- 인덱스 적용 (created_date desc 단일 인덱스)
CREATE INDEX idx_board_created_date_desc ON board (created_date DESC);


-- Explain Analyze
-> Limit: 10 row(s)  (cost=51767 rows=1) (actual time=0.132..0.337 rows=10 loops=1)
    -> Nested loop inner join  (cost=51767 rows=1) (actual time=0.131..0.335 rows=10 loops=1)
        -> Filter: (b.deleted_at is null)  (cost=0.98 rows=1) (actual time=0.102..0.203 rows=10 loops=1)
            -> Index scan on b using idx_board_created_date_desc  (cost=0.98 rows=10) (actual time=0.1..0.2 rows=13 loops=1)
        -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.522 rows=1) (actual time=0.0128..0.0128 rows=1 loops=10)
