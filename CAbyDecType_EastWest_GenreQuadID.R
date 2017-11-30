# set the working directory to P
setwd("P:/")
#setwd("E:/Hermitage/SHA2018")

#load the library
require(RPostgreSQL)
library(plyr)
library(dplyr)

# tell DBI which driver to use
pgSQL <- dbDriver("PostgreSQL")
# establish the connection
connection <- read.csv('RCodeExamples/connection.csv', header=TRUE, stringsAsFactors = F)
DRCcon<-dbConnect(pgSQL, host=connection$host, port=connection$port,
                  dbname=connection$dbname,
                  user=connection$user, password=connection$password)

#Reset working directory to folder with your data
setwd("P:/SHA/2018/Hermitage2018/Lynsey/Genre/")

# get the table with the ware type date ranges
MCDTypeTable<- read.csv('WareGenreMCDTypes.csv', header=TRUE, stringsAsFactors = F)

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
                          "public"."tblContext"."ProjectID",
                          "public"."tblContext"."Context",
"public"."tblContext"."QuadratID",
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

###Section 1:Context Selection ########################################

#Make certain contexts from project 1410 to 1412 and vice versa
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
# require(plyr)
# summary2<-ddply(wareTypeData, .(Ware), summarise, Count=sum(Quantity))
# summary2

# Now we do some ware type recoding if necessary
# For example if "American Stoneware" is William Rogers, we might recode it as "Fulham Type"
# wareTypeData$Ware[wareTypeData$Ware =='American Stoneware'] <- 'Fulham Type'

# get rid of types with no dates
typesWithNoDates <- MCDTypeTable$Ware[(is.na(MCDTypeTable$midPoint))]
wareTypeDataB <- wareTypeData[!wareTypeData$Ware %in%  typesWithNoDates,]

#Drop non-REW (& undecorated) types -- same dataset as decoration only
#wareTypeDataZ<- subset(wareTypeDataB, ! wareTypeDataB$Ware  %in%  c('Porcelain, English Soft Paste',
 #                                                                   'American Stoneware',
  #                                                                  'Bennington/Rockingham',
   #                                                                 'British Stoneware',
    #                                                                'Jasperware Type',
     #                                                               'Black Basalt',
      #                                                              'Redware',
       #                                                             'Refined Stoneware, unidentifiable'))

# what is left?
#summary3<-ddply(wareTypeDataZ, .(Ware), summarise, Count=sum(Quantity))
#summary3

#Replace NA Genre values
wareTypeDataB$CeramicGenre <- ifelse(is.na(wareTypeDataB$CeramicGenre), 
                                     'Not Applicable', wareTypeDataB$CeramicGenre)

#Replace NA Pattern values

#Add new column with combination Ware, & Genre
wareTypeDataB$Ware <- paste(wareTypeDataB$Ware, wareTypeDataB$CeramicGenre, sep='_')

#Remove undecorated ware types
wareTypeData1 <- wareTypeDataB[! grepl("^.*_Not Applicable", wareTypeDataB$Ware),]

#Bone China
# wareTypeData1$Ware[wareTypeData1$Ware =='Porcelain, English Bone China_Handpainted Blue'] <- 'Porcelain, English Bone China_LongDec'
# wareTypeData1$Ware[wareTypeData1$Ware =='Porcelain, English Bone China_Luster Decoration'] <- 'Porcelain, English Bone China_LongDec'
# wareTypeData1$Ware[wareTypeData1$Ware =='Porcelain, English Bone China_Molded Edge Decoration, other'] <- 'Porcelain, English Bone China_LongDec'
# wareTypeData1$Ware[wareTypeData1$Ware =='Porcelain, English Bone China_Overglaze, handpainted'] <- 'Porcelain, English Bone China_LongDec'
# wareTypeData1$Ware[wareTypeData1$Ware =='Porcelain, English Bone China_Transfer Print Over'] <- 'Porcelain, English Bone China_LongDec'
# wareTypeData1$Ware[wareTypeData1$Ware =='Porcelain, English Bone China_Transfer Print Under, blue'] <- 'Porcelain, English Bone China_LongDec'
# wareTypeData1$Ware[wareTypeData1$Ware =='Porcelain, English Bone China_Transfer Print Under, light blue'] <- 'Porcelain, English Bone China_LongDec'

