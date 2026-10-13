#!/bin/bash
cd ~/CuNiAlCo-MEA/elastic
IDS="Equiatomic Cu10 Cu40 Cu55 Ni10 Ni40 Ni55 Al10 Al40 Al55 Co10 Co40 Co55"

for ID in $IDS; do
    ELEMS=$(grep "^${ID} " ../structures/elem_order.txt | cut -d' ' -f2-)
    if [ -z "$ELEMS" ]; then
        echo "!! ERROR: $ID এর elem order পাওয়া যায়নি, স্কিপ করছি"
        continue
    fi
    if [ -f "../logs/${ID}_cij_raw.dat" ] && [ $(grep -c "CIJ_ROW" "../logs/${ID}_cij_raw.dat") -eq 6 ]; then
        echo ">>> $ID আগেই সম্পূর্ণ হয়ে গেছে, স্কিপ করছি।"
        continue
    fi
    echo ">>> $ID চলছে (elems: $ELEMS)"
    rm -f "../logs/${ID}_cij_raw.dat"
    mpirun -np 4 lmp -var comp $ID -var elems "$ELEMS" -in 05_elastic.in -log ../logs/${ID}_elastic.log
    if [ $? -ne 0 ]; then
        echo "!! WARNING: $ID এ সমস্যা হয়েছে"
    else
        echo ">>> $ID সফলভাবে শেষ হলো।"
    fi
done
echo "ব্যাচ শেষ।"
