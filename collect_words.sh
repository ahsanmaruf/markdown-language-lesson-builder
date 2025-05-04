#!/bin/bash

# Define the output file
WORDS_FILE="German/words.md"

# Initialize the output file with the table header
echo -e "| German | English |\n|--------|---------|" > "$WORDS_FILE"

# Create a temporary file to hold extracted table rows
TMP_FILE=$(mktemp)

# Loop through all .md files in 'German' except 'words.md'
find German/ -name "*.md" ! -name "words.md" | while read -r file; do
    awk '
    BEGIN { inside_table = 0 }
    /^\| *German *\| *English *\|/ { inside_table = 1; next }
    /^\|[- ]+\|[- ]+\|/ { next }
    {
        if (inside_table && /^\|/ && $0 !~ /^\| *\| *\|$/) print $0
    }
    ' "$file" >> "$TMP_FILE"
done

# Sort and deduplicate, then append to words.md
sort -u "$TMP_FILE" >> "$WORDS_FILE"

# Remove the temporary file
rm "$TMP_FILE"

WORD_COUNT=$(tail -n +3 "$WORDS_FILE" | wc -l)
echo -e "\n**Total words: $WORD_COUNT**" >> "$WORDS_FILE"

echo "✅ Words.md has been created!"

# Convert words.md to TSV format for Anki import
ANKI_FILE="German/words_for_anki.txt"
tail -n +3 "$WORDS_FILE" | grep '|' | sed 's/|//g' | awk -F' ' '{gsub(/^ +| +$/, "", $0); print $1 "\t" $2}' > "$ANKI_FILE"

echo "📥 Anki-ready file created at: $ANKI_FILE"
echo "📌 To import into Anki without resetting stats, use the 'Update existing notes' option in Anki's import dialog."