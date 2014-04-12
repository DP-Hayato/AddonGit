-----------------------------------------------------------------------------------------------
-- Client Lua Script for SlashRoll
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"
 
-----------------------------------------------------------------------------------------------
-- SlashRoll Module Definition
-----------------------------------------------------------------------------------------------
local SlashRoll = {} 
 
-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
 
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function SlashRoll:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    -- initialize variables here

    return o
end

function SlashRoll:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		-- "UnitOrPackageName",
	}
    Apollo.RegisterAddon(self, bHasConfigureButton, strConfigureButtonText, tDependencies)
end
 

-----------------------------------------------------------------------------------------------
-- SlashRoll OnLoad
-----------------------------------------------------------------------------------------------
function SlashRoll:OnLoad()
    -- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("SlashRoll.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
	Apollo.RegisterSlashCommand("roll", "OnSlashRoll", self)
end

-----------------------------------------------------------------------------------------------
-- SlashRoll OnDocLoaded
-----------------------------------------------------------------------------------------------
function SlashRoll:OnDocLoaded()

	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
	    self.wndMain = Apollo.LoadForm(self.xmlDoc, "SlashRollForm", nil, self)
		if self.wndMain == nil then
			Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
			return
		end
		
	    self.wndMain:Show(false, true)

		-- if the xmlDoc is no longer needed, you should set it to nil
		-- self.xmlDoc = nil
		
		-- Register handlers for events, slash commands and timer, etc.
		-- e.g. Apollo.RegisterEventHandler("KeyDown", "OnKeyDown", self)


		-- Do additional Addon initialization here
	end
end

-----------------------------------------------------------------------------------------------
-- SlashRoll Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here

-- on SlashCommand "/roll"
function SlashRoll:OnSlashRoll()
-- get a random number between 1 and 100
rollnumber = math.random(100)
-- info variables
local ininstance = GroupLib.InInstance(0)
local ingroup = GroupLib.InGroup(0)
-- Check for Solo or in Group/Raid or in Group/Raid (Instance)
-- Solo
if ingroup == false and ininstance == false then
ChatSystemLib.Command('/emote' .. ' rolls ' .. tostring(rollnumber) .. '!')
-- Group/Raid
elseif ingroup == true and ininstance == false then
ChatSystemLib.Command('/party' .. ' rolls ' .. tostring(rollnumber) .. '!')
-- Group/Raid (Instance)
elseif ingroup == true and ininstance == true then
ChatSystemLib.Command('/instance' .. ' rolls ' .. tostring(rollnumber) .. '!')
end

end

-----------------------------------------------------------------------------------------------
-- SlashRollForm Functions
-----------------------------------------------------------------------------------------------
-- when the OK button is clicked
function SlashRoll:OnOK()
	self.wndMain:Show(false) -- hide the window
end

-- when the Cancel button is clicked
function SlashRoll:OnCancel()
	self.wndMain:Show(false) -- hide the window
end


-----------------------------------------------------------------------------------------------
-- SlashRoll Instance
-----------------------------------------------------------------------------------------------
local SlashRollInst = SlashRoll:new()
SlashRollInst:Init()
