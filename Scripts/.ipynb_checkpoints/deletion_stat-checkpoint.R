library(ggtree)
library(ape)
library(stringr)

df <- data.frame()
sample_names <- readRDS("./Cache/Subchallenge2/subc2_training_data.rds") %>% names()

for (s in sample_names) {
  print(s)
  data <- read_tsv(paste("./Data/Subchallenge2/Train/",s,".txt",sep=""),col_names=c("label","seq"))
  gt_tree <- read.tree(paste("./Data/Subchallenge2/Ref/",s,"_REF.nw",sep=""))
  
  deletions <- str_locate_all(data$seq,"-+")
  names(deletions) <- data$label
  deletions <- lapply(deletions,as.data.frame)
  deletions <- bind_rows(deletions,.id="label")
  
  unique_deletions <- deletions %>% group_by(start,end) %>% summarise(n=n()) %>% filter(n>=2)
  max_dists <- c()
  for (i in 1:nrow(unique_deletions)) {
    labels <- filter(deletions,start==unique_deletions$start[i],end==unique_deletions$end[i]) %>% pull(label)
    label_ids <- do.call(c,lapply(labels,function(x) which(gt_tree$tip.label==x)))
    combs <- t(combn(label_ids,2)) %>% as.data.frame()
    dist <- mapply(function(x,y) length(nodepath(gt_tree,from=x,to=y)),combs$V1,combs$V2) %>% max
    max_dists <- c(max_dists,dist-1)
  }
  unique_deletions$max_dist <- max_dists
  unique_deletions$sample <- s
  df <- rbind(df,unique_deletions %>% as.data.frame())}

ggplot(df,aes(x=as.factor(n),y=max_dist)) + 
  geom_boxplot(fill="orange") +
  # theme_classic() +
  scale_y_continuous(breaks=seq(0,30,5)) +
  scale_x_discrete()

