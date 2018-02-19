# data source - https://freedomhouse.org/report-types/freedom-world
# 'https://freedomhouse.org/sites/default/files/Country%20and%20Territory%20Ratings%20and%20Statuses%20FIW1973-2018.xlsx'
# Download dataset into data/source and rename to all.xlsx
# 
# Read data from worksheet of interest
c.ratings <- readxl::read_excel('data/source/all.xlsx', sheet = 'Country Ratings, Statuses ')

# select column 1, and all columns 1990 onwards
ratings <- c.ratings[,c(1, match(1990, c.ratings[1,]):ncol(c.ratings))]

# get all years as per row 1
years <- as.character(ratings[1,2:ncol(ratings)])

# only retain non-null values i.e. the years
years <- years[!is.na(years)]

# repeat each year value 3 times to ensure all columns filled in
year.labels <- rep(years, rep(3, length(years)))

# create column names made up of the name of a column and also the data value part as in row 2
column.names <- paste(as.character(ratings[2,2:ncol(ratings)]), year.labels)

# rename column 2 onwards
names(ratings)[2:ncol(ratings)] <- make.names(column.names, unique = T)

# create new dataset which drops cols 1 & 2
ratings.clean <- ratings[3:nrow(ratings),]

# rename column 1 to country
names(ratings.clean)[1] <- 'country'

ratings.long <- reshape2::melt(ratings.clean, id.vars = 'country', value.name = 'rating')

ratings.long <- dplyr::mutate(ratings.long,
                             year = stringr::str_extract(variable, pattern = '[0-9]{4}'),
                             area = stringr::str_extract(variable, pattern = '[a-zA-Z]+'))

ratings.long <- dplyr::select(ratings.long, country, year, area, rating)

ratings <- reshape2::dcast(ratings.long, country + year ~ area, value.var = 'rating')
ratings <- dplyr::mutate(ratings, 
                         CL = as.numeric(CL),
                         PR = as.numeric(PR),
                         FR = (CL + PR) / 2)

head(ratings)
length(unique(ratings$country))
write.csv(ratings, 'data/output/ratings_99_17.csv', row.names = F)



