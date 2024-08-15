library(rstudioapi)
library(svDialogs)
FileToAvg<-read.table(selectFile(caption="Select file to read"),header=TRUE,sep="\t",fill=TRUE,skip=5)
SampleMin<-FileToAvg[1,'SAM_NUMBER']
SampleMax<-FileToAvg[nrow(FileToAvg),'SAM_NUMBER']
AvgDataStore<-data.frame(matrix(NA,SampleMax-SampleMin,length(FileToAvg)))
colnames(AvgDataStore)<-colnames(FileToAvg)
SampleCount=0
for(i in SampleMin:SampleMax){
  SampleCount=SampleCount+1
  RowsToExtract<-which(FileToAvg[,'SAM_NUMBER']==i)
  TempDataStore<-data.frame(matrix(NA,length(RowsToExtract),length(FileToAvg)))
  colnames(TempDataStore)<-colnames(FileToAvg)
  counter<-0
  for (element in RowsToExtract){
    counter<-counter+1
    TempDataStore[counter,]<-FileToAvg[element,]
    for (x in 1:length(TempDataStore)){
      if(is.numeric(TempDataStore[,x])){
        AvgDataStore[SampleCount,x]<-mean(TempDataStore[,x])
      } else{
        AvgDataStore[SampleCount,x]<-TempDataStore[1,x]
      }
    }
  }
  rm(TempDataStore)
}
write.csv(AvgDataStore,file=file.path(selectDirectory(caption="Select folder to save in"),"RStudio_FlankSampleAverages_From_PFE.csv"))