#Porcellaneous
# wareTypeData1$Ware[grepl("^.*Porcellaneous/English Hard Paste_H", wareTypeData1$Ware)] <- 'Porcellaneous/English Hard Paste_LongDec'
# wareTypeData1$Ware[grepl("^.*Porcellaneous/English Hard Paste_L", wareTypeData1$Ware)] <- 'Porcellaneous/English Hard Paste_LongDec'
# wareTypeData1$Ware[grepl("^.*Porcellaneous/English Hard Paste_O", wareTypeData1$Ware)] <- 'Porcellaneous/English Hard Paste_LongDec'
# wareTypeData1$Ware[grepl("^.*Porcellaneous/English Hard Paste_T", wareTypeData1$Ware)] <- 'Porcellaneous/English Hard Paste_LongDec'

#Pearlware
wareTypeData1$Ware[wareTypeData1$Ware =='Pearlware_Shell Edge, blue'] <- 'Pearlware_ShellEdge'
wareTypeData1$Ware[wareTypeData1$Ware =='Pearlware_Shell Edge, green'] <- 'Pearlware_ShellEdge'
wareTypeData1$Ware[wareTypeData1$Ware =='Pearlware_Shell Edge, unid.'] <- 'Pearlware_ShellEdge'
wareTypeData1$Ware[wareTypeData1$Ware =='Pearlware_Transfer Print Under, blue'] <- 'Pearlware_TPBlue'
wareTypeData1$Ware[wareTypeData1$Ware =='Pearlware_Handpainted, Polychrome Other'] <- 'Pearlware_Handpainted, Polychrome Warm'
# wareTypeData1$Ware[wareTypeData1$Ware =='Pearlware_Transfer Print Under, brown'] <- 'Pearlware_TPOther'
# wareTypeData1$Ware[wareTypeData1$Ware =='Pearlware_Transfer Print Under, black'] <- 'Pearlware_TPOther'

#Ironstone
wareTypeData1$Ware[wareTypeData1$Ware =='Ironstone/White Granite_Handpainted, Polychrome Other'] <- 'Ironstone/White Granite_Handpainted, Polychrome Cool'
wareTypeData1$Ware[grepl("^.*Ironstone/White Granite_Shell", wareTypeData1$Ware)] <- 'Ironstone/White Granite_ShellEdge'
# wareTypeData1$Ware[grepl("^.*Ironstone/White Granite_T", wareTypeData1$Ware)] <- 'Ironstone/White Granite_LongDec'
# wareTypeData1$Ware[grepl("^.*Ironstone/White Granite_M", wareTypeData1$Ware)] <- 'Ironstone/White Granite_LongDec'
# wareTypeData1$Ware[grepl("^.*Ironstone/White Granite_O", wareTypeData1$Ware)] <- 'Ironstone/White Granite_LongDec'
# wareTypeData1$Ware[grepl("^.*Ironstone/White Granite_L", wareTypeData1$Ware)] <- 'Ironstone/White Granite_LongDec'
wareTypeData1$Ware[grepl("^.*Ironstone/White Granite_F", wareTypeData1$Ware)] <- 'Ironstone/White Granite_Flow'
# wareTypeData1$Ware[grepl("^.*Porcelain, English Bone China_F", wareTypeData1$Ware)] <- 'Porcelain, English Bone China_LongDec'
# wareTypeData1$Ware[grepl("^.*Porcellaneous/English Hard Paste_M", wareTypeData1$Ware)] <- 'Porcelain, English Bone China_LongDec'

#Whiteware
wareTypeData1$Ware[grepl("^.*Whiteware_F", wareTypeData1$Ware)] <- 'Whiteware Granite_Flow'
wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Handpainted, Polychrome Warm'] <- 'Whiteware_Handpainted, Polychrome Cool'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Molded Edge Decoration, other'] <- 'Whiteware_LongDec'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Overglaze, handpainted'] <- 'Whiteware_LongDec'
wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Shell Edge, blue'] <- 'Whiteware_ShellEdge'
wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Shell Edge, green'] <- 'Whiteware_ShellEdge'
wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Shell Edge, unid.'] <- 'Whiteware_ShellEdge'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, blue'] <- 'Whiteware_LongDec'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, black'] <- 'Whiteware_TPOther'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, unidentifiable'] <- 'Whiteware_LongDec'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, brown'] <- 'Whiteware_TPOther'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, gray'] <- 'Whiteware_TPOther'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, light blue'] <- 'Whiteware_TPOther'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, pink'] <- 'Whiteware_TPOther'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, polychrome'] <- 'Whiteware_TPOther'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, purple'] <- 'Whiteware_TPOther'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, red'] <- 'Whiteware_TPOther'
# wareTypeData1$Ware[wareTypeData1$Ware =='Whiteware_Transfer Print Under, green'] <- 'Whiteware_TPOther'

