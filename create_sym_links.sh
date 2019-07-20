#!/bin/bash
cs_found=0
cs_files_found=0
insufficient_permissions=1
default_cs_paths=("$HOME/.steam/steam/steamapps/common/Counter-Strike Global Offensive")
repo_path=`dirname $(readlink -f $(type -p $0))`

function pause() {
    read -p "Press ENTER to continue..."
}

function folders_loop() {
    echo "$1"
    echo "$2"
    #ls -la "$1/csgo/cfg"

    if [[ -e "$1/csgo/cfg" ]]; then
        echo "CS:GO found on $1 path"

        if [ ! -e "$1/csgo/cfg/my_overrides.cfg" ]
        then
            echo "// Write your configuration overrides below" > "$1/csgo/cfg/my_overrides.cfg"
        fi

        for cfg_file_path in $(ls -1 $2/cfg/*.cfg)
        do
            filename=$(basename $cfg_file_path)

            if [ -e "$1/csgo/cfg" ]
            then
                cs_found=1

                if [ -L "$1/csgo/cfg/$filename" ]
                then
                    echo An old symbolic link for "$1/csgo/cfg/$filename" is found. Trying to remove it... &&
                    rm "$1/csgo/cfg/$filename"
                fi

                if [ -e "$1/csgo/cfg/$filename" ]
                then
                    cs_files_found=0
                    echo Found a file "$filename" instead of link in directory: "$1/csgo/cfg".
                    echo Please remove it and restart this script.
                    echo
                    pause
                    exit 1
                fi

                if [ ! -e "$1/csgo/cfg/$filename" ]
                then
                    ln -s "$2/cfg/$filename" "$1/csgo/cfg/$filename" && insufficient_permissions=0
                    echo
                fi
            fi
        done
    fi
}

if [[ "$1" != "" ]]
then
    default_cs_paths="$1"
    echo Using specified path.
    echo
else
    echo Using a default paths...
    echo
fi

#for p in $default_cs_paths
for (( i=0; i<${#default_cs_paths[@]}; i++ ));
do
    folders_loop "${default_cs_paths[$i]}" "$repo_path"
done

if [[ $insufficient_permissions == 1 ]]
then
    echo
    echo This script should be runned under Administrator privileges.
    echo
    pause
    exit 0
fi

if [[ $cs_files_found == 1 ]]
then
    exit 0
fi

if [[ $cs_found == 0 ]]
then
    if [[ "$1" != "" ]]
    then
        echo
        echo CS:GO was not found in specified path.
        echo
        pause
    else
        echo
        echo CS:GO was not found in your system.
        echo
        pause
    fi
else
    echo
    echo CS GO was succesfully found and links to configs are created.
    echo
    echo Note:
    echo   You can override the default autoexec configuration in a file "CSGO-DIR/csgo/cfg/my_overrides.cfg"
    echo
    pause
fi
