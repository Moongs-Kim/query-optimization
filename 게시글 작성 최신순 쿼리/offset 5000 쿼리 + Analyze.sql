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
	b.created_date DESC LIMIT 5000,10;

-- 인덱스 적용 (deleted_at, created_date DESC 멀티 컬럼 인덱스)
CREATE INDEX idx_board_deleted_at_created_date_desc ON board (deleted_at, created_date DESC);


-- Explain Analyze
-> Limit/Offset: 10/5000 row(s)  (cost=453617 rows=10) (actual time=1499..1502 rows=10 loops=1)
    -> Nested loop inner join  (cost=453617 rows=496052) (actual time=0.159..1501 rows=5010 loops=1)
        -> Index lookup on b using idx_board_deleted_at_created_date_desc (deleted_at=NULL), with index condition: (b.deleted_at is null)  (cost=66246 rows=496052) (actual time=0.131..744 rows=5010 loops=1)
        -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.681 rows=1) (actual time=0.15..0.15 rows=1 loops=5010)
