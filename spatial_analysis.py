import os
from pathlib import Path

import geopandas as gpd
import matplotlib.pyplot as plt
import pandas as pd
from shapely.geometry import Point, Polygon


OUTPUT_DIR = Path("outputs")
OUTPUT_DIR.mkdir(exist_ok=True)


def create_sample_data():
    """Create a study area polygon and sample point features."""
    boundary = Polygon([(0, 0), (0, 12), (12, 12), (12, 0)])

    points = [
        Point(2, 2),
        Point(4, 3),
        Point(6, 6),
        Point(8, 8),
        Point(10, 5),
        Point(3, 9),
        Point(7, 10),
        Point(9, 2),
    ]

    point_gdf = gpd.GeoDataFrame(
        {
            "id": [f"P{i+1}" for i in range(len(points))],
            "name": [f"Point {i+1}" for i in range(len(points))],
            "geometry": points,
        },
        crs="EPSG:4326",
    )

    study_area = gpd.GeoDataFrame(
        {"area_name": ["study_area"], "geometry": [boundary]},
        crs="EPSG:4326",
    )

    return study_area, point_gdf


def analyze_points(study_area, points):
    """Run a basic spatial analysis workflow."""
    within_boundary = points.within(study_area.geometry.iloc[0])

    point_summary = {
        "total_points": len(points),
        "points_within_area": int(within_boundary.sum()),
        "points_outside_area": int((~within_boundary).sum()),
        "average_x": float(points.geometry.x.mean()),
        "average_y": float(points.geometry.y.mean()),
        "min_x": float(points.geometry.x.min()),
        "max_x": float(points.geometry.x.max()),
        "min_y": float(points.geometry.y.min()),
        "max_y": float(points.geometry.y.max()),
    }

    buffer_distance = 1.5
    buffers = points.copy()
    buffers["geometry"] = points.geometry.buffer(buffer_distance)
    buffers["buffer_distance"] = buffer_distance

    # Save outputs
    study_area.to_file(OUTPUT_DIR / "study_area.geojson", driver="GeoJSON")
    points.to_file(OUTPUT_DIR / "sample_points.geojson", driver="GeoJSON")
    buffers.to_file(OUTPUT_DIR / "buffers.geojson", driver="GeoJSON")

    print("Spatial analysis summary:")
    for key, value in point_summary.items():
        print(f"- {key}: {value}")

    # Plot results
    fig, ax = plt.subplots(figsize=(8, 8))
    study_area.plot(ax=ax, color="lightgray", edgecolor="black", linewidth=1)
    points.plot(ax=ax, color="royalblue", markersize=70, label="Points")
    buffers.plot(ax=ax, color="cornflowerblue", alpha=0.4, edgecolor="navy", label="Buffer")
    ax.set_title("Spatial Analysis Example")
    ax.set_xlabel("X")
    ax.set_ylabel("Y")
    ax.legend()
    plt.tight_layout()
    plt.savefig(OUTPUT_DIR / "spatial_analysis_map.png", dpi=200)
    plt.close(fig)

    return point_summary


def main():
    study_area, points = create_sample_data()
    result = analyze_points(study_area, points)
    print("\nOutputs saved to:", OUTPUT_DIR)
    return result


if __name__ == "__main__":
    main()
