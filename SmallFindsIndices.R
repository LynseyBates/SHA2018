#Code to calculate abundance index values for Hermitage small finds
#Created 12.03.2017 LAB
#Updated 12.04.2017 LAB fleshing out category info in all sections
#NOTE: in a separate window run SmallFinds_ArtifactTables first

#load the library
library(plyr)
library(dplyr)

##Section 1: Glass######################

#Create sum of glass by project to use in abundance indices
glass_sum<-ddply(HermGlass, .(ProjectID), summarise, Count=sum(Quantity))

#Create dataframe by project and glass form
HermGlass3<-ddply(HermGlass, .(ProjectID, GlassForm), summarise, Count=sum(Quantity))
colnames(HermGlass3)<- c("Project","Form","Count")

#Keep only pharmaceutical and ink well forms
Ink <- subset(HermGlass3, HermGlass3$Form %in% c('Bottle, Ink'))
Pharm <- HermGlass3[grepl("^.*Pharmaceutical", HermGlass3$Form), ]

#Create category for aggregation and assign to glass forms
Pharm$Form[grepl("^.*Pharmaceutical", Pharm$Form)] <- 'Medical_Pharm'
Ink$Form[Ink$Form =='Bottle, Ink'] <- 'Education'
colnames(Pharm)<- c("Project","Category","Count")
colnames(Ink)<- c("Project","Category","Count")

##Section 2: General Artifacts ######################
                                                     
#Create coin dataframe based on coin date, will append to other tables below
Coin <- HermGA[grepl("^.*Coin", HermGA$GenArtifactForm), ]
Coin2 <- unique(Coin[(Coin$CoinDate < 1900), ])                                                  
Coin3 <- subset(Coin2, ! is.na(Coin2$ProjectID))

#Aggregate by project and form, add category
Coin3$Category <- 'Coins'
Coins<-aggregate(Coin3$Quantity, by=list(Coin3$ProjectID, Coin3$Category), FUN=sum)
colnames(Coins)<- c("Project","Category","Count")


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
GenArts<-ddply(HermGA, .(ProjectID, Category), summarise, Count=sum(Quantity))
GenArts2 <- subset(GenArts, GenArts$Category %in% c('Accessory', 'Clothing', 'Hygiene',
                                                      'Medical','Utensil', 'DecorativeHome',
                                                      'Sewing', 'Horse', 'Music', 'Jewelry',
                                                      'GunParts_Ammunition_FoodProcurement',
                                                      'Buttons', 'Social', 'Education',
                                                    'Toy_Game'))
colnames(GenArts2)<- c("Project","Category","Count")


##Section 3: Utensils ######################

#Aggregate by project and form, add category
Utensil<-ddply(HermUten, .(ProjectID), summarise, Count=sum(Quantity))
colnames(Utensil)<- c("Project","Count")
Utensil$Category <- 'Utensil'
Utensil <- Utensil[,c("Project","Category","Count")]

##Section 4: Pipes ######################

#Aggregate by project and form, add category
Pipe<-ddply(HermPipe, .(ProjectID), summarise, Count=sum(Quantity))
colnames(Pipe)<- c("Project","Count")
Pipe$Category <- 'Pipes'
Pipe <- Pipe[,c("Project","Category","Count")]

##Section 5: Beads ######################

#Aggregate by project and form, add category
Bead <- subset(HermBead, ! HermBead$BeadMaterial %in% c('Plastic'))
Bead2<-ddply(Bead, .(ProjectID), summarise, Count=sum(Quantity))
colnames(Bead2)<- c("Project","Count")
Bead2$Category <- 'Beads'
Bead2 <- Bead2[,c("Project","Category","Count")]


##Section 6: Buckles ######################

#Aggregate by project and form, add category
Buckle <- subset(HermBuckle, ! HermBuckle$BuckleType %in% c('Unid: Harness/Util.', 'Unidentifiable'))
Buckle2<-ddply(Buckle, .(ProjectID), summarise, Count=sum(Quantity))
colnames(Buckle2)<- c("Project","Count")
Buckle2$Category <- 'Buckles'
Buckle2 <- Buckle2[,c("Project","Category","Count")]


##Section 7: Buttons ######################

ButtonX <- subset(HermButton, ! HermButton$ButtonMaterial %in% c('Synthetic/Modern'))
Button<-ddply(ButtonX, .(ProjectID), summarise, Count=sum(Quantity))
colnames(Button)<- c("Project","Count")
Button$Category <- 'Buttons'
Button <- Button[,c("Project","Category","Count")]

##Section 8: Create one table ######################

#Bind together all artifact category tables
SmallFinds <- rbind(Ink, Pharm, Pipe, Utensil, GenArts2, Coins, Buckle2, Bead2, Button)

#Summarize file by project and category
SmallFinds3 <- ddply(SmallFinds, .(Project, Category), summarise, Count=sum(Count))

