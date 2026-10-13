#!/bin/bash
# ব্যবহার: ./get_pair_coeff_line.sh <file.lmp>
FILE=$1
awk '/^Masses/{flag=1; next} /^Atoms/{flag=0} flag && NF>=2 {print $1, $NF}' "$FILE" | sort -n | awk '{printf "%s ", $2} END{print ""}'
