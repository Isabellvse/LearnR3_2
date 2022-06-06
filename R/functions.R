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
