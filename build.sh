#!/bin/bash
mkdir -p docs/static
mkdir -p docs/examples
mkdir -p docs/exercises
cp src/static/style.css docs/static/style.css
pandoc -s -c "static/style.css" src/index.md -o docs/index.html
pandoc -s -c "../static/style.css" src/exercises/index.md -o docs/exercises/index.html
pandoc -s -c "../static/style.css" src/examples/command-line-args-and-object-composition.md -o docs/examples/command-line-args-and-object-composition.html
