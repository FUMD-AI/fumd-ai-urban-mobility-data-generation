# `examples/`

Complete, self-contained, already-generated scenarios from the 4-density ×
3-replicate matrix described in
[`../docs/workflow_documentation.md`](../docs/workflow_documentation.md),
included so the pipeline's file formats can be inspected without running
SUMO at all.

## Naming convention

Each subdirectory is named `<density>_<replicate>`, matching the scenario
IDs in the workflow documentation's parameter table (Section 7.2):
`<density>` ∈ {900, 1000, 1200, 1400}, `<replicate>` ∈ {1, 2, 3}.

## Available examples

| Directory | Target vehicles | Replicate (seed) |
|---|---|---|
| [`900_1/`](900_1/) | 900 | 1 (seed 3001) |

Only one example scenario is bundled directly in this repository, to keep
its size manageable — `fcd_signals_900_1.xml` alone is ~15 MB. The other 11
scenarios in the matrix are not pre-generated here; regenerate any of them
locally with [`../scripts/generate_scenario.sh`](../scripts/generate_scenario.sh)
and [`../scripts/generate_fcd_outputs.sh`](../scripts/generate_fcd_outputs.sh)
using the parameters listed in `docs/workflow_documentation.md` Section 7.2
(root `README.md`'s Quick Start has a loop that regenerates the full matrix
in one pass).

Each example directory has its own `README.md` describing its specific
files and parameters — see [`900_1/README.md`](900_1/README.md).
