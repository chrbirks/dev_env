#!/usr/bin/env zsh
#echo "TEST"

# TODO: Map key bindings
# TODO: Add version numbers if set to p10k status line

function setup_quartus() {
   # License setup
   export ALTERAD_LICENSE_FILE=2110@bohr

   local BOHR_QUARTUS_DIR="/net/bohr/opt/altera"
   export QUARTUS_VER=$(find $BOHR_QUARTUS_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort --ignore-case --reverse | fzf)
   export QUARTUS_ROOTDIR="$BOHR_QUARTUS_DIR/$QUARTUS_VER/quartus"
   #export QUARTUS_INSTALL_DIR="$QUARTUS_ROOTDIR"
   #export PATH="$QUARTUS_ROOTDIR/linux64":$PATH
   source "$QUARTUS_ROOTDIR"/adm/qenv.sh 2> /dev/null
}

function my_quartus_env() {
   p10k segment -s QUARTUS -f blue -t 2019
}
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=my_quartus_env

function setup_questa() {
   # Mentor license setup
   export LM_LICENSE_FILE=1717@bohr

   export MODELSIM=~/modelsim.ini

   local BOHR_QUESTA_DIR="/opt/Mentor/questasim"
   export QUESTA_VER=$(find $BOHR_QUESTA_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort --ignore-case --reverse | fzf)
   export QUESTA_HOME="$BOHR_QUESTA_DIR/$QUESTA_VER/questasim"
   #export INSTALL_HOME=/opt/Mentor/questasim/$1/questasim
   export CC="gcc -g -c -m64 -Wall -ansi -pedantic -fPIC -I. -I$QUESTA_HOME/include"
   export LD="gcc -shared -lm -m64 -lpthread -Wl,-Bsymbolic -Wl,-export-dynamic -o"
   export UCDB_LD="gcc -ldl -lm -m64 -lpthread -o"
   export UCDBLIB="$QUESTA_HOME/linux_x86_64/libucdb.a"
   export PATH=$QUESTA_HOME/bin:$PATH
   export PATH=$QUESTA_HOME/linux_x86_64:$PATH
}

function setup_vivado() {
   # Xilinx FPGA setup
   export XILINXD_LICENSE_FILE=2100@bohr

   local BOHR_VIVADO_DIR="/net/bohr/opt/Xilinx/Vivado"
   export VIVADO_VER=$(find $BOHR_VIVADO_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort --ignore-case --reverse | fzf)
   export VIVADO_ROOTDIR="$BOHR_VIVADO_DIR/$VIVADO_VER"
   source "$VIVADO_ROOTDIR"/settings64.sh
}

