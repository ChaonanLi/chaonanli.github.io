#!/bin/bash
python3 ./convert.py jupyter/ doc/ scripts/
tar -czvf archive/jupyter.tar.gz jupyter/*.ipynb
tar -czvf archive/html.tar.gz doc/*.html
tar -czvf archive/rscripts.tar.gz scripts/*.R