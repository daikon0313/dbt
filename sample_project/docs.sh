#!/bin/bash

dbt run-operation print_profile --args '{"relation_name": "notion_mart", "exclude_measures": ["std_dev_population", "std_dev_sample", "avg", "median"]}' > docs/notion_mart.tmp
sed -nr 's/\x1B\[[0-9;]*[mK]//g;/^\|/p' docs/notion_mart.tmp > docs/notion_mart.filtered.md

# ファイル作成
echo "{% docs dbt_profiler__customer %}" > docs/notion_mart.md
cat docs/notion_mart.filtered.md >> docs/notion_mart.md
echo "{% enddocs %}" >> docs/notion_mart.md

rm docs/notion_mart.tmp docs/notion_mart.filtered.md