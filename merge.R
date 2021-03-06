
merge_OTU = function(directory){
  
  files = dir(directory, full.names = TRUE)
  col_names = c("species", "unknown","abundance", "coverage", "nreads")
  df = data.frame(col1 = character(),
                  col2 = numeric(),
                  col3 = numeric(),
                  col4 = numeric(),
                  col5 = numeric())
  colnames(df) = col_names
  
  for (file in files){
    fileid = basename(file)
    fileid = gsub("_profile.txt","",fileid )
    sample_match = lupil[lupil$file == fileid ,]$sampleID
    
    
    dfx <- read.delim(file, header = FALSE, skip = 5)
    colnames(dfx) =  c("species", "unknown","abundance", "coverage", "nreads")
    
    dfx = dfx[c("species", "abundance")]
    colnames(dfx) = c("species", sample_match)
                  
    df = merge(dfx, df, by = c("species"), all = TRUE)
                      
  }
  df$unknown = NULL
  df$coverage = NULL
  df$nreads = NULL
  df$abundance = NULL
  
  
  return(df)
}
      
#TRAITEMENT DE LA DATAFRAME AVANT CLASSIF
LUPI = merge_OTU("C:/Users/marti/Desktop/StageI3/LUPILDF")

LUPI_duplicate = LUPI #conserve species
LUPI$species = NULL #sinon probl�me quand transpose
LUPIT = t(LUPI) #transpose 
#class = c(rep("class1",10),rep("class2",10)) classes arbitraires pour test
TLUPI = as.data.frame(LUPIT) #reconversion en df
colnames(TLUPI) = LUPI_duplicate$species #colnames = nom OTU
#TLUPI$class = class
write.table(TLUPI, file = "TLUPI.txt")

#AJOUT COLONNE TRAITEMENT
TLUPI$treatment = rev(lupil$Treatment)
   
  
  

