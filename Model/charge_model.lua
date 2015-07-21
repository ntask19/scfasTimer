--[[
@
@ Project  : 
@
@ Filename : charge_model.lua
@
@ Author   : Task Nagashige
@
@ Date     : 
@
@ Comment  : 
@
]]--

local this = object.new()
this.event = nil


local recoverTime = 360
if __isDebug then
	recoverTime = 10
end

local function startTimerListener( e )
	this.event = e
	local count = e.count
	
	local event = 
	{
		name = 'charge_model-startTimerListener-counting',
		time = count
	}
	this:dispatchEvent( event )
	if count % recoverTime == 0 then
		livePoint.current_point = livePoint.current_point + 1
		local event = 
		{
			name = 'charge_model-startTimerListener-update',
		}
		this:dispatchEvent( event )
	end

	if livePoint.current_point >= livePoint.target_point then
		timer.cancel( e.source )
		local event = 
		{
			name = 'charge_model-startTimerListener-finish',
		}
		this:dispatchEvent( event )
	end
end

function this.startTimer()
	if this.event == nil then
		timer.performWithDelay( 1000, startTimerListener, 0 )
	end
end


function this.stopTimer()
	if this.event and this.event.source then
		timer.cancel( this.event.source )
		this.event = nil
	end
end


function this.init()
end

return this
