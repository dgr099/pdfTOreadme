# PDF-to-README Converter
This repository contains a handy Bash script that converts PDF documents into README files, making it easier to share and understand the content of PDFs directly on GitHub repositories.

## How it Works
The script obtains an xml from the pdf file obtaining the info. Then, it parses the xml output to extract text and images, organizing them into a structured README.md file. The extracted text is cleaned up and formatted appropriately, while images are linked within the README.md file.

## Why it's Useful
* Improved Accessibility: By converting PDFs into README files, the content becomes more accessible to users who may not have the means to 
view PDFs easily.

* Enhanced Collaboration: README files are a standard part of GitHub repositories, making it easier for collaborators to understand the contents of a project, including any associated documentation.
* Version Control: With the content in README format, changes and updates can be tracked more efficiently using version control systems like Git. This ensures that all contributors have access to the latest information.

## How to Use
Clone or download this repository to your local machine.
Place the PDF file you want to convert into the same directory as the pdf_to_readme.sh script.
Run the script with the PDF file as an argument: bash pdfTOreadme.sh your_pdf_file.pdf.
The script will generate a README.md file containing the converted content from the PDF.
![example](demo.gif)

### License
This project is licensed under the MIT License.

By converting PDFs into README files, this script promotes better accessibility, collaboration, and version control practices within GitHub repositories. Give it a try and make your PDF documents more accessible and user-friendly!

Follow me on github, linkedin, twitter, etc.

