#' Import MMASH user info data file.
#'
#' @param file_path Path to user info data file.
#'
#' @return Outputs a data frame/tibble.
#'
import_user_info <- function(file_path) {
    info_data <- vroom::vroom(
        file_path,
        col_select = -1,
        col_types = vroom::cols(
            gender = vroom::col_character(),
            weight = vroom::col_double(),
            height = vroom::col_double(),
            age = vroom::col_double(),
            .delim = ","
        ),
        .name_repair = snakecase::to_snake_case
    )
    return(info_data)
}

#' Import MMASH user saliva data file.
#'
#' @param file_path Path to user saliva data file
#'
#' @return Outputs a data frame/tibble.
#'
import_saliva <- function(file_path) {
    # Paste the code to import saliva data you created
    # from previous exercise
    saliva_data <- vroom::vroom(
        file_path,
        col_select = -1,
        col_types = vroom::cols(
            vroom::col_skip(),
            samples = vroom::col_character(),
            cortisol_norm = vroom::col_double(),
            melatonin_norm = vroom::col_double(),
            .delim = ","
        ),
        .name_repair = snakecase::to_snake_case
    )
    return(saliva_data)
}

#' Import MMASH user rr data file.
#'
#' @param file_path path to rr data file
#'
#' @return Outputs a data frame/tibble.
#'
import_rr <- function(file_path) {
    rr_data <- vroom::vroom(
        file_path,
        col_select = -1,
        col_types = vroom::cols(
            ibi_s = vroom::col_double(),
            day = vroom::col_double(),
            time = vroom::col_time(format = ""),
            .delim = ","
        ),
        .name_repair = snakecase::to_snake_case
    )
    return(rr_data)
}

#' Import MMASH user actigraph data file.
#'
#' @param file_path path to user actigraph data file
#'
#' @return  Outputs a data frame/tibble.
#'
import_actigraph <- function(file_path) {
    actigraph_data <- vroom::vroom(
        file_path,
        col_select = -1,
        col_types = vroom::cols(
            vroom::col_skip(),
            axis_1 = vroom::col_double(),
            axis_2 = vroom::col_double(),
            axis_3 = vroom::col_double(),
            steps = vroom::col_double(),
            hr = vroom::col_double(),
            inclinometer_off = vroom::col_double(),
            inclinometer_standing = vroom::col_double(),
            inclinometer_sitting = vroom::col_double(),
            inclinometer_lying = vroom::col_double(),
            vector_magnitude = vroom::col_double(),
            day = vroom::col_double(),
            time = vroom::col_time(format = "")
        ),
        .name_repair = snakecase::to_snake_case
    )
    return(actigraph_data)
}

#' Import multiple MMASH data files and merge into one data frame.
#'
#' @param file_pattern Pattern for which data file to import.
#' @param import_function Function to import the data file.
#'
#' @return A single data frame/tibble.
#'
import_multiple_files <- function(file_pattern, import_function) {
    data_files <- fs::dir_ls(here::here("data-raw/mmash/"),
                             regexp = file_pattern,
                             recurse = TRUE)

    combined_data <- purrr::map_dfr(data_files, import_function,
                                    .id = "file_path_id") %>%
        extract_user_id()
    return(combined_data)
}

#' Extract user id from file path
#'
#' @param imported_data Data with `file_path_id` column.
#'
#' @return A data.frame/tibble.
#' @export
#'
#' @examples
extract_user_id <- function(imported_data){
    data <- imported_data %>%
        dplyr::mutate(user_id = stringr::str_extract(file_path_id,
                                              "user_[1-9][0-9]?"),
               .before = file_path_id) %>%
        dplyr::select(-file_path_id)
    return(data)
}
