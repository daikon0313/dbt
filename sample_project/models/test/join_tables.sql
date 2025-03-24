{{ config(materialized='table') }}

with customer as (
  select {{ dbt_utils.star(from=source('tpch_sample', 'customer')) }} 
  from {{ source('tpch_sample', 'customer') }}
),
nation as (
  select {{ dbt_utils.star(from=source('tpch_sample', 'nation')) }} 
  from {{ source('tpch_sample', 'nation') }}
),
orders as (
  select {{ dbt_utils.star(from=source('tpch_sample', 'orders')) }} 
  from {{ source('tpch_sample', 'orders') }}
),
lineitem as (
  select {{ dbt_utils.star(from=source('tpch_sample', 'lineitem')) }} 
  from {{ source('tpch_sample', 'lineitem') }}
)

select
  -- customer テーブル
  c.c_custkey       as custkey,
  c.c_name          as customer_name,
  c.c_address       as customer_address,
  c.c_nationkey     as nationkey,
  
  -- nation テーブル
  n.n_name          as nation_name,
  n.n_regionkey     as regionkey,
  n.n_comment       as nation_comment,
  
  -- orders テーブル
  o.o_orderkey      as orderkey,
  o.o_orderstatus   as orderstatus,
  o.o_totalprice    as totalprice,
  o.o_orderdate     as orderdate,
  o.o_orderpriority as orderpriority,
  o.o_clerk         as clerk,
  
  -- lineitem テーブル
  l.l_linenumber    as linenumber,
  l.l_quantity      as quantity,
  l.l_extendedprice as extendedprice,
  l.l_discount      as discount,
  l.l_tax           as tax,
  l.l_returnflag    as returnflag,
  l.l_linestatus    as linestatus,
  l.l_shipdate      as shipdate,
  l.l_commitdate    as commitdate,
  l.l_receiptdate   as receiptdate,
  l.l_shipinstruct  as shipinstruct,
  l.l_shipmode      as shipmode,
  l.l_comment       as lineitem_comment,
  'test' as test
from customer c
inner join nation n
  on c.c_nationkey = n.n_nationkey
inner join orders o
  on c.c_custkey = o.o_custkey
inner join lineitem l
  on o.o_orderkey = l.l_orderkey