#!/usr/bin/env bash
entry="$@"
subfinder -d "$entry" | while read line
  do
        whatweb "$line"
      done | tr ',' '\n' \
        | sort -u | uniq
