# Project Proposal for Group 5

## Project Description

- Our current purpose for proposing this type of analysis on automobile related traffic incidences and the finding the main reason for its prevalence in the United States. We will attempt to address the extent drivers are at risk of traffic related injuries based on multiple risk factors. Common problems such as **Alcohol Level**, **Average Temperature**, and **Time of Occurrence** will be analysed to understand the extent to which they are prevalent in affecting mortality rate. 

## Existing Research

_Driver-related risk factors of fatal road traffic crashes associated with alcohol or drug impairment_
(https://www.sciencedirect.com/science/article/pii/S0001457518308406?via=ihub)
- This study looks at the impact that impairment has on causing fatal car crashes, specifically looking at alcohol and drug impairment associated with “driver-related” risk factors. The researchers used a multivariate logistic regression, to investigate the relationship between impairment and more risky driving. They found that drivers impaired by alcohol or drugs were more often breaking driving laws such as speeding, lack of wearing a seatbelt, and driving without a driver license or with an expired one, compared to drivers that were not impaired. The logistic regression they used showed that alcohol impairment was strongly linked to a driver exhibiting all the of three risk factors listed.

_Mortality and potential years of life lost by road traffic injuries in Brazil, 2013_
(https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5068963/)
- This study investigated Brazil and analyzed data on road traffic injuries for the year 2013, estimating both crude and standard mortality rates for Brazil as a whole and regions within the country. Mortality rates were calculated for different demographics, and YLLs was estimated for both men and women. There ended up being more than one million YLLs in 2013 alone in Brazil, with the largest portion coming from ages 20-29 years. They did end up finding that mortality rates from traffic accidents decreased in 2013 from 2011, but that they increased when a motorcycle was involved.

_Human factors in the causation of road traffic crashes_
(https://link-springer-com.offcampus.lib.washington.edu/content/pdf/10.1023/A:1007649804201.pdf)
- This study attempts to highlight the human behavioral factors that are most responsible for causing traffic accidents and distinguishes 4 categories as potential risks for causing an accident: things that reduce capabilities on a long-term basis, a short-term basis, things that promote risk taking behaviors with long-term impacts, and promotion of risk-taking behaviors on a short-term basis. The study essentially concludes with the idea that there are many reasons that accidents occur but categorizing human behaviors that increase risk of accident clarifies the issue. 


## Data sources

CDC Data Catalogue filtered for Motor Vehicle data:

1. https://data.cdc.gov/Motor-Vehicle/Motor-Vehicle-Occupant-Death-Rate-by-Age-and-Gende/rqg5-mkef

2. https://data.cdc.gov/Motor-Vehicle/Impaired-Driving-Death-Rate-by-Age-and-Gender-2012/ebbj-sh54

Kaggle:

1. https://www.kaggle.com/sobhanmoosavi/us-accidents

GBD Compare Tool

1. https://vizhub.healthdata.org/gbd-compare/

## Intended Audience

When looking at our project proposal and determining the target audience, we see that several audiences could be particularly interested in our project. For example, insurance companies or policy makers would be especially interested  in the information that we are to collect to determine how certain circumstances affect risk factors and how these policy makers could potentially better allocate resources for the benefit of the community. Our region will be limited to within the US and thus our findings will have more weight to those living here. This will mean that explanations or insights will take inspiration from US culture, behavior, and policy.


## Main Takeaways

When our audience looks at our project and our resources, we hope that they are able to learn the correlation between traffic accidents and risk factors present. More specifically, we hope to present things such as age or the impairment of the driver to see how they would possibly affect the severity of the traffic accidents or the frequency of the traffic accidents. We also want to understand the extent to which certain factors affect mortality and whether or not they interesect in relation to mortality. 

## Technical Description

- The goal of the final deliverable is to have a working and visually pleasing shiny interactable that dynamcially change depending on user input. We also plan to include a Rmd and HTML file that details the calculations that needed to be made in preparing the datasets from the various sources.

- We expect to have formatting issues when merging and cleaning datasets. It is likely that columns will have to be omitted due to a lack of clear labeling and not containing infomration relevant. One problem we may encounter is finding datasets that are reliable and have relevant information related to health statistics.

### What new technical skills will need to learn in order to complete your project?

We expect to discover and implement new libraries in our code as we analyze the data and implement new visualizations. This will involve learning new functions in ggplot2, and new data processing functions within the `tidyverse` package set. We will be working with a large dataset and adequate cleaning and datawrangling skills will be needed to create a shareable _csv_ file for group work. 

### What major challenges do you anticipate? 

We anticipate to struggle finding novel insights in our source datasets. Purportedly, most of the data collected has already been thoroughly analyzed, so we expect to spend a decent amount of time trying to find unique research question to answer. Furthermore, in files that multiple group members are working on we expect to run in to merge conflicts, so we will rely on consistent communication to manage this problem. Finally, we also expect to struggle with cleaning and joining the datasets, which is a common problem for data collected from different sources.
