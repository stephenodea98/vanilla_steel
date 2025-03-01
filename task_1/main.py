import pandas as pd

# Load both Excel files
df1 = pd.read_excel('supplier_data_1.xlsx')  # Load as string to handle formatting
df2 = pd.read_excel('supplier_data_2.xlsx')

# Replace empty strings and NaN values with "N/A" and fix the warning
df1 = df1.replace(r'^\s*$', 'N/A', regex=True).fillna('N/A').infer_objects(copy=False)
df2 = df2.replace(r'^\s*$', 'N/A', regex=True).fillna('N/A').infer_objects(copy=False)

# Convert German-style thousand separators in "Länge" column if it exists
if "Länge" in df1.columns:
    df1["Länge"] = df1["Länge"].str.replace('.', '', regex=True)  # Remove thousand separator
    df1["Länge"] = pd.to_numeric(df1["Länge"], errors='coerce')  # Convert to numeric

# Display first few rows to verify
print("Supplier Data 1 (Cleaned):")
print(df1.head())

print("\nSupplier Data 2 (Cleaned):")
print(df2.head())

# Save cleaned datasets
df1.to_excel('cleaned_supplier_data_1.xlsx', index=False)
df2.to_excel('cleaned_supplier_data_2.xlsx', index=False)

print("Data cleaning completed successfully. Warning removed.")
