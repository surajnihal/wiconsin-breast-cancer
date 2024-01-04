## Introduction 

# Determining dimensions of Breast Cancer using Common Factor Analysis (CFA) 
# First we will discover and visualize the data to gain insights then we will apply Common factor analysis (CFA) to determine which features effect Breast Cancer the most 

# The Dataset 
# The Breast Cancer (Wisconsin) Diagnosis dataset contains the diagnosis and a set of 30 features describing the characteristics of the cell nuclei present in the digitized image of a fine needle aspirate (FNA) of a breast mass. 

# Attribute Information:

# 1) ID number 
# 2) Diagnosis (M = malignant, B = benign) 

# Ten real-valued features are computed for each cell nucleus: 

# a) radius (mean of distances from center to points on the perimeter) 
# b) texture (standard deviation of gray-scale values)
# c) perimeter 
# d) area 
# e) smoothness (local variation in radius lengths) 
# f) compactness (perimeter^2 / area - 1.0) 
# g) concavity (severity of concave portions of the contour) 
# h) concave points (number of concave portions of the contour) 
# i) symmetry 
# j) fractal dimension ("coastline approximation" - 1)  

## Libraries and Dataset

library(dplyr)
library(corrplot)
library(psych)
library(yacca)
library(REdaS)
library(ggplot2)
library(ltm)

data <- read.csv("~/Downloads/data.csv")

## Data Cleaning and Inspection

# Checking Sample Size and Number of Variables
dim(data)
# 569-Sample Size and 34 variables

# Showing head of the dataset
head(data, 3)

# Showing summary of the dataset
summary(data)

# Showing structure of the dataset
str(data)

# Checking for missing values 
colSums(is.na(data))
# 569 total missing values were found in X variable 

# Treating Missing Values 

# Sub-setting out the X variable and saving in a new dataframe
data_clean <- data[,1:32]

# Checking if new data has any missing values 
colSums(is.na(data_clean))
# no missing values found 

# Removing the ID column 
wbcd <- data_clean[,2:32]

# converting the diagnosis variable into a factor 
wbcd$diagnosis <- factor(ifelse(wbcd$diagnosis=='B',"Bening","Malignant"))

# now converting diagnosis as a double - 1 if Malignant and 0 if Benign 
wbcd_n <- wbcd %>%
  mutate_at(vars(diagnosis), as.double) %>%
  mutate(diagnosis = diagnosis - 1)

# checking the structure of the new dataframe
str(wbcd_n)
# all numeric variables

# Now we know the data is clean and we can run some Visualization and Analysis 

## Data Visualization 

# Distribution of the diagnosis variable -

# visualizing the diagnosis variable
p1 <- ggplot(wbcd, aes(x = diagnosis, fill = diagnosis)) +
  geom_bar(stat = "count", position = "stack", show.legend = FALSE) +
  theme_minimal(base_size = 16) +
  geom_label(stat = "count", aes(label = after_stat(count)), position = position_stack(vjust = 0.5),
             size = 5, show.legend = FALSE)

p1 +
  ggtitle("Distribution of the Diagnosis variable")

# After looking at the distribution we notice that the diagnosis variable is biased.

## Correlation Analysis 

# In this correlation matrix, correlation coefficients which has a p-value less than 0.05 are marked with a cross (which means they are significant).

#checking the correlation matrix
cor(wbcd_n) %>%
  corrplot(method = "circle", type = "lower", tl.col = "black", tl.srt = 45, p.mat = cor.mtest(wbcd_n)$p, sig.level = 0.05)


# We notice that many of the independent variables are very strongly correlated, which suggests that there is multicollinearity.

## Descriptive Analysis 

#showing descriptive analysis for the numeric dataframe
describe(wbcd_n)

# We see that radius_se (3.07), perimeter_se (3.43), area_se(5.42), concavity_se (5.08) and fractal_dimension_se (3.90) are some of the highly skewed variables. \newline
# We see observe that texture_worse(0.50) and diagnosis(0.53) are approximately symmetric. \newline
# The highest mean values were found for area_mean (654.89), area_worst (880.58) and perimeter_worst (107.26). \newline
# The lowest mean values was for fractal_dimension_se (0.00).

## Statstical Analysis

# Before running Factor Analysis, we need to check for the factoribility of the dataset by running the below tests

#Testing KMO Sampling Adequacy 
KMO(wbcd_n)
#Overall MSA = 0.84

#Testing Bartlett's Test of Sphericity
bart_spher(wbcd_n)
#p-value < 2.22e-16

#Checking the Cronbach's Alpha
CronbachAlpha(wbcd_n)
#raw_alpha = 0.58


# The KMO Sampling Test gave us a MSA value of 0.84, which confirms that the sample used is sufficient. \newline
# We see the the Bartlett's Test of Sphericity has a p-value of less than 0.05 demonstrating that the correlation matrix is not an identity matrix, therefore providing justification to use Factor Analysis. \newline
# Usual we accept a sample only when the Cronbach's alpha is greater than 0.6 but I am making an exception with my dataset.

## Parallel Analysis 

# Parallel Analysis can helps us determine how many factors we need to use in factor analysis. 
# Parallel Analysis can be used as a guess and not a final answer, it gives us something to get started. 

#running parallel analysis
comp <- fa.parallel(wbcd_n) 
comp

# Parallel Analysis suggests that we should be using 6 factors but let's take a look at eigenvalues which are greater than 1

# Checking for eigenvalues which are greater than 1
sum(comp$fa.values>1)

# Now since we know that there are four factors which have eigenvalues that are greater than 1, we will start by using 4 factors

## Common Factor Analysis 


# Conducting factor analysis 
fit = factanal(wbcd_n[,-1], 4, rotation = "varimax", lower = 0.1)
print(fit$loadings, cutoff=0.5, sort=T)

# Displaying the summary
summary(fit)


# Interpretation -

# The variables with high factor loadings in Factor 1 are radius, parameter and area which are related to the size of the nucleus. The larger these variables are, the larger these values become. \newline
# The variables with high factor loadings in Factor 2 are those related to the distortion of the contour of the cell nucleus, such as fractal_dimension, smoothness, compactness and concavity. \newline
# The variable with highest factor loading in Factor 3 is smoothness_se which drives the Factor 3. \newline
# The variables with high factor loadings in Factor 4 are mainly related to texture and larger these values are, the larger these values become. \newline
# We also observe some cross-loadings between Factor 1 and Factor 2 and Factor 3 and Factor 4. \newline
# The four factors explain 75% of the variance. \newline

Names of the components -

# Factor 1 - size, as it speaks about how large a nuclei is 
# Factor 2 - distortion, as it describes the distorted cells outline 
# Factor 3 - variety, as it tells us the variety of cell nuclei 
# Factor 4 - texture, as it talks about the texture of the nuclei 

## Conclusion

# We arrive at a conclusion that there are four main characteristics which are needed to detect breast cancer and among these four characteristics, size is one of the most important characteristics to consider. 
# In actual medical practice, the degree of “nuclear atypia” of cells is used to classify the malignancy of breast cancer. The larger the cell nucleus, the more chromatin is increased and unevenly distributed, and the more distorted the nuclear outline, the more abnormal the cell is considered to be. [1] 
# The above mentioned study confirms are findings.


# References

# 1. Okudela K. (2014). An association between nuclear morphology and immunohistochemical expression of p53 and p16INK4A in lung cancer cells. Medical molecular morphology, 47(3), 130–136. https://doi.org/10.1007/s00795-013-0052-x

