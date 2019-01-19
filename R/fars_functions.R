#' @title Read csv file of FARS data
#'
#' @description  Read FARS data file of csv format and return tbl_df.
#' If there is no file, error message comes up
#'
#' @param filename A charactor string with the name of the file to read
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @return a data frame with data readed from the csv file, or an error if the file does not exists.
#' @export
#'
#' @examples
#' \dontrun{yr <- 2015
#' file <- make_filename(yr)
#' fars_read(file)}
#'
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' @title Make data file name with year
#'
#' @description From the given year (four digit number), make file name of csv data
#'
#' @param year an integer or string with input year
#'
#' @return A string of file name for given year
#' @export
#'
#' @seealso \link{fars_read}
#'
#' @examples
#' \dontrun{make_filename(2013)}
#'
#'
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' @title Read csv file with given years
#' @description Read the FARS data from disk for input year and returen a list of data frames
#' @param years a vector of list of year to read in
#'
#' @return A date table including month for all entry in data, or NULL if the given year is not available
#' @export
#' @importFrom dyplr %>%
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#'
#' @seealso \link{fars_read}
#' @seealso \link{make_filename}
#'
#' @examples
#' \dontrun{fars_read_years(2013)}
#'
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' @title Summarize entry number of each month by year
#' @description generate summary
#' @param years a vector of list of years to summarize
#'
#' @return a wide type data frame containing the number of accidents for each month
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom dplyr %>%
#' @importFrom dplyr bind_rows
#' @importFrom tidyr spread
#'
#' @export
#' @seealso \link{fars_read_years}
#' @seealso \link{fars_read}
#' @seealso \link{make_filename}
#'
#' @examples
#' \dontrun{fars_summarize_years(c(2013,2014))}
#'
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' @title Show map of accident number by state and year
#' @description generate a map of fatal accidents for a given state and year. An error is raised for invalid state numbers.
#' @param state.num an integer of state codes
#' @param year an integer or string with input year
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @return map graphics
#' @export
#'
#' @examples
#' \dontrun{fars_map_state(1,2013)}
#'
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}

#'
#'test for git
