#!/usr/bin/env Rscript

# Load required libraries
# library(dplyr)
# library(ggplot2)
# library(tidyr)

# Función para graficar la distribución de frecuencia de términos
plot_term_frequency <- function(docs_words, title="Distribución de Frecuencia de Términos", xlab="Frecuencia de Términos", ylab="Conteo") {
  ggplot(data = docs_words, aes(n/total, fill = document)) +
    geom_histogram(show.legend = FALSE) +
    facet_wrap(~document, ncol = 3, scales = "free_y") +
    ggtitle(title) +
    xlab(xlab) +
    ylab(ylab) +
    theme_minimal()
}

# Función para aplicar la Ley de Zipf y graficar
plot_zipfs_law <- function(docs_words, title="Ley de Zipf", xlab="Rango", ylab="Frecuencia de Término") {
  freq_by_rank <- docs_words %>% 
    group_by(document) %>% 
    mutate(rank = row_number(), frecuencia_de_termino = n/total)
  
  ggplot(freq_by_rank, aes(rank, frecuencia_de_termino, color = document)) + 
    geom_line(size = 1, alpha = 0.8, show.legend = FALSE) + 
    scale_x_log10() +
    scale_y_log10() +
    ggtitle(title) +
    xlab(xlab) +
    ylab(ylab) +
    theme_minimal()
}

# Función para graficar TF-IDF
plot_tf_idf <- function(docs_words, title="Top 10 Palabras por TF-IDF", xlab=NULL, ylab="tf-idf") {
  docs_words %>%
    select(-total) %>%
    arrange(desc(tf_idf)) %>%
    mutate(word = factor(word, levels = rev(unique(word)))) %>% 
    group_by(document) %>% 
    top_n(10) %>% 
    ungroup() %>%
    ggplot(aes(word, tf_idf, fill = document)) +
    geom_col(show.legend = FALSE) +
    labs(x = xlab, y = ylab) +
    facet_wrap(~document, ncol = 3, scales = "free") +
    coord_flip() +
    ggtitle(title) +
    theme_minimal()
}

plot_top_15 <- function(docs_words, title="Top 15 Palabras Más Frecuentes por Documento", xlab=NULL, ylab="Número de Palabras") {
  ggplot(docs_words, aes(x = reorder_within(word, n, document), y = n, fill = document)) +
    geom_bar(stat = "identity") +
    scale_x_reordered() +
    facet_wrap(~document, ncol = 3, scales = "free") +
    theme_minimal() +
    theme(legend.position = "none") +
    ggtitle(title) +
    labs(x = xlab, y = ylab) +
    coord_flip()
}

# Función para guardar un gráfico en PDF con tamaños fijos
save_plot_to_pdf <- function(plot, filename, width = 8, height = 6) {
  ggsave(filename, plot = plot, width = width, height = height, limitsize = FALSE)
}


#############################################################################################

# # Function to plot term frequency distribution
# plot_term_frequency <- function(docs_words, title="Term Frequency Distribution", xlab="Term Frequency", ylab="Count") {
#   ggplot(data = docs_words, aes(n/total, fill = document)) +
#     geom_histogram(show.legend = FALSE) +
#     facet_wrap(~document, ncol = 3, scales = "free_y") +
#     ggtitle(title) +
#     xlab(xlab) +
#     ylab(ylab)
# }

# # Function to apply Zipf's Law and plot
# plot_zipfs_law <- function(docs_words, title="Zipf's Law", xlab="Rank", ylab="Term Frequency") {
#   freq_by_rank <- docs_words %>% 
#     group_by(document) %>% 
#     mutate(rank = row_number(), 'term frequency' = n/total)
  
#   ggplot(freq_by_rank, aes(rank, `term frequency`, color = document)) + 
#     geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) + 
#     scale_x_log10() +
#     scale_y_log10() +
#     ggtitle(title) +
#     xlab(xlab) +
#     ylab(ylab)
# }

# # Function to plot TF-IDF
# plot_tf_idf <- function(docs_words, title="Top 10 Words by TF-IDF", xlab=NULL, ylab="tf-idf") {
#   docs_words %>%
#     select(-total) %>%
#     arrange(desc(tf_idf)) %>%
#     mutate(word = factor(word, levels = rev(unique(word)))) %>% 
#     group_by(document) %>% 
#     top_n(10) %>% 
#     ungroup() %>%
#     ggplot(aes(word, tf_idf, fill = document)) +
#     geom_col(show.legend = FALSE) +
#     labs(x = xlab, y = ylab) +
#     facet_wrap(~document, ncol = 2, scales = "free") +
#     coord_flip() +
#     ggtitle(title)
# }


# # Function to plot yearly frequency of all words
# plot_yearly_frequency <- function(data_words, title="Yearly Frequency", xlab="Year", ylab="Frequency") {
#   yearly_counts <- data_words %>%
#     mutate(year = year(ymd(date))) %>%
#     count(year, word)
  
#   ggplot(yearly_counts) +
#     geom_col(aes(x = year, y = n, fill = word)) +
#     ggtitle(title) +
#     xlab(xlab) +
#     ylab(ylab)
# }

