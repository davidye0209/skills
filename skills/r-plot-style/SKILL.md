---
name: r-plot-style
description: >-
  Use to generate publication- and presentation-ready scientific plots in R using ggplot2.
---

Standardizes aesthetic rules, palettes, geoms, and export dimensions for academic figures and 16:9 presentation slides.

---

## 1. Theme & Structure

- Source `theme.R` and apply `theme_dy()` (handles L-frame, outward ticks, typography, top legend, and transparent canvas automatically).
- No in-plot titles (`plot.title = element_blank()`) except for gridded multi-plot panels / facets.
- Use `guides(color = guide_pure_circles())` for circle legend keys, and `lineend = "round"` on any custom lines/annotations.
- No end caps for error bars (`stat_line_sd()`).
- No bar plots unless explicitly requested.
- N < 30: Dot plot with individual points and red median line (`stat_red_median()`). N >= 30: Box plot.
- Recognized controls: `control`, `ctrl`, `dmso`, `untreated`, `untr`, `vehicle`, `veh`, `wt`, `parental`, `mock`, `sham`, `nc`.
- Re-level factors with controls first (`factor(x, levels = c("Control", ...))`) before plotting.
- Use colors only when necessary. Ask user if a series needs to be highlighted.
- Hierarchy of factorial design: Genotype (WT/KO) > Treatment (Drug/Vehicle) > Timepoint (0h, 24h, 48h). Ask user to clarify if multiple factors are present in one group.
- Plot three factors maximum. If more, break down to multiple panels.

---

## 2. Color System

### Tokens (defined in `theme.R`)
- `COLOR_BASE`: `#45465e`
- `COLOR_REFERENCE`: `#A8A19C`
- `PALETTE_SERIES` (in order): `#3271AE`, `#C12C1F`, `#4C8045`, `#C67915`, `#A76283`, `#3D8E86`, `#EA5514`, `#6B798E`, `#BA5140`
- `GRADIENT_*` (5-step, Light -> Dark; Step 4 anchors `PALETTE_SERIES` / `COLOR_BASE`):
  - `GRADIENT_GRAPHITE`: `#D3CBC5`, `#A8A19C`, `#6B798E`, `#45465e`, `#31322C`
  - `GRADIENT_BLUE`: `#D4E5EF`, `#BCD4E7`, `#4994C4`, `#3271AE`, `#003460`
  - `GRADIENT_RED`: `#E7CAD3`, `#CF929E`, `#DD6B7B`, `#C12C1F`, `#8F1D22`
  - `GRADIENT_GREEN` (`_SAGE`): `#CAD7C5`, `#99BCAC`, `#68945C`, `#4C8045`, `#446A37`
  - `GRADIENT_GOLD`: `#FFFBC7`, `#FAC03D`, `#DA9233`, `#C67915`, `#9F6027`
  - `GRADIENT_PLUM` (`_LILAC`): `#DCC7E1`, `#BBA1CB`, `#9B8EA9`, `#A76283`, `#422256`
  - `GRADIENT_TEAL`: `#D4DDE1`, `#88BFB8`, `#5DA39D`, `#3D8E86`, `#206864`
- `PALETTE_DIVERGENT_BLUE_RED` (Continuous Blue-White-Red Divergent):
  `#003460`, `#3271AE`, `#4994C4`, `#BCD4E7`, `#D4E5EF`, `#FFFFFF`, `#E7CAD3`, `#CF929E`, `#DD6B7B`, `#C12C1F`, `#8F1D22`
- `PALETTE_CONTINUOUS_*` (Sequential Smooth Continuous for Heatmaps & Hexbins):
  - `PALETTE_CONTINUOUS_GRAPHITE`: `#FFFFFF`, `#D3CBC5`, `#A8A19C`, `#6B798E`, `#45465e`, `#31322C`
  - `PALETTE_CONTINUOUS_BLUE`: `#FFFFFF`, `#D4E5EF`, `#BCD4E7`, `#4994C4`, `#3271AE`, `#003460`
  - `PALETTE_CONTINUOUS_GREEN`: `#FFFFFF`, `#CAD7C5`, `#99BCAC`, `#68945C`, `#4C8045`, `#446A37`