#other types
# wareTypeData1$Ware[grepl("^.*Redware, refined_L", wareTypeData1$Ware)] <- 'Redware, refined_LongDec'
# wareTypeData1$Ware[grepl("^.*Redware, refined_S", wareTypeData1$Ware)] <- 'Redware, refined_LongDec'
# wareTypeData1$Ware[grepl("^.*Redware, refined_Y", wareTypeData1$Ware)] <- 'Redware, refined_LongDec'
# wareTypeData1$Ware[grepl("^.*Bennington/Rockingham_M", wareTypeData1$Ware)] <- 'Bennington/Rockingham_LongDec'
# wareTypeData1$Ware[grepl("^.*Bennington/Rockingham_S", wareTypeData1$Ware)] <- 'Bennington/Rockingham_LongDec'
wareTypeData1$Ware[wareTypeData1$Ware =='Yellow Ware_Shell Edge, blue'] <- 'Yellow Ware_Slipware, factory made'
wareTypeData1$Ware[wareTypeData1$Ware =='Yellow Ware_Sponge/Spatter'] <- 'Yellow Ware_Slipware, factory made'

#Write new summary with WGP
summary4 <- ddply(wareTypeData1, .(Ware), summarise, Count=sum(Quantity))
#write.csv(summary4, "waretypessum.csv")
# summary4

# More recoding: let's create a new variable called 'unit', this will make it easier to 
#change the counting unit (context, SG, feature)in future analyses   

#Replace blanks in SG and Feature Number to NA
wareTypeData1$DAACSStratigraphicGroup[is.na(wareTypeData1$DAACSStratigraphicGroup)] <- ''
wareTypeData1$FeatureNumber[is.na(wareTypeData1$FeatureNumber)] <- ''
wareTypeData1$QuadratID[is.na(wareTypeData1$QuadratID)] <- ''

wareTypeDataY <- mutate(wareTypeData1, unit=ifelse((QuadratID == '' & FeatureNumber == '' & DAACSStratigraphicGroup == ''),
                                                   paste(ProjectID,Context),
                                                   ifelse((QuadratID != '' & FeatureNumber == '' & DAACSStratigraphicGroup == ''),
                                                          paste(ProjectID,'Q',QuadratID,Context),
                                                          ifelse((QuadratID == '' & FeatureNumber != '' & DAACSStratigraphicGroup == ''),
                                                                 paste(ProjectID,Context,'F',FeatureNumber),
                                                                 ifelse((QuadratID != '' & FeatureNumber == '' & DAACSStratigraphicGroup != ''),
                                                                        paste(ProjectID,'Q',QuadratID,DAACSStratigraphicGroup),
                                                                        ifelse((QuadratID == '' & FeatureNumber != '' & DAACSStratigraphicGroup != ''),
                                                                               paste(ProjectID,'F',FeatureNumber,DAACSStratigraphicGroup),
                                                                               paste(ProjectID,Context)
                                                                        ))))))
# 
#divisions for Interior/Exterior and North/South
wareTypeDataY$SiteName[(grepl("^.*ECS", wareTypeDataY$QuadratID))] <- 'ECSINT'
wareTypeDataY$SiteName[(grepl("^.*ECN", wareTypeDataY$QuadratID))] <- 'ECNINT'
wareTypeDataY$SiteName[(! grepl("^.*EC", wareTypeDataY$QuadratID)) & (wareTypeDataY$meannorthing < -988)] <- 'ECSEXT'
wareTypeDataY$SiteName[(! grepl("^.*EC", wareTypeDataY$QuadratID)) & (wareTypeDataY$meannorthing > -988)] <- 'ECNEXT'
wareTypeDataY$SiteName[wareTypeDataY$Context %in% c('97-03-001','80-45-12','80-45-13','80-45-14','80-45-15','80-45-16','80-45-UNPR')] <- 'ECEXT'
wareTypeDataY$SiteName[(! grepl("^.*EC", wareTypeDataY$QuadratID)) & (wareTypeDataY$FeatureNumber %in% c('002','004','668','688','689','705','709','710','714','717','718','719','734','760','765','796','801'))] <- 'ECNEXT'
wareTypeDataY$SiteName[(! grepl("^.*EC", wareTypeDataY$QuadratID)) & (wareTypeDataY$FeatureNumber %in% c('001','003','013','014','015','667','669','670','677','678','679','687','691','692','704','707','711','735','738','755','794','797','800','802','807','817','820','821'))] <- 'ECSEXT'
wareTypeDataY$SiteName[(! grepl("^.*EC", wareTypeDataY$QuadratID)) & (wareTypeDataY$FeatureNumber %in% c('668','685','696','697','715','716','721','722','725'))] <- 'ECNINT'
wareTypeDataY$SiteName[(! grepl("^.*EC", wareTypeDataY$QuadratID)) & (wareTypeDataY$FeatureNumber %in% c('662','662A','662B','666','671','672','698','702','703','708','712','713','772','772A','772B'))] <- 'ECSINT'

