import pandas as pd
import matplotlib.pyplot as plt

# Load Dataset
df = pd.read_csv("Netflix_Cleaned.csv", encoding="utf-8-sig")

# Filter Movies
movies = df[df['type'] == 'Movie'].copy()

# Extract duration in minutes
movies['duration_minutes'] = (
    movies['duration']
    .str.extract(r'(\d+)')
    .astype(float)
)

# Average Movie Duration
avg_duration = movies['duration_minutes'].mean()

print("Average Movie Duration:", round(avg_duration, 2), "minutes")

# Create Histogram
plt.figure(figsize=(10, 6))
movies['duration_minutes'].dropna().plot(
    kind='hist', bins=30, edgecolor='black'
)

plt.title('Netflix Movie Duration Distribution')
plt.xlabel('Duration (Minutes)')
plt.ylabel('Number of Movies')

plt.tight_layout()
plt.savefig('python/movie_duration_analysis.png')
plt.show()