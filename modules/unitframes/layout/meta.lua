--[[
	Project....: LUI NextGenWoWUserInterface
	File.......: meta.lua
	Description: oUF Meta Functions
]]

local addonname, LUI = ...
local module = LUI:GetModule("Unitframes")
local oUF = LUI.oUF

local function FormatName(self)
	if not self or not self.Info then return end

	local info = self.Info

	local name
	if info.Length == "Long" then
		name = "[NameLong]"
	elseif info.Length == "Short" then
		name = "[NameShort]"
	else
		name = "[NameMedium]"
	end

	if info.ColorNameByClass then name = "[GetNameColor]"..name.."|r" end

	local level = info.ColorLevelByDifficulty and "[DiffColor][level]|r" or "[level]"

	if info.ShowClassification then
		level = info.ShortClassification and level.."[shortclassification]" or level.."[classification]"
	end

	local race = "[race]"

	local class = info.ColorClassByClass and "[GetNameColor][smartclass]|r" or "[smartclass]"

	self:Tag(info, info.Format:gsub(" %+ ", " "):gsub("Name", name):gsub("Level", level):gsub("Race", race):gsub("Class", class))
	self:UpdateAllElements('refreshUnit')
end
oUF:RegisterMetaFunction("FormatName", FormatName)

local function FormatRaidName(self)
	if not self or not self.Info then return end

	local info = self.Info

	local index = self:GetParent():GetParent():GetName() == "oUF_LUI_raid_25" and 1 or 2
	local tag = self:GetParent():GetParent():GetName() == "oUF_LUI_raid_25" and "[RaidName25]" or "[RaidName40]"

	if info.ColorByClass then tag = "[GetNameColor]"..tag.."|r" end

	self:Tag(info, tag)
	self:UpdateAllElements('refreshUnit')
end
oUF:RegisterMetaFunction("FormatRaidName", FormatRaidName)
