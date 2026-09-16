# ==============================================================================
# theme.R - Scientific Plot Theme, Tokens & Helpers
# ==============================================================================
# Standardizes aesthetic rules, palettes, geoms, and export dimensions
# optimized for academic figures and 16:9 presentation slides.
# ==============================================================================

suppressPackageStartupMessages({
  library(ggplot2)
})

# ------------------------------------------------------------------------------
# 1. Color Tokens & Control Detection
# ------------------------------------------------------------------------------

# Regex matching standard biological/experimental controls
CONTROL_REGEX <- "(?i)^(control|ctrl|dmso|untreated|untr|vehicle|veh|wt|parental|mock|sham|nc)$"

is_control_label <- function(x) {
  grepl(CONTROL_REGEX, trimws(as.character(x)))
}

# Color Tokens
COLOR_BASE      <- "#45465e" 
COLOR_REFERENCE <- "#A8A19C" 

# Backward-compatibility aliases
COLOR_PRIMARY   <- COLOR_BASE
COLOR_CONTROL   <- COLOR_REFERENCE
COLOR_ACCENT    <- "#A76283" 

# Ordered Series 
PALETTE_SERIES <- c(
  "#3271AE", # 1. Blue   
  "#C12C1F", # 2. Red    
  "#4C8045", # 3. Green  
  "#C67915", # 4. Gold   
  "#A76283", # 5. Plum   
  "#3D8E86", # 6. Teal   
  "#EA5514", # 7. Orange 
  "#6B798E", # 8. Slate  
  "#BA5140"  # 9. Rust   
)

# ------------------------------------------------------------------------------
# 2. 5-Step Continuous Gradients
# ------------------------------------------------------------------------------

# 1. Earthy Grayscale / Graphite Gradient (Light -> Dark)
GRADIENT_GRAPHITE <- c(
  "#D3CBC5", 
  "#A8A19C", 
  "#6B798E", 
  "#45465e", 
  "#31322C"  
)

# 2. Blue Gradient 
GRADIENT_BLUE <- c(
  "#D4E5EF", 
  "#BCD4E7", 
  "#4994C4", 
  "#3271AE", 
  "#003460"  
)

# 3. Red Gradient 
GRADIENT_RED <- c(
  "#E7CAD3", 
  "#CF929E", 
  "#DD6B7B", 
  "#C12C1F", 
  "#8F1D22"  
)

# 4. Green Gradient 
GRADIENT_GREEN <- c(
  "#CAD7C5", 
  "#99BCAC", 
  "#68945C", 
  "#4C8045", 
  "#446A37"  
)


# 5. Gold Gradient 
GRADIENT_GOLD <- c(
  "#FFFBC7", 
  "#FAC03D", 
  "#DA9233", 
  "#C67915", 
  "#9F6027"  
)

# 6. Purple Gradient 
GRADIENT_PLUM <- c(
  "#DCC7E1", 
  "#BBA1CB", 
  "#9B8EA9", 
  "#A76283", 
  "#422256"  
)


# 7. Teal Gradient 
GRADIENT_TEAL <- c(
  "#D4DDE1", 
  "#88BFB8", 
  "#5DA39D", 
  "#3D8E86", 
  "#206864"  
)

# 8. Orange Gradient 
GRADIENT_ORANGE <- c(
  "#ECD9C7", 
  "#F5B087", 
  "#F18F60", 
  "#EA5514", 
  "#9F5221"  
)

# ------------------------------------------------------------------------------
# 3. Continuous & Divergent Palette Vectors (Heatmaps & Hexbins)
# ------------------------------------------------------------------------------

# 1. Divergent Blue-White-Red Palette 
PALETTE_DIVERGENT_BLUE_RED <- c(
  "#003460", 
  "#3271AE", 
  "#4994C4", 
  "#BCD4E7", 
  "#D4E5EF", 
  "#FFFFFF", 
  "#E7CAD3", 
  "#CF929E", 
  "#DD6B7B", 
  "#C12C1F", 
  "#8F1D22" 
)

# 2. Sequential Continuous Palette Anchors (Smooth Light -> Dark)
PALETTE_CONTINUOUS_GRAPHITE <- c("#FFFFFF", "#D3CBC5", "#A8A19C", "#6B798E", "#45465e", "#31322C")
PALETTE_CONTINUOUS_BLUE     <- c("#FFFFFF", "#D4E5EF", "#BCD4E7", "#4994C4", "#3271AE", "#003460")
PALETTE_CONTINUOUS_GREEN    <- c("#FFFFFF", "#CAD7C5", "#99BCAC", "#68945C", "#4C8045", "#446A37")

# ------------------------------------------------------------------------------
# 4. Base Themes
# ------------------------------------------------------------------------------

