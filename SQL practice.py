#%%
import pandas as pd 
from pandasql import sqldf


desserts=pd.read_csv('date_sold product amount_sold.tsv',sep=' ')

pysqldf=lambda q: sqldf(q,globals())
q="""
SELECT 
    t1.date_sold,
     CAST(ABS(COALESCE(t1.amount_sold,0)-COALESCE(t2.amount_sold,0)) AS int) AS difference,
     CASE 
     WHEN COALESCE(t1.amount_sold,0)-COALESCE(t2.amount_sold,0) > 0 THEN 'Cake'
     ELSE 'Pie'
     END AS sold_more
FROM 
    (SELECT * FROM desserts
    WHERE product='Cake') t1
INNER JOIN 
    (SELECT * FROM desserts
    WHERE product='Pie') t2 
ON t1.date_sold=t2.date_sold

"""
pysqldf(q)
# %%
