#!/bin/bash

#Author: David T. Garitagoitia Romero
# Function to print ASCII art with delays
print_text_with_delays() {
  # Decode and unzip the base64-encoded text
  base64 -d <<< "H4sIAAAAAAAAA22PwQ0DMQgE/1Qxz+QTGoiuj0iWaMTFhwV0d4/DsjHsrJGNKz4RQShA+ynEWAyU1Cbcy7QcdjlH6jyMraoXgtmrhDnT2Ioie41gWw8eHHh41iqh0wu+Kb3hl4t8ohl50u09LT2azqRquu6qTsYG6vH+/O+7ltmwP6Ow9h86AQAA" | gunzip | while read -r line; do
    # Print the line and wait for one second
    echo "$line"
    sleep 0.15
  done
}

# Mostrar arte ASCII de carga al principio
print_text_with_delays
base64 -d <<< "H4sIAAAAAAAAA32OwQnFMAxD755CR/eSLBR4I3gBDd84FMo//ApjJJBlhdALoJf+I6wlhlTC0p65
/YxB4Sadh1pUqzAz8ZrO4y8tmnqfmjw8uVocR3z8fjr6p88NR/G25sEAAAA=" | gunzip

# Check if a PDF file is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 pdf_file.pdf"
  exit 1
fi

# Input PDF file name
input_pdf="$1"

# Check if the PDF file exists
if [ ! -f "$input_pdf" ]; then
  echo "The PDF file '$input_pdf' does not exist."
  exit 1
fi

# Convert PDF to HTML using pdftohtml
echo -e "\033[32mConverting PDF to HTML...\033[0m"
pdftohtml -xml "$input_pdf" output.xml
echo -e "\033[32mConversion complete.\033[0m"

# Function to clean text
clean_text() {
  # Remove special characters
  sed -E 's/&lt;|&gt;|&amp;|&quot;|&apos;/ /g' |
  # Remove extra whitespace
  tr -s '[:space:]' ' ' |
  # Remove leading and trailing whitespace on each line
  sed 's/^ *//;s/ *$//'
}

# Function to extract and format text from <text> tags
extract_text() {
  grep '<text>' output.xml | sed -E 's/<text.*>(.*)<\/text>/\1/' | clean_text
}

# Function to extract and format text from <title> tags
extract_headings() {
  grep '<title>' output.xml | sed -E 's/<title.*>(.*)<\/title>/\1/' | clean_text | sed -E 's/^# (.*)$/# \1/'
}

# Create the README.md
echo "# PDF Content" > README.md

# Extract and organize content in the order it appears in the PDF
while IFS= read -r line; do
    if [[ $line == *"<title>"* ]]; then
        # Rule 1: Match heading
        echo -e "\033[33mMatched Rule 1: Heading\033[0m"
        echo "$line" | extract_headings >> README.md
    elif [[ $line == *"<text"* ]]; then
        echo -e "\033[33mMatched Rule 2: Text\033[0m"
        echo $line
        text_content=$(echo "$line" | sed -E 's/.*>(.*)<\/text>/\1/' | clean_text)
        text_top=$(echo "$line" | sed -E 's/.*top="([^"]*)".*/\1/')
        text_left=$(echo "$line" | sed -E 's/.*left="([^"]*)".*/\1/')
        text_font=$(echo "$line" | sed -E 's/.*font="([^"]*)".*/\1/')
        # Adjust representation based on font, top, and left values
        if [ "$text_font" -eq 1 ]; then
            echo "$text_content" >> README.md
        elif [ "$text_font" -eq 2 ]; then
            echo "## $text_content" >> README.md
        else
            echo "### $text_content" >> README.md
        fi
        echo "" >> README.md
    elif [[ $line == *"<image"* ]]; then
        # Rule 3: Match image tag
        echo -e "\033[34mMatched Rule 3: Image Tag\033[0m"
        echo $line
        image_src=$(echo "$line" | sed -E 's/.*src="([^"]*)".*/\1/')
        echo "![Image]($image_src)" >> README.md
        echo "" >> README.md
    fi
done < output.xml
rm output.xml

echo -e "\033[32mREADME.md generated successfully from $input_pdf.\033[0m"
