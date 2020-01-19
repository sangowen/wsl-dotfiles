#!/usr/bin/env bash
# requires jq
# https://i3wm.org/docs/user-contributed/swapping-workspaces.html

IFS=:
i3-msg -t get_outputs | jq -r '.[]|"\(.name):\(.current_workspace)"' | grep -v 'null$' | \
while read -r name current_workspace; do
  # i3-msg workspace "${current_workspace}", move workspace to output down
  if [[ ${name} == "HDMI1" ]]; then
    i3-msg workspace "${current_workspace}", move workspace to output down
  elif [[ ${name} == "HDMI2" ]]; then
    i3-msg workspace "${current_workspace}", move workspace to output up
  # elif [[ ${name} == "HDMI3" ]]; then
  #   continue
  fi
done
i3-msg focus output HDMI1
