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
local number_view = require( ViewDir .. 'number_view' )

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

	this.bg = display.newRect( 0, 0, _W, _H )
	-- this.bg:setFillColor( 248, 181, 0 )
	this.bg:setFillColor( 255, 0, 153 )

	this.maxLivePointTitle = display.newImage( ImgDir .. 'btn/target.png' )
	this.maxLivePointTitle.x, this.maxLivePointTitle.y =  _W*0.5, 150
	
	this.maxLivePointBtn = display.newRect( 0, 0, 300, 100 )
	this.maxLivePointBtn.x, this.maxLivePointBtn.y =  _W*0.5, 230
	this.maxLivePointBtn.isVisible = false
	this.maxLivePointBtn.isHitTestable = true

	-- this.maxLivePointText = number_view.displayPoint( 0 )
	-- this.maxLivePointText:scale( 0.8, 0.8 )
	-- this.maxLivePointText:setReferencePoint( display.CenterReferencePoint )
	-- this.maxLivePointText.x, this.maxLivePointText.y =  this.maxLivePointBtn.x, this.maxLivePointBtn.y

	this.maxLivePointText = native.newTextField( 0, 0, 100, 80 )
	this.maxLivePointText.inputType = "number"
	this.maxLivePointText.x, this.maxLivePointText.y =  this.maxLivePointBtn.x, this.maxLivePointBtn.y
	this.maxLivePointText.text = livePoint.target_point or 50
	this.maxLivePointText.type = 'target'
	-- this.maxLivePointText.hasBackground = false
	
	this.currentLivePointTitle = display.newImage( ImgDir .. 'btn/now.png' )
	this.currentLivePointTitle.x, this.currentLivePointTitle.y = _W*0.5, 330
	
	this.currentLivePointBtn = display.newRect( 0, 0, 300, 100 )
	this.currentLivePointBtn.x, this.currentLivePointBtn.y = _W*0.5, 410
	this.currentLivePointBtn.isVisible = false
	this.currentLivePointBtn.isHitTestable = true

	-- this.currentLivePointText = number_view.displayPoint( 0 )
	-- this.currentLivePointText:scale( 0.8, 0.8 )
	-- this.currentLivePointText:setReferencePoint( display.CenterReferencePoint )
	-- this.currentLivePointText.x, this.currentLivePointText.y = this.currentLivePointBtn.x, this.currentLivePointBtn.y
	
	this.currentLivePointText = native.newTextField( 0, 0, 100, 80 )
	this.currentLivePointText.inputType = "number"
	this.currentLivePointText.x, this.currentLivePointText.y = this.currentLivePointBtn.x, this.currentLivePointBtn.y
	this.currentLivePointText.text = livePoint.current_point or 0
	this.currentLivePointText.type = 'current'
	-- this.currentLivePointText.hasBackground = false

	this.timerText = display.newText( '0:00', 0, 0, nil, 60 )
	this.timerText.x, this.timerText.y = _W*0.5, 510

	this.startBtn = display.newImage( ImgDir .. 'btn/start.png' )
	this.startBtn.x, this.startBtn.y = _W*0.5-150, 650
	this.startBtn.type = 'start'
	
	this.stopBtn = display.newImage( ImgDir .. 'btn/stop.png' )
	this.stopBtn.x, this.stopBtn.y = _W*0.5+150, 650
	this.stopBtn.type = 'stop'

	local options = 
	{
	    text = 'NOT COMPLETED',
	    x = 0,
	    y = 0,
	    width = _W-100,
	    font = nil,
	    fontSize = 50,
	    align = 'center' 
	}
	this.dateText = display.newText( options )
	this.dateText.x, this.dateText.y = _W*0.5, 800
	this.dateText.isVisible = false

	this.bg:addEventListener( 'tap', returnTrue )
	this.bg:addEventListener( 'touch', returnTrue )
	this.startBtn:addEventListener( 'touch', this.btnTouchListener )
	this.stopBtn:addEventListener( 'touch', this.btnTouchListener )
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

function this.btnTapListener( e )
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
