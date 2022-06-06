library(here)

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
