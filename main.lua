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

__isDebug = true
-- Your code here

require 'ntconfig'

local background = display.newRect( 0, 0, _W, _H )
background:setFillColor( 248, 181, 0 )

local timerText = display.newText( '0:00', 0, 0, nil, 100 )
timerText.timer = 0
timerText.x, timerText.y = _W*0.5, _H*0.5


local lpText = display.newText( '0', 0, 0, nil, 100 )
lpText.point = 0
lpText.x, lpText.y = _W*0.5, _H*0.3

-- -- メモリーリーク
local prevTime = system.getTimer()

-- textureMemoryUsed
local textMemTitle = display.newText( 'textureMemory', 0, 60, nil, 24 )
textMemTitle.x = _W-80
textMemTitle:setFillColor( 255, 0, 0, 100 )
local textMemText = display.newText( '0.00', 0, 90, nil, 24 )
textMemText.x = _W-80
textMemText:setFillColor( 255, 0, 0, 100 )

local memoryTitle = display.newText( 'totalMemory', 0, 120, nil, 24 )
memoryTitle.x = _W-80
memoryTitle:setFillColor( 255, 0, 0, 100 )
local memoryText = display.newText( '0.00', 0, 150, nil, 24 )
memoryText.x = _W-80
memoryText:setFillColor( 255, 0, 0, 100 )
memoryText.prevTime = prevTime

-- fps
local fpsTitle = display.newText( 'fps', 0, 180, nil, 24 )
fpsTitle.x = _W-80
fpsTitle:setFillColor( 255, 0, 0, 100 )
local fps = display.newText( '00.00', 0, 210, nil, 24 )
fps.x = _W-80
fps:setFillColor( 255, 0, 0, 100 )


-- displayObjectNum
local displayObjTitle = display.newText( 'numChildren', 0, 240, nil, 24 )
displayObjTitle.x = _W-80
displayObjTitle:setFillColor( 255, 0, 0, 100 )
local displayObjText = display.newText( '0', 0, 270, nil, 24 )
displayObjText.x = _W-80
displayObjText:setFillColor( 255, 0, 0, 100 )


local function developLog( event )

	local curTime = event.time
	local dt = curTime - prevTime
	prevTime = curTime

    collectgarbage()

	if (curTime - memoryText.prevTime ) > 100 then
		memoryText.text = tostring( collectgarbage('count') )
		memoryText.prevTime = curTime

		if textMemText then
			textMemText.text = tostring( system.getInfo( 'textureMemoryUsed' ) / 1000000 )
		end

		if displayObjText then
			displayObjText.text = tostring( display.getCurrentStage().numChildren )
		end

		timerText.timer = timerText.timer + 1
		local timerTextNum = math.floor(timerText.timer*0.1)
		timerText.text = timerTextNum

		if timerTextNum%10 == 0 then
			local beforePoint = tonumber(lpText.text)
			lpText.point = lpText.point + 1 
			local lpTextNum = math.floor(lpText.point*0.1)
			lpText.text = lpTextNum
			if lpTextNum > beforePoint then
				timerText.timer = 0
				local timerTextNum = math.floor(timerText.timer*0.1)
				timerText.text = timerTextNum
			end
		end

		if fps then
			fps.text = string.format( '%.2f', 1000 / dt )
		end
	end
	

end

Runtime:addEventListener( 'enterFrame', developLog )
