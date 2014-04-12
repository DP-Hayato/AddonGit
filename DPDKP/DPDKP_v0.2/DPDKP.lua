-----------------------------------------------------------------------------------------------
-- Client Lua Script for DPDKP
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
 
require "Window"
 
-----------------------------------------------------------------------------------------------
-- DPDKP Module Definition
-----------------------------------------------------------------------------------------------
local DPDKP = {} 
 
-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
-- e.g. local kiExampleVariableMax = 999
 
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function DPDKP:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    -- initialize variables here
	o.wndSelectedListItem = nil -- keep track of which list item is currently selected
	unitPlayer = GameLib.GetPlayerUnit()
	o.tItems = {} -- keep track of all the list items
    return o
end

function DPDKP:Init()
	local bHasConfigureFunction = false
	local strConfigureButtonText = ""
	local tDependencies = {
		-- "UnitOrPackageName",
	}
    Apollo.RegisterAddon(self, bHasConfigureButton, strConfigureButtonText, tDependencies)
end
 

-----------------------------------------------------------------------------------------------
-- DPDKP OnLoad
-----------------------------------------------------------------------------------------------
function DPDKP:OnLoad()
    -- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("DPDKP.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
end

-----------------------------------------------------------------------------------------------
-- DPDKP OnDocLoaded
-----------------------------------------------------------------------------------------------
function DPDKP:OnDocLoaded()

	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
	    self.wndMain = Apollo.LoadForm(self.xmlDoc, "DPDKPForm", nil, self)
		if self.wndMain == nil then
			Apollo.AddAddonErrorText(self, "Could not load the main window for some reason.")
			return
		end
		
	    self.wndMain:Show(false, true)
		-- item list
		self.wndList = Apollo.LoadForm(self.xmlDoc, "DPDKPLeaderWindow", nil, self)
		self.wndItemList = self.wndList:FindChild("ItemList")
		self.wndList:Show(false, true)

		-- if the xmlDoc is no longer needed, you should set it to nil
		-- self.xmlDoc = nil
		
		-- Register handlers for events, slash commands and timer, etc.
		-- e.g. Apollo.RegisterEventHandler("KeyDown", "OnKeyDown", self)
		Apollo.RegisterSlashCommand("dpdkp", "OnDPDKPOn", self)


		-- Do additional Addon initialization here
	end
end

-----------------------------------------------------------------------------------------------
-- DPDKP Functions
-----------------------------------------------------------------------------------------------
-- Define general functions here

-- on SlashCommand "/dpdkp"
function DPDKP:OnDPDKPOn()
	self.wndMain:FindChild("wndHead"):SetCostume(unitPlayer)
	self.wndMain:Show(true) -- show the window
end


-----------------------------------------------------------------------------------------------
-- DPDKPForm Functions
-----------------------------------------------------------------------------------------------
-- when the OK button is clicked
function DPDKP:OnOK()
	self.wndMain:Show(false) -- hide the window
end

function DPDKP:OnOpenList()
	local leader = GroupLib.AmILeader(unitPlayer)
	--if leader == true then
		self.wndList:Show(true)
	--else
	--end
end

function DPDKP:OnImport()	
	data = self.wndList:FindChild("editImport"):GetText()
	playername = unitPlayer:GetName()
	load_table = loadstring(data)
	load_table()
	self.wndList:FindChild("editImport"):AddStyleEx("ReadOnly")
    
	-- populate the item list
	self:PopulateItemList()
end

function DPDKP:OnReset()
	self.wndList:FindChild("editImport"):SetText("")
	self.wndList:FindChild("editImport"):RemoveStyleEx("ReadOnly")
end

-- when the Cancel button is clicked
function DPDKP:OnCancel()
	self.wndMain:Show(false) -- hide the window
end

-----------------------------------------------------------------------------------------------
-- ItemList Functions
-----------------------------------------------------------------------------------------------
-- populate item list
function DPDKP:PopulateItemList()
	-- make sure the item list is empty to start with
	self:DestroyItemList()
	
    -- add items
	count = 0
	for k,v in pairs(gdkp["players"]) do
     count = count + 1
	end
	players = {}
	
	local ordered_keys = {}

	for k in pairs(gdkp["players"]) do
    	table.insert(ordered_keys, k)
	end

	table.sort(ordered_keys)
	for i = 1, #ordered_keys do
    	local k, v = ordered_keys[i], gdkp["players"][ ordered_keys[i] ]
    	table.insert(players, k)
	end
	
	for i = 1,count do
        self:AddItem(i)
	end
	
	-- now all the item are added, call ArrangeChildrenVert to list out the list items vertically
	self.wndItemList:ArrangeChildrenVert()
end

-- clear the item list
function DPDKP:DestroyItemList()
	-- destroy all the wnd inside the list
	for idx,wnd in ipairs(self.tItems) do
		wnd:Destroy()
	end

	-- clear the list item array
	self.tItems = {}
	self.wndSelectedListItem = nil
end

-- add an item into the item list
function DPDKP:AddItem(i)
	-- load the window item for the list item
	local wnd = Apollo.LoadForm(self.xmlDoc, "ListItem", self.wndItemList, self)
	
	-- keep track of the window item created
	self.tItems[i] = wnd

	-- give it a piece of data to refer to 
	local wndItemName = wnd:FindChild("Name")
	if wndItemName then -- make sure the text wnd exist
		wndItemName:SetText(players[i]) -- set the item wnd's text to "item i"
	end
	-- give it a piece of data to refer to 
	local wndItemDKP = wnd:FindChild("DKP")
	if wndItemDKP then -- make sure the text wnd exist
		wndItemDKP:SetText(gdkp["players"][players[i]]["DKP"]) -- set the item wnd's text to "item i"
	end
	wnd:SetData(i)
end

-- when a list item is selected
function DPDKP:OnListItemSelected(wndHandler, wndControl)
    -- make sure the wndControl is valid
    if wndHandler ~= wndControl then
        return
    end
    
    -- change the old item's text color back to normal color
    local wndItemName
    if self.wndSelectedListItem ~= nil then
        wndItemName = self.wndSelectedListItem:FindChild("Name")
        wndItemName:SetTextColor(kcrNormalText)
    end
    
	-- wndControl is the item selected - change its color to selected
	self.wndSelectedListItem = wndControl
	wndItemName = self.wndSelectedListItem:FindChild("Name")
    wndItemName:SetTextColor(kcrSelectedText)
    
	Print( "item " ..  self.wndSelectedListItem:GetData() .. " is selected.")
end
-----------------------------------------------------------------------------------------------
-- DPDKP Instance
-----------------------------------------------------------------------------------------------
local DPDKPInst = DPDKP:new()
DPDKPInst:Init()
