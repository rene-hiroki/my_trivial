library(bookdown)
library(here)
setwd(here())

serve_book(dir = here("/code"),
           output_dir = "../_live_book",
           preview = TRUE)

