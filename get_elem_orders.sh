#!/bin/bash
 ./get_elem_orders.sh <folder_with_lmp_files> <output_mapping_file>

FOLDER=$1
OUTFILE=$2
> "$OUTFILE"

for f in "$FOLDER"/*.lmp; do
    ID=$(basename "$f" .lmp)
    ELEMS=$(awk '/^Masses/{flag=1; next} /^Atoms/{flag=0} flag && NF>=2 {print $1, $NF}' "$f" \
            | sort -n | awk '{printf "%s ", $2} END{print ""}' | sed 's/ $//')
    echo "$ID $ELEMS" >> "$OUTFILE"
done
echo "Mapping: $OUTFILE"
cat "$OUTFILE"