#WEST CABIN INTERIOR
wareTypeDataY$SiteName[(grepl("^.*WCN", wareTypeDataY$QuadratID))] <- 'WCNINT'
wareTypeDataY$SiteName[(grepl("^.*WCS", wareTypeDataY$QuadratID))] <- 'WCSINT'
wareTypeDataY$SiteName[wareTypeDataY$QuadratID %in% c('SQUAREA','SQUAREB','SQUAREC','SQUARED','SQUAREE')] <- 'WCSINT'
wareTypeDataY$SiteName[wareTypeDataY$QuadratID %in% c('SQUAREF','SQUAREG','SQUAREH','SQUAREI','SQUAREJ', 'SQUAREK')] <- 'WCNINT'
wareTypeDataY$SiteName[(wareTypeDataY$FeatureNumber %in% c('798','786','785'))] <- 'ECSINT'

#WEST CABIN NE
wareTypeDataY$SiteName[(grepl("^.*E060", wareTypeDataY$QuadratID))] <- 'WCNEEXT'
wareTypeDataY$SiteName[(grepl("^.*E60", wareTypeDataY$QuadratID))] <- 'WCNEEXT'
wareTypeDataY$SiteName[wareTypeDataY$QuadratID %in% c('N522E536','N524E536','N524E532','N526E532','S972E027')] <- 'WCNINT'
wareTypeDataY$SiteName[wareTypeDataY$QuadratID %in% c('S0980E050','S0970E050', 'N524E536','N524E532','N526E532','S972E027')] <- 'WCNINT'

#WEST CABIN WEST
wareTypeDataY$SiteName[(grepl("^.*E020", wareTypeDataY$QuadratID))] <- 'WCWEXT'
wareTypeDataY$SiteName[(grepl("^.*E010", wareTypeDataY$QuadratID))] <- 'WCWEXT'
wareTypeDataY$SiteName[wareTypeDataY$QuadratID %in% c('N522E526')] <- 'WCWEXT'

#WEST CABIN SOUTH
wareTypeDataY$SiteName[(grepl("^.*E30", wareTypeDataY$QuadratID))] <- 'WCSEXT'
wareTypeDataY$SiteName[(grepl("^.*E40", wareTypeDataY$QuadratID))] <- 'WCSEXT'
wareTypeDataY$SiteName[(grepl("^.*E50", wareTypeDataY$QuadratID))] <- 'WCSEXT'
wareTypeDataY$SiteName[(wareTypeDataY$FeatureNumber %in% c('726','779','730'))] <- 'WCSEXT'


# #Create name field, fill with projectID values
# wareTypeData1$name <- wareTypeData1$ProjectID
# 
# #Assign character names to name field based on projectID
# wareTypeData1$name[wareTypeData1$name=="1412"] <- 'WC'
# wareTypeData1$name[wareTypeData1$name=="1410"] <- 'EC'
# 
# #Add projectID to unit
# wareTypeData1$unit <- paste(wareTypeData1$name, wareTypeData1$unitX, sep='_')
#wareTypeData1$unit <- paste(wareTypeData1$ProjectID, wareTypeData1$unitX, sep='_')

###Section 4: Remove Ware Outliers ########################################

wareTypeData2<- subset(wareTypeDataY, ! wareTypeDataY$Ware  %in%  c('Creamware_Molded Edge Decoration, other',
                                                                    'Porcelain, French_Transfer Print Over'))
                                                                 #   'Creamware_Slipware, factory made',
                                                                 #   'Pearlware_TPOther'))            
                                                                  

# lets get a data frame with contexts as rows and type as cols, with the
# entries as counts
WareByUnit <- ddply(wareTypeData2, .(unit, Ware), summarise, Count=sum(Quantity))
#WareByUnit <- ddply(wareTypeDataY, .(unit, Ware), summarise, Count=sum(Quantity))

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

