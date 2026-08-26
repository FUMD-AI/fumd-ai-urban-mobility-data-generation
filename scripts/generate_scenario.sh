#!/usr/bin/env bash
#
# generate_scenario.sh - Generate trips, routes and a SUMO config file for a
#                         given traffic density on the Alicante centro ciudad
#                         network.
#
# Usage:
#   ./generate_scenario.sh <net_file> <num_cars> <sim_end_seconds> <seed> <out_prefix> [min_distance]
#
# Example:
#   ./generate_scenario.sh Alicante_centro_ciudad.net.xml 900 1800 12345 Alicante_900_1 500

set -euo pipefail

if [ $# -lt 5 ]; then
    echo "Usage: $0 <net_file> <num_cars> <sim_end_seconds> <seed> <out_prefix> [min_distance]"
    exit 1
fi

NET_FILE="$1"
NUM_CARS="$2"
END_TIME="$3"
SEED="$4"
PREFIX="$5"
MIN_DISTANCE="${6:-0}"

: "${SUMO_HOME:?SUMO_HOME must be set}"

TRIP_FILE="${PREFIX}.trips.xml"
ROUTE_FILE="${PREFIX}.rou.xml"
CFG_FILE="${PREFIX}.sumo.cfg"

# Period between successive vehicle insertions so that ~NUM_CARS vehicles
# are inserted between t=0 and t=END_TIME.
PERIOD=$(python3 -c "print(${END_TIME} / ${NUM_CARS})")

echo "=== Generating scenario: ${PREFIX} ==="
echo "  Net file   : $NET_FILE"
echo "  Cars       : $NUM_CARS"
echo "  End time   : $END_TIME s"
echo "  Seed       : $SEED"
echo "  Period     : $PERIOD s/veh"
echo "  Min dist   : $MIN_DISTANCE m"

python3 "$SUMO_HOME/tools/randomTrips.py" \
    -n "$NET_FILE" \
    -o "$TRIP_FILE" \
    -r "$ROUTE_FILE" \
    -b 0 -e "$END_TIME" \
    -p "$PERIOD" \
    --seed "$SEED" \
    --fringe-factor 5 \
    --min-distance "$MIN_DISTANCE" \
    --validate \
    --vehicle-class passenger \
    --trip-attributes "departLane=\"best\" departSpeed=\"max\""

# Count actual vehicles generated (randomTrips.py's count is approximate)
ACTUAL_COUNT=$(grep -c "<vehicle " "$ROUTE_FILE" || true)
echo "  Generated  : $ACTUAL_COUNT vehicles (target was $NUM_CARS)"

# --- Write the .sumo.cfg -----------------------------------------------
cat > "$CFG_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<configuration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/sumoConfiguration.xsd">

    <input>
        <net-file value="${NET_FILE}"/>
        <route-files value="${ROUTE_FILE}"/>
    </input>

    <time>
        <begin value="0"/>
        <end value="${END_TIME}"/>
    </time>

    <processing>
        <ignore-route-errors value="true"/>
    </processing>

    <random_number>
        <seed value="${SEED}"/>
    </random_number>

</configuration>
EOF

echo "  Wrote      : $CFG_FILE"
echo
