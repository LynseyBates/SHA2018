# wareTypeCAandMCD.R
# Establish a DBI connection to DAACS PostgreSQL database and submit SQL queries
# Created by:  FDN 8.5.2014
# Previous update: EAB 3.24.2015 To add MCDs and TPQs by Phase  
# Last update: LAB 9.5.2017 to add List of Contexts with Phase Assignments for database updates

# set the working directory to P
setwd("P:/")
#setwd("E:/Hermitage/SHA2018")

#load the library
require(RPostgreSQL)

# tell DBI which driver to use
pgSQL <- dbDriver("PostgreSQL")
# establish the connection
connection <- read.csv('RCodeExamples/connection.csv', header=TRUE, stringsAsFactors = F)
DRCcon<-dbConnect(pgSQL, host=connection$host, port=connection$port,
                  dbname=connection$dbname,
                  user=connection$user, password=connection$password)

#Reset working directory to folder with your data
setwd("P:/SHA/2018/Hermitage2018/Lynsey/Ware/")

###Section 0: Get the data ########################################
# get the table with the ware type date ranges
MCDTypeTable<- dbGetQuery(DRCcon,'
                          SELECT * 
                          FROM "tblCeramicWare"
                          ')


# submit a SQL query: note the use of \ as an escape sequence
# note the LEFT JOIN on the Feature table retains non-feature contexts
#Fill in your appropriate projectID

wareTypeDataX<-dbGetQuery(DRCcon,'
                    SELECT
                    "public"."tblCeramic"."Quantity",
                    "public"."tblCeramicWare"."Ware",
                    "public"."tblCeramicWare"."BeginDate",
                    "public"."tblCeramicWare"."EndDate",
                    "public"."tblContextFeatureType"."FeatureType",
                    "public"."tblCeramicGenre"."CeramicGenre",
                    "public"."tblContext"."ContextID",
                    "public"."tblContext"."ProjectID",
                    "public"."tblContext"."Context",
                    "public"."tblContextDepositType"."DepositType",
                    "public"."tblContext"."DAACSStratigraphicGroup",
                    "public"."tblContext"."FeatureNumber"
                    FROM
                    "public"."tblContext"
                    INNER JOIN "public"."tblContextSample" ON "public"."tblContextSample"."ContextAutoID" = "public"."tblContext"."ContextAutoID"
                    INNER JOIN "public"."tblGenerateContextArtifactID" ON "public"."tblContextSample"."ContextSampleID" = "public"."tblGenerateContextArtifactID"."ContextSampleID"
                    LEFT JOIN "public"."tblContextDepositType" ON "public"."tblContext"."DepositTypeID" = "public"."tblContextDepositType"."DepositTypeID"
                    INNER JOIN "public"."tblCeramic" ON "public"."tblCeramic"."GenerateContextArtifactID" = "public"."tblGenerateContextArtifactID"."GenerateContextArtifactID"
                    INNER JOIN "public"."tblCeramicWare" ON "public"."tblCeramic"."WareID" = "public"."tblCeramicWare"."WareID"
                    LEFT JOIN "public"."tblContextFeatureType" ON "public"."tblContext"."FeatureTypeID" = "public"."tblContextFeatureType"."FeatureTypeID" 
                    LEFT JOIN "public"."tblCeramicGenre" ON "public"."tblCeramic"."CeramicGenreID" = "public"."tblCeramicGenre"."CeramicGenreID"
                    WHERE
                    "public"."tblContext"."ProjectID" = \'1410\'OR 
"public"."tblContext"."ProjectID" = \'1412\' 
                    ')

###Section 1:Context Selection #######################################
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-155'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-159'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-154'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-156'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-161'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-132'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-133'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-137'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-143'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-144'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-145'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-146'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-147'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-164'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-129'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-131'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-135'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-139'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-121'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-124'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-166'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-169'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-170'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-175'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-176'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-180'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '99-02-017'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '99-02-010'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '99-02-015'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '99-02-022'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '99-02-023'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '99-02-014'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-117'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-118'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-119'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-123'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-128'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-109'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-111'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-112'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-115'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-122'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-126'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-081'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-083'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-084'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-089'] <- '1412'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1410' & wareTypeDataX$Context == '97-03-096'] <- '1412'

wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-039'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-043'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-044'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-046'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-047'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-053'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-054'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-055'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-056'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-061'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-062'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-063'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-064'] <- '1410'
wareTypeDataX$ProjectID[wareTypeDataX$ProjectID == '1412' & wareTypeDataX$Context == '98-01-065'] <- '1410'

#Remove contexts with deposit type cleanup and surface collection
wareTypeData <- subset(wareTypeDataX, ! wareTypeDataX$DepositType  %in%  c('Clean-Up/Out-of-Stratigraphic Context',
                                                                           'Surface Collection'))

###Section 2: Ware Type Selection ########################################
# compute new numeric variables from original ones, which we will need to compute the MCDs
MCDTypeTable<-within(MCDTypeTable, {     # Notice that multiple vars can be changed
  midPoint <- (EndDate+BeginDate)/2
  span <- EndDate - BeginDate
  inverseVar <- 1/(span/6)##2 
  
})

# let's see what we have for ware types and counts
require(plyr)
summary2<-ddply(wareTypeData, .(Ware), summarise, Count=sum(Quantity))
summary2

# Now we do some ware type recoding if necessary
# For example if "American Stoneware" is William Rogers, we might recode it as "Fulham Type"
# wareTypeData$Ware[wareTypeData$Ware =='American Stoneware'] <- 'Fulham Type'


# get rid of types with no dates
typesWithNoDates <- MCDTypeTable$Ware[(is.na(MCDTypeTable$midPoint))]
wareTypeData1<- wareTypeData[!wareTypeData$Ware %in%  typesWithNoDates,]

# what is left?
summary3<-ddply(wareTypeData1, .(Ware), summarise, Count=sum(Quantity))
summary3

###Section 3: Create Counting Unit ########################################
#Create a new variable called 'unit', this will make it easier to 
#change the counting unit (context, SG, feature)in future analyses   
wareTypeData1$unitX<- NULL

#Make the units context if you do not have identifiable SGs or features
#wareTypeData1$unit<-wareTypeData1$Context

#Replace blanks in SG and Feature Number to NA
wareTypeData1$DAACSStratigraphicGroup[wareTypeData1$DAACSStratigraphicGroup==""] <- NA
wareTypeData1$FeatureNumber[wareTypeData1$FeatureNumber==""] <- NA


#If you want to run the CA by SGs, features and remaining contexts, use this unit creation code
#if no feature, then use the strat group, if no strat group then use context
#
wareTypeData1$unitX<-ifelse(is.na(wareTypeData1$FeatureNumber),
                           ifelse(is.na(wareTypeData1$DAACSStratigraphicGroup),
                                  wareTypeData1$Context,
                                  wareTypeData1$DAACSStratigraphicGroup),
                           wareTypeData1$FeatureNumber)

wareTypeData1$name <- wareTypeData1$ProjectID

wareTypeData1$name[wareTypeData1$name=="1412"] <- 'WC'
wareTypeData1$name[wareTypeData1$name=="1410"] <- 'EC'

#Add projectID to unit
wareTypeData1$unit <- paste(wareTypeData1$name, wareTypeData1$unitX, sep='_')
#wareTypeData1$unit <- paste(wareTypeData1$ProjectID, wareTypeData1$unitX, sep='_')

#Combine certain SGs (1,2, and 3) across the two projects
#wareTypeData1$unit[wareTypeData1$unit=="1410_SG01"] <- 'SG01'
#wareTypeData1$unit[wareTypeData1$unit=="1412_SG01"] <- 'SG01'
#wareTypeData1$unit[wareTypeData1$unit=="1410_SG02"] <- 'SG02'
#wareTypeData1$unit[wareTypeData1$unit=="1412_SG02"] <- 'SG02'
#wareTypeData1$unit[wareTypeData1$unit=="1410_SG03"] <- 'SG03'
#wareTypeData1$unit[wareTypeData1$unit=="1412_SG03"] <- 'SG03'

###Section 4: Remove Ware Outliers ########################################
#Remove outlier ware types
wareTypeData2<- subset(wareTypeData1, ! wareTypeData1$Ware  %in%  c('Jasperware Type'))

# what is left?
#summary4<-ddply(wareTypeData1, .(Ware), summarise, Count=sum(Quantity))
#summary4

# lets get a data frame with contexts as rows and type as cols, with the
# entries as counts
WareByUnit <- ddply(wareTypeData2, .(unit, Ware), summarise, Count=sum(Quantity))
#WareByUnit <- ddply(wareTypeData1, .(unit, Ware), summarise, Count=sum(Quantity))

###Section 5: Remove Context Outliers ########################################

# now we transpose the data so that we end up with a context (rows) x type 
# (cols) data matrix; unit ~ ware formula syntax, left side = row, right side = column, to fill in
# body of table with the counts, fill rest with zeros
require(reshape2)
WareByUnitT <- dcast(WareByUnit, unit ~ Ware, value.var='Count', fill=0 )

# lets compute the totals for each context i.e. row
# Note the use of column numbers as index values to get the type counts, which are
# assumed to start iin col 2.
WareByUnitTTotals<- rowSums(WareByUnitT[,2:ncol(WareByUnitT)])

# OK now let's get rid of all the rows where totals are <= 5
WareByUnitT1 <-WareByUnitT[WareByUnitTTotals>5,]


#Remove any outliers
#WareByUnitTout <-subset(WareByUnitT1, !WareByUnitT1$unit %in% c('1410_662A', '1410_SG05'))
WareByUnitTout <-subset(WareByUnitT1, !WareByUnitT1$unit %in% c('EC_662A'))

#Ok now let's get rid of all the columns (ware types) where totals < 0
#WareByUnitT2<-WareByUnitT1[, colSums(WareByUnitT1 != 0) > 0]
WareByUnitT2<-WareByUnitTout[, colSums(WareByUnitTout != 0) > 0]

###Section 6: Run MCD and Sort Data functions  ########################################
# now we build a function that computes MCDs
# two arguments: 1. unitData: a dataframe with the counts of ware types in units. We assume
# the left variable IDs the units, while the rest of the varaibles are types
# 2. typeData: a dataframe with at least two variables named 'midPoint' and 'inversevar'
# containing the manufacturing midpoints and inverse variances for the types.
# retruns a list comprise of two dataframes: 
#     MCDs has units and the vanilla and BLUE MCDs
#     midPoints has the types and manufacturing midpoints, in the order they appeaed in the input
#     unitData dataframe.  

EstimateMCD<- function(unitData,typeData){
  #for debugging
  #unitData<- WareByUnitT1
  #typeData <-mcdTypes
  countMatrix<- as.matrix(unitData[,2:ncol(unitData)])
  unitNames <- (unitData[,1])
  nUnits <- nrow(unitData)   
  nTypes<- nrow(typeData)
  nTypesFnd <-ncol(countMatrix)
  typeNames<- colnames(countMatrix)
  # create two col vectors to hold inverse variances and midpoints
  # _in the order in which the type variables occur in the data_.
  invVar<-matrix(data=0,nrow=nTypesFnd, ncol=1)
  mPoint <- matrix(data=0,nrow=nTypesFnd, ncol=1)
  for (i in (1:nTypes)){
    for (j in (1:nTypesFnd)){
      if (typeData$Ware[i]==typeNames[j]) {
        invVar[j,]<-typeData$inverseVar[i] 
        mPoint[j,] <-typeData$midPoint[i]
      }
    }
  }
  
  # replace NAs for types with no dates with 0s -- so they do not count
  # compute the blue MCDs
  # get a unit by type matrix of inverse variances
  invVarMat<-matrix(t(invVar),nUnits,nTypesFnd, byrow=T)
  # a matrix of weights
  blueWtMat<- countMatrix * invVarMat
  # sums of the weight
  sumBlueWts <- rowSums(blueWtMat)
  # the BLUE MCDs
  blueMCD<-(blueWtMat %*% mPoint) / sumBlueWts
  # compute the vanilla MCDs
  sumWts <- rowSums(countMatrix)
  # the vanilla MCDs
  MCD<-(countMatrix %*% mPoint) / sumWts
  # now for the TPQs
  meltedUnitData<- melt(unitData, id.vars='unit',  variable.name = 'Ware', value.name='count')
  meltedUnitData <- subset(meltedUnitData, count > 0) 
  mergedUnitData <- merge(x = meltedUnitData, y = typeData,  by.x='Ware', by.y='Ware')
  # the trick is that to figure out the tpq it's best to have each record (row) represent an individual sherd
  # but in its current state, each record has a count that is likely more than 1 so it's necessary to break them up
  # use rep and rownames - rowname is a unique number for each row, kind of link an index
  # rep goes through dataframe mergedUnitData and replicates based on the count column, i.e. if count is
  # 5 it will create 5 records or rows and only replicates columns 2 and 6 (2 is unit name and 6 is begin date)
  repUnitData <- mergedUnitData[rep(rownames(mergedUnitData),mergedUnitData$count),c(2,6)]
  #once all the rows have a count of one, then can run the quantile function
  TPQ <- tapply(repUnitData$BeginDate,repUnitData$unit, 
                function(x) quantile(x, probs =1.0, type=3 ))              
  TPQp95 <- tapply(repUnitData$BeginDate,repUnitData$unit, 
                   function(x) quantile(x, probs = .95 , type=3 ))                 
  TPQp90 <- tapply(repUnitData$BeginDate,repUnitData$unit, 
                   function(x) quantile(x, probs = .90, , type=3 ))   
  # Finally we assemble the results in to a list
  MCDs<-data.frame(unitNames,MCD,blueMCD, TPQ, TPQp95, TPQp90, sumWts )
  colnames(MCDs)<- c('unit','MCD','blueMCD', 'TPQ', 'TPQp95', 'TPQp90', 'Count')
  midPoints <- data.frame(typeNames,mPoint)
  MCDs <- list('MCDs'=MCDs,'midPoints'=midPoints)
  return(MCDs)
} 
#end of function EstimateMCD

# apply the function
MCDByUnit<-EstimateMCD(WareByUnitT2,MCDTypeTable)
#MCDByUnit

# a function to sort the rows and cols of a matrix based on the
# orders from two arguments (e.g. MCDs and midpoints)
# arguments:  the name of the variable that contains the unit scores (e.g. MCDs)
#             the name of the variable that contains the type score (e.g. the midpoints)
#             the name of the dataframe that contains the counts of ware types in units
# returns:    the sorted dataframe 

sortData<- function(unitScores,typeScores,unitData){
  #unitScores<-U3MCDByUnit$MCDs$blueMCD
  #typeScores<-U3MCDByUnit$midPoints$mPoint
  #unitData<- U3WareByUnitT1
  sortedData<-unitData[order(unitScores),]
  sortedData<-sortedData[,c(1,order(typeScores)+1)]
  return(sortedData)
}

# apply the function
WareByUnitT2Sorted<-sortData(MCDByUnit$MCDs$blueMCD,
                             MCDByUnit$midPoints$mPoint,
                             WareByUnitT2)
#WareByUnitT2Sorted

# now we prep the sorted dataframe to make a Bertin plot
# convert to a matrix, whose cols are the counts
# make the unit name a 'rowname" of the matrix
Mat<-as.matrix(WareByUnitT2Sorted[,2:ncol(WareByUnitT2Sorted)])
rownames(Mat)<-WareByUnitT2Sorted$unit
rSums<- matrix (rowSums(Mat),nrow(Mat),ncol(Mat), byrow=F)
MatProp<-Mat/rSums

# do the plot
#(package for seriation)
library(plotrix) 
battleship.plot(MatProp,
                mar=c(2,5,5,1),
                #main = 'Seriation',
                #xlab='ManuTech',
                ylab= 'Context',
                col='grey')

###Section 7: Run the CA ########################################
# now let's try some Correspondence Analysis
Matx<-as.matrix(WareByUnitT2[,2:ncol(WareByUnitT2)]) 
rownames(Matx)<-WareByUnitT2$unit

require(ca)
ca3<-ca(Matx)

#summary(ca3)

#Scree plot
plot(1:(length(ca3$sv)), ca3$sv^2 / sum(ca3$sv^2), cex=1.25)
#ca3$sv

#default plot
plot(ca3, cex.lab=1.25, cex.axis=1.25)

#create dataframe of unit/context dimension 1 and 2 scores for ggplot
rowscores <- data.frame(ca3$rowcoord[,1], ca3$rowcoord[,2])
colnames(rowscores) <- c("Dim1", "Dim2")

#create dataframe of ware type dimension 1 and 2 scores for ggplot
colscores <- data.frame(ca3$colcoord[,1], ca3$colcoord[,2])
colnames(colscores) <- c("Dim1", "Dim2")

#Create plot: Dim 1 and Dim 2 context scores
require(ggplot2)
library(ggrepel)
p1 <- ggplot(rowscores, aes(x=rowscores$Dim1,y=rowscores$Dim2))+
  geom_point(shape=21, size=5, colour="black", fill="cornflower blue")+
 geom_text(aes(label=rownames(rowscores)),vjust=-.6, hjust=-.1, cex=5)+
  xlim(-7,3)+
 #geom_text_repel(aes(label=rownames(rowscores)), cex=6) +
  theme_classic()+
  labs(title="East and West Cabin", x="Dimension 1", y="Dimension 2")+
  theme(plot.title=element_text(size=rel(2), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))
p1
#save the plot for website chronology page/presentations
#ggsave("WCAwares_EastWest_Dims12.png", p1, width=10, height=7.5, dpi=300)


# plot the row scores on dim1 and dim2
#plot(ca3$rowcoord[,1], ca3$rowcoord[,2], pch=21, bg="black", cex=1.25,
 #    xlab="Dimension 1", ylab="Dimension 2", cex.lab=1.25, cex.axis=1.25)
#text(ca3$rowcoord[,1],ca3$rowcoord[,2],rownames(ca3$rowcoord),
 #    pos=4, cex=1.0, col="black", cex.lab=1.5)

p2 <- ggplot(colscores, aes(x=colscores$Dim1,y=colscores$Dim2))+
  geom_point(shape=21, size=5, colour="black", fill="cornflower blue")+
  #geom_text(aes(label=CA_MCD_Phase1$unit),vjust=-.6, cex=5)+
  geom_text_repel(aes(label=rownames(colscores)), cex=6) +
  theme_classic()+
  labs(title="East and West Cabin", x="Dimension 1", y="Dimension 2")+
  theme(plot.title=element_text(size=rel(2.25), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))
p2
#ggsave("CAwares_EastWest_DimWares.png", p2, width=10, height=7.5, dpi=300)

# plot the col scores on dim1 and dim2, which types are important in which regions of the plot
#plot(ca3$colcoord[,1],ca3$colcoord[,2],pch=21, bg="black",cex=1.25,
 #    xlab="Dimension 1", ylab="Dimension 2", asp=1, cex.lab=1.25, cex.axis=1.25)
#text(ca3$colcoord[,1],ca3$colcoord[,2],rownames(ca3$colcoord),
 #    pos=4 ,cex=1.25, col="black")

# CA Dim 1 vs. MCDs
p3 <- ggplot(rowscores, aes(x=rowscores$Dim1,y=MCDByUnit$MCDs$blueMCD))+
  geom_point(shape=21, size=5, colour="black", fill="cornflower blue")+
 geom_text(aes(label=rownames(rowscores)),vjust=-.6, hjust=-.1, cex=5)+
 #geom_text_repel(aes(label=rownames(rowscores)), cex=6) +
  theme_classic()+
  labs(title="East and West Cabin", x="Dimension 1", y="BLUE MCD")+
  theme(plot.title=element_text(size=rel(2.25), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))
p3
cor.test(ca3$rowcoord[,1],MCDByUnit$MCDs$blueMCD, method="kendall")
#ggsave("CAwares_EastWest_Dim1MCD.png", p3, width=10, height=7.5, dpi=300)

#OLD DIM 1 BLUE MCD PLOT
#plot(ca3$rowcoord[,1], MCDByUnit$MCDs$blueMCD, pch=21, bg="black",cex=1.25,
#xlab="Dimension 1", ylab="BLUE MCD",cex.lab=1.5, cex.axis=1.5)
#text(ca3$rowcoord[,1],MCDByUnit$MCDs$blueMCD,rownames(ca3$rowcoord),
#pos=4, cex=1.25, col="black")
#abline(v=-5, lty=1, col="grey")
#abline(v=-3, lty=1, col="grey")


#create table of contexts, counts, and mcds, need to read in unit as character
unit <- as.character(MCDByUnit$MCDs$unit)
dim1Scores <- ca3$rowcoord[,1]
dim2Scores <- ca3$rowcoord[,2]
MCD<- MCDByUnit$MCDs$MCD
blueMCD <-MCDByUnit$MCDs$blueMCD
count<- MCDByUnit$MCDs$Count

#create data frame, read strings as characters
CA_MCD<-data.frame(unit, dim1Scores,dim2Scores,MCD,blueMCD, count, stringsAsFactors = F) 

#Create new field to hold cabin name, fill with unit
CA_MCD$Cabin <- CA_MCD$unit

#Assign cabin name based on 'unit' character string
CA_MCD$Cabin[grepl("^.*EC_", CA_MCD$Cabin)] <- 'EC'
CA_MCD$Cabin[grepl("^.*WC_", CA_MCD$Cabin)] <- 'WC'


#Dim 1 bluemcd with colors by cabin
color <- ggplot(rowscores, aes(x=CA_MCD$dim1Scores,y=CA_MCD$blueMCD))+
  geom_point(aes(colour=CA_MCD$Cabin),size=5)+
  #geom_text(aes(label=CA_MCD_Phase1$unit),vjust=-.6, cex=5)+
  geom_text_repel(aes(label=rownames(rowscores)), cex=5, segment.alpha=0.2) +
  theme_classic()+
  labs(title="East and West", x="Dimension 1", y="BLUE MCD")+
  theme(plot.title=element_text(size=rel(2), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.75)),
        legend.title=element_text(size=rel(1.5)), legend.position="bottom")+
  scale_colour_manual(name="Cabin",
                      labels=c("East", "West"),
                      values=c("darkgoldenrod1", "aquamarine4"))
