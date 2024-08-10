
# Healthcare Data Linkage Project

This repository contains the code and data used for a healthcare data linkage project, where the primary goal is to link datasets containing patient profiles and general healthcare information. The linkage is performed by assigning Social Insurance Numbers (SINs) to find out if there is a correlation between high age and having cancer.

## Project Structure

- **code.R**: The main R script that performs the data linkage, data cleaning, and analysis. This script processes the datasets and links the `Expanded_General_Healthcare_Info.csv` with `Expanded_Patient_Profile.csv` based on specified conditions.

- **Expanded_General_Healthcare_Info.csv**: This dataset contains general healthcare information, including diagnoses and treatments.

- **Expanded_Patient_Profile.csv**: This dataset includes patient profiles with demographic information such as age, gender, and other relevant attributes.

## Objectives

1. **Data Linkage**: Link the `Expanded_General_Healthcare_Info.csv` with `Expanded_Patient_Profile.csv` using primary and secondary keys. The Social Insurance Number in the linked table will also be hashed to ensure confidentiality. 
2. **Correlation Analysis**: Establish a correlation between patient age and the presence of cancer in the linked dataset.
3. **Data Cleaning**: Handle missing values, particularly in the `Age` column, and ensure data integrity.

## Requirements

- R version 4.0.0 or higher
- Required R packages: `dplyr`, `here`, `ggplot2`

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/healthcare-data-linkage.git
   cd healthcare-data-linkage
   ```

2. Run the `code.R` script:
   ```bash
   Rscript code.R
   ```

3. The results of the data linkage and analysis will be output to the console or saved as specified in the script.
