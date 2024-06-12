# init_utilitis.R

help_function <- function() {
  # Title
  cat("Usage: Program description \n\n")
  
  # Arguments Section
  cat("🛠 ARGUMENTS:\n")
  cat("\tIf you want to create AUTOMATIC categories\n")
  cat("\t-d file.txt\t\t Specifies the directory where the texts are.\n")
  cat("\t-l SP or EN\t Specifies the language of the texts for processing.\n")
  cat("\t-n ngram\t\t Specify the ngram number you want to work on.\n\n")
  
  cat("\tIf you want to create MANUAL categories\n")
  cat("\t-d file.txt\t\t Specifies the directory where the texts are.\n")
  cat("\t-k keywords.txt\t\t Specify the table with the keywords.\n")
  cat("\t-l SP or EN\t Specifies the language of the texts for processing.\n")
  cat("\t-n ngram\t\t Specify the ngram number you want to work on.\n\n")
  
  cat("\t-help\t\t\tMuestra esta ayuda y la lista de argumentos 🆘\n\n")
  
  # Keyword table format
  cat("📄 FORMAT OF THE KEYWORDS TABLE:\n")
  cat("\t Keywords (tab separated)\n\n")
  
  # Contact
  cat("📨 CONTACT:\n")
  
}

# Function to validate the arguments
validate_arguments <- function(args) {
  if (length(args) == 3) {
    mode <- "auto"
    directory <- args[1]
    language <- args[2]
    ngram_number <- as.integer(args[3])
  } else if (length(args) == 4) {
    mode <- "manual"
    directory <- args[1]
    keywords_file <- args[2]
    language <- args[3]
    ngram_number <- as.integer(args[4])
  } else {
    stop("Program usage:\n",
         "\tFor automatic categories: path/de/file language ngram\n",
         "\tFor manual categories: path/de/file path/de/keywords.txt language ngram\n")
  }
  
  # Validate that the directory exists
  if (!file.exists(directory) || !file.info(directory)$isdir) {
    stop("The first argument must be a valid path to an existing directory")
  }
  
  # Validate keyword file if in manual mode
  if (mode == "manual" && (!file.exists(keywords_file) || file.info(keywords_file)$isdir)) {
    stop("The second argument in manual mode must be a valid path to an existing keyword file")
  }
  
  # Validate the language
  if (!language %in% c("SP", "EN")) {
    stop("The third argument must be 'SP' or 'EN'")
  }
  
  # Validate ngram number
  if (is.na(ngram_number) || ngram_number <= 0) {
    stop("The last argument must be a positive integer >= 1 & <= 3")
  }
  
  # Return the validated values and the mode
  return(list(
    mode = mode,
    directory = directory,
    keywords_file = if (mode == "manual") keywords_file else NULL,
    language = language,
    ngram_number = ngram_number
  ))
}
