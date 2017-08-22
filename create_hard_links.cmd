@ECHO OFF
cls
set _cs_found=0
set _cs_files_found=0
set _insufficient_permissions=1
set _default_cs_paths="c:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive" "c:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive" "d:\Games\Steam\steamapps\common\Counter-Strike Global Offensive"

if not "%1" == "" (
	set _default_cs_paths="%1"
	echo Using specified path.
	echo.
	echo.
	echo.
) else (
	echo Using a default paths...
	echo.
	echo.
	echo.
)		

for %%p in (%_default_cs_paths%) do (
	CALL :folders_loop %%p %~dp0cfg
)

if %_insufficient_permissions% == 1 (
	echo.
	echo.
	echo This script should be runned under Administrator privileges.
	echo.
	echo.
	pause
	goto :finish
)

if %_cs_files_found% == 1 (
	goto :finish
)

if %_cs_found% == 0 (
	if not "%1" == "" (
		echo.
		echo.
		echo CS:GO was not found in specified path.
		echo.
		pause
	) else  (
		echo.
		echo.
		echo CS:GO was not found in your system.
		echo.
		pause
	)
) else (
	echo.
	echo.
	echo CS GO was succesfully found and links to configs are created.	
	echo.
	echo Note:
	echo  You can override the default autoexec configuration in a file "CSGO-DIR\csgo\cfg\my_overrides.cfg"
	echo.
	pause
)

:finish
goto :eof

:folders_loop
	if exist "%~1\csgo\cfg" (
		if not exist "%~1\csgo\cfg\my_overrides.cfg" (
			echo // Write your configuration overrides below > "%~1\csgo\cfg\my_overrides.cfg"
		)

		for /r %2 %%f in (*.cfg) do (
			set _filename=%%~nxf
			
			if exist "%~1\csgo\cfg" (
				set _cs_found=1
				if exist "%~1\csgo\cfg\%%~nxf" (
					dir "%~1\csgo\cfg\%%~nxf" | find "<SYMLINK>" >NUL 2>&1 && (
						echo An old symbolic link for "%~1\csgo\cfg\%%~nxf" is found. Trying to remove it... 
						del "%~1\csgo\cfg\%%~nxf"
					)
					
					if exist "%~1\csgo\cfg\%%~nxf" (
						set _cs_files_found=1
						echo Found a file "%%~nxf" instead of link in directory: "%~1\csgo\cfg".
						echo Please remove it and restart this script.
						echo.
						echo.
						echo.
						pause
						echo.
						echo.
						echo.
						exit /B  	
					)
				)
				
				if not exist "%~1\csgo\cfg\%%~nxf" (
					mklink "%~1\csgo\cfg\%%~nxf" "%%~f" && set _insufficient_permissions=0
					echo.
				)
			)
		)
	)
EXIT /B
