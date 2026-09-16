# Advanced Annotation & Direct Labeling Reference

Techniques for direct labeling, multi-scale coloring, and inline typographic styling in ggplot2.

---

## 1. Halo / Shadowed Direct Labels (`shadowtext`)

Draws text with a background outline / halo. This prevents background grid lines or overlapping curves from cutting through text annotations without creating rigid bounding boxes.

### Dependencies
```r
library(ggplot2)
library(shadowtext)
```

### Usage
```r
geom_shadowtext(
  data = line_labels,
  aes(x = x, y = y, label = labels, color = color),
  hjust = 0,
  bg.colour = "white",  # Halo / shadow color behind text
  bg.r = 0.4,           # Radius / thickness of the halo outline
  size = 4,
  show.legend = FALSE
)
```

---

## 2. Multi-Color Scale Layering (`ggnewscale` + `scale_color_identity`)

Allows introducing an independent color scale for text annotations or secondary layers without conflicting with the main plot's primary `scale_color_manual()`.

### Dependencies
```r
library(ggplot2)
library(ggnewscale)
```

### Usage
```r
# 1. Primary series layer
ggplot(df, aes(x = x, y = y, color = Group)) +
  geom_line(linewidth = 1) +
  scale_color_manual(values = my_palette) +
  
  # 2. Break color scale to introduce an independent annotation color mapping
  new_scale_color() +
  geom_text(
    data = label_df,
    aes(x = x, y = y, label = Label, color = HexColor),
    hjust = 0
  ) +
  scale_color_identity()  # Interprets HexColor values directly
```

---

## 3. In-Plot Axis / Grid Value Labels

Places gridline values directly at the right/left boundary of the plot area above major horizontal gridlines, useful when standard outer axis tick text is suppressed.

### Usage
```r
geom_text(
  data = data.frame(
    x = max_x,                    # Rightmost x coordinate
    y = seq(0, 300, by = 50)      # Grid break values
  ),
  aes(x = x, y = y, label = y),
  hjust = 1,                      # Right-aligned against the border
  vjust = 0,                      # Bottom-aligned
  nudge_y = max_y * 0.01,         # 1% vertical offset above the grid line
  size = 3.5,
  color = "#5C5B5D",
  inherit.aes = FALSE
)
```

---

## 4. Markdown-Formatted Headers (`ggtext::element_markdown`)

Enables inline markdown formatting (bolding, italics, font colors) in titles, subtitles, and captions without requiring complex `bquote()` or `expression()` syntax.

### Dependencies
```r
library(ggplot2)
library(ggtext)
```

### Usage
```r
theme(
  plot.title = element_markdown(
    size = 14,
    lineheight = 1.2
  ),
  plot.subtitle = element_markdown(
    size = 11,
    color = "grey40"
  )
) +
labs(
  title = "**Selected cohort,** % of total population (2020–2024)",
  subtitle = "Values represent *mean ± SD* across replicates"
)
```
