#!/usr/bin/env bash

TEMPLATE_DIR="templates"
LESSON_FILE="lessons/topics.csv"
OUTPUT_DIR="output"
DATE_START=$(date "+%Y-%m-%d")

mkdir -p "$OUTPUT_DIR"
touch "$OUTPUT_DIR/.counters"

# Initialize counter tracking
get_counter() {
  grep -c "^$1," "$OUTPUT_DIR/.counters"
}

increment_counter() {
  local key="$1"
  local count=$(get_counter "$key")
  echo "$key,$((count + 1))" >> "$OUTPUT_DIR/.counters"
  echo $((count + 1))
}

# Keep track of lessons per level for the timeline
LEVEL_LIST=()

tail -n +2 "$LESSON_FILE" | while IFS=',' read -r LEVEL SECTION TOPIC; do
  LEVEL_CLEAN="${LEVEL//./_}"
  SECTION_DIR="$OUTPUT_DIR/$LEVEL/$SECTION"
  mkdir -p "$SECTION_DIR"

  KEY="${LEVEL}_${SECTION}"
  COUNT=$(increment_counter "$KEY")

  SAFE_TOPIC=$(echo "$TOPIC" | sed 's|/|-|g' | tr -cd '[:alnum:] .,-')
  FILENAME=$(printf "%02d - %s.md" "$COUNT" "$SAFE_TOPIC")
  FILEPATH="$SECTION_DIR/$FILENAME"

  if [ -f "$FILEPATH" ]; then
    echo "⚠️  Skipped existing file: $FILEPATH"
  else
    TEMPLATE_PATH="$TEMPLATE_DIR/$SECTION.md"
    if [ ! -f "$TEMPLATE_PATH" ]; then
      echo "# $TOPIC" > "$FILEPATH"
      echo "**Missing template for '$SECTION'**" >> "$FILEPATH"
    else
      CONTENT=$(<"$TEMPLATE_PATH")
      CONTENT="${CONTENT//\{\{title\}\}/$TOPIC}"
      CONTENT="${CONTENT//\{\{level\}\}/$LEVEL}"
      CONTENT="${CONTENT//\{\{level_tag\}\}/$LEVEL_CLEAN}"
      echo "$CONTENT" > "$FILEPATH"
    fi
  fi

  echo "$LEVEL,$SECTION,$FILENAME,$TOPIC" >> "$OUTPUT_DIR/.timeline_entries"
done

echo "✅ Notes and Gantt timelines generated in '$OUTPUT_DIR/'"