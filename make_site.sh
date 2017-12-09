#!/bin/sh

set -e

mkdir -p static/posts
cp -R notebooks static/
./convert_notebooks.py notebooks/ content/posts static/posts/

hugo

