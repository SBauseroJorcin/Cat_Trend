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
  # Parse arguments manually
  directory <- NULL
  keywords_file <- NULL
  language <- NULL
  ngram_number <- NULL

  for (i in seq_along(args)) {
    if (args[i] == "--file" && (i + 1) <= length(args)) {
      directory <- args[i + 1]
    } else if (args[i] == "--keywords" && (i + 1) <= length(args)) {
      keywords_file <- args[i + 1]
    } else if (args[i] == "--language" && (i + 1) <= length(args)) {
      language <- args[i + 1]
    } else if (args[i] == "--ngram" && (i + 1) <= length(args)) {
      ngram_number <- as.integer(args[i + 1])
    }
  }

  # Check if all necessary arguments were provided
  if (is.null(directory) || is.null(language) || is.null(ngram_number)) {
    stop("Program usage:\n",
         "\tFor categories: ./main.R --file directory [--keywords keywords_file] --language SP|EN --ngram ngram\n")
  }

  # Validate that the directory exists
  if (!file.exists(directory) || !file.info(directory)$isdir) {
    stop("The --file argument must be a valid path to an existing directory")
  }

  # Validate keyword file if provided
  if (!is.null(keywords_file) && (!file.exists(keywords_file) || file.info(keywords_file)$isdir)) {
    stop("The --keywords argument must be a valid path to an existing keyword file, if provided")
  }

  # Validate the language
  if (!language %in% c("SP", "EN")) {
    stop("The --language argument must be 'SP' or 'EN'")
  }

  # Validate ngram number
  if (is.na(ngram_number) || ngram_number <= 0 || ngram_number > 3) {
    stop("The --ngram argument must be a positive integer >= 1 and <= 3")
  }

  # Return the validated values
  return(list(
    directory = directory,
    keywords_file = keywords_file,
    language = language,
    ngram_number = ngram_number
  ))
}

## NEED SHOW INFORMATION TO USER OF LIBRARY
manage_packages <- function(required_packages) {
  for (pkg in required_packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg)
    }
    library(pkg, character.only = TRUE)
  }
}

