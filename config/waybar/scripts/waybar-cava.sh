#! /bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]; do
  dict="${dict}s/$i/${bar:$i:1}/g;"
  i=$((i + 1))
done

# write cava config
config_file="/tmp/cava_waybar_config"
echo "
[general]
bars = 18
framerate = 60
autospawn = false
ignore_terminal = true

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
" >$config_file

# read stdout from cava and wrap in JSON for Waybar
cava -p $config_file | while read -r line; do
  bars=$(echo $line | sed "$dict")
  echo "{\"text\": \"$bars\"}"
done
