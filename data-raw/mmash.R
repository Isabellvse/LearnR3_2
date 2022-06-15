library(here)
library(tidyverse)
source(here("R/functions.R"))


# define link to mmash data
mmash_link <- "https://physionet.org/static/published-projects/mmash/multilevel-monitoring-of-activity-and-sleep-in-healthy-people-1.0.0.zip"

# download the zip dataset
#download.file(mmash_link, destfile = here("data-raw/mmash-data.zip"))

# Unzip file
unzip(here("data-raw/mmash-data.zip"),
      exdir = here("data-raw"),
      junkpaths = TRUE)

# Unzip MMASH.zip
unzip(here("data-raw/MMASH.zip"),
      exdir = here("data-raw"))

# Delete and rename files
library(fs)
file_delete(here(c("data-raw/MMASH.zip",
                   "data-raw/SHA256SUMS.txt",
                   "data-raw/LICENSE.txt")))
file_move(here("data-raw/DataPaper"), here("data-raw/mmash"))

# Import functions
user_info_df <- import_multiple_files("user_info.csv", import_user_info)
saliva_df <- import_multiple_files("saliva.csv", import_saliva)
rr_df <- import_multiple_files("RR.csv", import_rr)
actigraph_df <- import_multiple_files("Actigraph.csv", import_actigraph)

summarised_rr_df <- rr_df %>%
    group_by(file_path_id, day) %>%
    summarise(across(ibi_s, list(mean = mean, sd = sd), na.rm = TRUE)) %>%
    ungroup()
