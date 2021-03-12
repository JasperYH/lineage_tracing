library(ggplot2)
library(ggtree)
library(phangorn)
library(gridExtra)

# PATH to the tree file in newick format
tree <- read.tree(PATH,sep=""))
# text_df <- read_tsv(paste("../Data/Subchallenge2/Train/",sample,".txt",sep=""),col_names=c("label","seq"))

tree_vis <- function(tree,text_df,out_dir) {
  m <- 100
  n <- 200
  
  g1 <- ggtree(tree,branch.length="none") + geom_tiplab() + ylim(0,m)
  loc_data <- g1$data
  text_df <- left_join(text_df,loc_data)
  
  for (i in 1:n) {
    text_df[as.character(i)] <- substr(text_df$seq,start=i,stop=i)
  }
  text_df <- text_df %>%
    gather("x","chr",as.character(1:n)) %>%
    mutate(x=as.integer(x))
  
  g2 <- ggplot(data=text_df,aes(x=x,y=y+0.5,label=chr)) + 
    geom_text(size=3) + 
    xlim(0,n+1) +
    ylim(0,m+1) +
    theme_void()
  
  g <- grid.arrange(g1,g2,ncol=2,widths=c(1,2.5))
  ggsave(paste("./Figures/Subchallenge2/",out_dir,"/",sample,".png",sep=""),g,width=40,height=20)
}

tree_vis(tree,text_df,"gt_tree")
