# Bryan Wilcox-Archuleta
# Aug. 9, 2017
# Sample Selection - Round 1

# Header ---------
# This file selects and writes a list of voters with email. 

# library -------
library(tidyverse)
library(data.table)
library(sampling)
#options(scipen=99999)

# read data 
data <- fread("/Users/bryanwilcox/Dropbox/projects/professors/collingwood/la_county_weights_FINAL.csv", header = T, stringsAsFactors = F)

# only those with email
df_email <- data %>% filter(has_email == 1) %>% mutate(email = tolower(email))

# must drop any duplicate emails
drop <- which(duplicated(df_email$email))
print(length(drop)) # should be 8842 only 82 were double entires

df <- df_email[-drop,]

# get rid of invalid email 
isValidEmail <- function(x) {
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x), ignore.case=TRUE)
}

keep <- which(isValidEmail(df$email))

length(drop) + ( nrow(df) - length(keep) )

df <- df[keep,]





# "18-29" "30-44" "45-64" "65+"
df <- df %>% mutate(age_bucket = case_when(age >= 18 & age <= 29 ~ 1, 
                                           age >= 30 & age <= 44 ~ 2,
                                           age >= 45 & age <= 64 ~ 3,
                                           age >= 65 ~ 4))

table(df$age_bucket)

df <- df %>% mutate(race_bucket = case_when(pred_latino > .6 ~ 1, 
                                            pred_black > .6 ~ 2,
                                            pred_white > .6 ~ 3,
                                           TRUE ~ 4))

df <- df %>% mutate(strata = case_when(age_bucket == 1 & race_bucket == 1 ~ 1,
                                       age_bucket == 1 & race_bucket == 2 ~ 2,
                                       age_bucket == 1 & race_bucket == 3 ~ 3,
                                       age_bucket == 1 & race_bucket == 4 ~ 4,
                                       age_bucket == 2 & race_bucket == 1 ~ 5,
                                       age_bucket == 2 & race_bucket == 2 ~ 6,
                                       age_bucket == 2 & race_bucket == 3 ~ 7,
                                       age_bucket == 2 & race_bucket == 4 ~ 8,
                                       age_bucket == 3 & race_bucket == 1 ~ 9,
                                       age_bucket == 3 & race_bucket == 2 ~ 10,
                                       age_bucket == 3 & race_bucket == 3 ~ 11,
                                       age_bucket == 3 & race_bucket == 4 ~ 12,
                                       age_bucket == 4 & race_bucket == 1 ~ 13,
                                       age_bucket == 4 & race_bucket == 2 ~ 14,
                                       age_bucket == 4 & race_bucket == 3 ~ 15,
                                       age_bucket == 4 & race_bucket == 4 ~ 16))

table(df$strata)
df <- df %>% mutate(index = 1:nrow(df))


A <- df %>% filter(strata == 1) # young + latino
B <- df %>% filter(strata == 2) # young + black
C <- df %>% filter(strata == 3) # young + white
D <- df %>% filter(strata == 4) # young + other
E <- df %>% filter(strata == 5) # middle + latino
f <- df %>% filter(strata == 6) # middle + black
G <- df %>% filter(strata == 7) # middle + white
H <- df %>% filter(strata == 8) # middle + other
I <- df %>% filter(strata == 9) # older + latino
J <- df %>% filter(strata == 10) # older + black
K <- df %>% filter(strata == 11) # older + white
L <- df %>% filter(strata == 12) # older + other
M <- df %>% filter(strata == 13) # old + latino
N <- df %>% filter(strata == 14) # old + black
O <- df %>% filter(strata == 15) # old + white
P <- df %>% filter(strata == 16) # old + other



#temp <- rbind(A,B,C,D)
len <- sapply(list(A$index, B$index, C$index, D$index, 
                 E$index, f$index, G$index, H$index,
                 I$index, J$index, K$index, L$index,
                 M$index, N$index, O$index, P$index), length)

