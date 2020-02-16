#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Sun Feb 16 10:23:52 PST 2020
# SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto 886a700603d0403c9fc0c2f185282a13 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot cmp_reg_file_behav xil_defaultlib.cmp_reg_file xil_defaultlib.glbl -log elaborate.log"
xelab -wto 886a700603d0403c9fc0c2f185282a13 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot cmp_reg_file_behav xil_defaultlib.cmp_reg_file xil_defaultlib.glbl -log elaborate.log