#delete any outliers
WareByUnitTOut <-subset(WareByUnitT1, !WareByUnitT1$unit %in% c('1412 Q S1020E40 SG02',
                                                                '1412 Q SQUAREC SG05',
                                                                '1410 Q 01 SG02_1980',
                                                                 '1410 Q 16 SG02_1980',
                                                                '1410 Q 15 SG04_1980',
                                                                '1410 Q 13 SG02_1980',
                                                                '1410 F 002 SG03_1980',
                                                                '1410 Q S0990E080C SG01'))

#Ok now let's get rid of all the columns (ware types) where totals < 0
WareByUnitT2<-WareByUnitTOut[, colSums(WareByUnitTOut != 0) > 0]
#WareByUnitT2<-WareByUnitT1[, colSums(WareByUnitT1 != 0) > 0]

###Section 6: Run MCD and Sort Data functions ########################################

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
  repUnitData <- mergedUnitData[rep(rownames(mergedUnitData),mergedUnitData$count),c(2,4)]
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

#Check for wonky MCD values
#CheckMCDs <- MCDByUnit$MCDs

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
  #geom_text(aes(label=rownames(rowscores)),vjust=-.6, hjust=-.1, cex=5)+
  #  xlim(-4,4)+
  #geom_text_repel(aes(label=rownames(rowscores)), cex=5, segment.alpha=0.2) +
  theme_classic()+
  labs(title="East and West Cabin", x="Dimension 1", y="Dimension 2")+
  theme(plot.title=element_text(size=rel(2), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))
p1
#ggsave("CAgenre_EastWest_Dim1Dim2.png", p1, width=10, height=7.5, dpi=300)

#Create plot: Dim 1 and Dim 2 ware scores
p2 <- ggplot(colscores, aes(x=colscores$Dim1,y=colscores$Dim2))+
  geom_point(shape=21, size=5, colour="black", fill="cornflower blue")+
  #geom_text(aes(label=rownames(colscores)),vjust=-.6, cex=5)+
  geom_text_repel(aes(label=rownames(colscores)), cex=5, segment.alpha=0.2) +
  theme_classic()+
  labs(title="East and West Cabin", x="Dimension 1", y="Dimension 2")+
  theme(plot.title=element_text(size=rel(2.25), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))
p2
#ggsave("CAgenre_EastWest_Dim1Dim2types.png", p2, width=10, height=7.5, dpi=300)

#Create plot: Dim 1 and BLUE MCD
p3 <- ggplot(rowscores, aes(x=rowscores$Dim1,y=MCDByUnit$MCDs$blueMCD))+
  geom_point(shape=21, size=5, colour="black", fill="cornflower blue")+
  #geom_text(aes(label=rownames(rowscores)),vjust=-.6, hjust=-.1, cex=5)+
  #geom_text_repel(aes(label=rownames(rowscores)), cex=5, segment.alpha=0.2) +
  theme_classic()+
  labs(title="East and West Cabin", x="Genre Dimension 1", y="BLUE MCD")+
  theme(plot.title=element_text(size=rel(2.25), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))
p3
#ggsave("CAgenre_EastWest_Dim1BLUEMCD.png", p3, width=10, height=7.5, dpi=300)
#ggsave("CAgenre_EastWest_Dim1BLUEMCD_nolabels.png", p3, width=10, height=7.5, dpi=300)

p3a <- ggplot(rowscores, aes(x=rowscores$Dim2,y=MCDByUnit$MCDs$blueMCD))+
  geom_point(shape=21, size=5, colour="black", fill="cornflower blue")+
  #geom_text(aes(label=rownames(rowscores)),vjust=-.6, hjust=-.1, cex=5)+
  #geom_text_repel(aes(label=rownames(rowscores)), cex=5, segment.alpha=0.2) +
  theme_classic()+
  labs(title="East and West Cabin", x="Genre Dimension 2", y="BLUE MCD")+
  theme(plot.title=element_text(size=rel(2.25), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))
p3a

# CA Dim 1 vs. MCDs with plot function
#plot(ca3$rowcoord[,1], MCDByUnit$MCDs$blueMCD, pch=21, bg="black",cex=1.25,
#    xlab="Dimension 1", ylab="BLUE MCD",cex.lab=1.5, cex.axis=1.5, xlim=c(-2.5,5))
#text(ca3$rowcoord[,1],MCDByUnit$MCDs$blueMCD,rownames(ca3$rowcoord),
#    pos=4, cex=1.25, col="black")
#abline(v=-6, lty=1, col="grey")
#abline(v=-3, lty=1, col="grey")
#abline(v=-1.5, lty=1, col="grey")
#abline(v=0.5, lty=1, col="grey")
#abline(v=-4.5, lty=1, col="grey")

