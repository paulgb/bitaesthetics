#!/usr/bin/env python

import argparse
from glob import glob
from os import path, rename
import shutil

from jinja2 import DictLoader
from nbconvert import HTMLExporter
from nbconvert.writers import FilesWriter
from traitlets.config import Config


def convert_notebooks(in_directory, html_directory, static_directory):
    dl = DictLoader({
        'post.tpl':
        """
        {%- extends 'basic.tpl' -%}

        {% block body %}---
title: {{resources['metadata']['name']}}
date: {{nb.metadata['date']}}
---
        {{ super() }}
        {% endblock body %}
        """
    })

    c = Config()
    c.HTMLExporter.preprocessors = [
        'nbconvert.preprocessors.ExtractOutputPreprocessor'
    ]
    html_exporter = HTMLExporter(config=c, extra_loaders=[dl])
    html_exporter.template_file = 'post.tpl'
    writer = FilesWriter(build_directory=html_directory)

    for notebook_file in glob(path.join(in_directory, '*.ipynb')):
        out_name, _ = path.splitext(path.basename(notebook_file))
        out_name = out_name.lower().replace(' ', '-')

        print('Converting {}'.format(notebook_file))

        (body, resources) = html_exporter.from_filename(
            notebook_file,
            resources={'output_files_dir': out_name})
        writer.write(body, resources, notebook_name=out_name)
        
        shutil.rmtree(path.join(static_directory, out_name), True)
        rename(path.join(html_directory, out_name),
               path.join(static_directory, out_name))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('in_directory')
    parser.add_argument('html_directory')
    parser.add_argument('static_directory')
    args = parser.parse_args()
    convert_notebooks(args.in_directory,
                      args.html_directory,
                      args.static_directory)
