rm(list = ls(all = TRUE))
options(stringsAsFactors = FALSE)

#TRAITEMENT LUPIL AVANT DE LANCER MERGE_OTU
lupil$Treatment = gsub("ILT-101", "IL2", lupil$Treatment)
lupil$Treatment = gsub("Placebo", "PL", lupil$Treatment)
lupil$Responder[lupil$Responder == "TRUE"] <- "R"
lupil$Responder[lupil$Responder == "FALSE"] <- "NR"
lupil$file = rownames(lupil)
lupil$sampleID = paste0(lupil$Treatment,"_",lupil$Responder,"_",lupil$ID,"_",lupil$Timepoint,"_",lupil$file)
write.table(lupil, file = "lupil.txt")

