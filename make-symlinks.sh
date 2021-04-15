#!/bin/bash

for f in *.md; do ln -s -- "$f" "${f%.md}.lhs"; done
