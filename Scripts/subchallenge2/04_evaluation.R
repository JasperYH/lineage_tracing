df <- data.frame()
for (sample in list.files("../../Data/Subchallenge2/groundTruth_train/")) {
  gt_file <- paste("../../Data/Subchallenge2/groundTruth_train/",sample,sep="")
  gt_tree <- read.tree(gt_file)
  hc_file <- paste("./Output/Subchallenge2/HC/",sample,sep="")
  hc_tree = read.tree(hc_file)
  
  df <- rbind(df,
              data.frame(sample=sample,
                         RF_hc = 1-RF.dist(gt_tree,hc_tree,normalize=TRUE),
                         triplet_hc = 1-TripletDistance(gt_file,hc_file)/choose(length(hc_tree$tip.label),3)))}

ggplot(df %>% gather("method","dist",-sample)) + geom_violin(aes(x=method,y=dist,fill=method))
ggsave("./result.png")

df %>% 
  gather("method","score",-sample) %>% 
  group_by(method) %>%
  summarise(score=mean(score,na.rm=TRUE))
