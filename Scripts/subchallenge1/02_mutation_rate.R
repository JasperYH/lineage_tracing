library(dplyr)
library(readr)
library(ggplot2)

mutation_rate <- read_csv("./Cache/Subchallenge1/mutation_table.csv") %>%
  mutate(x=paste(state,pos,sep="_")) %>%
  group_by(state,pos) %>%
  summarise(n=n()) %>%
  ungroup %>%
  group_by(pos) %>%
  mutate(rate=n/sum(n)) %>%
  mutate(x=paste(state,pos,sep="_"))
write_tsv("./mutation_rate.tsv")

ggplot(filter(mutation_rate,state!=1)) +
  geom_tile(aes(x=pos,y=state,fill=rate)) +
  scale_fill_gradient(low="white",high="red") +
  coord_fixed(ratio=0.5) +
  theme_void()
ggsave("./transition_heatmap.png",width=10,height=3)

ggplot(mutation_rate %>% arrange(state,pos) %>% mutate(state=as.factor(state),barcode=as.factor(x)),
       aes(x=barcode,y=rate,fill=state)) + 
  geom_bar(stat="identity") +
  labs(x="",y="transition rate") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.line = element_line(colour = "black"),
        panel.background = element_blank())
ggsave("./mutation_rate.png") 
