--[[
@
@ Project  : ditch_boyfriend
@
@ Filename : charge_view.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2015-06-23
@
@ Comment  : 
@
]]--

-- require Model
local charge_model = require( ModelDir .. 'charge_model' )

-- require View
local popup_view = require( ViewDir .. 'popup_view' )

local this = object.new()
this.group = nil


function this.updateTimer( value )
	print( value )
	this.timerText.text = changeSeconds( value )
	this.timerText.x = _W*0.5
end

function this.updatePoint()
	local num = tonumber( this.currentLivePointText.text ) + 1
	this.currentLivePointText.text = num
end

function this.updateDate( str )
	if str then
		this.dateText.text = '回復時刻\n' .. str
		this.dateText.isVisible = true
	else
		this.dateText.isVisible = false
	end
end

function this.create()

	this.group = display.newGroup()

	local color_table = { 248, 181, 0 }
	
	if __isPremium then
		color_table = { 242, 159, 197 }
	end
	this.bg = display.newRect( 0, 0, _W, _H )
	this.bg:setFillColor( color_table[1], color_table[2], color_table[3] )
	-- this.bg:setFillColor( 255, 0, 153 )

	-- this.maxLivePointTitle = display.newImage( ImgDir .. 'btn/target.png' )
	this.maxLivePointTitle = display.newText( '目標のLP', 0, 0, __motoyama, 60 )
	this.maxLivePointTitle.x, this.maxLivePointTitle.y =  _W*0.5, 150
	
	this.maxLivePointBtn = display.newRect( 0, 0, 300, 100 )
	this.maxLivePointBtn.x, this.maxLivePointBtn.y =  _W*0.5, 230
	this.maxLivePointBtn.isVisible = false
	this.maxLivePointBtn.isHitTestable = true

	this.maxLivePointText = native.newTextField( 0, 0, 120, 80 )
	this.maxLivePointText.inputType = "number"
	this.maxLivePointText.x, this.maxLivePointText.y =  this.maxLivePointBtn.x, this.maxLivePointBtn.y
	this.maxLivePointText.text = livePoint.target_point or 50 
	this.maxLivePointText.type = 'target'
	this.maxLivePointText.align = 'center'
	this.maxLivePointText.font = native.newFont( __motoyama, 60 )
	this.maxLivePointText:setTextColor( 50 )
	
	-- this.currentLivePointTitle = display.newImage( ImgDir .. 'btn/now.png' )
	this.currentLivePointTitle = display.newText( '現在のLP', 0, 0, __motoyama, 60 )
	this.currentLivePointTitle.x, this.currentLivePointTitle.y = _W*0.5, 330
	
	this.currentLivePointBtn = display.newRect( 0, 0, 300, 100 )
	this.currentLivePointBtn.x, this.currentLivePointBtn.y = _W*0.5, 410
	this.currentLivePointBtn.isVisible = false
	this.currentLivePointBtn.isHitTestable = true
	
	this.currentLivePointText = native.newTextField( 0, 0, 120, 80 )
	this.currentLivePointText.inputType = "number"
	this.currentLivePointText.x, this.currentLivePointText.y = this.currentLivePointBtn.x, this.currentLivePointBtn.y
	this.currentLivePointText.text = livePoint.current_point or 0
	this.currentLivePointText.type = 'current'
	this.currentLivePointText.align = 'center'
	this.currentLivePointText.font = native.newFont( __motoyama, 60 )
	this.currentLivePointText:setTextColor( 50 )

	this.timerText = display.newText( '0:00', 0, 0, __motoyama, 60 )
	this.timerText.x, this.timerText.y = _W*0.5, 510

	-- this.startBtn = display.newImage( ImgDir .. 'btn/start.png' )
	this.startBtn = widget.newButton
	{
	    onEvent = this.handleButtonEvent,
	    emboss = false,
	    shape = "roundedRect",
	    width = 200,
	    height = 100,
	    cornerRadius = 10,
	    fillColor = { default={ 255 }, over={ 200 } },
	    label = 'START',
		labelColor = { default={ color_table[1], color_table[2], color_table[3] }, over={ color_table[1]+10, color_table[2]+10, color_table[3]+10 } },
	    fontSize = 50,
	    font = __motoyama,
	}
	this.startBtn.x, this.startBtn.y = _W*0.5-150, 650
	this.startBtn.type = 'start'
	
	-- this.stopBtn = display.newImage( ImgDir .. 'btn/stop.png' )
	this.stopBtn = widget.newButton
	{
	    onEvent = this.handleButtonEvent,
	    emboss = false,
	    shape = "roundedRect",
	    width = 200,
	    height = 100,
	    cornerRadius = 10,
	    fillColor = { default={ 255 }, over={ 200 } },
	    label = 'STOP',
		labelColor = { default={ color_table[1], color_table[2], color_table[3] }, over={ color_table[1]+10, color_table[2]+10, color_table[3]+10 } },
	    fontSize = 50,
	    font = __motoyama,
	}
	this.stopBtn.x, this.stopBtn.y = _W*0.5+150, 650
	this.stopBtn.type = 'stop'

	local options = 
	{
	    text = 'NOT COMPLETED',
	    x = 0,
	    y = 0,
	    width = _W-100,
	    font = __motoyama,
	    fontSize = 50,
	    align = 'center' 
	}
	this.dateText = display.newText( options )
	this.dateText.x, this.dateText.y = _W*0.5, 800
	this.dateText.isVisible = false

	this.bg:addEventListener( 'tap', returnTrue )
	this.bg:addEventListener( 'touch', returnTrue )
	this.maxLivePointText:addEventListener( 'userInput', this.inputListener )
	this.currentLivePointText:addEventListener( 'userInput', this.inputListener )

	this.group:insert( this.bg )
	this.group:insert( this.maxLivePointTitle )
	this.group:insert( this.maxLivePointBtn )
	this.group:insert( this.maxLivePointText )
	this.group:insert( this.currentLivePointTitle )
	this.group:insert( this.currentLivePointBtn )
	this.group:insert( this.currentLivePointBtn )
	this.group:insert( this.timerText )
	this.group:insert( this.startBtn )
	this.group:insert( this.stopBtn )
	this.group:insert( this.dateText )

