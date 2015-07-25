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

admob = require "ads"

local interstitial = nil
local function adListener( event )
 	print( json.encode(event) )
 	if not event.isError then

	end
end
admob.init( "admob", "pub-2136596755146345", adListener )
admob.show( "banner", { x = 0, y = _H-100, appId = 'ca-app-pub-2136596755146345/9874021114' } )

local nonce = math.random(100)
if interstitial == nil and nonce%4 == 0 then
	interstitial = admob.show( "interstitial", { x = _W*0.5, y = _H*0.5, appId = 'ca-app-pub-2136596755146345/2350754316' } )
end

local function onComplete( event )
   if event.action == "clicked" then
        local i = event.index
        if i == 1 then
            -- Do nothing; dialog will simply dismiss
        elseif i == 2 then
            -- Open URL if "Learn More" (second button) was clicked
			local option = 
			{
            	androidAppPackageName = 'com.ntask19.scfas',
            	supportedAndroidStores = { 'google' }
        	}
        	native.showPopup( 'appStore', option )
        end
    end
end

local review_nonce = math.random(100)
if review_nonce%10 == 0 then
	-- Show alert with two buttons
	local alert = native.showAlert( "レビューのお願い(・8・)", "アプリをもっと良くするために、レビューで☆5をつけて頂けませんか？m(_ _)m", { "ｵｺﾄﾜﾘｼﾏｽ!!", "ハラショー!!☆5をつけてあげる" }, onComplete )
end

local charge = require( ContDir .. 'charge' )
charge:createScene()