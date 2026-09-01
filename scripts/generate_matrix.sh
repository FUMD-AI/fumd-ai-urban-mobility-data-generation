#!/usr/bin/env bash
#
# generate_matrix.sh - Generate trips, routes, and a SUMO config file for the
#                       full 4-density x 3-replicate scenario matrix (12
#                       scenarios total) against a single, fixed SUMO
#                       network, using this repository's fixed parameters
#                       (docs/workflow_documentation.md Section 7.1) and
#                       per-scenario seed table (Section 7.2).
#
# This is a thin driver loop around generate_scenario.sh (unmodified - it is
# already generic over net file and output prefix). It exists so the
# documented 12-scenario matrix can be reproduced in one command instead of
# hand-writing the loop shown in Section 9 every time.
#
# Usage:
#   ./generate_matrix.sh <net_file> <city_prefix> [out_dir] [generate_scenario_script]
#
# Example - regenerate the Alicante matrix (Section 9's worked example):
#   ./generate_matrix.sh ../data/Alicante_centro_ciudad.net.xml Alicante
#
# Requires SUMO_HOME to be set (same as generate_scenario.sh):
#   export SUMO_HOME=$(python3 -c "import sumo, os; print(os.path.dirname(sumo.__file__))")
#   export PATH="$SUMO_HOME/bin:$PATH"

set -euo pipefail

NET_FILE="${1:?Usage: $0 <net_file> <city_prefix> [out_dir] [generate_scenario_script]}"
CITY_PREFIX="${2:?Usage: $0 <net_file> <city_prefix> [out_dir] [generate_scenario_script]}"
OUT_DIR="${3:-${CITY_PREFIX}_scenarios}"
GEN_SCRIPT="${4:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/generate_scenario.sh}"

: "${SUMO_HOME:?SUMO_HOME must be set}"

if [ ! -f "$NET_FILE" ]; then
    echo "Error: net file not found: $NET_FILE" >&2
    exit 1
fi
if [ ! -f "$GEN_SCRIPT" ]; then
    echo "Error: generate_scenario.sh not found at: $GEN_SCRIPT" >&2
    echo "  (pass its path explicitly as arg 4 if it isn't next to this script)" >&2
    exit 1
fi

# Resolve to absolute paths before we cd into OUT_DIR below
NET_FILE="$(cd "$(dirname "$NET_FILE")" && pwd)/$(basename "$NET_FILE")"
GEN_SCRIPT="$(cd "$(dirname "$GEN_SCRIPT")" && pwd)/$(basename "$GEN_SCRIPT")"

mkdir -p "$OUT_DIR"
cd "$OUT_DIR"

# Same fixed simulation window as every scenario in the matrix
# (workflow_documentation.md Section 7.1): 0-1800s. generate_scenario.sh
# derives the insertion period as END_TIME / NUM_CARS internally, which
# reproduces Section 7.2's documented table exactly (900 -> 2.0000,
# 1000 -> 1.8000, 1200 -> 1.5000, 1400 -> 1.2857 s/veh).
SIM_END=1800
MIN_DISTANCE=500

# Same density set and same seed range (3001-3012) as Section 7.2's table.
SEED=3001
for density in 900 1000 1200 1400; do
    for rep in 1 2 3; do
        PREFIX="${CITY_PREFIX}_${density}_${rep}"
        echo "=================================================="
        echo "Scenario ${PREFIX}  (seed ${SEED})"
        echo "=================================================="
        "$GEN_SCRIPT" "$NET_FILE" "$density" "$SIM_END" "$SEED" "$PREFIX" "$MIN_DISTANCE"
        SEED=$((SEED + 1))
        echo
    done
done

echo "All 12 scenarios generated in: $(pwd)"
echo "(.trips.xml, .rou.xml, .sumo.cfg per scenario, named ${CITY_PREFIX}_<density>_<rep>.*)"
echo "Next: ./generate_fcd_outputs.sh ${SIM_END}   (run from ${OUT_DIR}/)"
