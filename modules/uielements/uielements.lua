-- This module handle various UI Elements by LUI or Blizzard.
-- It's an umbrella module to consolidate the many, many little UI changes that LUI does
--	that do not need a full module for themselves.

-- ####################################################################################################################
-- ##### Setup and Locals #############################################################################################
-- ####################################################################################################################

local _, LUI = ...
local module = LUI:GetModule("UI Elements")
local db

--local NUM_OBJECTIVE_HEADERS = 3

--local origInfo = {}

local orderUI = false

local DurabilityFrame_SetAlerts = _G.DurabilityFrame_SetAlerts
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
local DurabilityFrame = _G.DurabilityFrame
local Minimap = _G.Minimap


-- ####################################################################################################################
-- ##### Module Functions #############################################################################################
-- ####################################################################################################################

function module:SetUIElements()
	db = module.db.profile
	module:SetHiddenFrames()
	--module:SetObjectiveFrame()
	module:SetAdditionalFrames()
	module:SetPosition('VehicleSeatIndicator')
	module:SetPosition('AlwaysUpFrame')
	module:SetPosition('CaptureBar')
	module:SetPosition('TicketStatus')
	module:SetPosition('MawBuffs')
	module:SetPosition('PlayerPowerBarAlt')
	module:SetPosition('ObjectiveTrackerFrame')
	module:SetPosition('DurabilityFrame')
	module:SetPosition('PlayerPowerBarAlt')
end

function module:SetHiddenFrames()
	-- Durability Frame
	if db.DurabilityFrame.HideFrame then
		LUI:Kill(DurabilityFrame)
	else
		LUI:Unkill(DurabilityFrame)
		DurabilityFrame_SetAlerts()
		if db.DurabilityFrame.ManagePosition then
			DurabilityFrame:ClearAllPoints()
			-- Not Working. Figure out why.
			DurabilityFrame:SetPoint("RIGHT", Minimap, "LEFT", db.DurabilityFrame.X, db.DurabilityFrame.Y)
		else
			DurabilityFrame_SetAlerts()
		end
	end

	if db.OrderHallCommandBar.HideFrame and not orderUI then
		module:SecureHook("OrderHall_LoadUI", function()
			LUI:Kill(_G.OrderHallCommandBar)
		end)
		orderUI = true
	end
end
-- ####################################################################################################################
-- ##### UIElements: Force Positioning ################################################################################
-- ####################################################################################################################
--- @TODO: Refactor to be cleaner. this was ripped straight out of V3 miinimap module.

local UIWidgetBelowMinimapContainerFrame = _G.UIWidgetBelowMinimapContainerFrame
local UIWidgetTopCenterContainerFrame = _G.UIWidgetTopCenterContainerFrame
local MawBuffsBelowMinimapFrame = _G.MawBuffsBelowMinimapFrame
local VehicleSeatIndicator = _G.VehicleSeatIndicator
local TicketStatusFrame = _G.TicketStatusFrame
local PlayerPowerBarAlt = _G.PlayerPowerBarAlt
local GroupLootContainer = _G.GroupLootContainer

local shouldntSetPoint = false

function module:SetAdditionalFrames()
	self:SecureHook(DurabilityFrame, "SetPoint", "DurabilityFrame_SetPoint")
	if (LUI.IsRetail) then
		self:SecureHook(VehicleSeatIndicator, "SetPoint", "VehicleSeatIndicator_SetPoint")
		self:SecureHook(ObjectiveTrackerFrame, "SetPoint", "ObjectiveTrackerFrame_SetPoint")
		self:SecureHook(UIWidgetTopCenterContainerFrame, "SetPoint", "AlwaysUpFrame_SetPoint")
		self:SecureHook(TicketStatusFrame, "SetPoint", "TicketStatus_SetPoint")
		self:SecureHook(UIWidgetBelowMinimapContainerFrame, "SetPoint", "CaptureBar_SetPoint")
		self:SecureHook(PlayerPowerBarAlt, "SetPoint", "PlayerPowerBarAlt_SetPoint")
		self:SecureHook(GroupLootContainer, "SetPoint", "GroupLootContainer_SetPoint")
		self:SecureHook(MawBuffsBelowMinimapFrame, "SetPoint", "MawBuffs_SetPoint")
	end
end