color
ggsave("CAwares_EastWest_D1BMCD_labels.png", color, width=10, height=7.5, dpi=300)

#Create weighted histogram for phasing
#library(plotrix)
#Compares counts of sherds in all units with BLUE MCDs that fall within bin, you may need to change sequence dates
#weighted.hist(MCDByUnit$MCDs$blueMCD, MCDByUnit$MCDs$Count, breaks=seq(1790,1930,10), col='lightblue')

#Dim 1 Scores Weighted Histogram, you may need to change scale
p5 <- ggplot(CA_MCD, aes(x=CA_MCD$dim1Scores, weight=CA_MCD$count/sum(CA_MCD$count)))+
  geom_histogram(aes(y=..density..), colour="gray", fill="tan", binwidth=0.1, boundary=0.5)+
  #xlim(-3.5,7)+
  #stat_function(fun = dnorm, colour = "blue")+
  #scale_x_continuous(breaks=seq(-6, 2, 1), limits=c(-3.5,7))+
  theme_classic()+
  labs(title="East and West Cabin", x="Dimension 1", y="Density")+
  theme(plot.title=element_text(size=rel(2.25), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))#+
#geom_density(fill=NA)
p5a <- p5 + geom_vline(xintercept=c(-5.8, -4, -2.5, 0.5))
p5a
#ggsave("CAwares_EastWest_Hist.png", p5, width=10, height=7.5, dpi=300)
#ggsave("CAwares_EastWest_Hist_lines.png", p5a, width=10, height=7.5, dpi=300)

