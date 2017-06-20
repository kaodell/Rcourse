#_______________________________________________________________________________
# libraries
library(readr)
library(dplyr)
#_______________________________________________________________________________

#_______________________________________________________________________________
# e.g. file <- "../data/arctas/ARCTAS-mrg60-dc8_merge_20080401_R14.ict"
# e.g. out <- read_ict_file(file)
read_ict_file <- function(file){
 # print file name
  print(file)
 # read first line of file
  dimensions <- read_csv(file, n_max = 1,
                               col_names = c("head_lines", "format"),
                               col_types = ("ic"))
 # read header
  header <- read_lines(file, n_max = dimensions$head_lines[1] -1)
 # read data
  data <- read_csv(file, skip = dimensions$head_lines[1] - 1,
                         col_names = TRUE,
                         progress = FALSE,
                         col_types = cols())
 # tidy column names
  names(data) <- tolower(gsub("[[:punct:]]", "_", names(data)))
 # return
  return(data)
}
#_______________________________________________________________________________
getwd()
list.files("./data/arctas/")


test <- read_ict_file("./data/arctas/ARCTAS-mrg60-dc8_merge_20080401_R14_thru20080419.ict")
problems(test)
