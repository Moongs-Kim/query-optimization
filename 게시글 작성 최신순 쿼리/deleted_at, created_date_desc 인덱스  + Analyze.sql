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

-- 인덱스 적용 (deleted_at, created_date DESC 멀티 컬럼 인덱스)
CREATE INDEX idx_board_deleted_at_created_date_desc ON board (deleted_at, created_date DESC);


-- Explain Analyze
-> Limit: 10 row(s)  (cost=485241 rows=10) (actual time=0.526..1.25 rows=10 loops=1)
    -> Nested loop inner join  (cost=485241 rows=496052) (actual time=0.525..1.24 rows=10 loops=1)
        -> Index lookup on b using idx_board_deleted_at_created_date_desc (deleted_at=NULL), with index condition: (b.deleted_at is null)  (cost=68082 rows=496052) (actual time=0.311..0.472 rows=10 loops=1)
        -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.741 rows=1) (actual time=0.0767..0.0767 rows=1 loops=10)
