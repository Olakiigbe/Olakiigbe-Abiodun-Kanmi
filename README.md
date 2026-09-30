# Spatial Analysis Project

This repository contains a simple Python project for spatial analysis using GeoPandas and Shapely. It demonstrates a few core spatial operations:

- creating sample point data
- creating a study area polygon
- calculating buffer zones around points
- checking which points fall within a boundary
- exporting outputs to GeoJSON
- plotting the result

## Features

- Point and polygon analysis
- Buffer generation
- Spatial summary statistics
- GeoJSON export
- Visualization with Matplotlib

## Requirements

Python 3.10+

Install dependencies:

```bash
pip install -r requirements.txt
```

## Run the analysis

```bash
python spatial_analysis.py
```

This will create the following outputs in the `outputs/` directory:

- `study_area.geojson`
- `sample_points.geojson`
- `buffers.geojson`
- `spatial_analysis_map.png`

## Project structure

```text
.
├── README.md
├── requirements.txt
├── spatial_analysis.py
├── outputs/
└── .gitignore
```

## Example use cases

This starter project can be extended for:

- land-use mapping
- wildlife movement analysis
- urban planning and service coverage
- environmental monitoring
- facility accessibility studies
