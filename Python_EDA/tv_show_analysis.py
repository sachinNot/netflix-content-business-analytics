import pandas as pd
import matplotlib.pyplot as plt

# Load Dataset
df = pd.read_csv("Netflix_Cleaned.csv", encoding="utf-8-sig")

# Filter TV Shows
tv = df[df['type'] == 'TV Show'].copy()

# Extract number of seasons
tv['seasons'] = (
    tv['duration']
    .str.extract(r'(\d+)')
    .astype(float)
)

# Seasons Count
season_counts = tv['seasons'].value_counts().sort_index()

# Average Seasons
print("Average TV Show Seasons:", round(tv['seasons'].mean(), 2))

# Create Chart
plt.figure(figsize=(10, 6))
season_counts.plot(kind='bar')

plt.title('Netflix TV Shows by Number of Seasons')
plt.xlabel('Number of Seasons')
plt.ylabel('Total TV Shows')
plt.xticks(rotation=0)

plt.tight_layout()
plt.savefig('python/tv_show_seasons.png')
plt.show()