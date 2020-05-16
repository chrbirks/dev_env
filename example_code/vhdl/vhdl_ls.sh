#!/usr/bin/env bash

if [[ $# -eq 0 ]]
then
    echo "ERROR: Missing output file argument"
    exit 1
fi

TOML_FILE=$1
echo "[libraries]" > "$TOML_FILE"

SCRIPTPATH="$( cd "$(dirname "$0")" || exit ; pwd -P )"

# Write local src files
echo "   project.files = [" >> "$TOML_FILE"
src_files=$(command find "$SCRIPTPATH" -regextype posix-extended -regex ".*.vhdl?" \
                    -not -path "$SCRIPTPATH/syn_par/*" \
                    -not -path "$SCRIPTPATH/src/sub_comp/*" \
                    -not -path "$SCRIPTPATH/hdl/ip/*" \
                    -type f)
num_files=$(wc -l <<< "$src_files")
# echo $src_files
# echo $num_files
i=1
for FILE in $src_files
do
    echo -n "      '$FILE'" >> "$TOML_FILE"
    # Add comma unless last file
    if [ $i -ne "$num_files" ]
    then
       echo -n "," >> "$TOML_FILE"
    fi
    # Append \n
    echo "" >> "$TOML_FILE"
    ((i+=1))
done
echo "   ]" >> "$TOML_FILE" # FIXME: Don't add comma if no sub_comp dirs

# Write sub_comp dirs (if existing)
if [ -d "$SCRIPTPATH"/src/sub_comp/ ]
then
    sub_comp_dirs=$(command find "$SCRIPTPATH"/src/sub_comp/ -maxdepth 1 -type d -not -path "$SCRIPTPATH/src/sub_comp/")
    num_sub_comp_dirs=$(wc -l <<< "$sub_comp_dirs")
    for DIR in $sub_comp_dirs
    do
        # TODO: Skip dir if no vhdl files in it
        # echo "$DIR"
        DIR_NAME=$(grep -o "[a-zA-Z0-9_-]*$" <<< "$DIR") # TODO: Better extraction of dir
        # echo $DIR_NAME
        echo "   $DIR_NAME.files = [" >> "$TOML_FILE"
        src_files=$(command find "$DIR" -regextype posix-extended -regex ".*.vhdl?" -type f)
        num_files=$(wc -l <<< "$src_files")
        i=1
        j=1
        for FILE in $src_files
        do
            echo -n "      '$FILE'" >> "$TOML_FILE"
            # Add comma unless last file
            if [ $i -ne "$num_files" ]
            then
                echo -n "," >> "$TOML_FILE"
            fi
            # Append \n
            echo "" >> "$TOML_FILE"
            ((i+=1))
        done

        echo -n "   ]" >> "$TOML_FILE"
        # if [ $j -ne $num_sub_comp_dirs ]
        # then
        #     echo -n "," >> $TOML_FILE
        # fi
        # Append \n
        echo "" >> "$TOML_FILE"
    done
fi

# Write ip dirs (if existing)
# TODO: specify sub_comp or ip dirs as command line args instead
if [ -d "$SCRIPTPATH"/hdl/ip/ ]
then
    ip_dirs=$(command find "$SCRIPTPATH"/hdl/ip/ -maxdepth 1 -type d -not -path "$SCRIPTPATH/hdl/ip/")
    num_sub_comp_dirs=$(wc -l <<< "$ip_dirs")
    for DIR in $ip_dirs
    do
        # TODO: Skip dir if no vhdl files in it
        # echo "$DIR"
        DIR_NAME=$(grep -o "[a-zA-Z0-9_-]*$" <<< "$DIR") # TODO: Better extraction of dir
        # echo $DIR_NAME
        echo "   $DIR_NAME.files = [" >> "$TOML_FILE"
        src_files=$(command find "$DIR" -regextype posix-extended -regex ".*.vhdl?" -type f)
        num_files=$(wc -l <<< "$src_files")
        i=1
        j=1
        for FILE in $src_files
        do
            echo -n "      '$FILE'" >> "$TOML_FILE"
            # Add comma unless last file
            if [ $i -ne "$num_files" ]
            then
                echo -n "," >> "$TOML_FILE"
            fi
            # Append \n
            echo "" >> "$TOML_FILE"
            ((i+=1))
        done

        echo -n "   ]" >> "$TOML_FILE"
        # if [ $j -ne $num_sub_comp_dirs ]
        # then
        #     echo -n "," >> $TOML_FILE
        # fi
        # Append \n
        echo "" >> "$TOML_FILE"
    done
fi