### Categorical & Continuous Rules
- **Named vectors required**: Always use named vectors in `scale_color_manual()` / `scale_fill_manual()`.
- **Single series**: `COLOR_BASE`
- **Two conditions (highlighting)**: Control: `COLOR_REFERENCE`, Highlight: `COLOR_BASE`
- **Multi-series**: `COLOR_REFERENCE` (controls) + `PALETTE_SERIES` in order
- **Titration / Dose-Response**: `GRADIENT_*` mono-hue per entity (Hue = Drug, Luminance = Dose)
  - 2 levels: indices `c(2, 4)`
  - 3 levels: indices `c(2, 4, 5)`
  - 4 levels: indices `c(2, 3, 4, 5)`
- **Adjacent conditions in factorial design**: `GRADIENT_*`
- **Divergent Heatmaps / Fold-Changes / Correlations**: `scale_fill_divergent_dy(midpoint = 0)`
- **Sequential Continuous Heatmaps & Hexbins**: `scale_fill_continuous_dy(palette = "blue" | "green" | "graphite")`

---

## 3. Canvas Sizing & Export

Height standardized to **125 mm (~4.9 in)** at **300 DPI transparent PNG**:

| Preset | Dimensions (W x H) | Primary Use |
|:---|:---|:---|
| `wide` | **140 x 125 mm** | >3 condition dot/box, wide scatter, line chart |
| `volcano` | **145 x 125 mm** | High-density volcano plots with inside legend |
| `square` | **125 x 125 mm** | 1:1 scatter / heatmap / correlation |
| `tall` / `compact` | **85 x 125 mm** | 2–3 condition dot/box plots |

---

## 4. Standard Code Recipes

```r
library(ggplot2)
source("theme.R")

# 1. Dot Plot (N < 30) - Single color default
ggplot(df, aes(x = Condition, y = Value)) +
  geom_dot_points(color = COLOR_BASE, size = 3.5) +
  stat_red_median(width = 0.45, linewidth = 0.85) +
  theme_dy_45() +
  labs(x = "Condition", y = "Response (A.U.)")

# 2. Box Plot (N >= 30)
ggplot(df_large, aes(x = Condition, y = Score)) +
  geom_boxplot(color = COLOR_BASE, fill = "transparent", width = 0.55, linewidth = 0.75, outlier.size = 2.0, lineend = "round") +
  theme_dy() +
  labs(x = "Condition", y = "Score")

# 3. Multi-Series / Time Course / Dose Response
ggplot(df_time, aes(x = Time, y = Value, color = Treatment, group = Treatment)) +
  stat_line_sd(linewidth = 0.9, point_size = 3.5) +
  scale_color_manual(values = c("Control" = COLOR_REFERENCE, "Drug A" = PALETTE_SERIES[1], "Drug B" = PALETTE_SERIES[2])) +
  guides(color = guide_pure_circles(nrow = 2)) +
  theme_dy() +
  labs(x = "Timepoint (Hours)", y = expression(Log[2]~"Normalized Response"))

# 4. Volcano Plot
ggplot(df_volcano, aes(x = log2FC, y = -log10(pvalue), color = Group)) +
  geom_point(aes(size = Group, alpha = Group)) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = COLOR_REFERENCE, linewidth = 0.5, lineend = "round") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = COLOR_REFERENCE, linewidth = 0.5, lineend = "round") +
  scale_color_manual(values = c("NS" = COLOR_REFERENCE, "Down" = PALETTE_SERIES[1], "Up" = PALETTE_SERIES[2])) +
  scale_size_manual(values = c("NS" = 1.5, "Down" = 4.0, "Up" = 4.0)) +
  scale_alpha_manual(values = c("NS" = 0.35, "Down" = 0.95, "Up" = 0.95)) +
  guides(color = guide_pure_circles(size = 3.5), size = "none", alpha = "none") +
  ggrepel::geom_text_repel(data = subset(df_volcano, Significant), aes(label = Gene), size = 3.2, show.legend = FALSE) +
  theme_volcano() +
  labs(x = expression(Log[2]~"Fold Change"), y = expression(-Log[10]~italic(P)~"value"))

# 5. Divergent Heatmap (Z-Scores / Differential Expression)
ggplot(df_heatmap, aes(x = Sample, y = Gene, fill = ZScore)) +
  geom_tile() +
  scale_fill_divergent_dy(midpoint = 0) +
  theme_dy() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Sample", y = "Gene", fill = "Z-Score")

# 6. Hexbin / 2D Count Density (Sequential Continuous)
ggplot(df_density, aes(x = MarkerA, y = MarkerB)) +
  geom_hex(bins = 35) +
  scale_fill_continuous_dy(palette = "blue") +
  theme_dy() +
  labs(x = "Marker A Intensity", y = "Marker B Intensity", fill = "Counts")
```
