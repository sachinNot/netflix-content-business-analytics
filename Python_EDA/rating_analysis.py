import pandas as pd
import matplotlib.pyplot as plt

# Load Dataset
df = pd.read_csv("Netflix_Cleaned.csv", encoding="utf-8-sig")

# Ratings Count
ratings = df[df['rating'] != 'Unknown']['rating'].value_counts().head(10)

# Create Chart
plt.figure(figsize=(10, 6))
ratings.sort_values().plot(kind='barh')

plt.title('Top 10 Netflix Content Ratings')
plt.xlabel('Total Content')
plt.ylabel('Rating')

plt.tight_layout()
plt.savefig('python/top_10_ratings.png')
plt.show()

print("\nTop 10 Ratings:")
print(ratings)