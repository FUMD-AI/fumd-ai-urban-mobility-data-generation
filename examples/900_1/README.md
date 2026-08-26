# Example scenario: `Alicante_900_1`

One complete, self-contained scenario from the 4-density x 3-replicate
matrix described in [`../../docs/workflow_documentation.md`](../../docs/workflow_documentation.md).
This folder includes its own copy of the network file, so it can be run
directly without referencing `../../data/`.

## Files

| File | Size | Description |
|---|---|---|
| `Alicante_centro_ciudad.net.xml` | ~4.1 MB | SUMO road network (Alicante centre, ≈2.1 x 1.8 km) |
| `Alicante_900_1.trips.xml` | ~112 KB | Raw stochastic origin-destination trip definitions |
| `Alicante_900_1.rou.xml` | ~536 KB | Validated, routed vehicles (via `duarouter`) |
| `Alicante_900_1.sumo.cfg` | ~4 KB | SUMO run configuration (net + routes + time window + seed) |
| `fcd_signals_900_1.xml` | ~15 MB | Simulation output: per-timestep vehicle trajectories with geo-coordinates and traffic-signal state |

## Parameters used

| Parameter | Value |
|---|---|
| Target vehicles | 900 |
| Simulation window | 0-1800 s |
| Insertion period | 2.0 s/vehicle |
| Minimum trip distance | 500 m |
| Random seed | 3001 |
| Fringe factor | 5 |
| Vehicle class | passenger |

Actual result when generated: 900/900 target vehicles inserted; mean route
length ≈ 1411 m. See `docs/workflow_documentation.md` Section 7.3 for the
full worked-example writeup, and Section 8 for provenance/validation notes
that apply across the full scenario matrix.

## Regenerating this example from scratch

```bash
# From the repository root, with SUMO_HOME/PROJ_LIB/PATH set (see main README)
cd examples/900_1

../../scripts/generate_scenario.sh \
    Alicante_centro_ciudad.net.xml 900 1800 3001 Alicante_900_1 500

sumo -c Alicante_900_1.sumo.cfg \
    --fcd-output.geo true \
    --fcd-output.signals true \
    --fcd-output fcd_signals_900_1.xml \
    --end 1800
```

## Inspecting the output

`fcd_signals_900_1.xml` is a standard SUMO FCD output file
(<http://sumo.dlr.de/xsd/fcd_file.xsd>). Each `<timestep>` element contains
one `<vehicle>` entry per active vehicle, with WGS84 `lon`/`lat` attributes
(from `--fcd-output.geo`) and a `signals` attribute reporting that
vehicle's current traffic-light signal state (from
`--fcd-output.signals`), when applicable.