#Lines step adds density curve to weighted histogram
#hist(rep(ca3$rowcoord[,1], MCDByUnit$MCDs$Count),col='tan',border='grey', breaks=seq(-7.5,2.5,.1),
 #    main='East & West Cabin',
  #   xlab="Dimension 1 Scores",
   #  freq=F, cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
#lines(density(ca3$rowcoord[,1], weights=MCDByUnit$MCDs$Count/sum(MCDByUnit$MCDs$Count)), 
 #     lwd=2)
#abline(v=-5, lty=1, col="grey")
#abline(v=-3, lty=1, col="grey")

# create a vector for the phases with as many entries as assemblages
Phase <- rep(NA, length(ca3$rowcoord[,1])) 

# do the phase assigments
Phase[(ca3$rowcoord[,1] >= -2.5 )] <- NA
Phase[(ca3$rowcoord[,1] < -2.5)] <- 'P01'

#create df of contexts, counts, mcds and phases
unit <- MCDByUnit$MCDs$unit
dim1Scores <- ca3$rowcoord[,1]
dim2Scores <- ca3$rowcoord[,2]
MCD<- MCDByUnit$MCDs$MCD
blueMCD <-MCDByUnit$MCDs$blueMCD
count<- MCDByUnit$MCDs$Count

CA_MCD_Phase<-data.frame(unit, dim1Scores,dim2Scores,MCD,blueMCD, Phase, count) 

