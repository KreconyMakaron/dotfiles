#!/usr/bin/env bash
cliphist list | head -n$1 | tail -n1 | cliphist decode | wl-copy
