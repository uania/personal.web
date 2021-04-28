--火车票 companyid:6603175886 KEY:zlhjfgtw prefix:ZLSJ
--测试key：abcdefgh
--查询表结构详情   
select c.oid,con.conname,c.relname,a.attname,d.description,t.typname,a.atttypmod
from pg_class c,pg_attribute a,pg_constraint con,
pg_description d,pg_type t
where c.oid = a.attrelid and a.attrelid = d.objoid 
and a.attnum = d.objsubid and a.atttypid = t.oid
and c.oid = con.conrelid
and c.relname = 'order_train_passenger'; --in ('mass_order','mass_order_item','mass_order_traveller') order by relname; --platform_workday
--pg_attribute
select * from pg_attribute where attrelid = 311270;
--pg_class
select oid,* from pg_class where relname = 'platform_setting';
--pg_constraint 
select oid,* from pg_constraint where conrelid = 311270;
--工作日配置
select id,date,day_type,year,day_of_year,remark from platform_workday where 1=1;
--平台设置
select id,code,name,value,remark from platform_setting;
--国家信息
select * from common_country where name = '中国';
--区域信息
select * from platform_region;
--insert into platform_region(code,"name",remark) values('feiyatai','非亚太地区','这是备注');
--国家区域关联查询
select * from platform_region_country;
--国家区域关联查询
select pr.id region_id,cc.id country_id,prc.id region_country_id,
cc.code country_code,pr.code region_code,cc.name country_name,pr.name region_name
from platform_region_country prc
left join common_country cc on prc.national_code = cc.code
left join platform_region pr on prc.region_code = pr.code
where 1=1 order by pr.name,cc.name;
------------------------------------2021-03-09 发版sql------------------
   select * from      customer_workday
--
CREATE TABLE public.customer_workday
(
    id serial primary key,
    customer_id integer,
    date character varying(10),
    day_type integer,
    "year" integer,
    day_of_year integer,
    remark character varying(200)
)WITH (OIDS = FALSE)
TABLESPACE pg_default;
ALTER TABLE public.customer_workday OWNER to postgres;
comment on table public.customer_workday is '客户工作日信息';
COMMENT ON COLUMN public.customer_workday.id IS '主键';
comment on column public.customer_workday.customer_id is '客户id';
COMMENT ON COLUMN public.customer_workday.date IS '日期（yyyy-MM-dd）';
COMMENT ON COLUMN public.customer_workday.day_type IS '类型';
COMMENT ON COLUMN public.customer_workday."year" IS '年';
COMMENT ON COLUMN public.customer_workday.day_of_year IS 'year年的第几天';
comment on column public.customer_workday.remark is '备注';

--区域和国家对应关系
CREATE TABLE public.customer_region_country
(
    id serial primary key,
    customer_id integer,
    region_code character varying(100),
    national_code character varying(100)
)WITH (OIDS = FALSE)
TABLESPACE pg_default;
ALTER TABLE public.customer_region_country OWNER to postgres;
comment on table public.customer_region_country is '区域和国家对应关系';
COMMENT ON COLUMN public.customer_region_country.id IS '主键';
comment on column public.customer_region_country.customer_id is '客户id';
COMMENT ON COLUMN public.customer_region_country.region_code IS '地区编号';
COMMENT ON COLUMN public.customer_region_country.national_code IS '国家编号';

--区域表扩展
alter table public.platform_region add column abbr varchar(50);
alter table public.platform_region add column name_en varchar(50);
alter table public.platform_region add column seq_no integer;
alter table public.platform_region add column region_level integer;
comment on column public.platform_region.abbr is '简称';
comment on column public.platform_region.name_en is '英文名';
comment on column public.platform_region.seq_no is '排序';
comment on column public.platform_region.region_level is '分级';

--platform_reason
create table public.platform_reason(
    id serial primary key,
    reason varchar(254),
    status integer,
    rule_type integer,
    order_category integer,
    reason_code varchar(8),
    reason_desc text,
    reason_en varchar(100),
    reason_desc_en text
);
comment on table public.platform_reason is '系统默认超标原因';
comment on column public.platform_reason.id is '主键';
comment on column public.platform_reason.reason is '原因';
comment on column public.platform_reason.status is '状态';
comment on column public.platform_reason.rule_type is '差旅规则原因';
comment on column public.platform_reason.order_category is '订单种类(（火车票、机票）';
comment on column public.platform_reason.reason_code is '超标原因编码';
comment on column public.platform_reason.reason_desc is '超标原因描述';
comment on column public.platform_reason.reason_en is '超标原因英文';
comment on column public.platform_reason.reason_desc_en is '超标原因英文描述';
----------------------------------------------2021-03-09 发版sql------------------------------
SELECT * from customer_setting_category order by id;
SELECT * from customer_setting_item;
SELECT * from customer_setting_value order by id ;

