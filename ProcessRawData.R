## Process K. Burn's Tagging Data
## v010

setwd("X:/Data_John/BurnsTaggingData/BurnsTaggingData")
grp2006 <- read.csv("grp2006.csv")

str(grp2006$RDATE)

grp2 <-  with(grp2006, grp2006[!(RDATE == "" | is.na(RDATE)), ])
##nrow(unique(grp2))


TLATDD = grp2$TLATDEG + (grp2$TLATMIN/60)
TLONGDD = (grp2$TLONGDEG + (grp2$TLONGMIN/60))*-1;
RLATDD = grp2$RLATDEG + (grp2$RLATMIN/60);
RLONGDD = (grp2$RLONGDEG + (grp2$RLONGMIN/60))*-1;
xy <- data.frame(TLONGDD=TLONGDD,TLATDD=TLATDD, RLONGDD=RLONGDD, RLATDD=RLATDD)
TaggingData <- cbind(TLONGDD=xy$TLONGDD, 
                     TLATDD=xy$TLATDD, 
                     RLONGDD=xy$RLONGDD, 
                     RLATDD=xy$RLATDD,
                     TAGNO=grp2$TAGNO,
                     SPECIES=grp2$SPECIES, 
                     TDATE=as.Date(grp2$TDATE),
                     UNIQUE=grp2$UNIQUE, 
                     TGEAR=grp2$TGEAR,
                     HOOKTYPE=grp2$HOOKTYPE,
                     TDEPTHFT=grp2$TDEPTHFT,
                     TLENIN=grp2$TLENIN, 
                     TWTLBS=grp2$TWTLBS,
                     RDATE=grp2$RDATE, 
                     RGEAR=grp2$RGEAR,
                     RETDEPTH=grp2$RETDEPTH 
                     )
        
ReturnDataWithXY <- subset(TaggingData, !is.na(RLONGDD))