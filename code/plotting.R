#!/usr/bin/env Rscript


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

