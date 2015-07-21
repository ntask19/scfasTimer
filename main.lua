--[[
@
@ Project  : 
@
@ Filename : main.lua
@
@ Author   : Task Nagashige
@
@ Date     : 
@
@ Comment  : 
@
]]--

__isDebug = false
-- Your code here

require 'Module.main_config'

analytics = require( PluginDir .. 'analytics.analytics' )
notifications = require 'plugin.notifications'
livePoint = require( ContDir .. 'livePoint' )
livePoint.readPoint()
livePoint.UpdatePointFromCache()

local charge = require( ContDir .. 'charge' )
charge:createScene()
