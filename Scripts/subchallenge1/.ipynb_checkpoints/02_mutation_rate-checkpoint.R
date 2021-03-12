mutation_df <- read_csv("./Cache/Subchallenge1/mutation.csv") %>%
  mutate(is_subtree=(n_leaf==n_labels)) %>%
  group_by(state,pos) %>%
  summarise(num_subtree=sum(is_subtree),tot_num=n()) %>%
  mutate(percentage_subtree=num_subtree/tot_num) %>%
  mutate(x=paste(state,pos,sep="_")) %>%
  ungroup

ggplot(mutation_df %>% arrange(state,pos),aes(x=as.factor(x),y=percentage_subtree,fill=as.factor(state))) + 
  geom_bar(stat="identity")

ggplot(mutation_df %>% arrange(state,pos),aes(x=as.factor(x),y=tot_num,fill=as.factor(state))) + 
  geom_bar(stat="identity")

mutation_df %>% group_by(state) %>% summarise(m=sum(num_subtree)/sum(tot_num))


mutation_table <- read_csv("./Cache/Subchallenge1/mutation_table.csv") %>%
  mutate(x=paste(state,pos,sep="_")) %>%
  group_by(state,pos) %>%
  summarise(n=n()) %>%
  ungroup %>%
  group_by(pos) %>%
  mutate(rate=n/sum(n))

write_tsv(mutation_table,"./Cache/Subchallenge1/mutation_rate.tsv")
