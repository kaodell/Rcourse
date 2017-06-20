#________________________________________________________
library(lubridate)
library(tidyverse)
#________________________________________________________

#________________________________________________________
read_sums <- function(file){
  readr::read_csv(file, skip = 0,
                        col_names = c("datetime", "units", "stove_temp"),
                        col_types = c(),
                        na = c("", "NA")) %>%
  dplyr::mutate(logger_id = gsub(".*: ", "", datetime[2])) %>%
  dplyr::slice(20:n()) %>%
  dplyr::mutate(datetime = as.POSIXct(gsub("00", "16", datetime), 
                                      format = "%d/%m/%y %I:%M:%S %p"),
                date = as.Date(datetime),
                time = as.numeric(hms(format(datetime, "%H:%M:%S"))),
                stove_temp = as.numeric(stove_temp),
                file_name = basename(file))}
#________________________________________________________
sums_data <- lapply(list.files("../data/field/sums",
                    pattern = ".csv",
                    full.names = TRUE),
                    read_sums) %>%
                    dplyr::bind_rows()
#________________________________________________________

# Load sums file
load_field_sums <- function(){
 
 return(lapply(list.files("../data/field/sums",
                          pattern = ".csv",
                          full.names = TRUE),
               function(x) readr::read_csv(x, skip = 20,
                                           col_names = c("datetime", "units",
                                                         "stove_temp"),
                                           col_types = cols(
                                            datetime = col_character(),
                                            units = col_character(),
                                            stove_temp = col_double()),
                                           na = c("", "NA")) %>%
                dplyr::mutate(logger_id = 
                               gsub(".*: ", "", 
                                    readr::read_csv(x, skip = 1, n_max = 1,
                                                    col_names = "id",
                                                    col_types = cols(
                                                     id = col_character()))))) %>%
         dplyr::bind_rows() %>%
         dplyr::mutate(datetime = as.POSIXct(gsub("00", "16", datetime), 
                                             format = "%d/%m/%y %I:%M:%S %p"),
                       date = as.Date(datetime),
                       time = as.numeric(substr(datetime, 12, 13)) * 60 * 60 +
                        as.numeric(substr(datetime, 15, 16)) * 60 +
                        as.numeric(substr(datetime, 18, 19))))
}
#________________________________________________________