cor.test(ca3$rowcoord[,1],MCDByUnit$MCDs$blueMCD, method="kendall")

# CA Dim 2 vs. MCDs
#plot(ca3$rowcoord[,2], MCDByUnit$MCDs$blueMCD, pch=21, bg="black",cex=1.25,
#xlab="Dimension 1", ylab="BLUE MCD",cex.lab=1.5, cex.axis=1.5)


#Create weighted histograms for phasing with plotrix
#library(plotrix)

#Compares counts of sherds in all units with BLUE MCDs that fall within bin, you may need to change sequence dates
#weighted.hist(MCDByUnit$MCDs$blueMCD, MCDByUnit$MCDs$Count, breaks=seq(1790,1930,10), col='lightblue')

#Dim 1 Scores Weighted Histogram, you may need to change scale
#Lines step adds density curve to weighted histogram
#hist(rep(ca3$rowcoord[,1], MCDByUnit$MCDs$Count),col='tan',border='grey', breaks=seq(-3,6,.1),
#    main='East & West Cabin',
#   xlab="Dimension 1 Scores",
#  freq=F, cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
#abline(v=-6, lty=1, col="grey")
#abline(v=-3, lty=1, col="grey")
#abline(v=-1.5, lty=1, col="grey")
#abline(v=0.5, lty=1, col="grey")
#abline(v=-4.5, lty=1, col="grey")
#lines(density(ca3$rowcoord[,1], weights=MCDByUnit$MCDs$Count/sum(MCDByUnit$MCDs$Count)), 
#      lwd=2)


#Create table of contexts, counts, and mcds, need to read in unit as character
unit <- as.character(MCDByUnit$MCDs$unit)
dim1Scores <- ca3$rowcoord[,1]
dim2Scores <- ca3$rowcoord[,2]
MCD<- MCDByUnit$MCDs$MCD
blueMCD <-MCDByUnit$MCDs$blueMCD
count<- MCDByUnit$MCDs$Count

#Create data frame, read strings as characters
CA_MCD<-data.frame(unit, dim1Scores,dim2Scores,MCD,blueMCD, count, stringsAsFactors = F) 

#Create new field to hold cabin name, fill with unit
# CA_MCD$Cabin <- CA_MCD$unit
# 
# #Assign cabin name based on 'unit' character string
# CA_MCD$Cabin[grepl("^.*EC_", CA_MCD$Cabin)] <- 'EC'
# CA_MCD$Cabin[grepl("^.*WC_", CA_MCD$Cabin)] <- 'WC'
# 
# #Dim 1 bluemcd with colors by cabin
# color <- ggplot(rowscores, aes(x=CA_MCD$dim1Scores,y=CA_MCD$blueMCD))+
#   geom_point(aes(colour=CA_MCD$Cabin),size=5)+
#   #geom_text(aes(label=CA_MCD_Phase1$unit),vjust=-.6, cex=5)+
#   #geom_text_repel(aes(label=rownames(rowscores)), cex=5, segment.alpha=0.2) +
#   theme_classic()+
#   labs(title="East and West", x="Dimension 1", y="BLUE MCD")+
#   theme(plot.title=element_text(size=rel(2), hjust=0.5),axis.title=element_text(size=rel(1.75)),
#         axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.75)),
#         legend.title=element_text(size=rel(1.5)), legend.position="bottom")+
#   scale_colour_manual(name="Cabin",
#                       labels=c("East", "West"),
#                       values=c("darkgoldenrod1", "aquamarine4"))
# color
#ggsave("CAgenre_EastWest_D1BMCD_color.png", color, width=10, height=7.5, dpi=300)

#Dim 1 scores Weighted Histogram, you may need to change scale
p5 <- ggplot(CA_MCD, aes(x=CA_MCD$dim1Scores, weight=CA_MCD$count/sum(CA_MCD$count)))+
  geom_histogram(aes(y=..density..), colour="gray", fill="tan", binwidth=0.1, boundary=0.5)+
  #xlim(-3.5,7)+
  #stat_function(fun = dnorm, colour = "blue")+
  scale_x_continuous(breaks=seq(-4, 3, 1))+
  theme_classic()+
  labs(title="East and West Cabin", x="Dimension 1", y="Density")+
  theme(plot.title=element_text(size=rel(2.25), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))#+
