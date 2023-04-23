#!/bin/bash

for de in budgie cinnamon gnome i3-wm kde-plasma mate xfce xmonad; do 
    ./compile.sh indiedroid-jammy-$de-multimedia
done