# # Function to save a plot to PDF with adaptive dimensions
# save_plot_to_pdf <- function(plot, filename, min_width = 8, min_height = 6, max_width = 50, max_height = 50) {
#   # Convert plot to grob
#   plot_grob <- ggplotGrob(plot)
  
#   # Calculate the plot dimensions
#   plot_width <- sum(as.numeric(plot_grob$widths))
#   plot_height <- sum(as.numeric(plot_grob$heights))
  
#   # Print the dimensions for debugging
#   print(paste("Calculated Plot Width:", plot_width))
#   print(paste("Calculated Plot Height:", plot_height))
  
#   # Adjust plot dimensions to be within the max size limits
#   plot_width <- min(max(plot_width, min_width), max_width)
#   plot_height <- min(max(plot_height, min_height), max_height)
  
#   # Print adjusted dimensions for debugging
#   print(paste("Adjusted Plot Width:", plot_width))
#   print(paste("Adjusted Plot Height:", plot_height))
  
#   # Save the plot to PDF with the calculated dimensions, using limitsize = FALSE
#   ggsave(filename, plot = plot, width = plot_width, height = plot_height, limitsize = FALSE)
# }

##############################################################################################################3


# save_plot_to_pdf <- function(plot, filename) {
#   # Calculate the plot dimensions
#   plot_grob <- ggplotGrob(plot)
#   plot_width <- sum(plot_grob$widths)
#   plot_height <- sum(plot_grob$heights)
  
#   # Save the plot to PDF with the calculated dimensions
#   ggsave(filename, plot = plot, width = as.numeric(plot_width), height = as.numeric(plot_height))
# }

# Example usage for term frequency plot:
# docs_words <- read.csv("your_data.csv") # Load your data here
# term_frequency_plot <- plot_term_frequency(docs_words, title="Distribución de Frecuencia de Términos", xlab="Frecuencia de Términos", ylab="Conteo")
# save_plot_to_pdf(term_frequency_plot, "term_frequency.pdf")

# Example usage for Zipf's Law plot:
# docs_words <- read.csv("your_data.csv") # Load your data here
# zipfs_law_plot <- plot_zipfs_law(docs_words, title="Ley de Zipf", xlab="Rango", ylab="Frecuencia de Término")
# save_plot_to_pdf(zipfs_law_plot, "zipfs_law.pdf")

# Example usage for TF-IDF plot:
# docs_words <- read.csv("your_data.csv") # Load your data here
# tf_idf_plot <- plot_tf_idf(docs_words, title="Top 10 Palabras por TF-IDF", xlab=NULL, ylab="tf-idf")
# save_plot_to_pdf(tf_idf_plot, "tf_idf.pdf")

######################################################################################

# #!/usr/bin/env Rscript

# # Load required libraries
# # library(dplyr)
# # library(ggplot2)
# # library(tidyr)

# # Function to plot term frequency distribution
# plot_term_frequency <- function(docs_words) {
#   ggplot(data = docs_words, aes(n/total, fill = document)) +
#     geom_histogram(show.legend = FALSE) +
#     facet_wrap(~document, ncol = 3, scales = "free_y") +
#     ggtitle("Term Frequency Distribution") +
#     xlab("Term Frequency") +
#     ylab("Count")
# }

# # Function to apply Zipf's Law and plot
# plot_zipfs_law <- function(docs_words) {
#   freq_by_rank <- docs_words %>% 
#     group_by(document) %>% 
#     mutate(rank = row_number(),
#            'term frequency' = n/total)
  
#   ggplot(freq_by_rank, aes(rank, `term frequency`, color = document)) + 
#     geom_line(size = 1.1, alpha = 0.8, show.legend = FALSE) + 
#     scale_x_log10() +
#     scale_y_log10() +
#     ggtitle("Zipf's Law") +
#     xlab("Rank") +
#     ylab("Term Frequency")
# }

# # Function to plot TF-IDF
# plot_tf_idf <- function(docs_words) {
#   docs_words %>%
#     select(-total) %>%
#     arrange(desc(tf_idf)) %>%
#     mutate(word = factor(word, levels = rev(unique(word)))) %>% 
#     group_by(document) %>% 
#     top_n(10) %>% 
#     ungroup() %>%
#     ggplot(aes(word, tf_idf, fill = document)) +
#     geom_col(show.legend = FALSE) +
#     labs(x = NULL, y = "tf-idf") +
#     facet_wrap(~document, ncol = 2, scales = "free") +
#     coord_flip() +
#     ggtitle("Top 10 Words by TF-IDF")
# }

# # Función para guardar un gráfico en PDF con dimensiones adaptativas
# save_plot_to_pdf <- function(plot, filename) {
#   # Calcular las dimensiones del gráfico
#   plot_grob <- ggplotGrob(plot)
#   plot_width <- sum(plot_grob$widths)
#   plot_height <- sum(plot_grob$heights)
  
#   # Guardar el gráfico en PDF con las dimensiones calculadas
#   ggsave(filename, plot = plot, width = as.numeric(plot_width), height = as.numeric(plot_height))
# }