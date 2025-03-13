with source_data as (
    select *
    from {{ source('notion', 'work_log') }}
)

SELECT
  fetched_at::date as fetched_at,
  current_date() as last_query_time
  context.value:id::STRING AS page_id,  -- NotionページのID
  context.value:properties."Duration(h)".formula.number::number(38,1) * 60 AS duration_minutes, -- 作業時間
  context.value:properties.Status.status.name::STRING AS status, -- ステータス
  CASE 
    WHEN ARRAY_SIZE(context.value:properties."Project Tag".multi_select) > 0 
    THEN context.value:properties."Project Tag".multi_select[0].name::STRING 
    ELSE NULL 
  END AS project_tag, -- プロジェクトタグ
  COALESCE(context.value:properties."Work Tag".select.name::STRING, '未設定') AS work_tag, -- 作業タグ (NULL の場合 '未設定')
  context.value:properties."Start Time".date.start::TIMESTAMP_TZ AS start_time, -- 開始時間
  context.value:properties."End Time".date.start::TIMESTAMP_TZ AS end_time, -- 終了時間
  context.value:properties."締切".date.start::DATE AS due_date, -- 締切
  context.value:url::STRING AS notion_url, -- NotionのページURL
  context.value:created_time::TIMESTAMP_TZ AS created_time, -- 作成日時
  context.value:last_edited_time::TIMESTAMP_TZ AS last_edited_time -- 最終編集日時
FROM source_data,
LATERAL FLATTEN(input => contexts:results) context
