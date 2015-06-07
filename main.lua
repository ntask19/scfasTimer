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

require 'Module.ntconfig'

local image = display.newImage( 'Default-568h@2x.png', _W*0.5, _H*0.5 )

timer.performWithDelay( 500, function() require( contDir .. 'index' ) end )