select csval.id,csval.customer_id,csi.code,csi."name",csi.category_code,csi.value_type,
case when csval."value" is null then csi.default_value else csval."value" end "value",
csi."template",csi.remark,csc."name" category_name
from customer_setting_item csi 
left join customer_setting_value csval on csi.code = csval.item_code
left join customer_setting_category csc on csc.code = csi.category_code
where csval.customer_id = 39636 and csi.code = ''

select * from customer_region_country;
select * from platform_region;
SELECT * from platform_region_country;
select * from platform_setting;
select is_close_personal_book,* from customer_company_setting where customer_info->>'Id'='39755';

with recursive category as (
    select * from customer_setting_category where code = 'service_fee'
    union all
    select csc.* from customer_setting_category csc,category where csc.parent_code = category.code
) select category."name" category_name,csi.category_code,csi.code,csi."name",csval.customer_id,
case when csval."value" is null then csi.default_value else csval."value" end "value",
csi.value_type,csi."template",csi.remark
from category
inner join customer_setting_item csi on  csi.category_code = category.code
left join customer_setting_value csval on csi.code = csval.item_code
where csval.customer_id = 39636;

select * from customer_setting_item;
select * from 
with setting_value as (
    select case when customer_id is null then '123456' else customer_id end,"value",
    case when item_code is null then 'date_worktime' else item_code end
    from customer_setting_value where customer_id = '123456' and item_code = 'date_worktime'
) select csi.code,csi.name,csi.category_code,csi.value_type,csi."template",csi.remark,csc.name category_name
from customer_setting_item csi
left join customer_setting_category csc on csc.code = csi.category_code
where csi.code = 'date_worktime';

select * from customer_employee_train_account order by id desc limit 100;
select * from customer_service_fee_definition LIMIT 10;
select * from common_job where job_name = 'TrainOrderReissueConfirm' and job_data->>'ReissueId'='194122';
select * from customer_employee where name='锦鲤三号' limit 1000
--是否显示绑定12306模块
alter table customer_company_setting add COLUMN is_show_bind12306 boolean default true;
comment on column public.customer_company_setting.is_show_bind12306 is '是否显示绑定12306模块';
select ctrip_train_account_id,train_account_id,* from customer_company_setting limit 100;
select * from customer_employee_train_account where id = 116 limit 10;
select train_account_id,* from customer_employee where train_account_id is not null limit 100;
--修改火车票订单的车次信息
update order_train set train_info ='{"Checi":"T135","Price":46.5,"Zwcode":null,"Zwname":"硬座","RunTime":"4小时26分钟","EnZwname":"Hard seat","CheciCode":"T","StartTime":"00:39","TrainDate":"2021-04-16","ArriveDate":"2021-04-16","ArriveTime":"05:49","TicketType":null,"ArrivalCity":"上海","ArrivalTime":"2021-04-16T05:49:00","CheciCategory":"特快","DepartureCity":"南京","DepartureTime":"2021-04-16T00:48:00","ToStationCode":"SNH","ToStationName":"上海南","ArrivalCityCode":"SHH","FromStationCode":"NJH","FromStationName":"南京","DepartureCityCode":"NJH"}'::jsonb where serial_number = 'TR20210416006770'
select * from platform_setting;
select * from platform_workday where "date" = '2021-4-15';
SELECT * from customer_setting_item where code = 'date_worktime';

    select * from customer_setting_item;

        select is_show_bind12306,train_supplier_type, ctrip_train_account_id,train_account_id,* from customer_company_setting where customer_info->>'Id' ='32887'
        select * from platform_account where id = 30;
--携程账号登录失败问题
        select apply_login_status,out_order_no,supplier_type,is_grab_ticket_order,group_id,supplier_service_charge,* from order_train where serial_number = 'TR20210409194113-G1';  --167261
select payment_status,payment_status,remark,status,* from order_train where remark = '支付超时自动取消' and payment_status = 2 order by id desc limit 100

        
        select * from order_train where serial_number like '%G1';  
        select apply_login_status,out_order_no,* from order_train where group_id = '167844';  
        select * from train_order_group where group_number = '5326319460117981568';
        select * from customer_employee where id=288177
select * from train_order_group where id = 167707
        select * from customer_employee_train_account where id = 6
select * from platform_account_train where id=6
        select * from customer_handler_bind where customer_id = '27069' and status = 1

--航天华友回调异常问题
select * from train_order_group where id = '167271'

