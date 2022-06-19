library(tidyverse)
library(vroom)
library(fs)
library(here)
source(here("R/functions.R"))

# Download
mmash_link <- "https://physionet.org/static/published-projects/mmash/multilevel-monitoring-of-activity-and-sleep-in-healthy-people-1.0.0.zip"
# download.file(mmash_link, destfile = here("data-raw/mmash-data.zip"))

# Unzip
# unzip(here("data-raw/mmash-data.zip"),
#       exdir = here("data-raw"),
#       junkpaths = TRUE)
# unzip(here("data-raw/MMASH.zip"),
#       exdir = here("data-raw"))

# Remove/tidy up left over files
# file_delete(here(c("data-raw/MMASH.zip",
#                    "data-raw/SHA256SUMS.txt",
#                    "data-raw/LICENSE.txt")))
# file_move(here("data-raw/DataPaper"), here("data-raw/mmash"))

user_info_df <- import_multiple_files("user_info.csv", import_user_info)
saliva_df <- import_multiple_files("saliva.csv", import_saliva)
rr_df <- import_multiple_files("RR.csv", import_rr)
actigraph_df <- import_multiple_files("Actigraph.csv", import_actigraph)

summarised_rr_df <- rr_df %>%
    group_by(user_id, day) %>%
    summarise(across(ibi_s, list(mean = mean, sd = sd), na.rm = TRUE)) %>%
    ungroup()

# Your Actigraph code will be probably be different
summarised_actigraph_df <- actigraph_df %>%
    group_by(user_id, day) %>%
    summarise(across(hr, list(mean = mean, sd = sd))) %>%
    ungroup()

saliva_with_day_df <- saliva_df %>%
    mutate(day = case_when(
        samples == "before sleep" ~ 1,
        samples == "wake up" ~ 2,
        TRUE ~ NA_real_
    ))

mmash1 <- reduce(
    list(
        user_info_df,
        saliva_with_day_df),
    full_join
)

mmash2 <- reduce(
    list(
        mmash1,
        summarised_rr_df),
    full_join
)

mmash3<- reduce(
    list(
        mmash2,
        summarised_actigraph_df),
    full_join
)

mash4 <- reduce(
    list(user_info_df,
         summarised_rr_df,
         saliva_with_day_df,
         summarised_actigraph_df
         ),
    full_join
)

df_list <- list(user_info_df,
          summarised_rr_df,
          saliva_with_day_df,
          summarised_actigraph_df)

df_merge <- cbind(df_list)

df_merge <- cbindPad(user_info_df,
         summarised_rr_df,
         saliva_with_day_df,
         summarised_actigraph_df)



usethis::use_data(mmash, overwrite = TRUE)
usethis::use_data(saliva_with_day_df, overwrite = TRUE)
usethis::use_data(summarised_rr_df, overwrite = TRUE)
usethis::use_data(summarised_actigraph_df, overwrite = TRUE)
usethis::use_data(user_info_df, overwrite = TRUE)
