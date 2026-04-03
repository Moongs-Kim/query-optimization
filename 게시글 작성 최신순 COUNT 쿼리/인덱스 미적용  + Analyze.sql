-- COUNT 쿼리  
SELECT 
	count(b.board_id) 
FROM 
	board b 
WHERE 
	b.deleted_at IS NULL;


-- Explain Analyze
-> Aggregate: count(b.board_id)  (cost=115252 rows=1) (actual time=1144..1144 rows=1 loops=1)
    -> Filter: (b.deleted_at is null)  (cost=105331 rows=99210) (actual time=15.8..1103 rows=900311 loops=1)
        -> Table scan on b  (cost=105331 rows=992104) (actual time=15.8..1025 rows=1e+6 loops=1)