#' Presentation & Publication Base Theme
#' - Transparent background
#' - No tags/subsections
#' - No in-plot chart title; retains X and Y axis titles
#' - Open L-frame with round line ends & outward ticks
#' - Top-aligned horizontal legend with pure circle keys
theme_dy <- function(base_size = 13, base_family = "Helvetica", line_width = 0.75) {
  theme_classic(base_size = base_size, base_family = base_family) %+replace%
    theme(
      # Axes & Ticks (Round ends, outward ticks)
      axis.line = element_line(color = "black", linewidth = line_width, lineend = "round"),
      axis.ticks = element_line(color = "black", linewidth = line_width, lineend = "round"),
      axis.ticks.length = unit(0.2, "cm"),
      axis.title.x = element_text(color = "black", size = rel(1.0), margin = margin(t = 6, b = 2)),
      axis.title.y = element_text(color = "black", size = rel(1.0), angle = 90, margin = margin(r = 6, l = 2)),
      axis.text = element_text(color = "black", size = rel(0.9)),

      # Suppress Chart Title & Tags completely (except multi-plot grid facets)
      plot.title = element_blank(),
      plot.subtitle = element_blank(),
      plot.tag = element_blank(),

      # Legend (Default Top, horizontal, pure circle glyphs, no box/border)
      legend.position = "top",
      legend.direction = "horizontal",
      legend.justification = "center",
      legend.title = element_blank(),
      legend.background = element_blank(),
      legend.key = element_blank(),
      legend.key.size = unit(1.0, "lines"),
      legend.spacing.x = unit(0.2, "cm"),
      legend.text = element_text(color = "black", size = rel(0.9)),
      legend.margin = margin(t = 0, b = 6),

      # Transparent Canvas & Facets (No grid lines)
      panel.background = element_blank(),
      plot.background = element_blank(),
      panel.grid = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      strip.background = element_blank(),
      strip.text = element_text(color = "black", face = "bold", size = rel(1.0)),

      # Plot Margins
      plot.margin = margin(t = 12, r = 12, b = 10, l = 12)
    )
}

#' Theme with 45-degree Angled X-axis Text
theme_dy_45 <- function(...) {
  theme_dy(...) %+replace%
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, color = "black")
    )
}

#' Volcano Plot Theme (Inside Top-Right Legend)
theme_volcano <- function(base_size = 14, base_family = "Helvetica", line_width = 0.75) {
  theme_dy(base_size = base_size, base_family = base_family, line_width = line_width) %+replace%
    theme(
      legend.position = "inside",
      legend.position.inside = c(0.98, 0.98),
      legend.justification = c(1, 1),
      legend.direction = "vertical",
      legend.text = element_text(size = rel(0.95)),
      plot.margin = margin(t = 12, r = 10, b = 10, l = 10)
    )
}

# ------------------------------------------------------------------------------
# 4. Specialized Plotting Helpers & Layers
# ------------------------------------------------------------------------------

#' Add a single horizontal red median line segment with round ends for dot plots
stat_red_median <- function(fun = "median", width = 0.45, linewidth = 0.85, color = "#E41A1C", ...) {
  stat_summary(
    fun = fun,
    fun.min = fun,
    fun.max = fun,
    geom = "errorbar",
    width = width,
    color = color,
    linewidth = linewidth,
    lineend = "round",
    show.legend = FALSE,
    ...
  )
}

#' Replicate points for dot plots (<30 samples)
geom_dot_points <- function(mapping = NULL, data = NULL, shape = 16, size = 3.2, color = COLOR_BASE, alpha = 0.85,
                            position = position_jitter(width = 0.08, height = 0, seed = 42), ...) {
  if (!is.null(mapping) && ("colour" %in% names(mapping) || "color" %in% names(mapping))) {
    geom_point(mapping = mapping, data = data, shape = shape, size = size, alpha = alpha, position = position, ...)
  } else {
    geom_point(mapping = mapping, data = data, shape = shape, size = size, color = color, alpha = alpha, position = position, ...)
  }
}

#' Mean line & point with vertical standard deviation (SD) without caps (all round line ends)
stat_line_sd <- function(linewidth = 0.85, point_size = 3.5, ...) {
  list(
    stat_summary(fun = mean, geom = "line", linewidth = linewidth, lineend = "round", ...),
    stat_summary(
      fun.data = function(y) {
        m <- mean(y, na.rm = TRUE)
        s <- sd(y, na.rm = TRUE)
        data.frame(y = m, ymin = m - s, ymax = m + s)
      },
      geom = "linerange",
      linewidth = linewidth * 0.85,
      lineend = "round",
      ...
    ),
    stat_summary(fun = mean, geom = "point", size = point_size, ...)
  )
}

#' Draw dashed vertical divider lines with round ends between categorical x positions
geom_group_dividers <- function(xintercepts, linetype = "dashed", color = "black", linewidth = 0.5, ...) {
  geom_vline(xintercept = xintercepts, linetype = linetype, color = color, linewidth = linewidth, lineend = "round", ...)
}

