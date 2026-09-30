# Spatial Analysis in R
# This script creates a simple study area polygon, sample points, buffers, and a map.

# Load required libraries
library(sf)
library(ggplot2)
library(dplyr)

# Create outputs directory if it does not exist
output_dir <- "outputs"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# 1. Create a study area polygon
study_area <- st_sfc(
  st_polygon(list(rbind(
    c(0, 0),
    c(0, 12),
    c(12, 12),
    c(12, 0),
    c(0, 0)
  ))),
  crs = 4326
)

study_area_sf <- st_sf(area_name = "study_area", geometry = study_area)

# 2. Create sample point locations
points_df <- data.frame(
  id = paste0("P", 1:8),
  name = paste("Point", 1:8),
  x = c(2, 4, 6, 8, 10, 3, 7, 9),
  y = c(2, 3, 6, 8, 5, 9, 10, 2)
)

points_sf <- st_as_sf(points_df, coords = c("x", "y"), crs = 4326)

# 3. Spatial analysis: check points within the study area
inside_area <- st_within(points_sf, study_area_sf)
points_sf$inside_study_area <- lengths(inside_area) > 0

# 4. Create buffer zones around each point
buffer_distance <- 1.5
buffers_sf <- st_buffer(points_sf, dist = buffer_distance)
buffers_sf$buffer_distance <- buffer_distance

# 5. Save outputs
st_write(study_area_sf, file.path(output_dir, "study_area.geojson"), driver = "GeoJSON", delete_dsn = TRUE)
st_write(points_sf, file.path(output_dir, "sample_points.geojson"), driver = "GeoJSON", delete_dsn = TRUE)
st_write(buffers_sf, file.path(output_dir, "buffers.geojson"), driver = "GeoJSON", delete_dsn = TRUE)

# 6. Summaries
summary_table <- points_sf %>%
  summarise(
    total_points = n(),
    points_in_area = sum(inside_study_area),
    points_outside_area = sum(!inside_study_area),
    avg_x = mean(st_coordinates(geometry)[, 1]),
    avg_y = mean(st_coordinates(geometry)[, 2]),
    min_x = min(st_coordinates(geometry)[, 1]),
    max_x = max(st_coordinates(geometry)[, 1]),
    min_y = min(st_coordinates(geometry)[, 2]),
    max_y = max(st_coordinates(geometry)[, 2])
  )

print(summary_table)

# 7. Plot the map
map_plot <- ggplot() +
  geom_sf(data = study_area_sf, fill = "lightgray", color = "black") +
  geom_sf(data = points_sf, aes(color = inside_study_area), size = 3) +
  geom_sf(data = buffers_sf, fill = "cornflowerblue", alpha = 0.35, color = "navy") +
  scale_color_manual(values = c("FALSE" = "red", "TRUE" = "royalblue"), name = "Inside area") +
  labs(
    title = "Spatial Analysis Example",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal()

ggsave(file.path(output_dir, "spatial_analysis_map.png"), plot = map_plot, width = 8, height = 8, dpi = 200)

message("Outputs saved to: ", output_dir)
