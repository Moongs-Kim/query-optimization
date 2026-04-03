-- 인라인 뷰 쿼리
SELECT 
	b.board_id,
	b.title,
	b.view_count,
	b.created_date,
	m.name,
	lc.like_count
FROM 
	board b
LEFT JOIN
	(SELECT
		board_id,
		count(*) AS like_count
	 FROM
	 	likes l
 	 GROUP BY
 	 	board_id
	) lc ON lc.board_id = b.board_id
JOIN
	member m ON m.member_id = b.member_id
WHERE
	b.deleted_at IS NULL
ORDER BY
	lc.like_count DESC
LIMIT 0, 10;


-- 인라인 뷰 쿼리 Explain Analyze
-> Limit: 10 row(s)  (actual time=41013..41013 rows=10 loops=1)
    -> Sort: lc.like_count DESC, limit input to 10 row(s) per chunk  (actual time=41013..41013 rows=10 loops=1)
        -> Stream results  (cost=2.39e+6 rows=19.9e+6) (actual time=365..40654 rows=900311 loops=1)
            -> Nested loop left join  (cost=2.39e+6 rows=19.9e+6) (actual time=365..39459 rows=900311 loops=1)
                -> Nested loop inner join  (cost=143894 rows=99210) (actual time=0.851..37675 rows=900311 loops=1)
                    -> Filter: (b.deleted_at is null)  (cost=107209 rows=99210) (actual time=0.827..2155 rows=900311 loops=1)
                        -> Table scan on b  (cost=107209 rows=992104) (actual time=0.825..1994 rows=1e+6 loops=1)
                    -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.27 rows=1) (actual time=0.0391..0.0392 rows=1 loops=900311)
                -> Index lookup on lc using <auto_key0> (board_id=b.board_id)  (cost=40699..40701 rows=10) (actual time=0.00158..0.00158 rows=193e-6 loops=900311)
                    -> Materialize  (cost=40698..40698 rows=201) (actual time=364..364 rows=200 loops=1)
                        -> Group aggregate: count(0)  (cost=40678 rows=201) (actual time=5.42..364 rows=200 loops=1)
                            -> Covering index scan on l using uq_board_member  (cost=20739 rows=199390) (actual time=5.17..351 rows=200000 loops=1)


-- 인덱스 적용 후(deleted_at 단일 컬럼 인덱스)
-> Limit: 10 row(s)  (actual time=28243..28243 rows=10 loops=1)
    -> Sort: lc.like_count DESC, limit input to 10 row(s) per chunk  (actual time=28243..28243 rows=10 loops=1)
        -> Stream results  (cost=11.6e+6 rows=99.7e+6) (actual time=120..28053 rows=900311 loops=1)
            -> Nested loop left join  (cost=11.6e+6 rows=99.7e+6) (actual time=120..27384 rows=900311 loops=1)
                -> Nested loop inner join  (cost=387242 rows=496052) (actual time=0.0597..26442 rows=900311 loops=1)
                    -> Index lookup on b using idx_board_deleted_at (deleted_at=NULL), with index condition: (b.deleted_at is null)  (cost=73980 rows=496052) (actual time=0.0512..2768 rows=900311 loops=1)
                    -> Single-row index lookup on m using PRIMARY (member_id=b.member_id)  (cost=0.532 rows=1) (actual time=0.0261..0.0261 rows=1 loops=900311)
                -> Index lookup on lc using <auto_key0> (board_id=b.board_id)  (cost=40699..40701 rows=10) (actual time=828e-6..828e-6 rows=193e-6 loops=900311)
                    -> Materialize  (cost=40698..40698 rows=201) (actual time=120..120 rows=200 loops=1)
                        -> Group aggregate: count(0)  (cost=40678 rows=201) (actual time=1.26..120 rows=200 loops=1)
                            -> Covering index scan on l using uq_board_member  (cost=20739 rows=199390) (actual time=1.16..113 rows=200000 loops=1)








