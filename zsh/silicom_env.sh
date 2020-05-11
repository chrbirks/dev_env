#!/usr/bin/env zsh
#echo "TEST"

# TODO: Map key bindings
# TODO: Add version numbers if set to p10k status line

function setup_quartus() {
   local BOHR_QUARTUS_DIR="/opt/altera"
   export QUARTUS_VER=$(find $BOHR_QUARTUS_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort --ignore-case --reverse | fzf)
   export QUARTUS_ROOTDIR="$BOHR_QUARTUS_DIR/$QUARTUS_VER"
   echo $QUARTUS_VER
   echo $QUARTUS_ROOTDIR
}

function my_quartus_env() {
   p10k segment -s QUARTUS -f blue -t 2019
}
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=my_quartus_env

function setup_questa() {
   local BOHR_QUESTA_DIR="/opt/Mentor/questasim"
   export QUESTA_VER=$(find $BOHR_QUESTA_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort --ignore-case --reverse | fzf)
   export QUESTA_ROOTDIR="$BOHR_QUESTA_DIR/$QUESTA_VER"
   echo $QUESTA_VER
   echo $QUESTA_ROOTDIR
}

function setup_vivado() {
   local BOHR_VIVADO_DIR="/opt/Xilinx/Vivado"
   export VIVADO_VER=$(find $BOHR_VIVADO_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort --ignore-case --reverse | fzf)
   export VIVADO_ROOTDIR="$BOHR_VIVADO_DIR/$VIVADO_VER"
   echo $VIVADO_VER
   echo $VIVADO_ROOTDIR
}

