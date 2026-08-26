#!/usr/bin/env bash
#
# generate_fcd_outputs.sh - Batch-run SUMO on every Alicante_*_*.sumo.cfg in
#                            the current directory, producing an FCD output
#                            (geo coordinates + traffic light signals) for
#                            each one.
#
# Output naming matches the original convention:
#   Alicante_900_1.sumo.cfg  ->  ../fcd_signals_900_1.xml
#   Alicante_1200_3.sumo.cfg ->  ../fcd_signals_1200_3.xml
#
# Usage:
#   ./generate_fcd_outputs.sh [end_time]
#
# Run this from the directory containing the .sumo.cfg files (the FCD
# outputs are written one level up, as in the original command).

set -euo pipefail

END_TIME="${1:-1800}"
OUT_DIR=".."

shopt -s nullglob
CFG_FILES=(Alicante_*_*.sumo.cfg)
shopt -u nullglob

if [ ${#CFG_FILES[@]} -eq 0 ]; then
    echo "No Alicante_*_*.sumo.cfg files found in the current directory."
    exit 1
fi

echo "Found ${#CFG_FILES[@]} config file(s). End time: ${END_TIME}s"
echo

for CFG in "${CFG_FILES[@]}"; do
    # Extract the "<density>_<rep>" suffix, e.g. Alicante_900_1.sumo.cfg -> 900_1
    BASE="${CFG%.sumo.cfg}"
    SUFFIX="${BASE#Alicante_}"
    OUT_FILE="${OUT_DIR}/fcd_signals_${SUFFIX}.xml"

    echo "=== ${CFG} -> ${OUT_FILE} ==="
    sumo -c "$CFG" \
        --fcd-output.geo true \
        --fcd-output.signals true \
        --fcd-output "$OUT_FILE" \
        --end "$END_TIME"
    echo
done

echo "All FCD outputs generated in ${OUT_DIR}/"
