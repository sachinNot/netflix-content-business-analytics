import pandas as pd
import matplotlib.pyplot as plt

# Load Dataset
df = pd.read_csv("Netflix_Cleaned.csv", encoding="utf-8-sig")
# Split and count genres
genres = (
    df["listed_in"]
    .dropna()
    .str.split(", ")
    .explode()
    .value_counts()
    .head(10)
)

# Create Bar Chart
plt.figure(figsize=(12, 6))
genres.sort_values().plot(kind="barh")

plt.title("Top 10 Netflix Genres")
plt.xlabel("Total Content")
plt.ylabel("Genre")

plt.tight_layout()
plt.savefig("python/top_10_genres.png")
plt.show()

print("\nTop 10 Genres:")
print(genres)