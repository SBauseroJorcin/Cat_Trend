#!/usr/bin/env Rscript

# Obtener los argumentos de línea de comandos
args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Debe proporcionar un directorio como argumento.")
}

library(stringr)
library(lubridate)

# Función para buscar la fecha en un archivo
find_date_in_file <- function(file_path) {
  # Patrones de fecha en español e inglés
  date_pattern_es <- "\\b(?:\\d{1,2}\\s+(?:de\\s+)?(?:enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|setiembre|octubre|noviembre|diciembre)\\s+(?:de\\s+)?(?:\\d{2})?\\d{2}|\\d{1,2}[\\/\\-]\\d{1,2}[\\/\\-](?:\\d{2})?\\d{2})\\b"
  date_pattern_en <- "\\b(?:\\d{1,2}\\s+(?:January|February|March|April|May|June|July|August|September|October|November|December)\\s+\\d{4})\\b"

  lines <- readLines(file_path, n = 10)
  
  date_found <- NA

  # Buscar fechas en las primeras 10 líneas del archivo
  for (line in lines) {
    # Limpiar la línea eliminando las comas pegadas a los números y agregando un espacio después de la coma
    line_cleaned <- gsub("(?<=[0-9])\\,|\\,(?=[0-9])", ", ", line, perl = TRUE)
    
    # Luego, limpiar los dos puntos pegados a letras o palabras (no números)
    line_cleaned <- gsub("(?<=[A-Za-z])\\:+|\\:+(?=[A-Za-z])", "", line_cleaned, perl = TRUE)
    
    # Agregar un espacio después de eliminar los dos puntos
    line_cleaned <- gsub(":", ": ", line_cleaned)
    
    # Eliminar los "de" que están entre una palabra y un número, pero no entre un número y una palabra
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


# Función para generar la tabla de datos
generate_table <- function(dir_path) {
  files <- list.files(path = dir_path, pattern = "\\.txt$", full.names = TRUE)
  table <- sapply(files, function(file) {
    date_in_file <- find_date_in_file(file)
    c(file, date_in_file)
  })
  return(t(table))
}

# Directorio que contiene los archivos txt
directorio <- args[1]

# Verificar si el directorio existe
if (!file.exists(directorio)) {
  stop("El directorio especificado no existe.")
}

# Verificar si hay archivos .txt en el directorio
if (length(list.files(directorio, pattern = "\\.txt$", full.names = TRUE)) == 0) {
  stop("No se encontraron archivos .txt en el directorio especificado.")
}

# Generar y guardar la tabla de datos
tabla_datos <- generate_table(directorio)
write.table(tabla_datos, file = "tabla_datos.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

