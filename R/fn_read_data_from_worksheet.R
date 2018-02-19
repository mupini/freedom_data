fn_read_data_from_worksheet <- function(worksheet.name) {
  df <- readxl::read_excel('data/source/agg.xlsx', sheet = worksheet.name)
  columns.of.interest.pattern <- 'Country|Status|(PR|CL) Rating|Total Aggr'
  columns.of.interest <- grep(names(df), pattern = columns.of.interest.pattern, ignore.case = T)
  df <- dplyr::select(df, columns.of.interest)
  names(df) <- c('country', 'status', 'PR', 'CL', 'Total')
  df$year <- stringr::str_extract(worksheet.name, pattern = '[0-9]{4}$')
  cat(worksheet.name)
  return(df)
}
