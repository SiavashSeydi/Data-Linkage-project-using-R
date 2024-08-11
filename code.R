library(dplyr)
library(ggplot2)
library(digest)
library(here)

# Loading the datasets
patient_profile <- read.csv(here("Expanded_Patient_Profile.csv"), stringsAsFactors = FALSE)
healthcare_info <- read.csv(here("Expanded_General_Healthcare_Info.csv"), stringsAsFactors = FALSE)

# Selecting relevant columns
healthcare_selected <- select(healthcare_info, Social_Insurance_Number, Medical_Condition)
patient_selected <- select(patient_profile, Social_Insurance_Number, Age)

# Converting Age to numeric to handle missing values
patient_selected$Age <- as.numeric(patient_selected$Age)

# Remove duplicates and missing values
healthcare_clean <- distinct(healthcare_selected, Social_Insurance_Number, .keep_all = TRUE)
patient_clean <- distinct(patient_selected, Social_Insurance_Number, .keep_all = TRUE)
healthcare_cleaner <- na.omit(healthcare_clean)
patient_cleaner <- na.omit(patient_clean)

# Detecting and removing outliers
Q1 <- quantile(patient_cleaner$Age, 0.25)
Q3 <- quantile(patient_cleaner$Age, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR
patient_cleaner <- filter(patient_cleaner, Age >= lower_bound & Age <= upper_bound)

# Hashing the Social Insurance Numbers for confidentiality
patient_cleaner$Hashed_SIN <- sapply(patient_cleaner$Social_Insurance_Number, digest)
healthcare_cleaner$Hashed_SIN <- sapply(healthcare_cleaner$Social_Insurance_Number, digest)

# Merging the datasets using the hashed Social Insurance Number as primary key
merged_data <- merge(patient_cleaner %>% select(Hashed_SIN, Age),
                     healthcare_cleaner %>% select(Hashed_SIN, Medical_Condition),
                     by = "Hashed_SIN", all = FALSE)

# Exporting the merged data to a CSV file
write.csv(merged_data, here("merged_data.csv"), row.names = FALSE)

# Reading the merged data back in
merged_data <- read.csv(here("merged_data.csv"), stringsAsFactors = FALSE)

# Identifying cancer cases
merged_data$cancer <- ifelse(grepl("cancer", tolower(merged_data$Medical_Condition)), 1, 0)

# Calculating correlation between Age and Cancer
correlation <- cor(merged_data$Age, merged_data$cancer)
print(paste("Correlation between Age and Cancer:", correlation))

# Visualization of correlation
ggplot(merged_data, aes(x = Age, y = cancer)) +
  geom_jitter(width = 0.2, height = 0.1, alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue", se = FALSE) +
  labs(title = "Scatter Plot of Age vs. Likelihood of Having Cancer", x = "Age", y = "Cancer (0 = No, 1 = Yes)") +
  theme_minimal()
