#!/usr/bin/env Rscript

# Function to plot the time line documents
plot_timeline <- function(date_table, title="Document per site", xlab="", ylab="Site") {

df_actas <- read.delim(date_table, 
                       header = FALSE, sep = "\t", stringsAsFactors = FALSE)

colnames(df_actas) <- c("file", "dates")

df_actas <- df_actas %>%
  mutate(
    sitio = tools::file_path_sans_ext(basename(file)),
    dates = dmy(dates)   # convert dates
  ) %>%
  filter(!is.na(dates))  # remove "Date not found"

df_actas$sitio <- recode(df_actas$sitio, !!!nombres_corregidos)

# session count
conteo_sesiones <- df_actas %>%
  group_by(sitio) %>%
  summarize(n_sesiones = n())

# Date range
rango_dates <- df_actas %>%
  group_by(sitio) %>%
  summarize(
    inicio = min(dates),
    fin    = max(dates)
  ) %>%
  left_join(conteo_sesiones, by = "sitio") %>%
  arrange(desc(n_sesiones)) %>%
  mutate(sitio = factor(sitio, levels = sitio))

# sequence of year
anios <- seq(from = year(min(df_actas$dates)),
             to   = year(max(df_actas$dates)), by = 1)
breaks_centrados <- as.Date(paste0(anios, "-07-01"))

# Plot
ggplot() +
  geom_segment(
    data = rango_dates,
    aes(x = inicio, xend = fin, y = sitio, yend = sitio),
    size = 10,
    color = "paleturquoise3"
  ) +
  geom_point(
    data = df_actas,
    aes(x = dates, y = sitio),
    color = "gray1",
    size = 2.5,
    alpha = 0.7
  ) +
  scale_x_date(
    breaks = breaks_centrados,
    date_labels = "%Y"
  ) +
  theme_light() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_line(color = "gray"),
    panel.grid.major.y = element_line(color = "gray"),
    axis.text.y = element_text(size = 15),
    axis.text.x = element_text(size = 15, angle = 45, hjust = 1)
  ) +
  labs(
    title = title,
    x = "",
    y = ylab
  )
}