#Order by dim1 score
CA_MCD_Phase1 <- CA_MCD_Phase[order(CA_MCD_Phase$dim1Scores),]

CA_MCD_Phase1

#weighted mean
#tapply function = applies whatever function you give it, x is object on which you calculate the function
#W is numerical weighted vector
tapply(CA_MCD_Phase1$blueMCD, CA_MCD_Phase1$Phase, weighted.mean)

#Export data
#write.csv(CA_MCD_Phase, file='CA_MCD_Phase_Stagville.csv')

#BlueMCDByDim1 plot 
#black border with unit labels can comment out geom_point and geom_text lines to add, situate, and remove labels
require(ggplot2)
library(ggrepel)
p6 <- ggplot(CA_MCD_Phase1,aes(x=CA_MCD_Phase1$dim1Scores,y=CA_MCD_Phase1$blueMCD))+
  scale_y_continuous(limits=c(1790, 1920))+
  geom_point(aes(colour=CA_MCD_Phase1$Phase),size=5)+
  #geom_text_repel(aes(label=CA_MCD_Phase1$unit), cex=6) +
  theme_classic()+
  labs(title="West Cabin", x="Dimension 1", y="BLUE MCD")+
  theme(plot.title=element_text(size=rel(2), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.75)),
        legend.title=element_text(size=rel(1.5)), legend.position="bottom")+
  scale_colour_manual(name="DAACS Phase",
                      labels=c("P01", "P02", "P03"),
                      values=c("skyblue", "blue", "darkblue"))