#' Add a significance bracket with text/asterisks and round line ends
annotate_significance <- function(x_start, x_end, y, label = "***", bar_height = NULL,
                                  linewidth = 0.65, text_size = 4.2, vjust = -0.3) {
  layers <- list(
    annotate("segment", x = x_start, xend = x_end, y = y, yend = y, linewidth = linewidth, color = "black", lineend = "round"),
    annotate("text", x = (x_start + x_end) / 2, y = y, label = label, size = text_size, vjust = vjust, color = "black")
  )
  if (!is.null(bar_height) && bar_height > 0) {
    layers <- c(layers, list(
      annotate("segment", x = x_start, xend = x_start, y = y, yend = y - bar_height, linewidth = linewidth, color = "black", lineend = "round"),
      annotate("segment", x = x_end, xend = x_end, y = y, yend = y - bar_height, linewidth = linewidth, color = "black", lineend = "round")
    ))
  }
  return(layers)
}

#' Helper to enforce pure circle glyphs in legends (no crossing lines, boxes, or borders)
guide_pure_circles <- function(size = 3.5, nrow = NULL, ncol = NULL, byrow = FALSE) {
  guide_legend(
    nrow = nrow,
    ncol = ncol,
    byrow = byrow,
    override.aes = list(
      shape = 16,
      linetype = 0,
      linewidth = 0,
      stroke = 0,
      size = size
    )
  )
}

#' Divergent Blue-White-Red Continuous Fill Scale for Heatmaps / Z-Scores
scale_fill_divergent_dy <- function(low = "#3271AE", mid = "#FFFFFF", high = "#C12C1F",
                                    midpoint = 0, colors = NULL, ...) {
  if (is.null(colors)) {
    scale_fill_gradient2(low = low, mid = mid, high = high, midpoint = midpoint, ...)
  } else {
    scale_fill_gradientn(colors = colors, ...)
  }
}

#' Divergent Blue-White-Red Continuous Color Scale for Heatmaps / Z-Scores
scale_color_divergent_dy <- function(low = "#3271AE", mid = "#FFFFFF", high = "#C12C1F",
                                     midpoint = 0, colors = NULL, ...) {
  if (is.null(colors)) {
    scale_color_gradient2(low = low, mid = mid, high = high, midpoint = midpoint, ...)
  } else {
    scale_color_gradientn(colors = colors, ...)
  }
}

#' Sequential Smooth Continuous Fill Scale for Heatmaps & Hexbins
scale_fill_continuous_dy <- function(palette = c("blue", "green", "graphite"),
                                     colors = NULL, ...) {
  palette <- match.arg(palette)
  pal_colors <- if (!is.null(colors)) {
    colors
  } else switch(palette,
    "blue"     = PALETTE_CONTINUOUS_BLUE,
    "green"    = PALETTE_CONTINUOUS_GREEN,
    "graphite" = PALETTE_CONTINUOUS_GRAPHITE
  )
  scale_fill_gradientn(colors = pal_colors, ...)
}

#' Sequential Smooth Continuous Color Scale for Heatmaps & Hexbins
scale_color_continuous_dy <- function(palette = c("blue", "green", "graphite"),
                                      colors = NULL, ...) {
  palette <- match.arg(palette)
  pal_colors <- if (!is.null(colors)) {
    colors
  } else switch(palette,
    "blue"     = PALETTE_CONTINUOUS_BLUE,
    "green"    = PALETTE_CONTINUOUS_GREEN,
    "graphite" = PALETTE_CONTINUOUS_GRAPHITE
  )
  scale_color_gradientn(colors = pal_colors, ...)
}

# ------------------------------------------------------------------------------
# 6. Slide & Publication Figure Export (Transparent PNG)
# ------------------------------------------------------------------------------

#' Save plot with standardized dimensions and transparent background
#' Dimensions tailored for standard 16:9 slide left-half placement:
#' - 'wide': 140 mm x 125 mm
#' - 'volcano': 145 mm x 125 mm
#' - 'square': 125 mm x 125 mm
#' - 'tall' / 'compact': 85 mm x 125 mm
save_publication_figure <- function(filename, plot = last_plot(),
                                    type = c("wide", "tall", "compact", "square", "volcano", "slide_half", "custom"),
                                    width = NULL, height = NULL,
                                    units = "mm", dpi = 300,
                                    bg = "transparent", ...) {
  type <- match.arg(type)

  if (is.null(width) || is.null(height)) {
    if (type %in% c("wide", "slide_half")) {
      width <- 140
      height <- 125
    } else if (type %in% c("tall", "compact")) {
      width <- 85
      height <- 125
    } else if (type == "square") {
      width <- 125
      height <- 125
    } else if (type == "volcano") {
      width <- 145
      height <- 125
    }
  }

  ggsave(
    filename = filename,
    plot = plot,
    width = width,
    height = height,
    units = units,
    dpi = dpi,
    bg = bg,
    ...
  )
  message(sprintf("Saved transparent figure to %s [%.1f x %.1f %s @ %d DPI]", filename, width, height, units, dpi))
}