x <- sample(c(A$index, B$index, C$index, D$index, 
              E$index, f$index, G$index, H$index,
              I$index, J$index, K$index, L$index,
              M$index, N$index, O$index, P$index),
            size = 35000,
            prob = rep(c(3, # young + latino
                         3, # young + black
                         2, # young + white
                         3, # young + other
                         3, # middle + latino
                         3, # middle + black
                         2, # middle + white
                         3, # middle + other
                         2, # older + latino
                         2, # older + black
                         1, # older + white
                         2, # older + other
                         2, # old + latino
                         2, # old + black
                         1, # old + white
                         2) / len, len),# old + other
            replace = F)


df$pik <- rep(c(3, # young + latino
                3, # young + black
                2, # young + white
                3, # young + other
                3, # middle + latino
                3, # middle + black
                2, # middle + white
                3, # middle + other
                2, # older + latino
                2, # older + black
                1, # older + white
                2, # older + other
                2, # old + latino
                2, # old + black
                1, # old + white
                2) / len, len)# old + other

final <- df[df$index %in% x,]

head(final)


table(final$pik)
table(final$strata)


# save 

write_csv(final,"/Users/bryanwilcox/Dropbox/projects/email_study/samples/pilot_sample.csv")


sample <- read.csv("Dropbox/projects/email_study/samples/Test_Conjoint-Distribution_History.csv")

sample <- sample %>% dplyr::select(name = First.Name, email = Email, link = Link)

sample$name <- tolower(sample$name)

firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

sample$name <- firstup(sample$name)

write_csv(sample, "Dropbox/projects/email_study/samples/clean_pilot.csv")


#
library(tidyverse)
df <- read.csv("/Users/bryanwilcox/Dropbox/projects/email_study/samples/pilot_sample.csv")

df %>% ggplot(aes(x = pik)) + geom_density() + theme_bw() + ggsave("/Users/bryanwilcox/Dropbox/Courses/UCLA/2017_autumn/stats_206/final/pik.png", width = 5, height = 5)

range(df$pik)
df$pik <- rep(c(3, # young + latino
                3, # young + black
                2, # young + white
                3, # young + other
                3, # middle + latino
                3, # middle + black
                2, # middle + white
                3, # middle + other
                2, # older + latino
                2, # older + black
                1, # older + white
                2, # older + other
                2, # old + latino
                2, # old + black
                1, # old + white
                2) / len, len)# old + other

df %>% ggplot(aes(x = factor(strata))) + geom_histogram(bins = 16, color = "black", alpha = .25, stat = "count") + 
  theme_bw() + 
  labs(x = "strata") + 
  scale_x_discrete(labels = c("18-29 + Latino", "18-29 + Black", "18-29 + White", "18-29 + Other",
                              "30-44 + Latino", "30-44 + Black", "30-44 + White", "30-44 + Other",
                              "45-64 + Latino", "45-64 + Black", "45-64 + White", "45-64 + Other",
                              "65+ + Latino", "65+ + Black", "65+ + White", "65+ + Other")) + 
  theme(axis.text.x=element_text(angle=300, hjust=0))
  ggsave("/Users/bryanwilcox/Dropbox/Courses/UCLA/2017_autumn/stats_206/final/sample_strata.png", width = 5, height = 5)

df %>% ggplot(aes(x = factor(age_bucket))) + geom_histogram(bins = 16, color = "black", alpha = .25, stat = "count") + 
  theme_bw() + 
  labs(x = "Age Bucket") + 
  scale_x_discrete(labels = c("18-29", "30-44", "45-64", "65+"))
  ggsave("/Users/bryanwilcox/Dropbox/Courses/UCLA/2017_autumn/stats_206/final/sample_age.png", width = 5, height = 5)



df %>% ggplot(aes(x = factor(race_bucket))) + geom_histogram(bins = 16, color = "black", alpha = .25, stat = "count") + 
  theme_bw() + 
  labs(x = "Predicted Race") + 
  scale_x_discrete(labels = c("Latino", "Blacks", "White", "Other"))
  ggsave("/Users/bryanwilcox/Dropbox/Courses/UCLA/2017_autumn/stats_206/final/sample_race.png", width = 5, height = 5)



head(df)



