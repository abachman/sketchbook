#!/bin/bash

rsync -rvt ./ dreamhost:demo.adambachman.org/sketchbook/the-dragon --exclude=sync.sh --exclude=.*.swp
