## Part 0: Introduction to R

## WE'LL BEGIN HERE:

## type getwd() in in RStudio's "Console" (bottom left)
getwd()
## the output should end in:
## [...]/r-workshop-odsc-master/programs
## if not, navigate to this directory in RStudio with:
## Session - Set Working Directory - Choose Directory...
setwd("C:\\Users\\kamal\\Desktop\\DSP\\Week 1\\Rlab\\programs\\r-workshop-odsc-master\\programs")

## ============================================================================
## INTRO
## ============================================================================

## "R is a free software environment for statistical computing and graphics"

## "The best way to learn a new language is to try out the commands"

## Q: what background do you have?
print("Information Systems")

## 3 topics covered today:
## 1. data manipulation, including package `dplyr`
## 2. graphics, including package `ggplot2`
## 3. basic statistical models: linear and logistic regression


## References:
## James et al, p 42+ 


## ============================================================================
## BASIC OPERATIONS
## ============================================================================

## vectors are fundamental
x <- c(1,3,2,5)

x
#[1] 1 3 2 5


y <- c(4,1,1,2)
y
#[1] 4 1 1 2

## how does R add?
x+y
#[1] 5 4 3 7
x-y
#[1] -3  2  1  3
x*y
#

## some functions
length(x)
#4

ls()
#returns the names of the local variables
#"x" "y"

x <- rnorm(50)
y <- x+rnorm(50,mean=50,sd=.1)

cor(x,y)
#0.9957296

mean(x)
#-0.1084798

sd(x)
#1.041499


## moving to two dimensions
mm <- matrix(1:16,nrow=4,ncol=4)
mm
# output matrix
#      [,1] [,2] [,3] [,4]
# [1,]    1    5    9   13
# [2,]    2    6   10   14
# [3,]    3    7   11   15
# [4,]    4    8   12   16


dim(mm)
#4 4

## subsetting/indexing etc
mm[2,]
#2  6 10 14

mm[,2]
#5 6 7 8

mm[-1,]
#       [,1] [,2] [,3] [,4]
# [1,]    2    6   10   14
# [2,]    3    7   11   15
# [3,]    4    8   12   16

mm[c(1,2),]
#       [,1] [,2] [,3] [,4]
# [1,]    1    5    9   13
# [2,]    2    6   10   14

mm[,c(1,3)]
#       [,1] [,2]
# [1,]    1    9
# [2,]    2   10
# [3,]    3   11
# [4,]    4   12


mm[,-c(1,3)]
#       [,1] [,2]
# [1,]    5   13
# [2,]    6   14
# [3,]    7   15
# [4,]    8   16

mm[,]
#       [,1] [,2] [,3] [,4]
# [1,]    1    5    9   13
# [2,]    2    6   10   14
# [3,]    3    7   11   15
# [4,]    4    8   12   16

## exercise: select 2x2 subsection from the "bottom left" of matrix mm

## [your code here]
#Solution 1
mm[c(3,4),c(1,2)]
#       [,1] [,2]
# [1,]    3    7
# [2,]    4    8

#Solution 2
mm[-c(1,2),-c(3,4)]
#       [,1] [,2]
# [1,]    3    7
# [2,]    4    8


## Part 1: Data Manipulation in R

## ============================================================================
## INTRO
## ============================================================================

## Introduction to data manipulation
## * using base R functions
## * using intuitive, fast methods from `dplyr`

## References
##
## James et al, p. 47
## vignette("introduction", "dplyr")`
##
## Data wrangling handout:
## http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

# Why dplyr?
#Package for data manipulation and exploration. Focused exclusively on DataFrames

## ============================================================================
## Read in data
## ============================================================================

## see ../data/README.txt
college <- read.csv("C:\\Users\\kamal\\Desktop\\DSP\\Week 1\\Rlab\\data\\College.csv")
## overview of dataset
head(college)
dim(college)
summary(college)

names(college)
str(college)


## select a manageable dataset for the following exercises
#Selecting rows from 270 to 299
df <- college[270:299,]

df
#Summary of the selected 29 rows
summary(df)

