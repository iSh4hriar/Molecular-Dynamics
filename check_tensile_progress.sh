#!/bin/bash
cd ~/CuNiAlCo-MEA
IDS="Equiatomic Cu10 Cu40 Cu55 Ni10 Ni40 Ni55 Al10 Al40 Al55 Co10 Co40 Co55"
TOTAL_STEPS=50000

echo "=== Tensile Progress ==="
for ID in $IDS; do
    if [ -f "tensile/${ID}_tensile_final.data" ]; then
        echo "$ID : DONE (100%)"
    elif [ -f "logs/${ID}_tensile.log" ]; then
        LAST_STEP=$(awk 'NF>=7 && $1 ~ /^[0-9]+$/ {last=$1} END{print last}' "logs/${ID}_tensile.log")
        if [ -n "$LAST_STEP" ]; then
            PCT=$(awk "BEGIN{printf \"%.1f\", $LAST_STEP/$TOTAL_STEPS*100}")
            echo "$ID : step $LAST_STEP / $TOTAL_STEPS ($PCT%)"
        else
            echo "$ID : "
        fi
    else
        echo "$ID : "
    fi
done