p5 + geom_density(fill=NA)
p5a <- p5 + geom_vline(xintercept=c(-2.3, -1.4, -0.4, 0.7), colour="black")
p5a
#ggsave("CAdgenre_EastWest_Hist.png", p5, width=10, height=7.5, dpi=300)
#ggsave("CAdgenre_EastWest_Hist_lines.png", p5a, width=10, height=7.5, dpi=300)
#Dim 1 scores Weighted Histogram, you may need to change scale
p5 <- ggplot(CA_MCD, aes(x=CA_MCD$dim2Scores, weight=CA_MCD$count/sum(CA_MCD$count)))+
  geom_histogram(aes(y=..density..), colour="gray", fill="tan", binwidth=0.1, boundary=0.5)+
  #xlim(-3.5,7)+
  #stat_function(fun = dnorm, colour = "blue")+
  scale_x_continuous(breaks=seq(-4, 3, 1))+
  theme_classic()+
  labs(title="East and West Cabin", x="Dimension 2", y="Density")+
  theme(plot.title=element_text(size=rel(2.25), hjust=0.5),axis.title=element_text(size=rel(1.75)),
        axis.text=element_text(size=rel(1.5)))#+
p5 + geom_density(fill=NA)
p5a <- p5 + geom_vline(xintercept=c(-2.3, -1.4, -0.4, 0.7), colour="black")

# create a vector for the phases with as many entries as assemblages
Phase <- rep(NA, length(ca3$rowcoord[,1])) 

# do the phase assigments
Phase[(ca3$rowcoord[,1] <= -3)] <- 'P01'  
Phase[(ca3$rowcoord[,1] > -3) & (ca3$rowcoord[,1]) <= -1.5] <- 'P02'
Phase[(ca3$rowcoord[,1] > -1.5) & (ca3$rowcoord[,1]) <= -0.2] <- 'P03'
Phase[(ca3$rowcoord[,1] > -0.2) & (ca3$rowcoord[,1]) <= 0.1] <- 'P04'
Phase[(ca3$rowcoord[,1] > 0.1) & (ca3$rowcoord[,1]) <= 1.1] <- 'P05'
Phase[(ca3$rowcoord[,1] > 1.1)] <- 'P06'  

Phase

#create table of contexts, counts, and mcds
unit <- MCDByUnit$MCDs$unit
dim1Scores <- ca3$rowcoord[,1]
dim2Scores <- ca3$rowcoord[,2]
MCD<- MCDByUnit$MCDs$MCD
blueMCD <-MCDByUnit$MCDs$blueMCD
count<- MCDByUnit$MCDs$Count

CA_MCD_Phase<-data.frame(unit, dim1Scores,dim2Scores,MCD,blueMCD, Phase, count) 

#Order by dim1 score
CA_MCD_Phase1 <- CA_MCD_Phase[order(CA_MCD_Phase$dim1Score),]

#weighted mean
#tapply function = applies whatever function you give it, x is object on which you calculate the function
#W is numerical weighted vector
tapply(CA_MCD_Phase1$blueMCD, CA_MCD_Phase1$Phase, weighted.mean)
#tapply(CA_MCD_Phase1$MCD, CA_MCD_Phase1$Phase, weighted.mean)

#Add phase assignments to ware counts by unit
WareByPhase1 <- merge(WareByUnitT2Sorted, CA_MCD_Phase1, by.x='unit', by.y='unit')
#aggregate counts for ware type by phase
WareByPhase <- ddply(WareByPhase1, "Phase", numcolwise(sum))
#Check ware by phase
WareByPhase <- WareByPhase[,-c(33:37)]


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
  repPhaseData <- mergedPhaseData[rep(rownames(mergedPhaseData),mergedPhaseData$count),c(2,4)]
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
results <- MCDByPhase$MCDs

#check sums of counts for phases
ddply(CA_MCD_Phase1, .(Phase), summarise, Count=sum(count))

write.csv(results, file = "MCDByPhase_Genre.csv")
write.csv(CA_MCD_Phase1, file = "CAMCDTPQ_Genre.csv")

####Section 8: Evaluate goodness of fit to seriation model ########################################

#Define three functions based on Marko Procic 2013 
#Written by Fraser D. Neiman 11.23.2017

