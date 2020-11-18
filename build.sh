#!/bin/bash
mkdir -p dist/static
mkdir -p dist/static/examples
mkdir -p dist/static/exercises
cp src/static/style.css dist/static/style.css
pandoc -s -c "static/style.css" src/index.md -o dist/index.html
pandoc -s -c "../static/style.css" src/exercises/index.md -o dist/exercises/index.html
pandoc -s -c "../static/style.css" src/examples/command-line-args-and-object-composition.md -o dist/examples/command-line-args-and-object-composition.html
