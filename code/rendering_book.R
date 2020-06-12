library(tidyverse)
library(bookdown)
library(here)



d <- dir(here("code")) %>%
  tibble(file = .) %>%
  mutate(Rmd = str_detect(file, ".Rmd")) %>%
  filter(Rmd) %>% 
  filter(file != "My_Trivial.Rmd")
d


setwd(here("code/"))
d$file %>% render_book(
  preview = TRUE,
  clean = TRUE,
  output_dir = here("docs"),
  encoding = "UTF-8",
  config_file = c("_bookdown.yml")
)
