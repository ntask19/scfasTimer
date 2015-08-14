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
__isPremium = false
-- Your code here

require 'Module.main_config'

local analytics = require('analytics')

-------------------------------
-- FlurryサイトよりAPI Keyを取得
-------------------------------
local app_key = nil
if system.getInfo( 'platformName' ) == 'Android' then
    if __isPremium then
        app_key = 'QBT847YSZZCDTJJ93XSQ'
    else
        app_key = 'K3DZJ5KZX849CQ8B4KYK'
    end
elseif system.getInfo( 'platformName' ) == 'iPhone OS' then
    app_key = ''
end
analytics.init(app_key)

playerInfo = require( ContDir .. 'playerInfo' )
playerInfo.init()
print( playerInfoData )

sound = require( ContDir .. 'sound' )
notifications = require 'plugin.notifications'
livePoint = require( ContDir .. 'livePoint' )
livePoint.readPoint()
livePoint.UpdatePointFromCache()



--------------------------------------------------
-- 無料版・有料版への誘導
--------------------------------------------------

local function storeEventHandler( event )
   if event.action == 'clicked' then
        local i = event.index
        if i == 1 then
            -- Do nothing; dialog will simply dismiss
        elseif i == 2 then
            -- Open URL if 'Learn More' (second button) was clicked

            local package_name = 'com.ntask19.scfas.premium'
            if __isPremium then
                package_name = 'com.ntask19.scfas'
            end
            local option = 
            {
                androidAppPackageName = package_name,
                supportedAndroidStores = { 'google' }
            }
            native.showPopup( 'appStore', option )
        end
    end
end

local review_nonce = math.random(100)
if false then -- review_nonce%10 == 1 then
    -- Show alert with two buttons
    local message = '広告のない有料版もあります。よろしければそちらをDLしませんか？'
    if __isPremium then
        message = 'ご購入ありがとうございます！ただ、広告の出る無料版もあるので今のアプリを返品して無料版に切り替えることもできますよ！'
    end
    local alert = native.showAlert( '開発者からお知らせ', message, { 'ｵｺﾄﾜﾘｼﾏｽ!!', 'ハラショー!!DLしてあげる' }, storeEventHandler )
end

local charge = require( ContDir .. 'charge' )
charge:createScene()