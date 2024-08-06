#!/usr/bin/env Rscript

# Function to plot the frequency distribution of terms
plot_term_frequency <- function(docs_words, title="Term Frequency Distribution", xlab="Terms Frequency", ylab="Count") {
  ggplot(data = docs_words, aes(n/total, fill = document)) +
    geom_histogram(show.legend = FALSE) +
    facet_wrap(~document, ncol = 3, scales = "free_y") +
    ggtitle(title) +
    xlab(xlab) +
    ylab(ylab) +
    theme_minimal()
}

# Function to apply Zipf's Law and graph
plot_zipfs_law <- function(docs_words, title="Zipf's Law", xlab="Range", ylab="Term Frequency") {
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

# Function to graph TF-IDF
plot_tf_idf <- function(docs_words, title="Top 10 Words by TF-IDF", xlab=NULL, ylab="tf-idf") {
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

plot_top_10 <- function(docs_words, title="Top 10 Most Frequent Words per Document", xlab=NULL, ylab="Number of words") {
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

# # Función para extraer el año de la columna date
# extract_year <- function(df) {
#   df %>%
#     mutate(year = year(dmy(date)))
# }

# # Función para graficar el total de palabras por año
# plot_words_per_year <- function(df, title = "Total de Palabras por Año", xlab = "Año", ylab = "Total de Palabras") {
#   words_per_year <- df %>%
#     extract_year() %>%
#     group_by(year) %>%
#     summarise(total_words = n()) # n() cuenta el número de filas por grupo
  
#   ggplot(words_per_year, aes(x = factor(year), y = total_words)) +
#     geom_bar(stat = "identity", fill = "skyblue") +
#     ggtitle(title) +
#     xlab(xlab) +
#     ylab(ylab) +
#     theme_minimal()
# }


# Feature to save a chart to PDF with fixed sizes
save_plot_to_pdf <- function(plot, filename, width = 8, height = 6) {
  ggsave(filename, plot = plot, width = width, height = height, limitsize = FALSE)
}

