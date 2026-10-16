#!/bin/sh
# Prints total CPU usage as a percentage of all cores, styled for the itmux
# status bar: normal under 50%, amber from 50%, coral from 80%.
cores=$(sysctl -n hw.logicalcpu 2>/dev/null || nproc 2>/dev/null || echo 1)
ps -A -o %cpu= | awk -v cores="$cores" -v icon="" '
  { sum += $1 }
  END {
    pct = sum / cores; if (pct > 100) pct = 100
    color = pct >= 80 ? "#f07a6a" : pct >= 50 ? "#f0b866" : "#c8cedb"
    printf "#[fg=#8aa4ff]%s #[fg=%s]%3d%% ", icon, color, pct
  }'
