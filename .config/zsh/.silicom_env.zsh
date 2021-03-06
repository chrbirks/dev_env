#!/usr/bin/env zsh

# TODO: Check for SSH X11 status: SSH_CLIENT or SSH_CONNECTION or SSH_TTY defined.

export SSH_USER=$USER
export BUILD_USER=CBS
export MODELSIM=~/modelsim.ini

###############################################################################
# Quartus setup
function setup_quartus() {
   # License setup
   export ALTERAD_LICENSE_FILE=2110@bohr

   local BOHR_QUARTUS_DIR="/net/bohr/opt/altera"
   local TMP_QUARTUS_VER=$(find $BOHR_QUARTUS_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort --ignore-case --reverse | fzf --no-info --header="Select Quartus version...")
   if [ ! -n "${TMP_QUARTUS_VER}" ]; then
      return
   fi
   export QUARTUS_VER=${TMP_QUARTUS_VER}

   export QUARTUS_ROOTDIR="$BOHR_QUARTUS_DIR/$QUARTUS_VER/quartus"
   #export QUARTUS_INSTALL_DIR="$QUARTUS_ROOTDIR"
   #export PATH="$QUARTUS_ROOTDIR/linux64":$PATH
   #source "$QUARTUS_ROOTDIR"/adm/qenv.sh 2> /dev/null
   #
   export PATH="${QUARTUS_ROOTDIR}/bin":$PATH
   export QUARTUS_64BIT=1
}
zle -N setup_quartus
bindkey '\ev' setup_quartus # Alt-v

# Powerline10K prompt
function prompt_quartus_env() {
   #p10k segment -f 208 -i '★ ⭐ ⛅ ⛄ ✪ ✱ ⛈ 🌀 🌐  ' -t 'Quartus, %n'
   if [ ! -n "${QUARTUS_VER}" ]; then
      return
   fi
   p10k segment -f 208 -i 'ℚ' -t $(echo $QUARTUS_VER) 
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
   local TMP_QUESTA_VER=$(find $BOHR_QUESTA_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort --ignore-case --reverse | fzf --no-info --header="Select QuestaSim version...")
   if [ ! -n "${TMP_QUESTA_VER}" ]; then
      return
   fi
   export QUESTA_VER=${TMP_QUESTA_VER}

   export QUESTA_HOME="$BOHR_QUESTA_DIR/$QUESTA_VER/questasim"
   #export INSTALL_HOME=/opt/Mentor/questasim/$1/questasim
   export CC="gcc -g -c -m64 -Wall -ansi -pedantic -fPIC -I. -I$QUESTA_HOME/include"
   export LD="gcc -shared -lm -m64 -lpthread -Wl,-Bsymbolic -Wl,-export-dynamic -o"
   export UCDB_LD="gcc -ldl -lm -m64 -lpthread -o"
   export UCDBLIB="$QUESTA_HOME/linux_x86_64/libucdb.a"
   export PATH=$QUESTA_HOME/bin:$PATH
   export PATH=$QUESTA_HOME/linux_x86_64:$PATH
}
zle -N setup_questa
bindkey '\eg' setup_questa

# Powerline10K prompt
function prompt_questa_env() {
   if [ ! -n "${QUESTA_VER}" ]; then
      return
   fi
   p10k segment -f 208 -i '𝒬' -t $(echo $QUESTA_VER) 
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
   local TMP_VIVADO_VER=$(find $BOHR_VIVADO_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort --ignore-case --reverse | fzf --no-info --header="Select Vivado version...")
   if [ ! -n "${TMP_VIVADO_VER}" ]; then
      return
   fi
   export VIVADO_VER=${TMP_VIVADO_VER}

   export VIVADO_ROOTDIR="$BOHR_VIVADO_DIR/$VIVADO_VER"
   source "$VIVADO_ROOTDIR"/settings64.sh
}
zle -N setup_vivado
bindkey '\eb' setup_vivado

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

