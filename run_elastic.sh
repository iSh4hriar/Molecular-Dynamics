#!/bin/bash
cd ~/CuNiAlCo-MEA/elastic
IDS="Equiatomic Cu10 Cu40 Cu55 Ni10 Ni40 Ni55 Al10 Al40 Al55 Co10 Co40 Co55"

for ID in $IDS; do
    ELEMS=$(grep "^${ID} " ../structures/elem_order.txt | cut -d' ' -f2-)
    if [ -z "$ELEMS" ]; then
        echo "!! ERROR: $ID elem order "
        continue
    fi
    if [ -f "../logs/${ID}_cij_raw.dat" ] && [ $(grep -c "CIJ_ROW" "../logs/${ID}_cij_raw.dat") -eq 6 ]; then
        echo ">>> $ID"
        continue
    fi
    echo ">>> $ID  (elems: $ELEMS)"
    rm -f "../logs/${ID}_cij_raw.dat"
    mpirun -np 4 lmp -var comp $ID -var elems "$ELEMS" -in 05_elastic.in -log ../logs/${ID}_elastic.log
    if [ $? -ne 0 ]; then
        echo "!! WARNING: $ID ে"
    else
        echo ">>> $ID "
    fi
done
echo "ok"
