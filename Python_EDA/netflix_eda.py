import pandas as pd

# Load Dataset
df = pd.read_csv("Netflix_Cleaned.csv", encoding="utf-8-sig")

# Display first 5 rows
print(df.head())

# Dataset information
print("\nDataset Information:")
print(df.info())

# Dataset Shape
print("\nDataset Shape:", df.shape)


# Missing Values Analysis

print("\nMissing Values:")
print(df.isnull().sum())

# Total Missing Values
print("\nTotal Missing Values:", df.isnull().sum().sum())

# Duplicate Records
print("\nDuplicate Records:", df.duplicated().sum())


import matplotlib.pyplot as plt

# Movies vs TV Shows
content_counts = df['type'].value_counts()

plt.figure(figsize=(8, 5))
content_counts.plot(kind='bar')

plt.title('Movies vs TV Shows on Netflix')
plt.xlabel('Content Type')
plt.ylabel('Total Content')
plt.xticks(rotation=0)

plt.tight_layout()
plt.savefig('python/content_type_analysis.png')
plt.show()





# Top 10 Countries Analysis

country_counts = df[df['country'] != 'Unknown']['country'].str.split(', ').explode().value_counts().head(10)

plt.figure(figsize=(10, 6))
country_counts.sort_values().plot(kind='barh')

plt.title('Top 10 Countries by Netflix Content')
plt.xlabel('Total Content')
plt.ylabel('Country')

plt.tight_layout()
plt.savefig('python/top_10_countries.png')
plt.show()



# Year-wise Content Trend

year_counts = df['release_year'].value_counts().sort_index()

plt.figure(figsize=(12, 6))
year_counts.plot(kind='line', marker='o')

plt.title('Netflix Content Release Year Trend')
plt.xlabel('Release Year')
plt.ylabel('Total Content')
plt.grid(True)

plt.tight_layout()
plt.savefig('python/yearly_content_trend.png')
plt.show()