# define a function to compute the number of Modes and the "Seriation Index"
# arguments:  rowscores - a vector of scores to order the rows (e.g. CA scores, MCDs)
#             dataMatrix - a matrix: counts of types(cols) in assemblages (rows).
# values:     nModes - the number of modes in the preder specified by the rowScores vector
#             sIndex - the Seriation Index (coefficient)
fsStats <- function(rowScores, dataMatrix){
  sortedMatrix <- dataMatrix[order(rowScores),]
  props <- prop.table(sortedMatrix,1)
  nRows <- nrow(props)
  nCols <- ncol(props)
  modeMat <- matrix(0, nRows,nCols) 
  for (i in 2:(nRows-1)) {
    modeMat[i,] <- (props[i-1,] < props[i,]) & (props[i,] > props[i+1,])
  }
  modeMat[1,] <- (props[1,] > props[2,]) 
  modeMat[nRows,] <- (props[nRows,] > props[nRows-1,]) 
  nModes <- sum(modeMat)
  maxModes <- ifelse(nRows %% 2 == 0, (nRows*nCols)/2, (nRows*(nCols+1))/2)
  sIndex <- (maxModes -nModes)/ (maxModes - nCols)
  list(nModes=nModes, sIndex=sIndex)
}

# Define a function to compute the number of Modes and the "Seriation Index"
# for a given number of random permutations of a data matrix.  
# arguments:  nPermutations - number of permutations desired  
#             dataMatrix - a matrix: counts of types(cols) in assemblages (rows) 
fsStatsMC <- function(nPermutations, dataMatrix){
  props <- prop.table(dataMatrix,1)
  nRows <- nrow(props)
  nCols <- ncol(props)
  mcValues <- matrix(0,nPermutations,2)
  colnames(mcValues) <- c('nModes', 'sIndex')
  for(k in 1:nPermutations){
    props <- props[order(runif(nRows)),]
    modeMat <- matrix(0, nRows,nCols)
    for (i in 2:(nRows-1)) {
      modeMat[i,] <- (props[i-1,] < props[i,]) & (props[i,] > props[i+1,])
    }
    modeMat[1,] <- (props[1,] > props[2,]) 
    modeMat[nRows,] <- (props[nRows,] > props[nRows-1,]) 
    nModes <- sum(modeMat)
    maxModes <- ifelse(nRows %% 2 == 0, (nRows*nCols)/2, (nRows*(nCols+1))/2)
    sIndex <- (maxModes -nModes)/ (maxModes - nCols)
    mcValues[k,] <- c(nModes, sIndex)
  }
  mcValues
}

# define a function to compute MC probabilities, zscores, and z-score probabilities, based on
# the results from fsStats() and fsStatsMC()
# arguments:    StatsMC - the matrix of Monte Carlo values from fsStatsMC()
#               Stats  - the stats for the seriation solution from fsStats()
# empirical probabilty from the ECDF of the sIndex values
fsAnalyze <- function(stats, statsMC ){
  probMC_sIndex <- 1- (ecdf(statsMC[,2])(stats$sIndex))   
  # z score for the Seriation Index. This is probably a good measure to compare 
  # seriations on different datasets
  z_sIndex <- (stats$sIndex - mean(statsMC[,2]))/ sd(statsMC[,2])
  # prob(z >= z_sIndex)
  prob_z_sIndex <- 1-pnorm(z_sIndex)
  list('sIndex'= stats$sIndex,
       'probMC_sIndex' = probMC_sIndex, 
       'z_sIndex' = z_sIndex, 
       'prob_z_sIndex' = prob_z_sIndex )
}


# now we call the three functions and do a couple of plots
#First run Dim 1 scores and ware type counts data matrix

EWStats_Dim1 <- fsStats(ca3$rowcoord[,1], Matx)
EWStats_Dim1

# Run results for random permutations of a data matrix
EWMC  <- fsStatsMC(1000, Matx)

#Compare results of Dim 1 values and permutations
fsAnalyze (EWStats_Dim1, EWMC)

#Second run MCDs and ware type counts data matrix
EWStats_MCD <- fsStats(CA_MCD$blueMCD, Matx)
EWStats_MCD

#Compare results of blue MCD values and permutations
fsAnalyze (EWStats_MCD, EWMC)

#Third run Dim 2 scores and ware type counts data matrix
EWStats_Dim2 <- fsStats(ca3$rowcoord[,2], Matx)
EWStats_Dim2

#Compare results of Dim 2 values and permutations
fsAnalyze (EWStats_Dim2, EWMC)

hist(EWMC[,1], 20, col='grey',
     xlab= 'Number of Modes', ylab = 'Frequency')
abline(v=EWStats_Dim1$nModes, col='blue', lwd=4)
abline(v=EWStats_MCD$nModes, col='yellow', lwd=4)
abline(v=EWStats_Dim2$nModes, col='green', lwd=4)

# 
