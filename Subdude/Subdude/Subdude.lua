-----------------------------------------------------------------------------------------------
-- Client Lua Script for Subdude
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"
 
-----------------------------------------------------------------------------------------------
-- Subdude Module Definition
-----------------------------------------------------------------------------------------------
local Subdude = {} 
 
-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
unitPlayer = GameLib.GetPlayerUnit()
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function Subdude:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    -- initialize variables here

    return o
end

function Subdude:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		-- "UnitOrPackageName",
	}
    Apollo.RegisterAddon(self, bHasConfigureFunction, strConfigureButtonText, tDependencies)
end
 

-----------------------------------------------------------------------------------------------
-- Subdude OnLoad
-----------------------------------------------------------------------------------------------
function Subdude:OnLoad()
    -- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("Subdude.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
end

-----------------------------------------------------------------------------------------------
-- Subdude OnDocLoaded
-----------------------------------------------------------------------------------------------
function Subdude:OnDocLoaded()

	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
	    self.wndMain = Apollo.LoadForm(self.xmlDoc, "SubdudeForm", nil, self)
		if self.wndMain == nil then
			Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
			return
		end
		
	    self.wndMain:Show(false, true)

		-- if the xmlDoc is no longer needed, you should set it to nil
		-- self.xmlDoc = nil
		
		-- Register handlers for events, slash commands and timer, etc.
		-- e.g. Apollo.RegisterEventHandler("KeyDown", "OnKeyDown", self)

		self.timer = ApolloTimer.Create(0.200, true, "OnTimer", self)

		-- Do additional Addon initialization here
	end
end

-----------------------------------------------------------------------------------------------
-- Subdude Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here

-- on timer
function Subdude:OnTimer()
	-- Do your timer-related stuff here.
		-- Subdue Weapon Tracker
	if unitPlayer:GetType() == "Pickup" then
		self.wndMain:Show(true)
	else
		self.wndMain:Show(false)
	end
end


-----------------------------------------------------------------------------------------------
-- SubdudeForm Functions
-----------------------------------------------------------------------------------------------
-- when the OK button is clicked
function Subdude:OnOK()
	self.wndMain:Close() -- hide the window
end

-- when the Cancel button is clicked
function Subdude:OnCancel()
	self.wndMain:Close() -- hide the window
end


-----------------------------------------------------------------------------------------------
-- Subdude Instance
-----------------------------------------------------------------------------------------------
local SubdudeInst = Subdude:new()
SubdudeInst:Init()
