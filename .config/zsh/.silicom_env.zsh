#!/usr/bin/env zsh

# TODO: Map key bindings

export SSH_USER=$USER
export BUILD_USER=CBS
export MODELSIM=~/modelsim.ini

###############################################################################
# Quartus setup
function setup_quartus() {
   # License setup
   export ALTERAD_LICENSE_FILE=2110@bohr

   local BOHR_QUARTUS_DIR="/net/bohr/opt/altera"
   export QUARTUS_VER=$(find $BOHR_QUARTUS_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort --ignore-case --reverse | fzf)
   if [ ! -n "${QUARTUS_VER}" ]; then
      return
   fi

   export QUARTUS_ROOTDIR="$BOHR_QUARTUS_DIR/$QUARTUS_VER/quartus"
   #export QUARTUS_INSTALL_DIR="$QUARTUS_ROOTDIR"
   #export PATH="$QUARTUS_ROOTDIR/linux64":$PATH
   source "$QUARTUS_ROOTDIR"/adm/qenv.sh 2> /dev/null
}
bindkey -s '^v' 'setup_quartus\n'

# Powerline10K prompt
function prompt_quartus_env() {
   #p10k segment -f 208 -i '★ ⭐ ⛅ ⛄ ✪ ✱ ⛈ 🌀 🌐  ' -t 'Quartus, %n'
   if [ ! -n "${QUARTUS_VER}" ]; then
      return
   fi
   p10k segment -f 208 -i '𝒬' -t $(echo $QUARTUS_VER) 
}

# Powerline10K instant prompt
function instant_prompt_quartus_env() {
   prompt_quartus_env
}

###############################################################################
# QuestaSim setup
function setup_questa() {
   # Mentor license setup
   export LM_LICENSE_FILE=1717@bohr

   export MODELSIM=~/modelsim.ini

   local BOHR_QUESTA_DIR="/opt/Mentor/questasim"
   export QUESTA_VER=$(find $BOHR_QUESTA_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort --ignore-case --reverse | fzf)
   if [ ! -n "${QUESTA_VER}" ]; then
      return
   fi

   export QUESTA_HOME="$BOHR_QUESTA_DIR/$QUESTA_VER/questasim"
   #export INSTALL_HOME=/opt/Mentor/questasim/$1/questasim
   export CC="gcc -g -c -m64 -Wall -ansi -pedantic -fPIC -I. -I$QUESTA_HOME/include"
   export LD="gcc -shared -lm -m64 -lpthread -Wl,-Bsymbolic -Wl,-export-dynamic -o"
   export UCDB_LD="gcc -ldl -lm -m64 -lpthread -o"
   export UCDBLIB="$QUESTA_HOME/linux_x86_64/libucdb.a"
   export PATH=$QUESTA_HOME/bin:$PATH
   export PATH=$QUESTA_HOME/linux_x86_64:$PATH
}
bindkey -s '^g' 'setup_questa\n'

# Powerline10K prompt
function prompt_questa_env() {
   if [ ! -n "${QUESTA_VER}" ]; then
      return
   fi
   p10k segment -f 208 -i 'ℚ' -t $(echo $QUESTA_VER) 
}

# Powerline10K instant prompt
function instant_prompt_questa_env() {
   prompt_questa_env
}

###############################################################################
# Vivado setup
function setup_vivado() {
   export XILINXD_LICENSE_FILE=2100@bohr

   local BOHR_VIVADO_DIR="/net/bohr/opt/Xilinx/Vivado"
   export VIVADO_VER=$(find $BOHR_VIVADO_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort --ignore-case --reverse | fzf)
   if [ ! -n "${VIVADO_VER}" ]; then
      return
   fi

   export VIVADO_ROOTDIR="$BOHR_VIVADO_DIR/$VIVADO_VER"
   source "$VIVADO_ROOTDIR"/settings64.sh
}
bindkey -s '^b' 'setup_vivado\n'

# Powerline10K prompt
function prompt_vivado_env() {
   if [ ! -n "${VIVADO_VER}" ]; then
      return
   fi
   p10k segment -f 208 -i '𝕍' -t $(echo $VIVADO_VER) 
}

# Powerline10K instant prompt
function instant_prompt_vivado_env() {
   prompt_vivado_env
}

