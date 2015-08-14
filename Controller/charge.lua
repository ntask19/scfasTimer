--[[
@
@ Project  : 
@
@ Filename : charge.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2015-07-11
@
@ Comment  : 
@
]]--

local this = object.new()

-- require Model
local charge_model = require( ModelDir .. 'charge_model' )

-- require View
local charge_view = require( ViewDir .. 'charge_view' )
local popup_view = require( ViewDir .. 'popup_view')

local notifications = require( ContDir .. 'notifications' )

local function eventHandler( event )
	
	print( json.encode( event ) )
	-- ボタンをタップした時
	if event.name == 'charge_view-btn-tap' then
		
		if event.type == 'start' then
			playerInfo.set( 'current_point', livePoint.current_point )
			playerInfo.set( 'target_point', livePoint.target_point )
			livePoint.getDiffTime()
			livePoint.savePoint()
			charge_model.startTimer()
			notifications.set( livePoint.diffTime )

		elseif event.type == 'stop' then
			livePoint.stopPoint()
			charge_model.stopTimer()
			charge_view.updateDate( nil )
			notifications.remove()

		end

	elseif event.name == 'charge_view-textBox-input' then
		if event.event.phase == 'began' then
			livePoint.stopPoint()
			charge_model.stopTimer()
			charge_view.updateDate( nil )
			notifications.remove()

		elseif event.event.phase == 'ended' then
			livePoint.stopPoint()
			charge_model.stopTimer()
			charge_view.updateDate( nil )
			notifications.remove()
			livePoint.setPoint( event.event.target.text, event.type )
			livePoint.getDiffTime()
			charge_view.updateTimer( livePoint.diffTime )
		    native.setKeyboardFocus( nil )

		elseif event.event.phase == 'editing' then
			livePoint.stopPoint()
			charge_model.stopTimer()
			charge_view.updateDate( nil )
			notifications.remove()
			livePoint.setPoint( event.event.text, event.type )
			livePoint.getDiffTime()
			charge_view.updateTimer( livePoint.diffTime )

		elseif event.event.phase == 'submitted' then
			native.setKeyboardFocus( nil )
			
		end

	elseif event.name == 'charge_model-startTimerListener-counting' then
		local diff_time = livePoint.diffTime - event.time
		charge_view.updateTimer( diff_time )

	elseif event.name == 'charge_model-startTimerListener-update' then
		charge_view.updatePoint()
	
	elseif event.name == 'charge_model-startTimerListener-finish' then
		local alert = native.showAlert( 'LP回復', 'LPが回復しました(・8・)', { 'OK' } )

	elseif event.name == 'notifications-set-finish' then
		charge_view.updateDate( event.time )

	elseif event.name == 'livePoint-readPoint-finish' then
		livePoint.setDiffTime( livePoint.endedTime )
		charge_view.updateDate( event.time )
		charge_model.startTimer()

   elseif event.action == 'clicked' then
        local i = event.index
        if i == 1 then
            -- Do nothing; dialog will simply dismiss
        elseif i == 2 then
            -- Open URL if 'Learn More' (second button) was clicked
            playerInfo.set( 'review', 1 )
            local package_name = 'com.ntask19.scfas'
            if __isPremium then
                package_name = 'com.ntask19.scfas.premium'
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

function this:createScene()
	local group = this.view

	charge_view:addEventListener( eventHandler )
	charge_model:addEventListener( eventHandler )
	notifications:addEventListener( eventHandler )
	livePoint:addEventListener( eventHandler )
	
	this.view = charge_view
	this.view.create()
	livePoint.readPoint()
	-- this.view.changeStatus()

	--------------------------------------------------
	-- 広告の管理
	--------------------------------------------------
	
	if not __isPremium then
	    admob = require 'ads'
	    
	    local interstitial = nil
	    local function adListener( event )
	     	print( json.encode(event) )
	     	if not event.isError then
	    
	    	end
	    end
	    admob.init( 'admob', 'pub-2136596755146345', adListener )
	    admob.show( 'banner', { x = 0, y = _H-100, appId = 'ca-app-pub-2136596755146345/9874021114' } )
	    
	    local nonce = math.random(100)
	    if interstitial == nil and nonce%3 == 0 then
	    	interstitial = admob.show( 'interstitial', { x = _W*0.5, y = _H*0.5, appId = 'ca-app-  	pub-2136596755146345/2350754316' } )
	    end
	end

	--------------------------------------------------
	-- レビュー促し
	--------------------------------------------------
	local review_nonce = math.random(100)
	if review_nonce%10 == 0 and playerInfoData['review'] == 0 then
		-- Show alert with two buttons
		local alert = native.showAlert( 'レビューのお願いﾁｭﾝ(・8・)', 'アプリをもっと良くするために、レビューで☆5をつけて頂けませんか？m(_ _)m', { 'ｵｺﾄﾜﾘｼﾏｽ!!', 'ハラショー!!☆5をつけてあげる' }, eventHandler )
	end
	
end

function this:exitScene( event )

	charge_view:removeEventListener( eventHandler )
	charge_model:removeEventListener( eventHandler )
	notifications:removeEventListener( eventHandler )
	livePoint:removeEventListener( eventHandler )

end

return this
