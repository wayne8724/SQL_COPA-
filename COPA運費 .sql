--計算比例後的各筆運費(各筆的銷售金額 / 總銷售金額 * 總運費19921773)
select
B.yymm,
B.deptno,
B.whno,
B.cusno,
B.prdline,
B.prdno,
(B.saleamt / X.totalamt * 19921773) as ptg
from (
	select
	A.YYMM,
	A.DEPTNO,
	A.WHNO,
	A.CUSNO,
	A.PRDLINE,
	A.PRDNO,
	(select sum(m.saleamt) from SAP_COPA_ANA m where 1=1 and m.yymm = '11211' and m.adjustyn = 'N') as totalamt --總銷售額
	from SAP_COPA_ANA A
	where 1=1
	and A.yymm = '11211'
	and A.adjustyn = 'N'
) X, SAP_COPA_ANA B
where 1=1
and X.yymm = B.yymm
and X.deptno = B.deptno 
and X.whno = B.whno 
and X.cusno = B.cusno 
and X.prdline = B.prdline
and X.prdno = B.prdno 

-- 原總運費-按比例計算後總運費，求出差額
declare @diff numeric(10)
set @diff = (
	select
	19921773-sum(m.ptg) as diff
	from SAP_COPA_ANA m
	where 1=1
	and m.yymm = '11211'
	and m.adjustyn = 'N'
)

print @diff

--找出按比例計算後，運費最多的那筆資料並補上差額


select 
(A.ptg + @diff) as ptg   
from (
	select top 1 
	m.yymm,
	m.deptno,
	m.whno,
	m.cusno,
	m.prdline,
	m.prdno,
	m.ptg
	from SAP_COPA_ANA m
	where 1=1
	and m.yymm = '11211'
	and m.adjustyn = 'N'
	order by m.ptg desc
) X, SAP_COPA_ANA A
where 1=1
and X.yymm = A.yymm
and X.deptno = A.deptno
and X.whno = A.whno 
and X.cusno = A.cusno 
and X.prdline = A.prdline 
and X.prdno = A.prdno