#Create new field to match against 'zeros' dataframe
# SmallFindsX$match <- paste(SmallFindsX$Project,SmallFindsX$Category)
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

##Section 9: Index with All Glass Denominator ######################

GlassIndex <- merge(glass_sum, SmallFinds3, by.x="ProjectID", by.y="Project")
colnames(GlassIndex)<- c("Project","Glass","Category", "Count")

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

##Section 10: Index with All Cerm Denominator ######################

#Create sum of glass by project to use in abundance indices
cerm_sum<-ddply(HermCerm, .(ProjectID), summarise, Count=sum(Quantity))

#create index values using all ceramic counts by project
cermIndex <- merge(cerm_sum, SmallFinds3, by.x="ProjectID", by.y="Project")
colnames(cermIndex)<- c("Project","cerm","Category", "Count")

cermIndex$Total <- cermIndex$Count+cermIndex$cerm

cermIndex$Index <- (cermIndex$Count)/(cermIndex$Total)

#run function on form data
CIWareSite <- adjustedWaldCI(cermIndex$Count,cermIndex$Total,0.5)
cermIndex$CIUpper <- CIWareSite$upperCL
cermIndex$CILower <- CIWareSite$lowerCL
cermIndex$p <- CIWareSite$pTilde


# cermIndex$Index[cermIndex$Count == 0] <- 0
# cermIndex$CIUpper[cermIndex$Count == 0] <- 0
# cermIndex$CILower[cermIndex$Count == 0] <- 0

cermIndex$Category[cermIndex$Category == 'DecorativeHome'] <- 'DecHome'
cermIndex$Category[cermIndex$Category == 'GunParts_Ammunition_FoodProcurement'] <- 'FoodProcure'


#Plot the Results
library(ggplot2)

PlotC <- ggplot(cermIndex, aes(x=cermIndex$Category, y=cermIndex$Index, col=cermIndex$Project)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=cermIndex$CILower, ymax=cermIndex$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Category", y="Index Value")+
  ggtitle(expression(atop("All Categories by cerm Index", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2.5)),axis.title=element_text(size=rel(1.5)),
        axis.text=element_text(size=rel(1.25), angle=90, hjust=1), legend.text=element_text(size=rel(1.25)),
        legend.title=element_text(size=rel(1.25)))+
#scale_colour_brewer(name="Site")+
scale_y_continuous(limits=c(0.0,0.2), breaks=seq(0, 0.2, 0.05))
#guides(fill=guide_legend(reverse=TRUE), 
#      colour=guide_legend(reverse=TRUE))
PlotC
ggsave("AllCatIndex_AllCerm.png", PlotC, width=10, height=7.5, dpi=300)

#Buttons only
Buttons_Allcerm <- subset(cermIndex, cermIndex$Category %in% c('Buttons'))

BtnsC <- ggplot(Buttons_Allcerm, aes(x=Buttons_Allcerm$Project, y=Buttons_Allcerm$Index, col=Buttons_Allcerm$Project)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=Buttons_Allcerm$CILower, ymax=Buttons_Allcerm$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Buttons Index by All Cerm", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(2)),
        legend.title=element_text(size=rel(2)))+
  scale_colour_brewer(name="Area", palette="Set3")+
  #scale_y_continuous(limits=c(0.0,0.1), breaks=seq(0, 0.1, 0.05))+
  guides(fill=guide_legend(reverse=TRUE), 
         colour=guide_legend(reverse=TRUE))
BtnsC
ggsave("ButtonIndex_Allcerm.png", BtnsC, width=10, height=7.5, dpi=300)

#Medical only
Med_Allcerm <- subset(cermIndex, cermIndex$Category %in% c('Medical_Pharm'))
PharmC <- ggplot(Med_Allcerm, aes(x=Med_Allcerm$Project, y=Med_Allcerm$Index, col=Med_Allcerm$Project)) +
  geom_point(size=6,shape=19)+
  geom_errorbar(aes(ymin=Med_Allcerm$CILower, ymax=Med_Allcerm$CIUpper), colour="black", width=.1)+
  theme_classic()+
  labs(x="Site", y="Index Value")+
  ggtitle(expression(atop("Pharm Index by All Cerm", atop(italic("95% Confidence Intervals"), ""))))+
  theme(plot.title=element_text(size=rel(2)),axis.title=element_text(size=rel(2)),
        axis.text=element_text(size=rel(1.5)), legend.text=element_text(size=rel(2)),
        legend.title=element_text(size=rel(2)))+
  scale_colour_brewer(name="Area", palette="Set3")+
  #scale_y_continuous(limits=c(0.0,0.1), breaks=seq(0, 0.1, 0.05))+
  guides(fill=guide_legend(reverse=TRUE), 
         colour=guide_legend(reverse=TRUE))
PharmC
ggsave("PharmIndex_Allcerm.png", PharmC, width=10, height=7.5, dpi=300)

#Medical only
Sew_Allcerm <- subset(cermIndex, cermIndex$Category %in% c('Sewing'))
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