select status,payment_status,supplier,group_id,supplier_service_charge,* from order_train where customer_employee->>'Name'='夏雨雄'  order by id desc limit 100;
select * from common_payment where business_id = '118099' ;
update order_train set test_order=false,
supplier='{"Id":342,"Name":"七彩阳光（北京）旅行社有限公司","AccountId":0,"AccountName":null,"AccountType":0,"InvoiceType":0,"PaymentType":0,"InvoiceTypeDesc":null,"PaymentTypeName":null}'::jsonb 
where serial_number in ( 
'TR20210423006851'
, 'TR20210423006852'
, 'TR20210423006853'
, 'TR20210423006855');
select price,employee_train_account_id,test_order,supplier_service_charge,supplier,* from order_train where serial_number in (
 'TR20210423006851'
, 'TR20210423006852'
, 'TR20210423006853'
, 'TR20210423006855');

select train_supplier_type,* from customer_company_setting order by id desc limit 10;
select supplier,* from order_train where serial_number = 'TR20210423006850';
SELECT * from common_job where job_data->>'OrderId'='6849' order by id desc limit 100;

with recursive category as (
select * 
from 
    customer_setting_category 
where code='customer_setting'
union all
select 
    csc.* 
from customer_setting_category csc,category
where csc.parent_code = category.code
),customer_values as (
select 
    item_code code,
    "value"
from
    customer_setting_value
where customer_id=39636
)
select 
    category."name" category_name,
    csi.category_code,
    csi.code,
    csi."name",
    csi.value_type,
    csi."template",
    csi.remark
from category
inner join customer_setting_item csi 
on csi.category_code = category.code
left join customer_values cvs
on csi.code=cvs.code;



with customer_items as(
select
	csi.code,
	csi."name",
	csi.category_code,
	csi.value_type,
    csi.default_value "value",
	csi."template",
	csi.remark,
	csc."name"category_name
from
	customer_setting_item csi
    left join customer_setting_category csc on
	    csc.code = csi.category_code
),customer_values as(
select
    item_code code,
    "value"
from
    customer_setting_value
where
    customer_id=39363
)
select 
    cis.code,
    cis."name",
    cis.category_code,
    cis.value_type,
    case when cvs."value" is null then cis."value"
        else cvs."value" end "value",
    cis."template",
    cis.remark
from customer_items cis
left join customer_values cvs
on cis.code = cvs.code; --使用sqllistasync

with customer_item as (
select 
    csi.code,
    csi."name",
    csi.category_code,
    csi.value_type,
    csi.default_value "value",
    csi."template",csi.remark,csc."name" category_name
from customer_setting_item csi
left join customer_setting_category csc on csc.code = csi.category_code
where csi.code=@Code
)

select train_is_outage,employee_train_account_id,group_id,* from order_train where serial_number = 'TR20210425195991'
update order_train set train_is_outage = true where serial_number = 'TR20210423006871'
select * from train_order_group where group_number = '5740957105116435402'
select * from order_train where group_id = '167946'

select certificate,* from customer_employee order by id desc limit 10 ; --certificate_list
select * from customer_department order by id desc limit 10;
select customer_employee,* from customer_travel_apply order by id desc limit 10;
select * from customer_travel_apply_traveller order by id desc limit 100;

select supplier_info,* from customer_company_setting where customer_info->>'Id'='27069'
select * from platform_account_train 

select order_type,employee_train_account_id,* from order_train where serial_number = 'TR20210425195899';
select * from common_job where job_data->>'GroupId'='168183'
select transaction_id,employee_train_account_id,group_id,* from order_train order by id desc limit 10;

select * from train_order_group where group_number = '4761327967302448334'
select * from order_train where group_id = '168184'
select * from ctrip_train_extend where request_key = '4e1fe9e4c1924470a24d63ee936c262f';
select serial_number,* from common_payment limit 10;

select notify_url,return_url,* from pay_trade order by id desc limit 100;
select * from ctrip_train_account limit 100 where profile_center = 'searchCtrip';
select * from platform_account_train order by id desc limit 100;
select * from platform_account order by id desc limit 100;

select rule_code from customer_service_fee_definition where customer_info->>'Id'='32500' and order_category='5'

select * from platform_rule_definition where code in ('OTRLR0008'
,	'OTRLR0016'
,	'OTRLR0015'
,	'OTRLR0014'
,	'OTRLR0013'
,	'OTRLR0011'
,	'OTRLR0005'
,	'OTRLR0002'
,	'OTRLR0012'
,	'OTRLR0009'
,	'OTRLR0006'
,	'OTRLR0003')