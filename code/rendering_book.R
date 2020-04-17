library(tidyverse)
library(bookdown)
library(here)

if (file.exists("data_engineering.Rmd")){
  file.remove("data_engineering.Rmd")
}

d <- dir(here("code/code_bookdown")) %>%
  tibble(file = .) %>%
  mutate(Rmd = str_detect(file, ".Rmd")) %>%
  filter(Rmd)
d


setwd(here("code/code_bookdown/"))
d$file %>% render_book(preview = TRUE,
  clean = TRUE,
  output_dir = here("output_book"),
  encoding = "UTF-8",
  config_file = c("_bookdown.yml")
)

