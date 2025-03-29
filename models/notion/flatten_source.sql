with source_data as (select * from {{ source("notion", "work_log") }})
select
    fetched_at,
    context.value:id::string as page_id,  -- notionページのid
    context.value:properties."Duration(h)".formula.number::number(38, 1)
    * 60 as duration_minutes,  -- 作業時間
    context.value:properties.status.status.name::string as status,  -- ステータス
    case
        when array_size(context.value:properties."Project Tag".multi_select) > 0
        then context.value:properties."Project Tag".multi_select[0].name::string
        else null
    end as project_tag,  -- プロジェクトタグ
    coalesce(
        context.value:properties."Work Tag".select.name::string, '未設定'
    ) as work_tag,  -- 作業タグ (NULL の場合 '未設定')
    context.value:properties."Start Time".date.start::timestamp_tz as start_time,  -- 開始時間
    context.value:properties."End Time".date.start::timestamp_tz as end_time,  -- 終了時間
    context.value:properties."締切".date.start::date as due_date,  -- 締切
    context.value:url::string as notion_url,  -- notionのページurl
    context.value:created_time::timestamp_tz as created_time,  -- 作成日時
    context.value:last_edited_time::timestamp_tz as last_edited_time  -- 最終編集日時
from source_data, lateral flatten(input => contexts:results) context