p6
#save the plot for website chronology page/presentations
#ggsave("WestCabin_Figure4Dim1MCD.png", p4, width=10, height=7.5, dpi=300)
#when you add labels back in 
#ggsave("WestCabin_Figure5Dim1MCDlabels.png", p4, width=10, height=7.5, dpi=300)

#Once phases are assigned we need to calculate MCDs and TPQs by phase 
#Add phase assignments to ware counts by unit
WareByPhase1 <- merge(WareByUnitT2Sorted, CA_MCD_Phase1, by.x='unit', by.y='unit')
#aggregate counts for ware type by phase
WareByPhase <- ddply(WareByPhase1, "Phase", numcolwise(sum))
#Check ware by phase
WareByPhase <- WareByPhase[,-c(15:20)]


#alter EstimateMCDandTPQ function to have phaseData as input for unitData
EstimateMCDandTPQ<- function(phaseData,typeData){
  #for debugging
  #phaseData<- WareByPhase
  #typeData <- MCDTypeTable     
  countMatrix<- as.matrix(phaseData[,2:ncol(phaseData)])
  phaseNames <- (phaseData[,1])
  nPhases <- nrow(phaseData)   
  nTypes<- nrow(typeData)
  nTypesFnd <-ncol(countMatrix)
  typeNames<- colnames(countMatrix)
  # create two col vectors to hold inverse variances and midpoints
  # _in the order in which the type variables occur in the data_.
  invVar<-matrix(data=0,nrow=nTypesFnd, ncol=1)
  mPoint <- matrix(data=0,nrow=nTypesFnd, ncol=1)
  for (i in (1:nTypes)){
    for (j in (1:nTypesFnd)){
      if (typeData$Ware[i]==typeNames[j]) {
        invVar[j,]<-typeData$inverseVar[i] 
        mPoint[j,] <-typeData$midPoint[i]
      }
    }
  }
  # replace NAs for types with no dates with 0s -- so they do not count
  # compute the blue MCDs
  # get a unit by type matrix of inverse variances
  invVarMat<-matrix(t(invVar),nPhases,nTypesFnd, byrow=T)
  # a matrix of weights
  blueWtMat<- countMatrix * invVarMat
  # sums of the weight
  sumBlueWts <- rowSums(blueWtMat)
  # the BLUE MCDs
  blueMCD<-(blueWtMat %*% mPoint) / sumBlueWts
  # compute the vanilla MCDs
  sumWts <- rowSums(countMatrix)
  # the vanilla MCDs
  MCD<-(countMatrix %*% mPoint) / sumWts
  # now for the TPQs
  meltedPhaseData<- melt(phaseData, id.vars='Phase',  variable.name = 'Ware', value.name='count')
  meltedPhaseData1 <- subset(meltedPhaseData, count > 0) 
  mergedPhaseData <- merge(x = meltedPhaseData1, y = typeData,  by.x='Ware', by.y='Ware')
  # the trick is that to figure out the tpq it's best to have each record (row) represent an individual sherd
  # but in its current state, each record has a count that is likely more than 1 so it's necessary to break them up
  # use rep and rownames - rowname is a unique number for each row, kind of link an index
  # rep goes through dataframe mergedUnitData and replicates based on the count column, i.e. if count is
  # 5 it will create 5 records or rows and only replicates columns 2 and 6 (2 is unit name and 6 is begin date)
  repPhaseData <- mergedPhaseData[rep(rownames(mergedPhaseData),mergedPhaseData$count),c(2,6)]
  #once all the rows have a count of one, then can run the quantile function
  TPQ <- tapply(repPhaseData$BeginDate,repPhaseData$Phase, 
                function(x) quantile(x, probs =1.0, type=3 ))              
  TPQp95 <- tapply(repPhaseData$BeginDate,repPhaseData$Phase, 
                   function(x) quantile(x, probs = .95 , type=3 ))                 
  TPQp90 <- tapply(repPhaseData$BeginDate,repPhaseData$Phase, 
                   function(x) quantile(x, probs = .90,  type=3 ))   
  # Finally we assemble the results in to a list
  MCDs<-data.frame(phaseNames,MCD,blueMCD, TPQ, TPQp95, TPQp90, sumWts )
  colnames(MCDs)<- c('Phase','MCD','blueMCD', 'TPQ', 'TPQp95', 'TPQp90', 'Count')
  midPoints <- data.frame(typeNames,mPoint)
  MCDs <- list('MCDs'=MCDs,'midPoints'=midPoints)
  return(MCDs)
} 

#end of function EstimateMCD

# apply the function
MCDByPhase<-EstimateMCDandTPQ(WareByPhase,MCDTypeTable)

# let's see what it looks like
MCDByPhase

#check sums of counts for phases
ddply(CA_MCD_Phase1, .(Phase), summarise, Count=sum(count))

#Export data
write.csv(CA_MCD_Phase1, file='CA_MCDTPQ_Phase.csv')

