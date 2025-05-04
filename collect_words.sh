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

echo "✅ Words.md has been created!"