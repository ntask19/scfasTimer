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
	if event.name == 'charge_view-btnTouchListener-finish' then
		
		if event.type == 'start' then
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
		    print( event.event.text )

		elseif event.event.phase == 'ended' then
		    print( event.event.target.text )
			livePoint.setPoint( event.event.target.text, event.type )
			livePoint.getDiffTime()
			charge_view.updateTimer( livePoint.diffTime )
		    native.setKeyboardFocus( nil )

		elseif event.event.phase == 'editing' then
		    print( event.event.newCharacters )
		    print( event.event.oldText )
		    print( event.event.startPosition )
		    print( event.event.text )
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
		popup_view.show( { type = 'center', text = 'LPが回復しました' } )

	elseif event.name == 'notifications-set-finish' then
		charge_view.updateDate( event.time )

	end
end

function this:createScene()
	local group = this.view

	charge_view:addEventListener( eventHandler )
	charge_model:addEventListener( eventHandler )
	notifications:addEventListener( eventHandler )
	
	this.view = charge_view
	this.view.create()
	-- this.view.changeStatus()
	
end

function this:exitScene( event )

	charge_view:removeEventListener( eventHandler )
	charge_model:removeEventListener( eventHandler )
	notifications:removeEventListener( eventHandler )

end

return this
