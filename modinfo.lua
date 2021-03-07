name = "Character Stat Editor"
description = "Edit Character Stats"
author = "Shu"
version = "0.0.1"

forumthread = ""

api_version = 10
api_version_dst = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
dst_compatible = true

all_clients_require_mod = false
client_only_mod = false

server_filter_tags = {"health","sanity","hunger","editor","player"}

priority = 0

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- -------------------
-- Resources
-- -------------------
-- Levelup system by Red J


--setup all key interactions for options
local KEY_A = 65
local string = ""
local keyslist = {}
for i = 1, 26 do
	local ch = string.char(KEY_A + i - 1)
	keyslist[i] = {description = ch, data = ch}
end

-- The collection of configuration options, each with a 
-- variable-name, 
-- label for the menu,  (Mod config menu)
-- {description = "FieldName", data = value},
-- and all the possible values for this option. 
configuration_options =
{
	{
		name = "KEYBOARDTOGGLEKEY",
		label = "Toggle Button",
		hover = "Testing Key.",
		options = keyslist,
		default = "P",
	},	
}