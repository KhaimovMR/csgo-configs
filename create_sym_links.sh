cs_found=0
cs_files_found=0
insufficient_permissions=1
default_cs_paths="~/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive"

if [[ "$1" == "" ]]
then 
	default_cs_paths="$1"
	echo Using specified path.
	echo
	echo
	echo
else
	echo Using a default paths...
	echo
	echo
	echo
fi		

for $p in $default_cs_paths
do
	folders_loop $p %~dp0cfg
done

if $insufficient_permissions == 1
then
	echo
	echo
	echo This script should be runned under Administrator privileges.
	echo
	echo
	sleep 15
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
		echo
		echo CS:GO was not found in specified path.
		echo
		sleep 15
	else
		echo
		echo
		echo CS:GO was not found in your system.
		echo
		sleep 15
    fi
else
	echo
	echo
	echo CS GO was succesfully found and links to configs are created.	
	echo
	echo Note:
	echo  You can override the default autoexec configuration in a file "CSGO-DIR/csgo/cfg/my_overrides.cfg"
	echo
	pause
fi

function folders_loop() {
	if [ -e "$1/csgo/cfg" ]
    then
		if [ ! -e "$1/csgo/cfg/my_overrides.cfg" ]
        then
			echo "// Write your configuration overrides below" > "$1/csgo/cfg/my_overrides.cfg"
        fi

		for /r %2 %%f in (*.cfg)
        do 
			set filename=%%~nxf
			
			if exist "$1/csgo/cfg"
            then
				cs_found=1
				if exist "$1/csgo/cfg/%%~nxf"
                then
					dir "%~1\csgo\cfg\%%~nxf" | find "<SYMLINK>" >NUL 2>&1 && (
						echo An old symbolic link for "%~1\csgo\cfg\%%~nxf" is found. Trying to remove it... 
						del "%~1\csgo\cfg\%%~nxf"
					)
					
					if exist "%~1\csgo\cfg\%%~nxf"
                    then
						set _cs_files_found=1
						echo Found a file "%%~nxf" instead of link in directory: "%~1\csgo\cfg".
						echo Please remove it and restart this script.
						echo
						echo
						echo
						sleep 15
						echo
						echo
						echo
						exit 1
                    fi
                fi
				
				if not exist "%~1\csgo\cfg\%%~nxf"
                then
					mklink "%~1\csgo\cfg\%%~nxf" "%%~f" && set _insufficient_permissions=0
					echo.
                fi
            fi
        done
    fi
}
