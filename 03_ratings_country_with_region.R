# clear environment
rm(list = ls())

# https://commondatastorage.googleapis.com/ckannet-storage/2012-07-26T090250/Countries-Continents-csv.csv
continents <- read.csv('https://commondatastorage.googleapis.com/ckannet-storage/2012-07-26T090250/Countries-Continents-csv.csv', 
                       stringsAsFactors = F)

# retain col 1 and 2 
continents <- continents[,1:2]

ratings <- read.csv('data/output/ratings_by_country.csv', stringsAsFactors = F)

correct_country_names <- function(wrong.name, correct.name) {
  
  continents$Country[continents$Country == wrong.name] <<- correct.name
}

# make corrections for ivory cost
ratings$country[grepl(ratings$country, pattern = '^cote d', ignore.case = T)] <- 'Ivory Coast'

# correct country names in continent list
correct_country_names('Burkina', 'Burkina Faso')
correct_country_names('Congo', 'Congo (Brazzaville)')
correct_country_names('Congo, Democratic Republic of', 'Congo (Kinshasa)')
correct_country_names('Gambia', 'The Gambia')
correct_country_names('Burma (Myanmar)', 'Myanmar')
correct_country_names('East Timor', 'Timor-Leste')
correct_country_names('Korea, North', 'North Korea')
correct_country_names('Korea, South', 'South Korea')
correct_country_names('Russian Federation', 'Russia')
correct_country_names('Saint Kitts and Nevis', 'St. Kitts and Nevis')
correct_country_names('Saint Lucia', 'St. Lucia')
correct_country_names('Saint Vincent and the Grenadines', 'St. Vincent and the Grenadines')


setdiff(continents$Country, unique(ratings$country))
# countries missed out
setdiff(unique(ratings$country), continents$Country)


ratings.with.region <- dplyr::left_join(ratings, continents, by = c('country' = 'Country'))

write.csv(ratings.with.region, 'data/output/ratings_with_region.csv', row.names = F)

