rm(list = ls(all = TRUE))
options(stringsAsFactors = FALSE)

library(mlr)
library(ggplot2)
library(glmnet)

classfonction <- function(file_name.pdf, df, feature_selection_method, filter_perc, method, class_target) {
  df[is.na(df)] = 0
  #TASK
  task = makeClassifTask(data = df, target = class_target)
  
  #FEATURE SELECTION
  fv = generateFilterValuesData(task, method = feature_selection_method )
  filtered.task = filterFeatures(task, fval = fv, perc = filter_perc )
  fv_data = fv$data
  fvdf = as.data.frame(fv$data)
  
  #PLOT FILTER VALUES
  pdf(file = paste0(feature_selection_method,"_","fv.pdf"))
  print(ggplot(fvdf, aes(x= name, y = value))+
    geom_col()+
      theme_bw())
  dev.off()
  write.table(x=fvdf, file = paste0(feature_selection_method,"_","fv.txt"))
  #LEARNER
  methoddf = listLearners("classif", properties = c("prob"))
  '%notin%' <- Negate('%in%')
  
  if (method %notin% methoddf$class) {
    return("method does not fit") 
  } else {
    
    base_learner = makeLearner(method, predict.type = "prob")
    learner = makeFilterWrapper(learner = base_learner, fw.method = feature_selection_method, fw.perc = filter_perc)
    
    
    #TRAINING
    training = train(learner, filtered.task)
    write.table(x = getFilteredFeatures(training), file = paste0(feature_selection_method,"_",method,"_","Ffeatures.txt"))
 
    #PREDICTION
    prediction = predict(training, newdata = df)
    #Quand parameters ready
    #prediction = setThreshold(pred, thresh_classif)
    
    prediction_df = as.data.frame(prediction)
    prediction_df$id = 1:nrow(prediction_df)
    
    col_names = c("truth", "prob.class", "1-prob.class", "response","id")
    colnames(prediction_df) = col_names
    
    #PERFORMANCE
    perf = generateThreshVsPerfData(prediction, measures = list(fpr, tpr, mmce, auc))
    pdf(file = paste0("ROC","_",feature_selection_method,method,".pdf"))
    print(plotROCCurves(perf))
    dev.off()
    write.table(x= perf$data, file = paste0("perf","_",feature_selection_method,method,".txt"))
    print(perf)
    #write.table(x =perf, file = paste0("performance","_",method,"_",feature_selection_method,"_",filter_perc,"",".txt"))
    
    #PLOT
    pdf(file = paste0(feature_selection_method,"_",method,"_",file_name.pdf))
    print(ggplot(prediction_df, aes(x = id, y = prob.class -0.5, fill = truth))+
      geom_col()+
      theme_bw())
    dev.off()
    print(ggplot(prediction_df, aes(x = id, y = prob.class -0.5, fill = truth))+
                  geom_col()+
            theme_bw())
    #OUTPUT
    output = prediction_df
    
    return(output)
    
  }
  
}


#TEST#
classfonction("traitement.pdf", TLUPI ,"anova.test", 0.8, "classif.glmnet", "treatment")


