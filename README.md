# FUMD-AI Urban Mobility Data Generation

Generates synthetic urban traffic demand scenarios on an OpenStreetMap-derived
SUMO network of central Alicante, Spain, and extracts Floating Car Data (FCD)
— vehicle trajectories with geographic coordinates and traffic-signal state —
from each simulated scenario.

This repository is the **upstream data-generation step** for
[`fumd-ai-preprocessing-workflow`](https://github.com/FUMD-AI/fumd-ai-preprocessing-workflow):
its output (`fcd_signals_<density>_<replicate>.xml`) is exactly the raw
"SUMO fcd-output XML" that workflow's Step 1 expects as input.

## Quick start

```bash
# 1. Install SUMO (bundles netconvert, randomTrips.py, duarouter)
pip install eclipse-sumo --break-system-packages
export SUMO_HOME=$(python3 -c "import sumo, os; print(os.path.dirname(sumo.__file__))")
export PROJ_LIB="$SUMO_HOME/data/proj"
export PATH="$SUMO_HOME/bin:$PATH"

# 2. Generate one scenario (900 target vehicles, 1800 s, 500 m min trip distance)
cd scripts
./generate_scenario.sh ../data/Alicante_centro_ciudad.net.xml 900 1800 3001 Alicante_900_1 500

# 3. Extract FCD output (geo-coordinates + traffic-signal state)
./generate_fcd_outputs.sh 1800
```

Out of the box, `examples/900_1/` bundles one complete, already-generated
scenario (config, trips, routes, and its FCD output) so the pipeline's
output format can be inspected without running SUMO at all.

## Repository layout

```
.
├── README.md
├── CITATION.cff              citation metadata (GitHub/Zenodo citation widget)
├── codemeta.json             CodeMeta software metadata
├── LICENSE.txt                MIT (source code)
├── LICENSE-CC-BY-4.0.txt      CC BY 4.0 (explanatory text/figures)
├── docs/
│   └── workflow_documentation.md   full FAIR-structured methodology (see below)
├── scripts/
│   ├── generate_scenario.sh        trip/route/config generation for one scenario
│   └── generate_fcd_outputs.sh     batch SUMO run + FCD extraction
├── data/
│   └── Alicante_centro_ciudad.net.xml   shared SUMO network (~2.1 x 1.8 km, Alicante centre)
└── examples/
    └── 900_1/                 one complete, runnable example scenario
        ├── README.md
        ├── Alicante_900_1.trips.xml
        ├── Alicante_900_1.rou.xml
        ├── Alicante_900_1.sumo.cfg
        ├── Alicante_centro_ciudad.net.xml   (self-contained copy)
        └── fcd_signals_900_1.xml
```

## Full methodology

[`docs/workflow_documentation.md`](docs/workflow_documentation.md) is the
authoritative, FAIR-structured (Findable, Accessible, Interoperable,
Reusable) methodology document for this repository. It covers:

1. Upstream OpenStreetMap extraction and `netconvert` conversion (Overpass
   API, Geofabrik + `osmium`, or `pyrosm`), including the exact bounding box
   and known provenance/reproducibility limitations of the bundled network.
2. The trip generation → routing → configuration → simulation pipeline.
3. Every fixed and per-scenario parameter used to generate the full
   4-density x 3-replicate (12-scenario) matrix.
4. Provenance/validation notes (e.g. minor vehicle-insertion shortfalls at
   high density due to end-of-horizon congestion — a real traffic effect,
   not a generation error).
5. The two automation scripts and how to re-run the full matrix.

## Scenario matrix

| Density (target vehicles) | Replicates | Min. trip distance | Horizon |
|---|---|---|---|
| 900, 1000, 1200, 1400 | 3 each (seeds 3001-3012) | 500 m | 1800 s |

See `docs/workflow_documentation.md` Section 7 for the full per-scenario
parameter table (exact seeds, insertion periods).

## Requirements

- Eclipse SUMO 1.27.1 (`pip install eclipse-sumo`, or see
  <https://www.eclipse.org/sumo/>)
- Python >= 3.10
- For OSM re-extraction (`docs/workflow_documentation.md` Section 3):
  `osmium-tool` and/or `pyrosm` (`pip install pyrosm`)

## Example

`examples/900_1/` contains one complete scenario from the matrix above —
900 target vehicles, seed 3001 — including its generated FCD output, as a
concrete, inspectable reference for the pipeline's file formats. See
[`examples/900_1/README.md`](examples/900_1/README.md) for exact
regeneration commands and file descriptions.

## Authors

- Cristina Bernad, Miguel Hernández University ([ORCID: 0000-0001-9537-415X](https://orcid.org/0000-0001-9537-415X))
- Sonja Filiposka <sonja.filiposka@finki.ukim.mk>, Ss. Cyril and Methodius University in Skopje ([ORCID: 0000-0003-0034-2855](https://orcid.org/0000-0003-0034-2855))
- Katja Gilly, Miguel Hernández University ([ORCID: 0000-0002-8985-0639](https://orcid.org/0000-0002-8985-0639))

## Licence

Unless otherwise indicated:

- Source code (scripts) in this repository is licensed under the MIT License.
- Explanatory text (`docs/workflow_documentation.md`, this README) is
  licensed under Creative Commons Attribution 4.0 International (CC BY 4.0).
- The bundled network and example data are derived from OpenStreetMap,
  © OpenStreetMap contributors, available under the Open Database Licence
  (ODbL).

SPDX-License-Identifier: MIT

See `LICENSE.txt` (MIT, code) and `LICENSE-CC-BY-4.0.txt` (CC BY 4.0,
text/figures).

## Citation

Please cite this workflow if you use it. See `CITATION.cff` and
`codemeta.json` for structured citation/author metadata.

## Acknowledgement

This work has been funded by the FUMD-AI project, an EOSC GRAVITY - Inter
Project with Grant Number 25-EOSC-GRV-INTER-013.
