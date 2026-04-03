-- COUNT 쿼리  
SELECT 
	count(b.board_id) 
FROM 
	board b 
WHERE 
	b.deleted_at IS NULL;


-- 인덱스 적용 (created_date desc 단일 인덱스)
CREATE INDEX idx_board_created_date_desc ON board (created_date DESC);


-- Explain Analyze
-> Aggregate: count(b.board_id)  (cost=113969 rows=1) (actual time=1312..1312 rows=1 loops=1)
    -> Filter: (b.deleted_at is null)  (cost=104048 rows=99210) (actual time=15.5..1269 rows=900311 loops=1)
        -> Table scan on b  (cost=104048 rows=992104) (actual time=15.5..1190 rows=1e+6 loops=1)
