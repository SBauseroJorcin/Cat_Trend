#!/usr/bin/env Rscript

# Load functions from functions.R
source("code/init_utilitis.R")
source("code/get_time_v1.R")
source("code/txt_ngram_to_tidy.R")
source("code/txt_frequency.R")

directory <- NULL
keywords_file <- NULL
language <- "SP"  
ngram_number <- 2
help <- FALSE

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  help <- TRUE
}

for (i in seq_along(args)) {
  if (args[i] %in% c("--help", "-h")) {
    help <- TRUE
  } else if (args[i] %in% c("--directory", "-d")) {
    directory <- args[i + 1]
  } else if (args[i] %in% c("--keywords", "-k")) {
    keywords_file <- args[i + 1]
  } else if (args[i] %in% c("--language", "-l")) {
    language <- args[i + 1]
  } else if (args[i] %in% c("--ngram", "-n")) {
    ngram_number <- as.integer(args[i + 1])
  }
}

if (help || is.null(directory) || is.null(keywords_file)) {
  cat("
Uso:
  script.R --directory <ruta> --keywords <archivo> [--language <es|en>] [--ngram <1|2|3>] [--help]

Opciones:
  -d, --directory   Ruta a la carpeta con los textos
  -k, --keywords    Archivo con palabras clave
  -l, --language    Idioma (es o en). Por defecto: es
  -n, --ngram       Tamaño del ngrama (1, 2 o 3). Por defecto: 2
  -h, --help        Mostrar esta ayuda

Ejemplo:
  ./script.R --directory texts --keywords palabras.txt --language es --ngram 2

")
  quit(save = "no")
}

cat("🔄 Start of processing________________________________________________________\n")

cat("📖 Installing and loading libraries...\n")
required_packages <- c("stringr", "lubridate", "tidytext", "tidyverse", "ggplot2")
manage_packages(required_packages)

# Fecha y hora actual
date_hour <- format(Sys.time(), "%d-%m-%Y_%H:%M")

# Procesamiento principal
cat("\n📊 Preparing data...\n\n")
main_get_time(directory, date_hour)
main_process_texts(directory, language, ngram_number, date_hour)

cat("\n🧮 Performing analysis...\n\n")
analyze_frequency(date_hour)

cat("\n✅ Processing completed successfully.\n\n")

# # Get command line arguments
# args <- commandArgs(trailingOnly = TRUE)

# # Check if arguments were provided or if help is requested
# if (length(args) == 0 || "--help" %in% args || "-h" %in% args) {
#   help_function()
#   quit(save = "no")
# }

# # # Validate and parse arguments
# # validated_args <- tryCatch(validate_arguments(args), error = function(e) {
# #   cat("Error in validate_arguments:", e$message, "\n")
# #   help_function()
# #   quit(save = "no")
# # })

# # Parse the arguments ## CHECK
# #parsed_args <- parse_args(args)

# cat("🔄 Start of processing________________________________________________________\n")

# cat("📖 Installing and loading libraries...\n")

# required_packages <- c("stringr", "lubridate", "tidytext", "tidyverse", "ggplot2")
# manage_packages(required_packages)

# # Get current date and time (only once)
# date_hour <- format(Sys.time(), "%d-%m-%Y_%H:%M")

# # # Validate arguments and get validated values
# # validated_args <- validate_arguments(args)

# # # Assign validated values ​​to variables for later use
# #mode <- validated_args$mode
# # directory <- validated_args$directory
# # keywords_file <- validated_args$keywords_file
# # language <- validated_args$language
# # ngram_number <- validated_args$ngram_number
# directory <- args
# keywords_file <- args
# language <- args
# ngram_number <- args

# # Llamar a las funciones principales
# cat("\n📊 Preparing data...\n\n")

# # Call main function of external script
# main_get_time(directory, date_hour)
# main_process_texts(directory, language, ngram_number, date_hour)

# cat("\n🧮 Performing analysis...\n\n")

# analyze_frequency(date_hour)


# cat("\n✅ Processing completed successfully.\n\n")
