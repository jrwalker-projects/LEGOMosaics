#####
# Generate LEGO mosaic an image
#####

source("0_Functions.R")

#This will take a few minutes to run
lego_mosaic <- readJPEG("Images/gecrc.jpg") %>% 
  scale_image(72) %>% 
  legoize() %>% 
  collect_bricks() 

lego_mosaic %>% display_set("")

#Get summary of pieces... could probably clean this up
pieces <- lego_mosaic %>% 
  select(Brick, brick_id, Lego_name, Lego_color) %>% 
  distinct() %>% 
  separate(Brick, c("g", "gn", "size", "gi")) %>% 
  select(-g, -gn, -gi) %>% 
  mutate(size1 = as.numeric(substr(size, 2, 2)), 
         size2 = as.numeric(substr(size, 4, 4))) %>% 
  mutate(Brick_size = ifelse(size1>size1, paste(size1, "x", size2), paste(size2, "x" , size1))) %>% 
  count(Brick_size, Lego_name) %>% 
  arrange(desc(Brick_size), desc(n))

#Instruction manual
lego_mosaic %>% generate_instructions(6) %>%
  ggplot() +
  geom_rect(aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax,
                fill = Lego_color), color = "#333333")+
  scale_fill_identity() +
  coord_fixed(expand = FALSE) +
  facet_wrap(~Step) +
  theme_minimal()+
  theme_lego
