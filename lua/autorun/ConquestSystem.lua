ConquestSystem = {}

if SERVER then

	include("conquestsystem/sh_config.lua")
	include("conquestsystem/sh_interface.lua")
	include("conquestsystem/sv_main.lua")

else

	include("conquestsystem/sh_config.lua")
	include("conquestsystem/sh_interface.lua")
	include("conquestsystem/cl_main.lua")
	include("conquestsystem/ui/base.lua")

end