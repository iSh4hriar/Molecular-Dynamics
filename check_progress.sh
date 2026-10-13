#!/bin/bash
cd ~/CuNiAlCo-MEA
IDS="Equiatomic Cu10 Cu40 Cu55 Ni10 Ni40 Ni55 Al10 Al40 Al55 Co10 Co40 Co55"
TOTAL_STEPS=200000

echo "=== Equilibration Progress ==="
for ID in $IDS; do
    if [ -f "equil/${ID}_equilibrated.data" ]; then
        echo "$ID : DONE (100%)"
    elif [ -f "logs/${ID}_equil.log" ]; then
        # thermo section এর সব সংখ্যা-শুরু লাইন থেকে প্রথম কলাম (step) নেয়,
        # শুধু যেসব লাইনে কমপক্ষে ৯টা কলাম আছে (আসল thermo output, header/minimization stats না)
        LAST_STEP=$(awk 'NF>=9 && $1 ~ /^[0-9]+$/ {last=$1} END{print last}' "logs/${ID}_equil.log")
        if [ -n "$LAST_STEP" ]; then
            PCT=$(awk "BEGIN{printf \"%.1f\", $LAST_STEP/$TOTAL_STEPS*100}")
            echo "$ID : step $LAST_STEP / $TOTAL_STEPS ($PCT%)"
        else
            echo "$ID : শুরু হয়েছে কিন্তু এখনো MD thermo data নেই (minimization পর্যায়ে আছে)"
        fi
    else
        echo "$ID : এখনো শুরু হয়নি"
    fi
done
