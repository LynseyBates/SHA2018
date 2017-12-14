#Code to calculate abundance index values for Hermitage small finds
#Created 12.03.2017 LAB
#Updated 12.05.2017 LAB drop Pharm, group projects next to each other, new plot with less than .05 values
#Updated 12.07.2017 LAB add in site MCDs
#Updated 12.12.2017 LAB add in Plantation-wide phases by Quad

#load the library
library(plyr)
library(dplyr)
require(RPostgreSQL)

# tell DBI which driver to use
pgSQL <- dbDriver("PostgreSQL")
# establish the connection
connection <- read.csv('RCodeExamples/connection.csv', header=TRUE, stringsAsFactors = F)
#connection <- read.csv('connection.csv', header=TRUE, stringsAsFactors = F)
DRCcon<-dbConnect(pgSQL, host=connection$host, port=connection$port,
                  dbname=connection$dbname,
                  user=connection$user, password=connection$password)


##Section 1: Glass######################
HermGlass <-dbGetQuery(DRCcon,'
                       SELECT
                       "public"."tblContext"."ProjectID",
                       "public"."tblContext"."Context",
                       "public"."tblGlass"."Quantity",
                       "public"."tblGlassForm"."GlassForm",
"public"."tblContext"."DAACSPhase",
"public"."tblContext"."ExcavatorPhase"
                       FROM
                       "public"."tblContext"
                       INNER JOIN "public"."tblContextSample" ON "public"."tblContextSample"."ContextAutoID" = "public"."tblContext"."ContextAutoID"
                       INNER JOIN "public"."tblGenerateContextArtifactID" ON "public"."tblContextSample"."ContextSampleID" = "public"."tblGenerateContextArtifactID"."ContextSampleID"
                       INNER JOIN "public"."tblGlass" ON "public"."tblGlass"."GenerateContextArtifactID" = "public"."tblGenerateContextArtifactID"."GenerateContextArtifactID"
                       LEFT JOIN "public"."tblGlassForm" ON "public"."tblGlassForm"."GlassFormID" = "public"."tblGlass"."GlassFormID"
                       WHERE
                       "public"."tblContext"."ProjectID" = \'1400\'OR
                       "public"."tblContext"."ProjectID" = \'1401\'OR
                       "public"."tblContext"."ProjectID" = \'1403\'OR
                       "public"."tblContext"."ProjectID" = \'1404\'OR
                       "public"."tblContext"."ProjectID" = \'1402\'OR
                       "public"."tblContext"."ProjectID" = \'1410\'OR
                       "public"."tblContext"."ProjectID" = \'1412\'OR
                       "public"."tblContext"."ProjectID" = \'1406\'OR
                       "public"."tblContext"."ProjectID" = \'1407\'OR
                       "public"."tblContext"."ProjectID" = \'1405\'
                       ')    
#Add in LMK
#HermGlass$ProjectID[(HermGlass$ProjectID == 1405) & (HermGlass$DAACSPhase =="P01")] <- 4000

#Create Project ID and ExcavatorPhase field
#HermGlass$Project <- paste(HermGlass$ProjectID,HermGlass$ExcavatorPhase,sep='_')

#Create sum of glass by project to use in abundance indices
glass_sum<-ddply(HermGlass, .(ProjectID, ExcavatorPhase), summarise, Count=sum(Quantity))

#Create dataframe by project and glass form
HermGlass3<-ddply(HermGlass, .(ProjectID, ExcavatorPhase, GlassForm), summarise, Count=sum(Quantity))
colnames(HermGlass3)<- c("Project","Phase", "Form","Count")

#Keep only pharmaceutical and ink well forms
Ink <- subset(HermGlass3, HermGlass3$Form %in% c('Bottle, Ink'))
#Pharm <- HermGlass3[grepl("^.*Pharmaceutical", HermGlass3$Form), ]

#Create category for aggregation and assign to glass forms
#Pharm$Form[grepl("^.*Pharmaceutical", Pharm$Form)] <- 'Medical_Pharm'
Ink$Form[Ink$Form =='Bottle, Ink'] <- 'Education'
#colnames(Pharm)<- c("Project","Category","Count")
colnames(Ink)<- c("Project","Phase", "Category","Count")

##Section 2: General Artifacts ######################
HermGA <-dbGetQuery(DRCcon,'
                       SELECT
                    "public"."tblContext"."ProjectID",
                    "public"."tblContext"."Context",
                    "public"."tblGenArtifact"."Quantity",
                    "public"."tblGenArtifactForm"."GenArtifactForm",
                    "public"."tblGenArtifact"."CoinDate",
"public"."tblContext"."DAACSPhase",
"public"."tblContext"."ExcavatorPhase"

                    FROM
                    "public"."tblContext"
                    INNER JOIN "public"."tblContextSample" ON "public"."tblContextSample"."ContextAutoID" = "public"."tblContext"."ContextAutoID"
                    INNER JOIN "public"."tblGenerateContextArtifactID" ON "public"."tblContextSample"."ContextSampleID" = "public"."tblGenerateContextArtifactID"."ContextSampleID"
                    INNER JOIN "public"."tblGenArtifact" ON "public"."tblGenArtifact"."GenerateContextArtifactID" = "public"."tblGenerateContextArtifactID"."GenerateContextArtifactID"
                    INNER JOIN "public"."tblGenArtifactForm" ON "public"."tblGenArtifactForm"."GenArtifactFormID" = "public"."tblGenArtifact"."GenArtifactFormID"
                    WHERE
                    "public"."tblContext"."ProjectID" = \'1400\'OR
                    "public"."tblContext"."ProjectID" = \'1401\'OR
                    "public"."tblContext"."ProjectID" = \'1403\'OR
                    "public"."tblContext"."ProjectID" = \'1404\'OR
                    "public"."tblContext"."ProjectID" = \'1402\'OR
                    "public"."tblContext"."ProjectID" = \'1410\'OR
                    "public"."tblContext"."ProjectID" = \'1412\'OR
                    "public"."tblContext"."ProjectID" = \'1406\'OR
                    "public"."tblContext"."ProjectID" = \'1407\'OR
                    "public"."tblContext"."ProjectID" = \'1405\'
                    ')    

#HermGA$ProjectID[(HermGA$ProjectID == 1405) & (HermGA$DAACSPhase =="P01")] <- 4000

#Create Project ID and ExcavatorPhase field
#HermGA$Project <- paste(HermGA$ProjectID,HermGA$ExcavatorPhase,sep='_')

#Create coin dataframe based on coin date, will append to other tables below
Coin <- HermGA[grepl("^.*Coin", HermGA$GenArtifactForm), ]
Coin2 <- unique(Coin[(Coin$CoinDate < 1900), ])                                                  
Coin3 <- subset(Coin2, ! is.na(Coin2$ProjectID))

#Aggregate by project, phase, and form, add category
Coin3$Category <- 'Coins'
Coins<-ddply(Coin3, .(ProjectID, ExcavatorPhase, Category), summarise, Count=sum(Quantity))
colnames(Coins)<- c("Project", "Phase", "Category","Count")


#Create new column to hold aggregation category
HermGA$Category <- HermGA$GenArtifactForm

#Assign categories to different gen art forms
HermGA$Category[HermGA$Category =='Doll, Frozen Charlotte'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Doll, head'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Doll, limb'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Doll, other'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Doll, eye'] <- 'Toy_Game'
HermGA$Category[HermGA$Category == 'Figurine'] <- 'DecorativeHome'
HermGA$Category[HermGA$Category =='Gaming Piece'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Gaming Piece, die'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Domino'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Marble, toy'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Fan Blade/Part'] <- 'Accessory'
HermGA$Category[HermGA$Category =='Toy, car'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Toy, cannon'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Toy, dish'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Toy, figurine'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Toy, other'] <- 'Toy_Game'
HermGA$Category[HermGA$Category =='Spectacles'] <- 'Accessory'
HermGA$Category[HermGA$Category =='Eye Glass'] <- 'Accessory'
HermGA$Category[HermGA$Category =='Slate, writing'] <- 'Education'
HermGA$Category[HermGA$Category =='Aiglet'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Crinoline, clamp'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Eye, clothing'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Rivet, clothing'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Fasetener, clothing'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Purse Part, clasp'] <- 'Accessory'
HermGA$Category[HermGA$Category =='Purse Part, mesh'] <- 'Accessory'
HermGA$Category[HermGA$Category =='Fasetener, corset'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Parasol/Umbrella, other'] <- 'Accessory'
HermGA$Category[HermGA$Category =='Parasol/Umbrella, stretcher/rib'] <- 'Accessory'
HermGA$Category[HermGA$Category =='Hook, clothing'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Musical Instrument, key'] <- 'Music'
HermGA$Category[HermGA$Category =='Musical Instrument, unidentifiable']<-'Music'
HermGA$Category[HermGA$Category =='Rivet, clothing'] <-'Clothing'
HermGA$Category[HermGA$Category =='Hair Clasp'] <- 'Accessory'
#HermGA$Category[HermGA$Category =='Knife, folding'
HermGA$Category[HermGA$Category =='Pencil, slate'] <- 'Education'
HermGA$Category[HermGA$Category =='Suspender Brace'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Suspender, hook'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Plate, trunk'] <- 'DecorativeHome'
HermGA$Category[HermGA$Category =='Gun Part, unidentified'] <- 'GunParts_Ammunition_FoodProcurement'
HermGA$Category[HermGA$Category =='Gun, hammer'] <- 'GunParts_Ammunition_FoodProcurement'
HermGA$Category[HermGA$Category =='Gun, plate'] <- 'GunParts_Ammunition_FoodProcurement'
HermGA$Category[HermGA$Category == 'Comb, folding'] <- 'Hygiene'
HermGA$Category[HermGA$Category =='Comb, hair'] <- 'Hygiene'
HermGA$Category[HermGA$Category =='Harmonica Plate and Reed'] <- 'Music'
HermGA$Category[HermGA$Category =='Comb, nit/lice'] <- 'Hygiene'
HermGA$Category[HermGA$Category =='Curling Iron'] <- 'Hygiene'
HermGA$Category[HermGA$Category =='Harmonica Reed'] <- 'Music'
HermGA$Category[HermGA$Category =='Toothbrush'] <- 'Hygiene'
HermGA$Category[HermGA$Category =='Razor'] <- 'Hygiene'
HermGA$Category[HermGA$Category =='Chandelier/Epergne Pendant'] <- 'DecorativeHome'
HermGA$Category[HermGA$Category =='Fork, toasting'] <- 'Utensil'
HermGA$Category[HermGA$Category =='Shoe Sole'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Shoe Upper'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Shoe, tip'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Shoe, tap'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Shoe, heel'] <- 'Clothing'
HermGA$Category[HermGA$Category =='Rivet, shoe'] <- 'Clothing'
#HermGA$Category[HermGA$Category =='Ornament, misc.' I think we may need to bring in notes here to determine categoryy
HermGA$Category[HermGA$Category =='Flask, powder'] <- 'GunParts_Ammunition_FoodProcurement'
HermGA$Category[HermGA$Category =='Gunflint'] <- 'GunParts_Ammunition_FoodProcurement'
HermGA$Category[HermGA$Category =='Fish Hook'] <- 'GunParts_Ammunition_FoodProcurement'
HermGA$Category[HermGA$Category =='Weight, Net'] <- 'GunParts_Ammunition_FoodProcurement'
HermGA$Category[HermGA$Category =='Horse Furniture'] <- 'Horse'
HermGA$Category[HermGA$Category =='Brooch'] <- 'Jewelry'
HermGA$Category[HermGA$Category =='Chain, watch'] <- 'Accessory'
HermGA$Category[HermGA$Category =='Charm, hand'] <- 'Jewelry'
HermGA$Category[HermGA$Category =='Cuff Link'] <- 'Button'
HermGA$Category[HermGA$Category =='Jewel'] <- 'Jewelry'
HermGA$Category[HermGA$Category =='Jewelry, earring'] <- 'Jewelry'
HermGA$Category[HermGA$Category =='Jewelry, other'] <- 'Jewelry'
HermGA$Category[HermGA$Category =='Jewelry, pendant'] <- 'Jewelry'
HermGA$Category[HermGA$Category =='Jewelry, Pin'] <- 'Jewelry'
HermGA$Category[HermGA$Category =='Medal, religious'] <- 'Jewelry'
HermGA$Category[HermGA$Category =='Pendant'] <- 'Jewelry'
HermGA$Category[HermGA$Category =='Ring, jewelry'] <- 'Jewelry'
#HermGA$Category[HermGA$Category =='Bell',
#HermGA$Category[HermGA$Category =='Boss, other'
#HermGA$Category[HermGA$Category =='Corkscrew, other'
HermGA$Category[HermGA$Category =='Plate, printing'] <- 'Social'
HermGA$Category[HermGA$Category =='Tack, antimacassar'] <- 'DecorativeHome'
#HermGA$Category[HermGA$Category =='Tip, cane/umbrella/furniture'
#HermGA$Category[HermGA$Category =='Token'
HermGA$Category[HermGA$Category =='Accordion Plate'] <- 'Music'
HermGA$Category[HermGA$Category =='Harmonica Plate'] <- 'Music'
HermGA$Category[HermGA$Category =='Jews/Jaw Harp'] <- 'Music'
HermGA$Category[HermGA$Category =='Musical Instrument'] <- 'Music'
HermGA$Category[HermGA$Category =='Needle'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Needle Case'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Pin, straight'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Scissors'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Thimble'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Accordion Plate and Reed'] <- 'Music'
#HermGA$Category[HermGA$Category =='Seal'
HermGA$Category[HermGA$Category =='Syringe'] <- 'Medical'
HermGA$Category[HermGA$Category =='Stirrup'] <- 'Horse'
HermGA$Category[HermGA$Category =='Spur'] <- 'Horse'
HermGA$Category[HermGA$Category =='Blank, button'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Bodkin'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Bobbin, lace'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Darning Egg'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Hook, crochet'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Hook, tambour'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Knitting Needle Guards'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Needle, mattress'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Thread Spool'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Sewing Equipment, unidentified'] <- 'Sewing'
HermGA$Category[HermGA$Category =='Clock/Watch part'] <- 'Accessory'
HermGA$Category[HermGA$Category == 'Key, watch'] <- 'Accessory'
HermGA$Category[HermGA$Category == 'Watch Gear'] <- 'Accessory'
HermGA$Category[HermGA$Category == 'Watch Part'] <- 'Accessory'

#Create dataframe by project and glass form
GenArts<-ddply(HermGA, .(ProjectID, ExcavatorPhase, Category), summarise, Count=sum(Quantity))
GenArts2 <- subset(GenArts, GenArts$Category %in% c('Accessory', 'Clothing', 'Hygiene',
                                                      'Medical','Utensil', 'DecorativeHome',
                                                      'Sewing', 'Horse', 'Music', 'Jewelry',
                                                      'GunParts_Ammunition_FoodProcurement',
                                                      'Buttons', 'Social', 'Education',
                                                    'Toy_Game'))
colnames(GenArts2)<- c("Project","Phase", "Category","Count")

##Section 3: Utensils ######################
HermUten <-dbGetQuery(DRCcon,'
                      SELECT
                      "public"."tblContext"."ProjectID",
                      "public"."tblContext"."Context",
                      "public"."tblUtensil"."Quantity",
"public"."tblContext"."DAACSPhase",
"public"."tblContext"."ExcavatorPhase"

                      FROM
                      "public"."tblContext"
                      INNER JOIN "public"."tblContextSample" ON "public"."tblContextSample"."ContextAutoID" = "public"."tblContext"."ContextAutoID"
                      INNER JOIN "public"."tblGenerateContextArtifactID" ON "public"."tblContextSample"."ContextSampleID" = "public"."tblGenerateContextArtifactID"."ContextSampleID"
                      INNER JOIN "public"."tblUtensil" ON "public"."tblUtensil"."GenerateContextArtifactID" = "public"."tblGenerateContextArtifactID"."GenerateContextArtifactID"
                      WHERE
                      
                      "public"."tblContext"."ProjectID" = \'1400\'OR
                      "public"."tblContext"."ProjectID" = \'1401\'OR
                      "public"."tblContext"."ProjectID" = \'1403\'OR
                      "public"."tblContext"."ProjectID" = \'1404\'OR
                      "public"."tblContext"."ProjectID" = \'1402\'OR
                      "public"."tblContext"."ProjectID" = \'1410\'OR
                      "public"."tblContext"."ProjectID" = \'1412\'OR
                      "public"."tblContext"."ProjectID" = \'1406\'OR
                      "public"."tblContext"."ProjectID" = \'1407\'OR
                      "public"."tblContext"."ProjectID" = \'1405\'
                      ')    

#HermUten$ProjectID[(HermUten$ProjectID == 1405) & (HermUten$DAACSPhase =="P01")] <- 4000
#Create Project ID and ExcavatorPhase field
#HermUten$Project <- paste(HermUten$ProjectID,HermUten$ExcavatorPhase,sep='_')


#Aggregate by project and form, add category
Utensil<-ddply(HermUten, .(ProjectID, ExcavatorPhase), summarise, Count=sum(Quantity))
colnames(Utensil)<- c("Project","Phase", "Count")
Utensil$Category <- 'Utensil'

##Section 4: Pipes ######################
HermPipe <-dbGetQuery(DRCcon,'
                      SELECT
                      "public"."tblContext"."ProjectID",
                      "public"."tblContext"."ExcavatorPhase",
                      "public"."tblTobaccoPipe"."Quantity",
"public"."tblContext"."DAACSPhase"
                      FROM
                      "public"."tblContext"
                      INNER JOIN "public"."tblContextSample" ON "public"."tblContextSample"."ContextAutoID" = "public"."tblContext"."ContextAutoID"
                      INNER JOIN "public"."tblGenerateContextArtifactID" ON "public"."tblContextSample"."ContextSampleID" = "public"."tblGenerateContextArtifactID"."ContextSampleID"
                      INNER JOIN "public"."tblTobaccoPipe" ON "public"."tblTobaccoPipe"."GenerateContextArtifactID" = "public"."tblGenerateContextArtifactID"."GenerateContextArtifactID"
                      WHERE                     
                      "public"."tblContext"."ProjectID" = \'1400\'OR
                      "public"."tblContext"."ProjectID" = \'1401\'OR
                      "public"."tblContext"."ProjectID" = \'1403\'OR
                      "public"."tblContext"."ProjectID" = \'1404\'OR
                      "public"."tblContext"."ProjectID" = \'1402\'OR
                      "public"."tblContext"."ProjectID" = \'1410\'OR
                      "public"."tblContext"."ProjectID" = \'1412\'OR
                      "public"."tblContext"."ProjectID" = \'1406\'OR
                      "public"."tblContext"."ProjectID" = \'1407\'OR
                      "public"."tblContext"."ProjectID" = \'1405\'
                      ')  

#HermPipe$ProjectID[(HermPipe$ProjectID == 1405) & (HermPipe$DAACSPhase =="P01")] <- 4000
#HermPipe$Project <- paste(HermPipe$ProjectID,HermPipe$ExcavatorPhase,sep='_')

#Aggregate by project and form, add category
Pipe<-ddply(HermPipe, .(ProjectID, ExcavatorPhase), summarise, Count=sum(Quantity))
colnames(Pipe)<- c("Project","Phase", "Count")
Pipe$Category <- 'Pipes'
#Pipe <- Pipe[,c("Project","Category","Count")]

##Section 5: Beads ######################
HermBead <-dbGetQuery(DRCcon,'
                      SELECT
                      "public"."tblContext"."ProjectID",
                      "public"."tblBeadMaterial"."BeadMaterial",
"public"."tblContext"."DAACSPhase",
"public"."tblBead"."Quantity",
"public"."tblContext"."ExcavatorPhase"
                      FROM
                      "public"."tblContext"
                      INNER JOIN "public"."tblContextSample" ON "public"."tblContextSample"."ContextAutoID" = "public"."tblContext"."ContextAutoID"
                      INNER JOIN "public"."tblGenerateContextArtifactID" ON "public"."tblContextSample"."ContextSampleID" = "public"."tblGenerateContextArtifactID"."ContextSampleID"
                      INNER JOIN "public"."tblBead" ON "public"."tblBead"."GenerateContextArtifactID" = "public"."tblGenerateContextArtifactID"."GenerateContextArtifactID"
                      INNER JOIN "public"."tblBeadMaterial" ON "public"."tblBead"."BeadMaterialID" = "public"."tblBeadMaterial"."BeadMaterialID"
                      
                      WHERE                     
                      "public"."tblContext"."ProjectID" = \'1400\'OR
                      "public"."tblContext"."ProjectID" = \'1401\'OR
                      "public"."tblContext"."ProjectID" = \'1403\'OR
                      "public"."tblContext"."ProjectID" = \'1404\'OR
                      "public"."tblContext"."ProjectID" = \'1402\'OR
                      "public"."tblContext"."ProjectID" = \'1410\'OR
                      "public"."tblContext"."ProjectID" = \'1412\'OR
                      "public"."tblContext"."ProjectID" = \'1406\'OR
                      "public"."tblContext"."ProjectID" = \'1407\'OR
                      "public"."tblContext"."ProjectID" = \'1405\'
                      ')    


#HermBead$ProjectID[(HermBead$ProjectID == 1405) & (HermBead$DAACSPhase =="P01")] <- 4000
#HermBead$Project <- paste(HermBead$ProjectID,HermBead$ExcavatorPhase,sep='_')

#Aggregate by project and form, add category
Bead <- subset(HermBead, ! HermBead$BeadMaterial %in% c('Plastic'))
Bead2<-ddply(Bead, .(ProjectID, ExcavatorPhase), summarise, Count=sum(Quantity))
colnames(Bead2)<- c("Project","Phase", "Count")
Bead2$Category <- 'Jewelry'
#Bead2 <- Bead2[,c("Project","Category","Count")]


##Section 6: Buckles ######################
HermBuckle <-dbGetQuery(DRCcon,'
                        SELECT
                        "public"."tblContext"."ProjectID",
"public"."tblContext"."DAACSPhase",
                        "public"."tblBuckle"."Quantity",
                        "public"."tblBuckleType"."BuckleType",
"public"."tblContext"."ExcavatorPhase"

                        
                        FROM
                        "public"."tblContext"
                        INNER JOIN "public"."tblContextSample" ON "public"."tblContextSample"."ContextAutoID" = "public"."tblContext"."ContextAutoID"
                        INNER JOIN "public"."tblGenerateContextArtifactID" ON "public"."tblContextSample"."ContextSampleID" = "public"."tblGenerateContextArtifactID"."ContextSampleID"
                        INNER JOIN "public"."tblBuckle" ON "public"."tblBuckle"."GenerateContextArtifactID" = "public"."tblGenerateContextArtifactID"."GenerateContextArtifactID"
                        INNER JOIN "public"."tblBuckleType" ON "public"."tblBuckle"."BuckleTypeID" = "public"."tblBuckleType"."BuckleTypeID"
                        WHERE                     
                        "public"."tblContext"."ProjectID" = \'1400\'OR
                        "public"."tblContext"."ProjectID" = \'1401\'OR
                        "public"."tblContext"."ProjectID" = \'1403\'OR
                        "public"."tblContext"."ProjectID" = \'1404\'OR
                        "public"."tblContext"."ProjectID" = \'1402\'OR
                        "public"."tblContext"."ProjectID" = \'1410\'OR
                        "public"."tblContext"."ProjectID" = \'1412\'OR
                        "public"."tblContext"."ProjectID" = \'1406\'OR
                        "public"."tblContext"."ProjectID" = \'1407\'OR
                        "public"."tblContext"."ProjectID" = \'1405\'
                        ')

#HermBuckle$ProjectID[(HermBuckle$ProjectID == 1405) & (HermBuckle$DAACSPhase =="P01")] <- 4000
#HermBuckle$Project <- paste(HermBuckle$ProjectID,HermBuckle$ExcavatorPhase,sep='_')

#Aggregate by project and form, add category
Buckle <- subset(HermBuckle, ! HermBuckle$BuckleType %in% c('Unid: Harness/Util.', 'Unidentifiable'))
Buckle2<-ddply(Buckle, .(ProjectID, ExcavatorPhase), summarise, Count=sum(Quantity))
colnames(Buckle2)<- c("Project","Phase", "Count")
Buckle2$Category <- 'Buckles'
#Buckle2 <- Buckle2[,c("Project","Category","Count")]


##Section 7: Buttons ######################
HermButton <-dbGetQuery(DRCcon,'
                        SELECT
                        "public"."tblContext"."ProjectID",
                        "public"."tblContext"."DAACSPhase",
                        "public"."tblButtonMaterial"."ButtonMaterial",
                        "public"."tblButton"."Quantity",
"public"."tblContext"."ExcavatorPhase"

                        FROM
                        "public"."tblContext"
                        INNER JOIN "public"."tblContextSample" ON "public"."tblContextSample"."ContextAutoID" = "public"."tblContext"."ContextAutoID"
                        INNER JOIN "public"."tblGenerateContextArtifactID" ON "public"."tblContextSample"."ContextSampleID" = "public"."tblGenerateContextArtifactID"."ContextSampleID"
                        INNER JOIN "public"."tblButton" ON "public"."tblButton"."GenerateContextArtifactID" = "public"."tblGenerateContextArtifactID"."GenerateContextArtifactID"
                        INNER JOIN "public"."tblButtonMaterial" ON "public"."tblButton"."ButtonMaterialID" = "public"."tblButtonMaterial"."ButtonMaterialID"
                        WHERE                     
                        "public"."tblContext"."ProjectID" = \'1400\'OR
                        "public"."tblContext"."ProjectID" = \'1401\'OR
                        "public"."tblContext"."ProjectID" = \'1403\'OR
                        "public"."tblContext"."ProjectID" = \'1404\'OR
                        "public"."tblContext"."ProjectID" = \'1402\'OR
                        "public"."tblContext"."ProjectID" = \'1410\'OR
                        "public"."tblContext"."ProjectID" = \'1412\'OR
                        "public"."tblContext"."ProjectID" = \'1406\'OR
                        "public"."tblContext"."ProjectID" = \'1407\'OR
                        "public"."tblContext"."ProjectID" = \'1405\'
                        ')    

#HermButton$ProjectID[(HermButton$ProjectID == 1405) & (HermButton$DAACSPhase =="P01")] <- 4000
#HermButton$Project <- paste(HermButton$ProjectID,HermButton$ExcavatorPhase,sep='_')

ButtonX <- subset(HermButton, ! HermButton$ButtonMaterial %in% c('Synthetic/Modern'))
Button<-ddply(ButtonX, .(ProjectID, ExcavatorPhase), summarise, Count=sum(Quantity))
colnames(Button)<- c("Project","Phase", "Count")
Button$Category <- 'Buttons'
#Button <- Button[,c("Project","Category","Count")]

#ddply(Button, .(Project), summarise, Count=sum(Count))



##Section 8: Create one table ######################

#Bind together all artifact category tables
#SmallFinds <- rbind(Ink, Pharm, Pipe, Utensil, GenArts2, Coins, Buckle2, Bead2, Button)
SmallFinds <- rbind(Ink, Pipe, Utensil, GenArts2, Coins, Buckle2, Bead2, Button)

#Summarize file by project and category
SmallFindsX <- ddply(SmallFinds, .(Project, Phase, Category), summarise, Count=sum(Count))
SmallFindsX$Phase[SmallFindsX$Phase=='']<-NA
SmallFindsX2 <- subset(SmallFindsX, ! is.na(SmallFindsX$Phase))

#Create new field to match against 'zeros' dataframe
SmallFindsX2$match <- paste(SmallFindsX2$Project,SmallFindsX2$Phase,SmallFindsX2$Category)
# 
# #Read in zeros file, create new field to match againt 'small finds' dataframe
# zeros <- read.csv("zeros.csv", header = T, stringsAsFactors = F)
# zeros$Project<-as.character(zeros$Project)
# zeros$match <- paste(zeros$Project,zeros$Category)
# 
# #Merge zeros and small finds and add zeros in for NA values
# SmallFinds2 <- merge(zeros, SmallFindsX, by.x='match', by.y='match', all=T)
# SmallFinds3 <- SmallFinds2[c(2,3,6)]
# colnames(SmallFinds3)<- c("Project","Category", "Count")
# SmallFinds3$Count[is.na(SmallFinds3$Count)] <- 0

#Read in zeros file, create new field to match againt 'small finds' dataframe
setwd('P:/SHA/2018/Hermitage2018/GalleBlochBates/ArtifactIndex')
zerosQ <- read.csv("zeros_qphase.csv", header = T, stringsAsFactors = F)
zerosQ2 <- read.csv("SitePhase.csv", header = T, stringsAsFactors = F)
colnames(zerosQ)<- c("Phase", "Category")
zerosQ3 <- merge(zerosQ, zerosQ2, by='Phase')
#zerosQ3$QPhase <- paste(zerosQ3$Project,zerosQ3$Phase, sep="_")

zerosQ3$match <- paste(zerosQ3$Project,zerosQ3$Phase,zerosQ3$Category)

#Merge zeros and small finds and add zeros in for NA values
SmallFinds2 <- merge(zerosQ3, SmallFindsX2, by.x='match', by.y='match', all=T)
SmallFinds3 <- SmallFinds2[c(2,4, 3,8)]
colnames(SmallFinds3)<- c("Phase", "Project","Category", "Count")
SmallFinds3$Count[is.na(SmallFinds3$Count)] <- 0
SmallFinds3$Project<- as.character(SmallFinds3$Project)

##Section 9: Index with All Cerm Denominator ######################
HermCerm <-dbGetQuery(DRCcon,'
                    SELECT
                      "public"."tblContext"."ProjectID",
                      "public"."tblCeramic"."Quantity",
                      "public"."tblCeramicWare"."Ware",
"public"."tblContext"."DAACSPhase",
"public"."tblContext"."ExcavatorPhase"

                      FROM
                      "public"."tblContext"
                      INNER JOIN "public"."tblContextSample" ON "public"."tblContextSample"."ContextAutoID" = "public"."tblContext"."ContextAutoID"
                      INNER JOIN "public"."tblGenerateContextArtifactID" ON "public"."tblContextSample"."ContextSampleID" = "public"."tblGenerateContextArtifactID"."ContextSampleID"
                      INNER JOIN "public"."tblCeramic" ON "public"."tblCeramic"."GenerateContextArtifactID" = "public"."tblGenerateContextArtifactID"."GenerateContextArtifactID"
                      INNER JOIN "public"."tblCeramicWare" ON "public"."tblCeramic"."WareID" = "public"."tblCeramicWare"."WareID"
                      WHERE                     
                      "public"."tblContext"."ProjectID" = \'1400\'OR
                      "public"."tblContext"."ProjectID" = \'1401\'OR
                      "public"."tblContext"."ProjectID" = \'1403\'OR
                      "public"."tblContext"."ProjectID" = \'1404\'OR
                      "public"."tblContext"."ProjectID" = \'1402\'OR
                      "public"."tblContext"."ProjectID" = \'1410\'OR
                      "public"."tblContext"."ProjectID" = \'1412\'OR
                      "public"."tblContext"."ProjectID" = \'1406\'OR
                      "public"."tblContext"."ProjectID" = \'1407\'OR
                      "public"."tblContext"."ProjectID" = \'1405\'
                      ')             

#HermCerm$ProjectID[(HermCerm$ProjectID == 1405) & (HermCerm$DAACSPhase =="P01")] <- 4000
#HermCerm$Project <- paste(HermCerm$ProjectID,HermCerm$ExcavatorPhase,sep='_')

HermCerm$ExcavatorPhase[HermCerm$ExcavatorPhase==''] <- NA
HermCerm2 <- subset(HermCerm, ! is.na(HermCerm$ExcavatorPhase))

#Create sum of glass by project to use in abundance indices
cerm_sum<-ddply(HermCerm2, .(ProjectID, ExcavatorPhase), summarise, Count=sum(Quantity))
colnames(cerm_sum)<- c("Project","Phase","cerm")

#Create index values using all ceramic counts by project
require(dplyr)
cermIndexA <- left_join(SmallFinds3,cerm_sum, by = c("Phase" = "Phase", "Project"="Project"))
cermIndexA$cerm[is.na(cermIndexA$cerm)] <- 0

#Read in phase MCDs
#SiteMCD <- read.csv("MCDbySiteQPhase.csv", stringsAsFactors = F, header = T)
cerm_sumQ <- read.csv("CermSumQPhaseONLY.csv", stringsAsFactors = F, header = T)

# #Split Project and Quad Phase
# library(stringr)
# Name <- data.frame(str_split_fixed(cermIndexA$Project, "_", 2))
# colnames(Name)<-c("Proj", "QPhase") 

# CA_MCD$SiteName <- as.character(Name$Proj)
# CA_MCD$SPhase <- Name$SPhase
# CA_MCD$SiteName[(grepl("^1406", CA_MCD$unit))] <- 'Cab1'
# CA_MCD$SiteName[(grepl("^1401", CA_MCD$unit))] <- 'Cab2'
# CA_MCD$SiteName[(grepl("^1405", CA_MCD$unit))] <- 'Cab3'
# CA_MCD$SiteName[(grepl("^1407", CA_MCD$unit))] <- 'Cab4'
# CA_MCD$SiteName[(grepl("^1403", CA_MCD$unit))] <- 'KES'
# CA_MCD$SiteName[(grepl("^1400", CA_MCD$unit))] <- 'TPX'
# CA_MCD$SiteName[(grepl("^1404", CA_MCD$unit))] <- 'Yard'
# CA_MCD$SiteName[(grepl("^1402", CA_MCD$unit))] <- 'South'
# CA_MCD$SiteName[(grepl("^1410", CA_MCD$unit))] <- 'East'
# CA_MCD$SiteName[(grepl("^1412", CA_MCD$unit))] <- 'West'

#Add quad phase back to cerm Index
# cermIndexA$qphase <- Name$QPhase
# cermIndexA$qphase[cermIndexA$qphase==''] <- NA
# cermIndexA$Project <- Name$Proj

#Merge files
#cermIndex <- merge(cermIndexA, SiteMCD, by.x="qphase", by.y="unit")
#colnames(cermIndex)<- c("Project","cerm","Category", "Count")

#####Section 9: Q PHASE ONLY #####################

#drop Project and project count from cermIndexA

cermIndexQ <- cermIndexA[-c(2,5)]
cermIndexQ2 <- ddply(cermIndexQ, .(Phase, Category), summarise, Count=sum(Count))

#Create index values using all ceramic counts by project
cermIndexQ3 <- merge(cerm_sumQ, cermIndexQ2, by.x="unit", by.y="Phase")
colnames(cermIndexQ3)<- c("Phase","Qcerm","blueMCD", "Category", "Count")

#Create column for total of small finds count plus ceramic count
cermIndexQ3$Total <- cermIndexQ3$Count+cermIndexQ3$Qcerm

#Create column for index value of small finds
cermIndexQ3$Index <- (cermIndexQ3$Count)/(cermIndexQ3$Total)

adjustedWaldCI<-function(count,total,alpha){
  nTilde <- total+4
  pTilde <- (count+2)/(total+4)
  se <- sqrt((pTilde*(1-pTilde))/(nTilde))
  upperCL <- pTilde + se * qnorm(1-(alpha/2))
  lowerCL <- pTilde + se * qnorm(alpha/2) 
  upperCL<-ifelse ( upperCL > 1, 1, upperCL)
  lowerCL <-ifelse ( lowerCL < 0, 0, lowerCL)                               
  return(data.frame(pTilde,upperCL,lowerCL))
}

#run function on form data
CIWareSite <- adjustedWaldCI(cermIndexQ3$Count,cermIndexQ3$Total,0.5)
cermIndexQ3$CIUpper <- CIWareSite$upperCL
cermIndexQ3$CILower <- CIWareSite$lowerCL
cermIndexQ3$p <- CIWareSite$pTilde

#make index values 0 for counts of 0
cermIndexQ3$Index[cermIndexQ3$Count == 0] <- 0
cermIndexQ3$CIUpper[cermIndexQ3$Count == 0] <- 0
cermIndexQ3$CILower[cermIndexQ3$Count == 0] <- 0

#Shorten names of Categories
cermIndexQ3$Category[cermIndexQ3$Category == 'DecorativeHome'] <- 'DecHome'
cermIndexQ3$Category[cermIndexQ3$Category == 'GunParts_Ammunition_FoodProcurement'] <- 'FoodProcure'

#Buttons only
Buttons_Allcerm <- subset(cermIndexQ3, cermIndexQ3$Category %in% c('Buttons'))

library(ggrepel)
#BtnsC <- ggplot(Buttons_Allcerm, aes(x=Buttons_Allcerm$Project, y=Buttons_Allcerm$Index, col=Buttons_Allcerm$Project)) +
Btns2 <- ggplot(Buttons_Allcerm, aes(x=Buttons_Allcerm$blueMCD, y=Buttons_Allcerm$Index)) +
  geom_point(aes(fill=Buttons_Allcerm$Phase), shape=21, size=6, alpha=0.6) +
  geom_errorbar(aes(ymin=Buttons_Allcerm$CILower, ymax=Buttons_Allcerm$CIUpper), colour="black", width=.1)+
 # geom_text_repel(aes(label=Buttons_Allcerm$Label), cex=5, segment.alpha=0.2) +
  theme_classic()+
  labs(x="blueMCD", y="Index Value")+
  ggtitle(expression(atop("Buttons Index by All Cerm", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  #scale_colour_brewer(name="Site", palette="Set3")+
  scale_y_continuous(breaks=seq(0, 0.2, 0.025))+
  scale_x_continuous(limits=c(1800,1890), breaks=seq(1800, 1890, 10))+
    #scale_fill_manual(name="Site", values=c("mediumspringgreen", "blue", "darkgreen", "darkgoldenrod1", "darkorange", "lightblue", "hotpink", "black", "red", "gray", "purple"))  
  scale_fill_manual(name="Phase", values=c("red", "blue", "darkgreen", "goldenrod1"))  
#  scale_fill_discrete(name="Site")
#guides(guide_legend(title="Site", text=c("Yard Cabin", "Triplex", "KES", "Cabin 4", "Cabin 3")))
#BtnsC
#ggsave("ButtonIndex_Allcerm.png", BtnsC, width=10, height=7.5, dpi=300)
Btns2
#ggsave("ButtonIndex_Allcerm_SiteMCD.png", Btns2, width=10, height=7.5, dpi=300)

#Buttons only
Sewing_Allcerm <- subset(cermIndexQ3, cermIndexQ3$Category %in% c('Sewing'))

library(ggrepel)
#BtnsC <- ggplot(Sewing_Allcerm, aes(x=Sewing_Allcerm$Project, y=Sewing_Allcerm$Index, col=Sewing_Allcerm$Project)) +
Sew2 <- ggplot(Sewing_Allcerm, aes(x=Sewing_Allcerm$blueMCD, y=Sewing_Allcerm$Index)) +
  geom_point(aes(fill=Sewing_Allcerm$Phase), shape=21, size=6, alpha=0.6) +
  geom_errorbar(aes(ymin=Sewing_Allcerm$CILower, ymax=Sewing_Allcerm$CIUpper), colour="black", width=.1)+
  # geom_text_repel(aes(label=Sewing_Allcerm$Label), cex=5, segment.alpha=0.2) +
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Sewing Index by All Cerm", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  #scale_colour_brewer(name="Site", palette="Set3")+
  #scale_y_continuous(breaks=seq(0, 0.2, 0.025))+
  scale_x_continuous(limits=c(1800,1890), breaks=seq(1800, 1890, 10))+
  scale_fill_manual(name="Phase", values=c("red", "blue", "darkgreen", "goldenrod1"))  
#  scale_fill_discrete(name="Site")
#guides(guide_legend(title="Site", text=c("Yard Cabin", "Triplex", "KES", "Cabin 4", "Cabin 3")))
#BtnsC
#ggsave("ButtonIndex_Allcerm.png", BtnsC, width=10, height=7.5, dpi=300)
Sew2
#ggsave("ButtonIndex_Allcerm_SiteMCD.png", Btns2, width=10, height=7.5, dpi=300)

#Buttons only
Clothing_Allcerm <- subset(cermIndexQ3, cermIndexQ3$Category %in% c('Clothing'))

library(ggrepel)
#BtnsC <- ggplot(Clothing_Allcerm, aes(x=Clothing_Allcerm$Project, y=Clothing_Allcerm$Index, col=Clothing_Allcerm$Project)) +
Clt2 <- ggplot(Clothing_Allcerm, aes(x=Clothing_Allcerm$blueMCD, y=Clothing_Allcerm$Index)) +
  geom_point(aes(fill=Clothing_Allcerm$Phase), shape=21, size=6, alpha=0.6) +
  geom_errorbar(aes(ymin=Clothing_Allcerm$CILower, ymax=Clothing_Allcerm$CIUpper), colour="black", width=.1)+
  # geom_text_repel(aes(label=Clothing_Allcerm$Label), cex=5, segment.alpha=0.2) +
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Clothing Index by All Cerm", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  scale_x_continuous(limits=c(1800,1890), breaks=seq(1800, 1890, 10))+
  scale_fill_manual(name="Area", values=c("red", "blue", "darkgreen", "goldenrod1"))  
#  scale_fill_discrete(name="Site")
Clt2
#ggsave("ButtonIndex_Allcerm_SiteMCD.png", Btns2, width=10, height=7.5, dpi=300)



#####Section 10: Q PHASE and Project #####################

#subset(cermIndex, cermIndex$Project==4000)

cermIndex$Total <- cermIndex$Count+cermIndex$cerm

cermIndex$Index <- (cermIndex$Count)/(cermIndex$Total)

adjustedWaldCI<-function(count,total,alpha){
  nTilde <- total+4
  pTilde <- (count+2)/(total+4)
  se <- sqrt((pTilde*(1-pTilde))/(nTilde))
  upperCL <- pTilde + se * qnorm(1-(alpha/2))
  lowerCL <- pTilde + se * qnorm(alpha/2) 
  upperCL<-ifelse ( upperCL > 1, 1, upperCL)
  lowerCL <-ifelse ( lowerCL < 0, 0, lowerCL)                               
  return(data.frame(pTilde,upperCL,lowerCL))
}

#run function on form data
CIWareSite <- adjustedWaldCI(cermIndex$Count,cermIndex$Total,0.5)
cermIndex$CIUpper <- CIWareSite$upperCL
cermIndex$CILower <- CIWareSite$lowerCL
cermIndex$p <- CIWareSite$pTilde


# cermIndex$Index[cermIndex$Count == 0] <- 0
# cermIndex$CIUpper[cermIndex$Count == 0] <- 0
# cermIndex$CILower[cermIndex$Count == 0] <- 0

#Shorten names of Categories
cermIndex$Category[cermIndex$Category == 'DecorativeHome'] <- 'DecHome'
cermIndex$Category[cermIndex$Category == 'GunParts_Ammunition_FoodProcurement'] <- 'FoodProcure'

#Create labels by Project
cermIndex$Label <- as.character(cermIndex$Project)
cermIndex$Label[cermIndex$Label == '1406'] <- 'Cab1'
cermIndex$Label[cermIndex$Label == '1401'] <- 'Cab2'
cermIndex$Label[cermIndex$Label == '1405'] <- 'Cab3'
cermIndex$Label[cermIndex$Label == '1407'] <- 'Cab4'
cermIndex$Label[cermIndex$Label == '1403'] <- 'KES'
cermIndex$Label[cermIndex$Label == '1400'] <- 'Triplex'
cermIndex$Label[cermIndex$Label == '1404'] <- 'YardCab'
cermIndex$Label[cermIndex$Label == '1402'] <- 'SouthCab'
cermIndex$Label[cermIndex$Label == '1410'] <- 'EastCab'
cermIndex$Label[cermIndex$Label == '1412'] <- 'WestCab'
#cermIndex$Label[cermIndex$Label == '4000'] <- 'FQ_LMK'
cermIndex$Area <- as.character(cermIndex$Project)
cermIndex$Area[cermIndex$Area == '1406'] <- 'FieldQtr'
cermIndex$Area[cermIndex$Area == '1401'] <- 'FieldQtr'
cermIndex$Area[cermIndex$Area == '1405'] <- 'FieldQtr'
cermIndex$Area[cermIndex$Area == '1407'] <- 'FieldQtr'
cermIndex$Area[cermIndex$Area == '1403'] <- 'FieldQtr'
cermIndex$Area[cermIndex$Area == '1400'] <- 'MBackYard'
cermIndex$Area[cermIndex$Area == '1404'] <- 'MBackYard'
cermIndex$Area[cermIndex$Area == '1402'] <- 'FirstHerm'
cermIndex$Area[cermIndex$Area == '1410'] <- 'FirstHerm'
cermIndex$Area[cermIndex$Area == '1412'] <- 'FirstHerm'


#Plot the Results
library(ggplot2)

PlotC <- ggplot(cermIndex, aes(x=cermIndex$Category, y=cermIndex$Index, col=cermIndex$blueMCD)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=cermIndex$CILower, ymax=cermIndex$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Category", y="Index Value")+
  ggtitle(expression(atop("All Categories by cerm Index", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2.5)),axis.title=element_text(size=rel(1.5)),
        axis.text=element_text(size=rel(1.25), angle=90, hjust=1), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(1.25)))
#scale_colour_brewer(name="Site")+
#scale_y_continuous(limits=c(0.0,0.2), breaks=seq(0, 0.2, 0.05))
#guides(fill=guide_legend(reverse=TRUE), 
#      colour=guide_legend(reverse=TRUE))
PlotC
#ggsave("AllCatIndex_AHH.png", PlotC, width=10, height=7.5, dpi=300)


LessThan_Allcerm <- subset(cermIndex, ! cermIndex$Category %in% c('Buttons','Sewing','Clothing'))

#PlotC2 <- ggplot(LessThan_Allcerm, aes(x=LessThan_Allcerm$Category, y=LessThan_Allcerm$Index, col=LessThan_Allcerm$Label)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=LessThan_Allcerm$CILower, ymax=LessThan_Allcerm$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Category", y="Index Value")+
  ggtitle(expression(atop("All Categories by cerm Index", atop(italic("95% Confidence Intervals"), "Values less than 0.03"))))+
  theme(plot.title=element_text(size=rel(2.5)),axis.title=element_text(size=rel(1.5)),
        axis.text=element_text(size=rel(1.25), angle=90, hjust=1), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(1.25)))+
  #scale_colour_brewer(name="Site")+
  scale_y_continuous(limits=c(0.0,0.03), breaks=seq(0, 0.03, 0.01))
#guides(fill=guide_legend(reverse=TRUE), 
#      colour=guide_legend(reverse=TRUE))
PlotC2
ggsave("AllCatIndex_AllCerm_ValuesLessThan03.png", PlotC2, width=10, height=7.5, dpi=300)


#Buttons only
Buttons_Allcerm <- subset(cermIndex, cermIndex$Category %in% c('Buttons'))

library(ggrepel)
#BtnsC <- ggplot(Buttons_Allcerm, aes(x=Buttons_Allcerm$Project, y=Buttons_Allcerm$Index, col=Buttons_Allcerm$Project)) +
Btns2 <- ggplot(Buttons_Allcerm, aes(x=Buttons_Allcerm$blueMCD, y=Buttons_Allcerm$Index)) +
  geom_point(aes(fill=Buttons_Allcerm$Area), shape=21, size=6, alpha=0.6) +
  geom_errorbar(aes(ymin=Buttons_Allcerm$CILower, ymax=Buttons_Allcerm$CIUpper), colour="black", width=.1)+
geom_text_repel(aes(label=Buttons_Allcerm$Label), cex=5, segment.alpha=0.2) +
      theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Buttons Index by All Cerm", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  #scale_colour_brewer(name="Site", palette="Set3")+
  scale_y_continuous(breaks=seq(0, 0.2, 0.025))+
#scale_fill_manual(name="Site", values=c("mediumspringgreen", "blue", "darkgreen", "darkgoldenrod1", "darkorange", "lightblue", "hotpink", "black", "red", "gray", "purple"))  
scale_fill_manual(name="Area", values=c("red", "blue", "darkgreen"))  
#  scale_fill_discrete(name="Site")
  #guides(guide_legend(title="Site", text=c("Yard Cabin", "Triplex", "KES", "Cabin 4", "Cabin 3")))
#BtnsC
#ggsave("ButtonIndex_Allcerm.png", BtnsC, width=10, height=7.5, dpi=300)
Btns2
#ggsave("ButtonIndex_Allcerm_SiteMCD.png", Btns2, width=10, height=7.5, dpi=300)

#Medical only
# Med_Allcerm <- subset(cermIndex, cermIndex$Category %in% c('Medical_Pharm'))
# PharmC <- ggplot(Med_Allcerm, aes(x=Med_Allcerm$Project, y=Med_Allcerm$Index, col=Med_Allcerm$Project)) +
#   geom_point(size=6,shape=19)+
#   geom_errorbar(aes(ymin=Med_Allcerm$CILower, ymax=Med_Allcerm$CIUpper), colour="black", width=.1)+
#   theme_classic()+
#   labs(x="Site", y="Index Value")+
#   ggtitle(expression(atop("Pharm Index by All Cerm", atop(italic("95% Confidence Intervals"), ""))))+
#   theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
#         axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(2)),
#         legend.title=element_text(size=rel(2)))+
#   scale_colour_brewer(name="Area", palette="Set3")+
#   #scale_y_continuous(limits=c(0.0,0.1), breaks=seq(0, 0.1, 0.05))+
#   guides(fill=guide_legend(reverse=TRUE), 
#          colour=guide_legend(reverse=TRUE))
# PharmC
# ggsave("PharmIndex_Allcerm.png", PharmC, width=10, height=7.5, dpi=300)

#Sewing only
Sew_Allcerm <- subset(cermIndex, cermIndex$Category %in% c('Sewing'))

Sew2 <- ggplot(Sew_Allcerm, aes(x=Sew_Allcerm$blueMCD, y=Sew_Allcerm$Index)) +
  geom_point(aes(fill=Sew_Allcerm$Area), shape=21, size=6) +
  geom_errorbar(aes(ymin=Sew_Allcerm$CILower, ymax=Sew_Allcerm$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Sewing Tools Index by All Cerm", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  #scale_colour_brewer(name="Site", palette="Set3")+
  scale_y_continuous(breaks=seq(0, 0.4, 0.025))+
  scale_fill_manual(name="Site", values=c("mediumspringgreen", "blue", "darkgreen", "darkgoldenrod1", "darkorange", "lightblue", "hotpink", "black", "red", "gray", "purple"))  

ggsave("SewingIndex_Allcerm_SiteMCDs_LMK.png", Sew2, width=10, height=7.5, dpi=300)


SewC <- ggplot(Sew_Allcerm, aes(x=Sew_Allcerm$Project, y=Sew_Allcerm$Index, col=Sew_Allcerm$Project)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=Sew_Allcerm$CILower, ymax=Sew_Allcerm$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Sew Index by All Cerm", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(2)),
        legend.title=element_text(size=rel(2)))+
  scale_colour_brewer(name="Area", palette="Set3")+
  #scale_y_continuous(limits=c(0.0,0.1), breaks=seq(0, 0.1, 0.05))+
  guides(fill=guide_legend(reverse=TRUE), 
         colour=guide_legend(reverse=TRUE))
SewC
ggsave("SewingIndex_Allcerm.png", SewC, width=10, height=7.5, dpi=300)

#Toys, Jewelry, Pipes, Clothing, Acc
Toys <- subset(cermIndex, cermIndex$Category %in% c('Toy_Game'))
Jewel <- subset(cermIndex, cermIndex$Category %in% c('Jewelry'))
Pipes <- subset(cermIndex, cermIndex$Category %in% c('Pipes'))
Cloth <- subset(cermIndex, cermIndex$Category %in% c('Clothing'))
Acc <- subset(cermIndex, cermIndex$Category %in% c('Accessory'))

PToy <- ggplot(Toys, aes(x=Toys$blueMCD, y=Toys$Index)) +
  geom_point(aes(fill=Toys$Label), shape=21, size=6) +
  geom_errorbar(aes(ymin=Toys$CILower, ymax=Toys$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Toy and Gaming Index by All Ceramic", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  #scale_colour_brewer(name="Site", palette="Set3")+
  scale_y_continuous(breaks=seq(0, 0.1, 0.01))+
  scale_fill_manual(name="Site", values=c("blue", "green", "yellow", "orange", "lightblue", "pink", "black", "red", "gray", "purple"))  
PToy
ggsave("ToyIndex_Allcerm_SiteMCDs.png", PToy, width=10, height=7.5, dpi=300)

PCloth <- ggplot(Cloth, aes(x=Cloth$blueMCD, y=Cloth$Index)) +
  geom_point(aes(fill=Cloth$Label), shape=21, size=6) +
  geom_errorbar(aes(ymin=Cloth$CILower, ymax=Cloth$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Clothing (non-Button) Index by All Ceramic", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  #scale_colour_brewer(name="Site", palette="Set3")+
  scale_y_continuous(breaks=seq(0, 0.1, 0.01))+
  scale_fill_manual(name="Site", values=c("blue", "green", "yellow", "orange", "lightblue", "pink", "black", "red", "gray", "purple"))  
PCloth
ggsave("ClothIndex_Allcerm_SiteMCDs.png", PCloth, width=10, height=7.5, dpi=300)

cerm <- ggplot(cermIndex, aes(x=cermIndex$blueMCD, y=cermIndex$cerm)) +
  geom_point(aes(fill=cermIndex$Label), shape=21, size=6) +
  # geom_errorbar(aes(ymin=ClothG$CILower, ymax=ClothG$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="BLUEMCD", y="Count")+
  ggtitle(expression(atop("Ceramic Counts by Project", atop(italic(""), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  #scale_colour_brewer(name="Site", palette="Set3")+
  scale_y_continuous(breaks=seq(0, 18000, 2000))+
  scale_fill_manual(name="Site", values=c("blue", "green", "yellow", "orange", "lightblue", "pink", "black", "red", "gray", "purple"))  
cerm
ggsave("Allcerm_SiteMCDs.png", cerm, width=10, height=7.5, dpi=300)


##Section 11: Index with All Glass Denominator ######################

GlassIndexA <- merge(glass_sum, SmallFinds3, by.x="ProjectID", by.y="Project")
colnames(GlassIndexA)<- c("Project","Glass","Category", "Count")

#Read in site MCDs
SiteMCD <- read.csv("MCDbyProject.csv", stringsAsFactors = F, header = T)

#Merge files
GlassIndex <- merge(GlassIndexA, SiteMCD, by.x="Project", by.y="unit")
#colnames(GlassIndex)<- c("Project","Glass","Category", "Count")


GlassIndex$Total <- GlassIndex$Count+GlassIndex$Glass

GlassIndex$Index <- (GlassIndex$Count)/(GlassIndex$Total)

adjustedWaldCI<-function(count,total,alpha){
  nTilde <- total+4
  pTilde <- (count+2)/(total+4)
  se <- sqrt((pTilde*(1-pTilde))/(nTilde))
  upperCL <- pTilde + se * qnorm(1-(alpha/2))
  lowerCL <- pTilde + se * qnorm(alpha/2) 
  upperCL<-ifelse ( upperCL > 1, 1, upperCL)
  lowerCL <-ifelse ( lowerCL < 0, 0, lowerCL)                               
  return(data.frame(pTilde,upperCL,lowerCL))
}

#run function on form data
CIWareSite <- adjustedWaldCI(GlassIndex$Count,GlassIndex$Total,0.5)
GlassIndex$CIUpper <- CIWareSite$upperCL
GlassIndex$CILower <- CIWareSite$lowerCL
GlassIndex$p <- CIWareSite$pTilde


# GlassIndex$Index[GlassIndex$Count == 0] <- 0
# GlassIndex$CIUpper[GlassIndex$Count == 0] <- 0
# GlassIndex$CILower[GlassIndex$Count == 0] <- 0

GlassIndex$Category[GlassIndex$Category == 'DecorativeHome'] <- 'DecHome'
GlassIndex$Category[GlassIndex$Category == 'GunParts_Ammunition_FoodProcurement'] <- 'FoodProcure'

GlassIndex$Label <- GlassIndex$Project
GlassIndex$Label[GlassIndex$Label == '1406'] <- 'FQ_C1'
GlassIndex$Label[GlassIndex$Label == '1401'] <- 'FQ_C2'
GlassIndex$Label[GlassIndex$Label == '1405'] <- 'FQ_C3'
GlassIndex$Label[GlassIndex$Label == '1407'] <- 'FQ_C4'
GlassIndex$Label[GlassIndex$Label == '1403'] <- 'FQ_KES'
GlassIndex$Label[GlassIndex$Label == '1400'] <- 'MBY_TX'
GlassIndex$Label[GlassIndex$Label == '1404'] <- 'MBY_Yard'
GlassIndex$Label[GlassIndex$Label == '1402'] <- 'FH_South'
GlassIndex$Label[GlassIndex$Label == '1410'] <- 'FH_East'
GlassIndex$Label[GlassIndex$Label == '1412'] <- 'FH_West'

#Plot the Results
library(ggplot2)

Plot <- ggplot(GlassIndex, aes(x=GlassIndex$Category, y=GlassIndex$Index, col=GlassIndex$Project)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=GlassIndex$CILower, ymax=GlassIndex$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Category", y="Index Value")+
  ggtitle(expression(atop("All Categories by Glass Index", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2.5)),axis.title=element_text(size=rel(1.5)),
        axis.text=element_text(size=rel(1.25), angle=90, hjust=1), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(1.25)))
#scale_colour_brewer(name="Site")+
scale_y_continuous(limits=c(0.0,0.2), breaks=seq(0, 0.2, 0.05))
#guides(fill=guide_legend(reverse=TRUE), 
#      colour=guide_legend(reverse=TRUE))
Plot
ggsave("AllCatIndex_AllGlass.png", Plot, width=10, height=7.5, dpi=300)

LessThan_Allglass <- subset(GlassIndex, ! GlassIndex$Category %in% c('Buttons','Sewing','Clothing'))

Plot2 <- ggplot(LessThan_Allglass, aes(x=LessThan_Allglass$Category, y=LessThan_Allglass$Index, col=LessThan_Allglass$Label)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=LessThan_Allglass$CILower, ymax=LessThan_Allglass$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Category", y="Index Value")+
  ggtitle(expression(atop("All Categories by Glass Index", atop(italic("95% Confidence Intervals"), "Values less than 0.03"))))+
  theme(plot.title=element_text(size=rel(2.5)),axis.title=element_text(size=rel(1.5)),
        axis.text=element_text(size=rel(1.25), angle=90, hjust=1), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(1.25)))+
  #scale_colour_brewer(name="Site")+
  scale_y_continuous(limits=c(0.0,0.03), breaks=seq(0, 0.03, 0.01))
#guides(fill=guide_legend(reverse=TRUE), 
#      colour=guide_legend(reverse=TRUE))
Plot2
ggsave("AllCatIndex_AllGlass_ValuesLessThan03.png", Plot2, width=10, height=7.5, dpi=300)


#Buttons only
Buttons_AllGlass <- subset(GlassIndex, GlassIndex$Category %in% c('Buttons'))

Btns <- ggplot(Buttons_AllGlass, aes(x=Buttons_AllGlass$Project, y=Buttons_AllGlass$Index, col=Buttons_AllGlass$Project)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=Buttons_AllGlass$CILower, ymax=Buttons_AllGlass$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Buttons Index by All Glass", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(2)),
        legend.title=element_text(size=rel(2)))+
  scale_colour_brewer(name="Area", palette="Set3")+
  #scale_y_continuous(limits=c(0.0,0.1), breaks=seq(0, 0.1, 0.05))+
  guides(fill=guide_legend(reverse=TRUE), 
         colour=guide_legend(reverse=TRUE))
Btns
ggsave("ButtonIndex_AllGlass.png", Btns, width=10, height=7.5, dpi=300)

#Pharm bottle only
Med_AllGlass <- subset(GlassIndex, GlassIndex$Category %in% c('Medical_Pharm'))
Pharm <- ggplot(Med_AllGlass, aes(x=Med_AllGlass$Project, y=Med_AllGlass$Index, col=Med_AllGlass$Project)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=Med_AllGlass$CILower, ymax=Med_AllGlass$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Pharm Index by All Glass", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(2)),
        legend.title=element_text(size=rel(2)))+
  scale_colour_brewer(name="Area", palette="Set3")+
  #scale_y_continuous(limits=c(0.0,0.1), breaks=seq(0, 0.1, 0.05))+
  guides(fill=guide_legend(reverse=TRUE), 
         colour=guide_legend(reverse=TRUE))
Pharm
ggsave("PharmIndex_AllGlass.png", Pharm, width=10, height=7.5, dpi=300)

#Medical only
Sew_AllGlass <- subset(GlassIndex, GlassIndex$Category %in% c('Sewing'))
Sew <- ggplot(Sew_AllGlass, aes(x=Sew_AllGlass$Project, y=Sew_AllGlass$Index, col=Sew_AllGlass$Project)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=Sew_AllGlass$CILower, ymax=Sew_AllGlass$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Sew Index by All Glass", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(2)),
        legend.title=element_text(size=rel(2)))+
  scale_colour_brewer(name="Area", palette="Set3")+
  #scale_y_continuous(limits=c(0.0,0.1), breaks=seq(0, 0.1, 0.05))+
  guides(fill=guide_legend(reverse=TRUE), 
         colour=guide_legend(reverse=TRUE))
Sew
ggsave("SewingIndex_AllGlass.png", Sew, width=10, height=7.5, dpi=300)

ClothG <- subset(GlassIndex, GlassIndex$Category %in% c('Clothing'))

PClothG <- ggplot(ClothG, aes(x=ClothG$blueMCD, y=ClothG$Index)) +
  geom_point(aes(fill=ClothG$Label), shape=21, size=6) +
  geom_errorbar(aes(ymin=ClothG$CILower, ymax=ClothG$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Clothing (non-Button) Index by All Glass", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  #scale_colour_brewer(name="Site", palette="Set3")+
  scale_y_continuous(breaks=seq(0, 0.1, 0.01))+
  scale_fill_manual(name="Site", values=c("blue", "green", "yellow", "orange", "lightblue", "pink", "black", "red", "gray", "purple"))  
PClothG
ggsave("ClothIndex_AllGlass_SiteMCDs.png", PCloth, width=10, height=7.5, dpi=300)

GLASS <- ggplot(GlassIndex, aes(x=GlassIndex$blueMCD, y=GlassIndex$Glass)) +
  geom_point(aes(fill=GlassIndex$Label), shape=21, size=6) +
  # geom_errorbar(aes(ymin=ClothG$CILower, ymax=ClothG$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="BLUEMCD", y="Count")+
  ggtitle(expression(atop("Glass Counts by Project", atop(italic(""), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(2)))+
  #scale_colour_brewer(name="Site", palette="Set3")+
  #scale_y_continuous(breaks=seq(0, 0.1, 0.01))+
  scale_fill_manual(name="Site", values=c("blue", "green", "yellow", "orange", "lightblue", "pink", "black", "red", "gray", "purple"))  
GLASS
ggsave("AllGlass_SiteMCDs.png", GLASS, width=10, height=7.5, dpi=300)
