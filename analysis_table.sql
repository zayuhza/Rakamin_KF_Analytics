CREATE TABLE kimia_farma.analysis_table AS
SELECT 
    tr.transaction_id,
    tr.date,
    tr.branch_id,
    br.branch_name,
    br.kota,
    br.provinsi,
    br.rating AS branch_rating, -- Aliasing kolom rating dari tabel br
    tr.rating AS transaction_rating, -- Aliasing kolom rating dari tabel tr
    tr.customer_name,
    tr.product_id,
    pr.product_name,
    tr.price,
    tr.discount_percentage,
    CASE 
        WHEN tr.price <= 50000 THEN 10
        WHEN tr.price > 50000 AND tr.price <= 100000 THEN 15
        WHEN tr.price > 100000 AND tr.price <= 300000 THEN 20
        WHEN tr.price > 300000 AND tr.price <= 500000 THEN 25
        ELSE 30
    END AS persentase_gross_laba,
    (tr.price * (1 - tr.discount_percentage / 100)) AS nett_sales,
    ((tr.price * (1 - tr.discount_percentage / 100)) * CASE 
        WHEN tr.price <= 50000 THEN 0.10
        WHEN tr.price > 50000 AND tr.price <= 100000 THEN 0.15
        WHEN tr.price > 100000 AND tr.price <= 300000 THEN 0.20
        WHEN tr.price > 300000 AND tr.price <= 500000 THEN 0.25
        ELSE 0.30
    END) AS nett_profit,
    tr.rating
FROM 
    `kimia_farma.kf_final_transaction` tr
JOIN 
    `kimia_farma.kf_inventory` inv ON tr.product_id = inv.product_id
JOIN 
    `kimia_farma.kf_kantor_cabang` br ON tr.branch_id = br.branch_id
JOIN 
    `kimia_farma.kf_product` pr ON tr.product_id = pr.product_id
LIMIT 50;
