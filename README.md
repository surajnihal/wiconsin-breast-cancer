# wiconsin-breast-cancer

**Introduction** 

Determining dimensions of Breast Cancer using Common Factor Analysis. (CFA) <br />
We will discover and visualize the data to gain insights then we will apply Common factor analysis (CFA) to determine which features effect Breast Cancer the most. <br />

**The Dataset**

**Dataset Used:** https://www.kaggle.com/datasets/uciml/breast-cancer-wisconsin-data/data

The Breast Cancer (Wisconsin) Diagnosis dataset contains the diagnosis and a set of 30 features describing the characteristics of the cell nuclei present in the digitized image of a fine needle aspirate (FNA) of a breast mass.  <br />

Attribute Information: <br />

1) ID number <br />
2) Diagnosis (M = malignant, B = benign) <br />

Ten real-valued features are computed for each cell nucleus: <br />

a) radius (mean of distances from center to points on the perimeter) <br />
b) texture (standard deviation of gray-scale values) <br />
c) perimeter <br />
d) area <br />
e) smoothness (local variation in radius lengths) <br />
f) compactness (perimeter^2 / area - 1.0) <br />
g) concavity (severity of concave portions of the contour) <br />
h) concave points (number of concave portions of the contour) <br />
i) symmetry <br />
j) fractal dimension ("coastline approximation" - 1)  <br />

The mean, standard error and "worst" or largest (mean of the three largest values) of these features were computed for each image,resulting in 30 features. For instance, field 3 is Mean Radius, field 13 is Radius SE, field 23 is Worst Radius. <br />

All feature values are recoded with four significant digits. <br />

Missing attribute values: none <br />

Class distribution: 357 benign, 212 malignant <br />

**Libraries Used:**

dplyr <br />
ggplot2 <br />
corrplot <br />
psych <br />
yacaa <br />
REdas <br />
ltm <br />
