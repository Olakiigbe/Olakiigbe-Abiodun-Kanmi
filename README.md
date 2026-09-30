# Spatial Analysis Project (R Version)

This project is implemented in R using the `sf` and `ggplot2` packages for vector spatial analysis and visualization.

## What this script does

- creates a study area polygon
- creates sample point features
- checks which points fall inside the polygon
- creates a 1.5-unit buffer around each point
- saves the outputs as GeoJSON files
- produces a map visualization

## Requirements

Install R (version 4.0 or newer) and then run:

```r
install.packages(c("sf", "ggplot2", "dplyr"), repos = "https://cloud.r-project.org")
```

## Run the project

```bash
Rscript spatial_analysis.R
```

This will create the following files in the `outputs/` folder:

- `study_area.geojson`
- `sample_points.geojson`
- `buffers.geojson`
- `spatial_analysis_map.png`

## File structure

```text
.
├── README.md
├── spatial_analysis.R
├── install_packages.R
├── outputs/
├── .gitignore
└── requirements.txt
```

## Example use cases

This starter project can be adapted for:

- land cover analysis
- flood risk mapping
- urban planning
- environmental monitoring
- location intelligence
- service coverage analysis
