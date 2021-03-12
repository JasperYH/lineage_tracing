dir_name <- "./Output/Subchallenge2/"

subc2_training_samples <- readRDS("./Cache/Subchallenge2/subc2_training_data.rds") %>% names
# subc2_ground_tree <- read.tree("./Data/Subchallenge2/Ref/SubC2_train_0001_REF.nw")

df <- data.frame()
for (sample in subc2_training_samples) {
  seq <- read_tsv(paste("./Data/Subchallenge2/Train/",sample,".txt",sep=""),col_names = FALSE)
  gt_tree <- read.tree(paste("./Data/Subchallenge2/Ref/",sample,"_REF.nw",sep=""))
  nj_tree = read.tree(paste("./Output/Subchallenge2/NJ/",sample,".nw",sep=""))
  nj_dist_tree = read.tree(paste("./Output/Subchallenge2/NJ_distmatrix/",sample,".nw",sep=""))
  UPGMA_tree = read.tree(paste("./Output/Subchallenge2/UPGMA/",sample,".nw",sep=""))
  parsimony_tree = read.tree(paste("./Output/Subchallenge2/Parsimony/",sample,".nw",sep=""))
  df <- rbind(df,
              data.frame(sample=sample,
                nj = 1-RF.dist(gt_tree,nj_tree,normalize=TRUE),
                nj_dist = 1-RF.dist(gt_tree,nj_dist_tree,normalize=TRUE),
                UPGMA = 1-RF.dist(gt_tree,UPGMA_tree,normalize=TRUE),
                parsimony = 1-RF.dist(gt_tree,parsimony_tree,normalize=TRUE)))
}

ggplot(df %>% gather("method","dist",-sample)) + geom_violin(aes(x=method,y=dist,fill=method))
