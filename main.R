#!/usr/bin/env Rscript

# Cargar funciones desde functions.R
source("code/init_utilitis.R")
source("code/get_time_v1.R")
source("code/txt_analysis_v1.R")
source("code/txt_frequency.R")

required_packages <- c("stringr", "lubridate", "tidytext", "tidyverse", "ggplot2")
manage_packages(required_packages)

# Obtener los argumentos de la línea de comandos
args <- commandArgs(trailingOnly = TRUE)

# Verificar si se proporcionaron argumentos o si se solicita la ayuda
if (length(args) == 0 || "-help" %in% args || "-h" %in% args ) {
  help_function()
  quit(save = "no")
}

# Get current date and time (only once)
date_hour <- format(Sys.time(), "%d-%m-%Y_%H:%M")

# Validar los argumentos y obtener los valores validados
validated_args <- validate_arguments(args)

# Asignar los valores validados a variables para su uso posterior
mode <- validated_args$mode
directory <- validated_args$directory
keywords_file <- validated_args$keywords_file
language <- validated_args$language
ngram_number <- validated_args$ngram_number

# Llamar a la función principal del script externo
main_get_time(directory, date_hour)
main_process_texts(directory, language, ngram_number, date_hour)

# # Separar los argumentos dependiendo del modo
# if (mode == "manual") {

#   # Llamar a la función principal del script externo
#   main_get_time(directory, date_hour)
#   main_process_texts(directory, language, ngram_number, date_hour)
  
# } else {
  
#   # Llamar a la función principal del script externo
#   main_get_time(directory, date_hour)
#   main_process_texts(directory, language, ngram_number, date_hour)
  
# }



  # # Ejecutar otros programas en diferentes directorios
  # if (condicion_otro_programa1) {
  #   # Directorio del otro programa 1
  #   otro_directorio1 <- "/ruta/al/otro/programa1"
    
  #   # Comando para ejecutar el otro programa 1
  #   comando1 <- paste("Rscript", shQuote(file.path(otro_directorio1, "otro_programa1.R")), "--opcion", "valor1", sep = " ")
    
  #   # Ejecutar el comando en el sistema operativo
  #   system(comando1)
  # }
  
  # if (condicion_otro_programa2) {
  #   # Directorio del otro programa 2
  #   otro_directorio2 <- "/ruta/al/otro/programa2"
    
  #   # Comando para ejecutar el otro programa 2
  #   comando2 <- paste("python", shQuote(file.path(otro_directorio2, "otro_programa2.py")), "--option", "value2", sep = " ")
    
  #   # Ejecutar el comando en el sistema operativo
  #   system(comando2)
  # }
  
  # if (tolower(args[x]) == "stemmp") {
    
  #   # Cargar el resultado desde el archivo .rdata
  #   load(file = file.path(ruta_directorio_, "txt_analysis.rdata"))
    
  #   ruta_directorio <- "/ruta/completa/a/mi_directorio/"
  #   source(file.path(ruta_directorio, "stemming_porter.R"))
    
  #   result_stem <- stem_column("aca va salida del analisis de texto", "word")
    
  #   textWord_stem <- paste("datos/outputData/stem_words", "_", date_hour, ".txt", sep = "")
  #   write.table(result_stem, file = textWord_stem, row.names = FALSE, col.names = TRUE, sep = "\t", quote = FALSE, qmethod = "double")
    
  # }
  
  # Agrega más bloques condicionales para otros programas si es necesario


#### GUIA DE EJECUCION DE LOS SCRIPT
## get_time_v1.R
## txt_analysis_v1.R