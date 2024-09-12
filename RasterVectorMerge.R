## Merging raster and vector files to obtain harmonized population data
# Load terra package
library(terra)

# Load raster and vector data
population_raster_2019 <- rast("/path/to/your/directory/ppp_2019_1km_Aggregated.tif")
migration_vector <- vect("/path/to/your/directory/admin1.gpkg")

# Zonal statistics - calculating the sum of the population within each administrative unit
aggregated_population_2019 <- zonal(population_raster_2019, migration_vector, fun = "sum", na.rm = TRUE)

# Convert to dataframe if not already one
if (!is.data.frame(aggregated_population_2019)) {
  aggregated_population_2019 <- as.data.frame(aggregated_population_2019)
}

# Ensure there is a unique ID column in the migration_vector
if ("ID" %in% names(migration_vector) == FALSE) {
  migration_vector$ID <- 1:length(migration_vector)
}

# Add an ID column to the aggregated_population that matches the IDs in migration_vector
aggregated_population_2019$ID <- migration_vector$ID

# Assign a unique ID to each row, from 1 to the number of rows in the dataframe
aggregated_population_2019$ID <- 1:nrow(aggregated_population_2019)

# Merge aggregated population data with original vector attributes
merged_data_2019 <- merge(as.data.frame(migration_vector), aggregated_population_2019, by = "ID")

# Preview the structure to confirm everything is as expected
print(str(merged_data_2019))
print(head(merged_data_2019))

# Define the path and name for the CSV file
csv_file_path <- "merged_data_2019.csv"

# Write the data frame to a CSV file, without row names
write.csv(merged_data_2019, csv_file_path, row.names = FALSE)

# Output to console to confirm file saving
print(paste("CSV file saved at:", csv_file_path))