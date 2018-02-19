# get aggregate scores for each country
# 
# download dataset from https://freedomhouse.org/sites/default/files/Aggregate%20Category%20and%20Subcategory%20Scores%20FIW2003-2018.xlsx
# and save to data/source/agg.xlsx
# 
sheets <- readxl::excel_sheets('data/source/agg.xlsx')
# 
# sheets of interest start with FIW then end in 4 digit number
sheets.of.interest.pattern <- '^FIW[0-9]{4}$'

# sheets to extract data from
sheets.of.interest <- sheets[grepl(sheets, pattern = sheets.of.interest.pattern)]

# get data from each worksheet in sheets.of.interest
# fn_read_data_from_worksheet function is defined in R/fn_read_data_from_worksheet.R script
ratings.list <- lapply(sheets.of.interest, fn_read_data_from_worksheet)

# merge into data frame
ratings <- dplyr::bind_rows(ratings.list)

# calculate freedom rating as FR
ratings <- dplyr::mutate(ratings, 
                         FR = (PR + CL) / 2)

# excludes territories (see index worksheet)
ratings.by.country <- dplyr::filter(ratings, !grepl(country, pattern = '\\*'))

write.csv(ratings.by.country, 'data/output/ratings_by_country.csv', row.names = F)