## ============================================================================
## BASE R
## ============================================================================

## subset data
private <- df[df$Private=="Yes",]
private
private <- subset(df,Private=="Yes")
private

## select columns

df2 <- df[,c("X","Private")]

df2

## order data
df3 <- df[order(df$Private),]
df3






## ============================================================================
## DPLYR: another tool for data manipulation
## ============================================================================

library(dplyr)

## overview of `dplyr` is here:
vignette("introduction", "dplyr")



## DPLYR: EASY AND FAST


## Single table verbs

## dplyr aims to provide a function for each basic verb of data manipulating:
## (1) filter() (and slice())
## (2) arrange()
## (3) select() (and rename())
## (4) distinct()
## (5) mutate() (and transmute())
## (6) summarise()
## sample_n() and sample_frac()
## (If you’ve used plyr before, many of these will be familar.)



glimpse(college)
glimpse(df)
summary(df)


## (1) "filter rows with filter()"
## first parameter is the data frame, then the conditions
filter(df, Private=="Yes")
filter(df, Private=="Yes" & Grad.Rate > 70)
filter(df, Private=="Yes" & Grad.Rate >= 70)



## (2) "select columns with select()"
## first parameter is the data frame, the remaining are column names
select(df, X, Private, S.F.Ratio, Grad.Rate, Top10perc)




## (3) "arrange rows with arrange()"
## first parameter is the data frame
arrange(df, Private)
arrange(df, desc(Private))

#select(df, X, arrange(df, X, desc(Grad.Rate)))

## EXERCISE
## obtain this data view from "df":



##                              X Grad.Rate          
## 1     James Madison University        98
## 2       Incarnate Word College        95
## 3     Johns Hopkins University        90
## 4      John Carroll University        89
## 5               Kenyon College        88
## 6               King's College        87
## 7          La Salle University        84
## 8 Illinois Wesleyan University        83
## 9              Juniata College        80


## [your code here]
dataview <- select(df, X, Grad.Rate) %>% arrange(desc(Grad.Rate))
dataview <- dataview[1:9,]  
dataview


## (4) "extract distinct (unique) rows"
select(df, S.F.Ratio)

distinct(select(df, S.F.Ratio))
head(df)
dim(distinct(select(df, Agency.Name)))



## (5) "add new columns with mutate()"
head(df)

mutate(df, cost=Personal+Books)

dfx <- select(df,Personal,Books)
dfx <- mutate(dfx, cost=Personal+Books)
dfx



## (6) "summarise values with summarise()" [minimizes output]
## summarise() "reduces" the size of the output
summarise(df, books=sum(Books))
summarise(df, mean.tuition=mean(Outstate))

## summarise() is really powerful when working in groups
dfx <- group_by(df, Private)
dfx <- summarise(dfx, mean.tuition=mean(Outstate))
dfx


dfx <- group_by(df, Private)
dfx <- summarise(dfx, mean.books=mean(Books))
dfx

dfx <- group_by(df, Private)
dfx <- summarise(dfx, count=n())
dfx

## EXERCISE
## find max and min tuition ("Outstate") grouped by private/public
## school, in dataset 'df' and 'college'

## DF:
##
##   Private   max  min
## 1      No  9766 3946
## 2     Yes 19240 6398

dfx <- group_by(df, Private)
dfx <- summarise(dfx, max.tuition=max(Outstate),  min.tuition=min(Outstate))
dfx

# Alternate code 
dfx <- group_by(df, Private)
dfx <- summarise(dfx, max=max(Outstate),  min=min(Outstate))
dfx


## college:
##
##   Private   max  min
## 1      No 15732 2580
## 2     Yes 21700 2340
## [your code here]
collegex <- group_by(college, Private)
collegex <- summarise(collegex, max=max(Outstate),  min=min(Outstate))
collegex


## Part 2: graphics in R, using ggplot2

## ============================================================================
## INTRO
## ============================================================================


## Hands-on introductions to creating graphics in R
## * using base R methods
## * using the very popular `ggplot2` package

## References:
## James et al, p 45, 49
## http://docs.ggplot2.org/current/




