#!/bin/bash
# Resize screenshots to exact App Store requirements
# Uses sips (macOS built-in) or ImageMagick if available

set -e

INPUT_DIR="${1:-screenshots/automated}"
OUTPUT_DIR="${2:-screenshots/app_store_ready}"

# App Store required sizes
declare -A SIZES=(
  ["iPhone_15_Pro_Max"]="1290x2796"
  ["iPhone_15_Pro"]="1179x2556"
  ["iPhone_14_Pro_Max"]="1290x2796"
  ["iPhone_11_Pro_Max"]="1242x2688"
  ["iPad_Pro_(12.9-inch)_(6th_generation)"]="2048x2732"
  ["iPad_Pro_(11-inch)_(4th_generation)"]="1668x2388"
  ["iPad_Air_(5th_generation)"]="1640x2360"
)

# Check for image tools
if command -v sips &> /dev/null; then
  RESIZE_TOOL="sips"
elif command -v convert &> /dev/null; then
  RESIZE_TOOL="imagemagick"
else
  echo "❌ No image resize tool found. Install ImageMagick: brew install imagemagick"
  exit 1
fi

resize_image() {
  local input=$1
  local output=$2
  local size=$3
  
  if [ "$RESIZE_TOOL" = "sips" ]; then
    # sips format: WIDTHxHEIGHT
    sips -z ${size#*x} ${size%x*} "$input" --out "$output" > /dev/null
  else
    # ImageMagick format: WIDTHxHEIGHT
    convert "$input" -resize "${size}!" "$output"
  fi
}

echo "🖼️  Resizing screenshots for App Store requirements"
echo "=================================================="
echo "Input:  $INPUT_DIR"
echo "Output: $OUTPUT_DIR"
echo ""

mkdir -p "$OUTPUT_DIR"

# Process each device directory
for device_dir in "$INPUT_DIR"/*; do
  if [ ! -d "$device_dir" ]; then
    continue
  fi
  
  device_name=$(basename "$device_dir")
  echo "Processing: $device_name"
  
  # Find matching size
  size=""
  for key in "${!SIZES[@]}"; do
    if [[ "$device_name" == *"$key"* ]]; then
      size="${SIZES[$key]}"
      break
    fi
  done
  
  if [ -z "$size" ]; then
    echo "  ⚠️  No size mapping found, skipping..."
    continue
  fi
  
  echo "  📐 Target size: $size"
  
  # Create output directory
  output_device_dir="$OUTPUT_DIR/$device_name"
  mkdir -p "$output_device_dir"
  
  # Resize each screenshot
  for screenshot in "$device_dir"/*.png "$device_dir"/*.jpg; do
    if [ ! -f "$screenshot" ]; then
      continue
    fi
    
    filename=$(basename "$screenshot")
    output_path="$output_device_dir/$filename"
    
    echo "  🔄 Resizing: $filename"
    resize_image "$screenshot" "$output_path" "$size"
    
    if [ -f "$output_path" ]; then
      echo "    ✅ Saved: $output_path"
    else
      echo "    ❌ Failed"
    fi
  done
done

echo ""
echo "✅ Resizing complete!"
echo "📁 Resized screenshots: $OUTPUT_DIR"
echo ""
echo "Ready for App Store Connect upload!"

