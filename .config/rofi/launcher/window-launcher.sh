#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Edited by : nurti (nurt1-creator)
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)

dir="$HOME/.config/rofi/launcher"
theme='style'

## Run
rofi \
    -show window \
    -theme ${dir}/${theme}.rasi