## ============================================================================
## BASE R
## ============================================================================

plot(college$S.F.Ratio, college$Grad.Rate)
title("College graduation rate vs. Student-faculty ratio")

hist(college$Grad.Rate)
hist(college$S.F.Ratio)


s1 <- college[,c(16:19)]
pairs(s1)



## ============================================================================
## ggplot2: another tool for R graphics
## ============================================================================

## "ggplot2 is designed to work in a layered fashion, starting with a
## layer showing the raw data then adding layers of annotation and
## statistical summaries."

## examples: ../docs/ggplot2-samples.pdf


library(ggplot2)
college <- read.csv("../data/College.csv")

## BASIC PLOTS

## ggplot2:
qplot(college$S.F.Ratio, college$Grad.Rate)
qplot(S.F.Ratio, Grad.Rate, data = college)

qplot(S.F.Ratio, Grad.Rate, data = college, colour=Private)

## add layers with "+"
qplot(S.F.Ratio, Grad.Rate, data = college, colour=Private) +
  ggtitle("College graduation rate vs. Student-faculty ratio")


## histograms are univariate: one variable required
qplot(Grad.Rate, data = college, geom="histogram")
qplot(Grad.Rate, data = college, geom="histogram", binwidth = 2)


## USING ggplot() function and CUSTOMIZING PLOTS
## aes = aesthetics
p <- ggplot(college, aes(x=S.F.Ratio, y=Grad.Rate))

p + geom_point()
p + geom_point(aes(colour = Private))
##p + geom_point(colour = Private) 
p + geom_point(colour = "green")


## nice palette
p + geom_point(aes(colour = Private)) + scale_color_brewer()

p + geom_point(aes(colour = Private)) +
  scale_color_brewer(type="qual", palette=2)

## variations on histogram
ggplot(college) +
  geom_histogram(aes(x=S.F.Ratio))

p <- ggplot(college, aes(x=S.F.Ratio))

p + geom_histogram()
p + stat_bin(geom="area")
p + stat_bin(geom="point")
p + stat_bin(geom="line")


## OVERLAYS
qplot(Private, Grad.Rate, data = college)
qplot(Private, Grad.Rate, data = college, geom="jitter")
qplot(Private, Grad.Rate, data = college, geom=c("jitter", "boxplot"))
qplot(Private, Grad.Rate, data = college, geom=c("boxplot", "jitter"))

p <- ggplot(college, aes(x=Private, y=Grad.Rate))

## documentation example: http://docs.ggplot2.org/current/geom_boxplot.html
p + geom_point()
p + geom_boxplot() + geom_jitter()
p + geom_boxplot() + geom_jitter() + coord_flip()
p + geom_boxplot(notch = TRUE, notchwidth = .5) +
  geom_jitter(colour="sienna1")

## modifying theme
theme_set(theme_bw())
## theme_set(theme_gray())
p + geom_boxplot(notch = TRUE, notchwidth = .5) +
  geom_jitter(colour="sienna1")


## 'FACETS'
library(dplyr)                          #for next line:
college$Top10quartile <- ntile(college$Top10perc, 4)

p <- ggplot(college, aes(x=S.F.Ratio, y=Grad.Rate)) + geom_point()
p

p + facet_grid(. ~ Top10quartile)

## an outlier affects the visuals. have a good reason for removing it,
## and document it
college2 <- college[college$S.F.Ratio<39,]

## tip: don't need to iterate too much
ggplot(college2, aes(x=S.F.Ratio, y=Grad.Rate)) + geom_boxplot() +
  geom_point() + facet_grid(. ~ Top10quartile) +
  ggtitle("Graduation Rate vs. Student-Faculty Ratio, by Top 10 Quartiles")

## vs.
p <- ggplot(college2, aes(x=S.F.Ratio, y=Grad.Rate))
p <- p + geom_boxplot()
p <- p + geom_point()
p <- p + facet_grid(. ~ Top10quartile)
p <- p + ggtitle("Graduation Rate vs. Student-Faculty Ratio, by Top 10 Quartiles")