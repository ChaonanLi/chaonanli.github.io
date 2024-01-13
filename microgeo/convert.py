#!/usr/bin/python3

import os, sys
from nbconvert import HTMLExporter, ScriptExporter
from nbconvert.preprocessors import ExecutePreprocessor

"""
Convert Jupyter Notebook to HTML and R scripts 
"""

# Get args
inpu_directory = sys.argv[1]
html_directory = sys.argv[2]
rexe_directory = sys.argv[3]

# Get all Jupyter Notebook files 
notebook_files = [file for file in os.listdir(inpu_directory) if file.endswith(".ipynb")]

# Create directories
os.makedirs(html_directory, exist_ok=True)
os.makedirs(rexe_directory, exist_ok=True)

# Convert files 
for notebook_file in notebook_files:
    
    # Notebook name
    notebook_name = os.path.splitext(notebook_file)[0]

    # Convert ipynb file to html file
    html_exporter = HTMLExporter()
    (body, resources) = html_exporter.from_file(os.path.join(inpu_directory, notebook_file))
    html_file_path = os.path.join(html_directory, f"{notebook_name}.html")
    with open(html_file_path, "w", encoding="utf-8") as html_file: html_file.write(body)
    print(f"Converted {notebook_file} to {html_file_path}...")

    # Convert ipynb R script file
    script_exporter = ScriptExporter()
    (body, resources) = script_exporter.from_file(os.path.join(inpu_directory, notebook_file))
    script_file_path = os.path.join(rexe_directory, f"{notebook_name}.R")
    with open(script_file_path, "w", encoding="utf-8") as script_file: script_file.write(body)
    print(f"Converted {notebook_file} to {script_file_path}...")