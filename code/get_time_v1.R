#!/usr/bin/env Rscript

# Get the command line arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Debe proporcionar un directorio como argumento.")
}

library(stringr)
library(lubridate)

# Function to search the date in a file
find_date_in_file <- function(file_path) {
  # Date patterns in Spanish and English
  date_pattern_es <- "\\b(?:\\d{1,2}\\s+(?:de\\s+)?(?:enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|setiembre|octubre|noviembre|diciembre)\\s+(?:de\\s+)?(?:\\d{2})?\\d{2}|\\d{1,2}[\\/\\-]\\d{1,2}[\\/\\-](?:\\d{2})?\\d{2})\\b"
  #date_pattern_en <- "\\b(?:\\d{1,2}\\s+(?:January|February|March|April|May|June|July|August|September|October|November|December)\\s+\\d{4})\\b"
  date_pattern_en <- "\\b(?:\\d{1,2}\\s+(?:January|February|March|April|May|June|July|August|September|October|November|December),?\\s+(?:\\d{2})?\\d{2})\\b|\\b(?:January|February|March|April|May|June|July|August|September|October|November|December)\\s+\\d{1,2},?\\s+(?:\\d{2})?\\d{2}\\b|\\b\\d{1,2}-(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\\d{2,4}\\b|\\b\\d{1,2}[\\/\\-]\\d{1,2}[\\/\\-](?:\\d{2})?\\d{2}\\b"


  lines <- readLines(file_path, n = 10)
  
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

  return(ifelse(is.na(date_found), "Fecha no encontrada", date_found))
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

# Directory containing the txt files
directorio <- args[1]

# Check if the directory exists
if (!file.exists(directorio)) {
  stop("El directorio especificado no existe.")
}

# Check if there are .txt files in the directory
if (length(list.files(directorio, pattern = "\\.txt$", full.names = TRUE)) == 0) {
  stop("No se encontraron archivos .txt en el directorio especificado.")
}

# Generate and save data table
tabla_datos <- generate_table(directorio)
write.table(tabla_datos, file = "tabla_datos.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

