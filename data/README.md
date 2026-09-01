# `data/`

The shared, static SUMO road network used as the fixed input to every
scenario in this repository.

| File | Size | Description |
|---|---|---|
| `Alicante_centro_ciudad.net.xml` | ~4.1 MB | OSM-derived SUMO network, central Alicante, ≈2.11 km (E–W) × 1.83 km (N–S) |

## Provenance

- **Area of interest**: `west,south,east,north = -0.495075,38.336600,-0.470936,38.353021` (embedded in the file's own `<location origBoundary=...>` element).
- **Originally generated**: 2018-05-07, with SUMO netconvert 0.32.0, `--proj.utm` only. The original source `.osm` file is not retained.
- Full provenance, the exact bounding box derivation, all three documented retrieval methods (Geofabrik + `osmium`, Overpass API, `pyrosm`), and the known reproducibility limitations of this specific file are in [`../docs/workflow_documentation.md`](../docs/workflow_documentation.md), Section 3.

## License

Derived from OpenStreetMap, © OpenStreetMap contributors, available under the Open Database License (ODbL). See the root [`README.md`](../README.md#licence) for full licensing terms.

## Usage

This file is the `<net_file>` argument to [`../scripts/generate_scenario.sh`](../scripts/generate_scenario.sh). `examples/900_1/` also bundles its own self-contained copy so that example can run without referencing this directory.
