#!/bin/bash

# setup

	curr_path=`pwd`

	mkdir quality_control

	mkdir quality_control/reg

	wm_path=`osascript -e 'text returned of (display dialog "Path to FA images" default answer "~/documents")'`

# run the ROI extraction and analyses

	chmod +x FA_extract.sh

	./FA_extract.sh $wm_path $curr_path
