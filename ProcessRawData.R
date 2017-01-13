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
TaggingData <- data.frame(TLONGDD=xy$TLONGDD, 
                     TLATDD=xy$TLATDD, 
                     RLONGDD=xy$RLONGDD, 
                     RLATDD=xy$RLATDD,
                     TAGNO=grp2$TAGNO,
                     SPECIES=grp2$SPECIES, 
                     TDATE=as.Date(grp2$TDATE, "%m/%d/%Y"),
                     UNIQUE=grp2$UNIQUE, 
                     TGEAR=grp2$TGEAR,
                     HOOKTYPE=grp2$HOOKTYPE,
                     TDEPTHFT=grp2$TDEPTHFT,
                     TLENIN=grp2$TLENIN, 
                     TWTLBS=grp2$TWTLBS,
                     RDATE= as.Date(grp2$RDATE, "%m/%d/%Y"), 
                     RGEAR=grp2$RGEAR,
                     RETDEPTH=grp2$RETDEPTH 
                     )
        
ReturnDataWithXY <- subset(TaggingData, !is.na(RLONGDD))

RedSnapper <- subset(ReturnDataWithXY, SPECIES=="RED SNAPPER") 
write.csv(RedSnapper, "RedSnapper.csv", row.names=FALSE)

library(sp)

## Make a spatial object of tagging data
TagXY <- RedSnapper
coordinates(TagXY) <- ~TLONGDD + TLATDD

## Make a spatial object of tagging data
ReturnXY <- RedSnapper
coordinates(ReturnXY) <- ~RLONGDD + RLATDD

library(leaflet)
library(mapview)
map <- leaflet() %>% 
  
  # addTiles('http://server.arcgisonline.com/ArcGIS/rest/services/Ocean_Basemap/MapServer/tile/{z}/{y}/{x}',
  #          options = list(providerTileOptions(noWrap = TRUE)) ) %>%
  addTiles('http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
           options = providerTileOptions(noWrap = TRUE), group="World Imagery") %>%
  addTiles('http://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/Mapserver/tile/{z}/{y}/{x}',
           options = providerTileOptions(noWrap = TRUE),group="Labels") %>%  
  #setView(-79.61663461, 27.7623829, zoom = 6) %>% 
  addMouseCoordinates() %>% 
  
  addCircleMarkers(data=TagXY,  color="#A0A0A0",
                   #fillColor = "#FDE725",
                   fillColor = "#FFFF00",
                   fillOpacity = 0.85,
                   radius = ~3,
                   stroke = TRUE,
                   weight=1,
                   group="Tag"
                    ) %>%
  
  addCircleMarkers(data=ReturnXY,  color="#A0A0A0",
                   fillColor = "#C42A77",
                   #fillColor = "#FFFF00",
                   fillOpacity = 0.85,
                   radius = ~3,
                   stroke = TRUE,
                   weight=1,
                   group="Return"
  ) %>% 
  
  # addLegend(position = "bottomright", #fillColor = "#FDE725",
  #           pal = binpal, values = gsumSP$Year,
  #           title="Red Snapper Tag and Recapturre", 
  #           labFormat=labelFormat(big.mark="")) #%>% 
addLayersControl(
  overlayGroups = c("Tag", "Return"),
  position=c("bottomright"),
  options = layersControlOptions(collapsed = FALSE)
                )

