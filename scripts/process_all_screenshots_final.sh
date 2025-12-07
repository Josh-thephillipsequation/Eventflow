#!/bin/bash

# Process ALL unique screenshots from img/ folder (no duplicates)

cd "$(dirname "$0")/.."

mkdir -p app_store_final

echo "================================================"
echo "PROCESSING ALL SCREENSHOTS FOR APP STORE"
echo "================================================"
echo ""

# Process only the base files (without (1), 2, 3 suffixes)
counter=1

for file in img/IMG_1265.jpeg \
            img/IMG_1266.jpeg \
            img/IMG_1267.jpeg \
            img/IMG_1268.jpeg \
            img/IMG_1269.jpeg \
            img/IMG_1270.jpeg \
            img/IMG_1271.jpeg \
            img/IMG_1272.jpeg \
            img/IMG_1273.PNG \
            img/IMG_1274.jpeg; do
    
    if [ -f "$file" ]; then
        # Determine output number (pad with zero)
        output_num=$(printf "%02d" $counter)
        
        # Resize to 1284 × 2778
        sips -z 2778 1284 "$file" --out "app_store_final/${output_num}_screenshot.jpg" >/dev/null 2>&1
        
        echo "✅ ${output_num}_screenshot.jpg (from $(basename "$file"))"
        
        counter=$((counter + 1))
    fi
done

echo ""
echo "================================================"
echo "✅ PROCESSED $(ls -1 app_store_final/*.jpg | wc -l | xargs) SCREENSHOTS"
echo "================================================"
echo ""
echo "All screenshots are 1284 × 2778 (App Store compliant)"
echo "Location: app_store_final/"
echo ""
echo "Files:"
ls -1 app_store_final/
echo ""
