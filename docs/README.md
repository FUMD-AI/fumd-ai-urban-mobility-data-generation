# `docs/`

| File | Description |
|---|---|
| [`workflow_documentation.md`](workflow_documentation.md) | The authoritative, FAIR-structured methodology document for this repository — the single source of truth for how every artefact in `data/`, `scripts/`, and `examples/` was produced. |

`workflow_documentation.md` covers, in order:

1. Upstream OpenStreetMap extraction and `netconvert` conversion (Geofabrik + `osmium` recommended, with Overpass API and `pyrosm` as documented alternatives), including the exact bounding box, coordinate-order gotchas across tools, and known provenance/reproducibility limitations of the bundled network.
2. The trip generation → routing → configuration → simulation pipeline.
3. Every fixed and per-scenario parameter used to generate the full 4-density × 3-replicate (12-scenario) matrix.
4. Provenance/validation notes.
5. The two automation scripts in [`../scripts/`](../scripts/) and how to re-run the full matrix.

If you're looking for *how to run something*, start at the root [`README.md`](../README.md) Quick Start instead — this document is the detailed reference it points to, not a getting-started guide.
