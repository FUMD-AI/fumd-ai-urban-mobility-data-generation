# `scripts/`

Automation scripts implementing the reusability interface described in
[`../docs/workflow_documentation.md`](../docs/workflow_documentation.md)
Section 9.

| Script | Purpose | Signature |
|---|---|---|
| [`generate_scenario.sh`](generate_scenario.sh) | Generates one scenario's trips (`randomTrips.py`), routes (`duarouter`), and `.sumo.cfg` | `./generate_scenario.sh <net_file> <num_cars> <sim_end_seconds> <seed> <out_prefix> [min_distance]` |
| [`generate_matrix.sh`](generate_matrix.sh) | Drives `generate_scenario.sh` across the full 4-density × 3-replicate (12-scenario) matrix in one command | `./generate_matrix.sh <net_file> <city_prefix> [out_dir] [generate_scenario_script]` |
| [`generate_fcd_outputs.sh`](generate_fcd_outputs.sh) | Batch-runs SUMO on every `Alicante_*_*.sumo.cfg` in the current directory, producing an FCD output (geo-coordinates + traffic-signal state) for each | `./generate_fcd_outputs.sh [end_time]` |

`generate_scenario.sh` and `generate_fcd_outputs.sh` are the two scripts
that actually invoke SUMO; `generate_matrix.sh` is a thin loop around
`generate_scenario.sh` that exists so the documented 12-scenario matrix
(`docs/workflow_documentation.md` Section 7.2) doesn't need to be re-typed
as a shell loop every time it's run.

## Requirements

All three scripts require `SUMO_HOME` to be set and SUMO's `bin/` on `PATH` — see the root [`README.md`](../README.md#quick-start) Quick Start for the exact environment setup.

## Typical usage

Generate one scenario, then run it:

```bash
cd scripts
./generate_scenario.sh ../data/Alicante_centro_ciudad.net.xml 900 1800 3001 Alicante_900_1 500
./generate_fcd_outputs.sh 1800
```

Regenerate the full 4×3 scenario matrix from scratch, using `generate_matrix.sh`:

```bash
./generate_matrix.sh ../data/Alicante_centro_ciudad.net.xml Alicante
./generate_fcd_outputs.sh 1800
```

Equivalently, without `generate_matrix.sh`, the matrix can still be written
out explicitly (this is exactly what `generate_matrix.sh` does internally):

```bash
SEED=3001
for density in 900 1000 1200 1400; do
  for rep in 1 2 3; do
    ./generate_scenario.sh ../data/Alicante_centro_ciudad.net.xml \
        "$density" 1800 "$SEED" "Alicante_${density}_${rep}" 500
    SEED=$((SEED + 1))
  done
done
./generate_fcd_outputs.sh 1800
```

All three scripts print their parameters as they run and
`generate_scenario.sh` reports the actual vehicle count generated (which may
differ slightly from the requested target — this is expected, see
`docs/workflow_documentation.md` Section 8).
