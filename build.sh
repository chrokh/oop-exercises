#!/bin/bash

echo "> rm"
rm -rf docs

echo "> mkdir"
mkdir -p docs/examples
mkdir -p docs/exercises

echo "> Index"
pandoc -s -c "static/style.css" src/index.md -o docs/index.html

echo "> Statics"
cp -r src/static docs/static

echo "> Exercises"
pandoc -s -c "../static/style.css" src/exercises/nat.md -o docs/exercises/nat.html
pandoc -s -c "../static/style.css" src/exercises/ciphers.md -o docs/exercises/ciphers.html

echo "> Examples"
pandoc -s -c "../static/style.css" src/examples/command-line-args-and-object-composition.md -o docs/examples/command-line-args-and-object-composition.html
pandoc -s -c "../static/style.css" src/examples/organism-simulator.md -o docs/examples/organism-simulator.html
