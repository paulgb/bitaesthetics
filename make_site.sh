#!/bin/sh

set -e

mkdir -p static/sites
./convert_notebooks.py notebooks/ content/posts static/posts/

hugo

