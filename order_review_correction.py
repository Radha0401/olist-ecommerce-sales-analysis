import pandas as pd

# Read CSV
file_path = "Data/raw/olist_order_reviews_dataset.csv"

df = pd.read_csv(file_path)

print("Rows Before:", len(df))

# Convert timestamp to datetime
df["review_answer_timestamp"] = pd.to_datetime(
    df["review_answer_timestamp"],
    errors="coerce"
)

# Keep latest review for duplicate review_id
df = (
    df.sort_values("review_answer_timestamp")
      .drop_duplicates(subset="review_id", keep="last")
)

print("Rows After:", len(df))

# Save cleaned CSV
output_path = "Data/clean/olist_order_reviews_clean.csv"
df.to_csv(output_path, index=False)

print("✅ Clean CSV saved successfully!")
print("Location:", output_path)
