--[[
@
@ Project  : 
@
@ Filename : livePoint.lua
@
@ Author   : Task Nagashige
@
@ Date     : 
@
@ Comment  : 
@
]]--

local this = object.new()

this.point = 0

local function listener()
	local self = object.new()

	return self
end

function this.new()
	return listener()
end

function this.init()
	this.point = 0
end

return this
