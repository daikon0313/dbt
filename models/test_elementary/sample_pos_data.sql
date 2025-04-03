WITH base AS (
  SELECT
    -- 購入日時（2025年3月2日から4月1日まで）
    DATEADD(
      minute,
      UNIFORM(0, 43200, RANDOM()),
      '2025-03-02'
    )::TIMESTAMP_LTZ AS purchase_datetime,

    ARRAY_CONSTRUCT(
      'コーヒー', '紅茶', 'サンドイッチ', 'おにぎり', '弁当',
      'サラダ', 'スナック', '飲料水', '菓子パン', 'カップラーメン'
    )[UNIFORM(0, 9, RANDOM())] AS item,

    UNIFORM(100, 1000, RANDOM()) AS price,
    'customer_' || UNIFORM(1, 1000, RANDOM()) AS customer_id,
    ARRAY_CONSTRUCT('東京店', '大阪店', '名古屋店', '福岡店', '札幌店')[UNIFORM(0, 4, RANDOM())] AS store_name,
    'SAMPLE_COLUMNS' as sample_columns
  FROM TABLE(GENERATOR(ROWCOUNT => 10000000))
)

SELECT
  *,
  DATEADD(minute, UNIFORM(1, 720, RANDOM()), purchase_datetime)::TIMESTAMP_LTZ AS loaded_datetime
FROM base