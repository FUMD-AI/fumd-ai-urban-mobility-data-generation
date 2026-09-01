# `scripts/`

Automation scripts implementing the reusability interface described in
[`../docs/workflow_documentation.md`](../docs/workflow_documentation.md)
Section 9.

| Script | Purpose | Signature |
|---|---|---|
| [`generate_scenario.sh`](generate_scenario.sh) | Generates one scenario's trips (`randomTrips.py`), routes (`duarouter`), and `.sumo.cfg` | `./generate_scenario.sh <net_file> <num_cars> <sim_end_seconds> <seed> <out_prefix> [min_distance]` |
| [`generate_fcd_outputs.sh`](generate_fcd_outputs.sh) | Batch-runs SUMO on every `Alicante_*_*.sumo.cfg` in the current directory, producing an FCD output (geo-coordinates + traffic-signal state) for each | `./generate_fcd_outputs.sh [end_time]` |

## Requirements

Both scripts require `SUMO_HOME` to be set and SUMO's `bin/` on `PATH` — see the root [`README.md`](../README.md#quick-start) Quick Start for the exact environment setup.

## Typical usage

Generate one scenario, then run it:

```bash
cd scripts
./generate_scenario.sh ../data/Alicante_centro_ciudad.net.xml 900 1800 3001 Alicante_900_1 500
./generate_fcd_outputs.sh 1800
```

Regenerate the full 4×3 scenario matrix from scratch:

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

Both scripts print their parameters as they run and `generate_scenario.sh`
reports the actual vehicle count generated (which may differ slightly from
the requested target — this is expected, see `docs/workflow_documentation.md`
Section 8).
