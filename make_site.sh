#!/bin/sh

set -e

mkdir -p static/posts
./convert_notebooks.py notebooks/ content/posts static/posts/

hugo

