#!/bin/bash
set -e

cd ~/CuNiAlCo-MEA/structures
A0=3.60
NX=17; NY=17; NZ=35

declare -A COMPS
COMPS["Equiatomic"]="10115 10115 10115 10115"
COMPS["Cu10"]="4046 12138 12138 12138"
COMPS["Cu40"]="16184 8092 8092 8092"
COMPS["Cu55"]="22253 6069 6069 6069"
COMPS["Ni10"]="12138 4046 12138 12138"
COMPS["Ni40"]="8092 16184 8092 8092"
COMPS["Ni55"]="6069 22253 6069 6069"
COMPS["Al10"]="12138 12138 4046 12138"
COMPS["Al40"]="8092 8092 16184 8092"
COMPS["Al55"]="6069 6069 22253 6069"
COMPS["Co10"]="12138 12138 12138 4046"
COMPS["Co40"]="8092 8092 8092 16184"
COMPS["Co55"]="6069 6069 6069 22253"

for ID in "${!COMPS[@]}"; do
    read -r N_CU N_NI N_AL N_CO <<< "${COMPS[$ID]}"
    TOTAL=$((N_CU + N_NI + N_AL + N_CO))
    echo ">>> Building $ID  (Cu=$N_CU Ni=$N_NI Al=$N_AL Co=$N_CO  Total=$TOTAL)"

    atomsk --create fcc $A0 Cu -duplicate $NX $NY $NZ \
        -select random $N_NI Cu -substitute Cu Ni \
        -select random $N_AL Cu -substitute Cu Al \
        -select random $N_CO Cu -substitute Cu Co \
        -ow ${ID}.lmp

    echo "    -> ${ID}.lmp"
    {
        echo "== $ID =="
        echo "-- Masses (type -> element) --"
        awk '/^Masses/{flag=1; next} /^Atoms/{flag=0} flag && NF>=2' ${ID}.lmp
        echo "-- Atom count per type --"
        awk '/^Atoms/{flag=1; next} /^Velocities/{flag=0} flag && NF>=5 {c[$2]++} END{for (t in c) print "type "t": "c[t]" atoms"}' ${ID}.lmp
        echo "Expected: Cu=$N_CU Ni=$N_NI Al=$N_AL Co=$N_CO"
        echo
    } >> ../logs/${ID}_atomcount.log

    echo ">>> $ID done."
    echo
done

echo "done"