--- Force the position of a given supported frame
---@param frame Frame
function module:SetPosition(frame)
	shouldntSetPoint = true
	if frame == "AlwaysUpFrame" and db.AlwaysUpFrame.ManagePosition then
		UIWidgetTopCenterContainerFrame:ClearAllPoints()
		UIWidgetTopCenterContainerFrame:SetPoint("TOP", UIParent, "TOP", db.AlwaysUpFrame.X, db.AlwaysUpFrame.Y)
	elseif (LUI.IsRetail) and frame == "VehicleSeatIndicator" and db.VehicleSeatIndicator.ManagePosition then
		VehicleSeatIndicator:ClearAllPoints()
		VehicleSeatIndicator:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", db.VehicleSeatIndicator.X, db.VehicleSeatIndicator.Y)
	elseif frame == "DurabilityFrame" and db.DurabilityFrame.ManagePosition then
		DurabilityFrame:ClearAllPoints()
		DurabilityFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", db.DurabilityFrame.X, db.DurabilityFrame.Y)
	elseif frame == "TicketStatus" and db.TicketStatus.ManagePosition then
		TicketStatusFrame:ClearAllPoints()
		TicketStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", db.TicketStatus.X, db.TicketStatus.Y)
	elseif (LUI.IsRetail) and frame == "ObjectiveTrackerFrame" and db.ObjectiveTracker.ManagePosition then
		--ObjectiveTrackerFrame:ClearAllPoints() -- Cause a lot of odd behaviors with the quest tracker.
		ObjectiveTrackerFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", db.ObjectiveTracker.OffsetX, db.ObjectiveTracker.OffsetY)
	elseif frame == "CaptureBar" and db.CaptureBar.ManagePosition then
		UIWidgetBelowMinimapContainerFrame:ClearAllPoints()
		UIWidgetBelowMinimapContainerFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", db.CaptureBar.X, db.CaptureBar.Y)
	elseif frame == "PlayerPowerBarAlt" and db.PlayerPowerBarAlt.ManagePosition then
		PlayerPowerBarAlt:ClearAllPoints()
		PlayerPowerBarAlt:SetPoint("BOTTOM", UIParent, "BOTTOM", db.PlayerPowerBarAlt.X, db.PlayerPowerBarAlt.Y)
	elseif frame == "GroupLootContainer" and db.GroupLootContainer.ManagePosition then
		GroupLootContainer:ClearAllPoints()
		GroupLootContainer:SetPoint("BOTTOM", UIParent, "BOTTOM", db.GroupLootContainer.X, db.GroupLootContainer.Y)
	elseif frame == "MawBuffs" and db.MawBuffs.ManagePosition then
		MawBuffsBelowMinimapFrame:ClearAllPoints()
		MawBuffsBelowMinimapFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", db.MawBuffs.X, db.MawBuffs.Y)
	end

	shouldntSetPoint = false
end

function module:DurabilityFrame_SetPoint()
	if shouldntSetPoint then return end
	self:SetPosition('DurabilityFrame')
end

function module:ObjectiveTrackerFrame_SetPoint()
	if shouldntSetPoint then return end
	self:SetPosition('ObjectiveTrackerFrame')
end

function module:VehicleSeatIndicator_SetPoint()
	if shouldntSetPoint then return end
	self:SetPosition('VehicleSeatIndicator')
end

function module:AlwaysUpFrame_SetPoint()
	if shouldntSetPoint then return end
	self:SetPosition('AlwaysUpFrame')
end

function module:CaptureBar_SetPoint()
	if shouldntSetPoint then return end
	self:SetPosition('CaptureBar')
end

function module:GroupLootContainer_SetPoint()
	if shouldntSetPoint then return end
	self:SetPosition('GroupLootContainer')
end

function module:PlayerPowerBarAlt_SetPoint()
	if shouldntSetPoint then return end
	self:SetPosition('PlayerPowerBarAlt')
end

function module:TicketStatus_SetPoint()
	if shouldntSetPoint then return end
	self:SetPosition('TicketStatus')
end

function module:MawBuffs_SetPoint()
	if shouldntSetPoint then return end
	self:SetPosition('MawBuffs')
end

-- ####################################################################################################################
-- ##### UIElement: ObjectiveTracker ##################################################################################
-- ####################################################################################################################

function module:ChangeHeaderColor(header, r, g, b)
	header.Background:SetDesaturated(true)
	header.Background:SetVertexColor(r, g, b)
end

function module:SetObjectiveFrame()
	-- if db.ObjectiveTracker.HeaderColor then
	-- 	module:SecureHook("ObjectiveTracker_Initialize", function()
	-- 		for i, v in pairs(ObjectiveTrackerFrame.MODULES) do
	-- 			module:ChangeHeaderColor(v.Header, module:RGB(LUI.playerClass))
	-- 		end
	-- 	end)
	-- end
	if db.ObjectiveTracker.ManagePosition then
		-- module:SecureHook("ObjectiveTracker_Update", function()
		-- 	shouldntSetPoint = true
		-- 	ObjectiveTrackerFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", db.ObjectiveTracker.OffsetX, db.ObjectiveTracker.OffsetY)
		-- 	shouldntSetPoint = false
		-- end)
	end
end

-- ####################################################################################################################
-- ##### Module Refresh ###############################################################################################
-- ####################################################################################################################

function module:Refresh()
	module:SetHiddenFrames()
end