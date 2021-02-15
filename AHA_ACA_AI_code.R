library(moonBook)
library(survminer)
library(ggpubr)
library(survival)
library(ggplot2)
library(sas7bdat)
library(dplyr)
library(ztable)
library(MatchIt)
library(optmatch)
library(csv)
library(tibble)
install.packages("DMwR")
library(gmodels)
library(DMwR)
library(kernlab)
library(stringr)
library(caret)
install.packages("rJava")
library(rJava)
install.packages("RWeka")
library(RWeka)
library(gmodels)
library(kernlab)
install.packages("kernlab")
install.packages("gmodels")
out = read.csv("C:/kim/Statin_preprocess.csv",header=T,stringsAsFactors=FALSE)
#out = read.csv("/home/rehappydoc/person_case_recom40_75_edited_version.csv",sep="",header=T,stringsAsFactors=FALSE)
out

paste(c('첫','두','세','네','다섯'), rep('번째', 5), collapse='-')

out_f=out[,c(3:4,6:10,21,26)] # 범주형
out_ns=out[,c(22,23)] #서수적 범주형
out_n=out[,c(1,5,11:20,24:25)] # 순수수치형
out_target=factor(out[,2]) # 목적 변수
quantile(out[,2])

x <- c(1, 2, NA, 10, 3)
