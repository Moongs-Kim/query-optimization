-- COUNT 쿼리  
SELECT 
	count(b.board_id) 
FROM 
	board b 
WHERE 
	b.deleted_at IS NULL;


-- 인덱스 적용 (created_date desc 단일 인덱스)
CREATE INDEX idx_board_deleted_at_created_date_desc ON board (deleted_at, created_date DESC);


-- Explain Analyze
-> Aggregate: count(b.board_id)  (cost=100781 rows=1) (actual time=401..401 rows=1 loops=1)
    -> Filter: (b.deleted_at is null)  (cost=51176 rows=496052) (actual time=0.0482..362 rows=900311 loops=1)
        -> Covering index lookup on b using idx_board_deleted_at_created_date_desc (deleted_at=NULL)  (cost=51176 rows=496052) (actual time=0.0467..291 rows=900311 loops=1)
