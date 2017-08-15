for %%p in (
	"c:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg"
	"c:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive\csgo\cfg"
	"d:\Games\Steam\steamapps\common\Counter-Strike Global Offensive\csgo\cfg"
) do (
	if exist %%p (
		for /r %cd%\cfg %%f in (*.cfg) do (
			mklink %%p\%%~nxf %%f
		)
	)
)
