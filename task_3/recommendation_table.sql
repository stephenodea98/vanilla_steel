CREATE OR REPLACE TABLE `wide-exchanger-452413-t5.buyer_supplier_analysis.best_supplier_matches` AS
SELECT * FROM matched_materials WHERE Rank = 1;
