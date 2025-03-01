WITH matched_materials AS (
  SELECT 
    bp.Buyer_ID,
    bp.Preferred_Grade,
    sd1.Grade AS Matched_Grade,
    bp.`Preferred Finish`,
    sd1.Finish AS Matched_Finish,
    bp.Preferred_Thickness_mm,
    sd1.Thickness_mm AS Matched_Thickness,
    bp.Preferred_Width_mm,
    sd1.Width_mm AS Matched_Width,
    bp.Max_Weight_kg,
    sd1.Gross_weight_kg AS Matched_Weight,
    bp.Min_Quantity,
    sd1.Quantity AS Matched_Quantity,
    sd2.Material AS Material_Type,
    sd1.Description AS Supplier_Description,
    sd2.Article_ID AS Supplier_Article_ID,
    sd2.Weight_kg AS Supplier_Weight,
    sd2.Quantity AS Supplier_Stock_Quantity,
    sd2.Reserved AS Reserved_Status,
    -- Debugging fields to check mismatches
    (bp.Preferred_Grade = sd1.Grade) AS Grade_Match,
    (bp.`Preferred Finish` = sd1.Finish) AS Finish_Match,
    ABS(bp.Preferred_Thickness_mm - sd1.Thickness_mm) AS Thickness_Diff,
    ABS(bp.Preferred_Width_mm - sd1.Width_mm) AS Width_Diff,
    -- Assign a ranking to each match per Buyer_ID
    ROW_NUMBER() OVER (PARTITION BY bp.Buyer_ID ORDER BY 
                       ABS(bp.Preferred_Thickness_mm - sd1.Thickness_mm) ASC, 
                       ABS(bp.Preferred_Width_mm - sd1.Width_mm) ASC) AS Rank
  FROM `wide-exchanger-452413-t5.buyer_supplier_analysis.buyer_preferences` bp
  JOIN `wide-exchanger-452413-t5.buyer_supplier_analysis.supplier_data_1` sd1
  ON bp.Preferred_Grade = sd1.Grade
  AND bp.`Preferred Finish` = sd1.Finish
  JOIN `wide-exchanger-452413-t5.buyer_supplier_analysis.supplier_data_2` sd2
  ON sd1.Grade = sd2.Material
)
SELECT * FROM matched_materials
WHERE Rank = 1;
