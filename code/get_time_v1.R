#!/usr/bin/env Rscript

# Load functions from functions.R
source("timeline_plot.R")
source("plotting.R")

# Encapsulate program in a function
main_get_time <- function(directory, date_hour) {

# Function to search the date in a file
find_date_in_file <- function(file_path) {
  # Date patterns in Spanish and English
  date_pattern_es <- "\\b(?:\\d{1,2}\\s+(?:de\\s+)?(?:enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|setiembre|octubre|noviembre|diciembre)\\s+(?:de\\s+)?(?:\\d{2})?\\d{2}|\\d{1,2}[\\/\\-]\\d{1,2}[\\/\\-](?:\\d{2})?\\d{2})\\b"
  #date_pattern_en <- "\\b(?:\\d{1,2}\\s+(?:January|February|March|April|May|June|July|August|September|October|November|December)\\s+\\d{4})\\b"
  date_pattern_en <- "\\b(?:\\d{1,2}\\s+(?:January|February|March|April|May|June|July|August|September|October|November|December),?\\s+(?:\\d{2})?\\d{2})\\b|\\b(?:January|February|March|April|May|June|July|August|September|October|November|December)\\s+\\d{1,2},?\\s+(?:\\d{2})?\\d{2}\\b|\\b\\d{1,2}-(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\\d{2,4}\\b|\\b\\d{1,2}[\\/\\-]\\d{1,2}[\\/\\-](?:\\d{2})?\\d{2}\\b"

lines <- readLines(file_path, n = 10, warn = FALSE)
lines <- iconv(lines, from = "latin1", to = "UTF-8", sub = "�")
  
  date_found <- NA

  # Find dates in the first 10 lines of the file
  for (line in lines) {
    # Clean the line by removing commas attached to the numbers and adding a space after the comma
    line_cleaned <- gsub("(?<=[0-9])\\,|\\,(?=[0-9])", ", ", line, perl = TRUE)
    
    # Then, clean the colons attached to letters or words (not numbers)
    line_cleaned <- gsub("(?<=[A-Za-z])\\:+|\\:+(?=[A-Za-z])", "", line_cleaned, perl = TRUE)
    
    # Add a space after removing the colon
    line_cleaned <- gsub(":", ": ", line_cleaned)
    
    # Remove "de"s that are between a word and a number, but not between a number and a word
    line_cleaned <- gsub("(?<=\\D)\\bde\\b(?=\\d)", "", line_cleaned, perl = TRUE)
    
    date_in_line_es <- str_extract(line_cleaned, date_pattern_es)
    date_in_line_en <- str_extract(line_cleaned, date_pattern_en)
    
    if (!is.na(date_in_line_es)) {
      parsed_date <- dmy(date_in_line_es, quiet = TRUE)
      if (!is.na(parsed_date)) {
        date_found <- format(parsed_date, "%d/%m/%Y")
        break
      }
    } else if (!is.na(date_in_line_en)) {
      parsed_date <- mdy(date_in_line_en, quiet = TRUE)
      if (!is.na(parsed_date)) {
        date_found <- format(parsed_date, "%d/%m/%Y")
        break
      }
    }
  }

  return(ifelse(is.na(date_found), "Date not found", date_found))
}

# Function to generate the data table
generate_table <- function(dir_path) {
  files <- list.files(path = dir_path, pattern = "\\.txt$", full.names = TRUE)
  table <- sapply(files, function(file) {
    date_in_file <- find_date_in_file(file)
    c(file, date_in_file)
  })
  return(t(table))
}

# Check if the directory exists
if (!file.exists(directory)) {
  stop("The specified directory does not exist.")
}

# Check if there are .txt files in the directory
if (length(list.files(directory, pattern = "\\.txt$", full.names = TRUE)) == 0) {
  stop("No .txt files were found in the specified directory.")
}

# Generate and save data table
tabla_datos <- generate_table(directory)

# Save the result to a file
output_dir <- "output"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Create full file name
file_name <- file.path("output/", paste0("data_table_", date_hour, ".txt"))

write.table(tabla_datos, file = file_name, sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

# Plot word by year
timeline_plot <- plot_timeline(tabla_datos, , title="Document per site", xlab="", ylab="Site")
save_plot_to_pdf(timeline_plot, paste0("output/timeline_", date_hour, ".pdf"))

}