end


function this.closeReviewPopup()
	if this.reviewPopupGroup then
		local function remove()
			display.remove( this.reviewPopupGroup )
			this.reviewPopupGroup = nil
		end
		transition.to( this.reviewPopupGroup, { time = 500, alpha = 0, transition = easing.outBack, onComplete = remove } )
	end
end

function this.inputListener( e )
	local event = 
	{
		name  = 'charge_view-textBox-input',
		type  = e.target.type,
		event = e,
	}
	this:dispatchEvent( event )
end

function this.handleButtonEvent( e )
    if 'ended' == e.phase then
    	this.btnTapListener( e )
    end
end

function this.btnTapListener( e )
	sound.play( sound.push )
	local event = 
	{
		name = 'charge_view-btn-tap',
		type = e.target.type, 
	}
	this:dispatchEvent( event )
end

function this.btnTouchListener( e )
	local phase = e.phase
	local target = e.target

	if 'began' == phase then
		target.isFocus = true
		target:setFillColor( 200 )
		timer.performWithDelay( 230,
			function() 
				if pcall(function()
						if target then
							target:setFillColor(255) 
						else 
							display.remove( target )
							target = nil
						end
					end) then
				else
					display.remove( target )
					target = nil
				end
			end
		)
	elseif target.isFocus then
		if 'ended' == phase then
			target.isFocus = false
			local event = 
			{
				name  = 'charge_view-btnTouchListener-finish',
				type  = target.type
			}
			this:dispatchEvent( event )

		elseif 'cancelled' == phase then
			target.isFocus = false
		end
	else


	end
end

function this.destroy()
	if this.group then
		display.remove( this.group )
		this.group = nil
	end
end

function this.modelHundler( event )
	if event.name == 'charge_model-startTimerListener-finish' then
	end
end
charge_model:addEventListener( this.modelHundler )

return this
