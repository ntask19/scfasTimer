-- --[[
-- @
-- @ Project  : 
-- @
-- @ Filename : index.lua
-- @
-- @ Author   : Task Nagashige
-- @
-- @ Date     : 
-- @
-- @ Comment  : 
-- @
-- ]]--

-- -- local this = object.new()


-- -- -- modelのハンドラー
-- -- function this.modelHundler(event)
-- -- 	if event.name == '' then
-- -- 	end
-- -- end

-- -- -- viewのハンドラー
-- -- function this.viewHundler(event)

-- -- end

-- -- function this:createScene()
-- -- 	local group = this.view

-- -- end

-- -- function this:exitScene( event )

-- -- end

-- -- return this

-- local LP = require( ContDir .. 'livePoint' )
-- local LPnotify = require( ContDir .. 'notifications' )

-- local recoverTime = 60
-- if __isDebug then
-- 	recoverTime = 10
-- end

-- local userLivePointData = {}
-- local livePointEventListener, developLog

-- -- -- メモリーリーク
-- local prevTime = system.getTimer()
-- userLivePointData.prevTime = prevTime

-- local prevTime2 = system.getTimer()
-- userLivePointData.prevTime2 = prevTime2

-- local background = display.newRect( _W*0.5, _H*0.5, _W, _H )
-- background:setFillColor( 248/255, 181/255, 0 )


-- -- Set up the picker column data
-- local maxLivePointArray = {}
-- local currentLivePointArray = {}
-- for i = 1, 400 do 
-- 	maxLivePointArray[i] = i 
-- end

-- for j = 0, 400 do 
-- 	currentLivePointArray[j] = j 
-- end

-- local maxLivePointData = { 
-- 	{
-- 		align = "center",
-- 		width = 320,
-- 		startIndex = 50,
-- 		labels = maxLivePointArray
-- 	},
-- }
	
-- -- Create a new Picker Wheel
-- local maxLivePointWheel = widget.newPickerWheel {
-- 	-- top = 20,
-- 	-- x = 0,
-- 	-- y = _H-200,
-- 	columns = maxLivePointData,
-- 	fontSize = 30,
-- }
-- maxLivePointWheel.x, maxLivePointWheel.y = _W*0.5, _H-200
-- maxLivePointWheel.isVisible = false

-- local currentLivePointData = { 
-- 	{
-- 		align = "center",
-- 		width = 320,
-- 		startIndex = 1,
-- 		labels = currentLivePointArray
-- 	},
-- }
	
-- -- Create a new Picker Wheel
-- local currentLivePointWheel = widget.newPickerWheel {
-- 	-- top = 20,
-- 	columns = currentLivePointData,
-- 	fontSize = 30,
-- }
-- currentLivePointWheel.x, currentLivePointWheel.y = _W*0.5, _H-200
-- currentLivePointWheel.isVisible = false

-- local function maxLivePointRectTapListener( event )
-- 	maxLivePointWheel.isVisible = true
-- 	currentLivePointWheel.isVisible = false
-- 	Runtime:addEventListener( 'enterFrame', developLog )
-- 	return true
-- end

-- local function currentLivePointRectTapListener( event )
-- 	maxLivePointWheel.isVisible = false
-- 	currentLivePointWheel.isVisible = true
-- 	Runtime:addEventListener( 'enterFrame', developLog )
-- 	return true
-- end

-- local function startBtnTapListener( event )
-- 	onAction()
-- 	LPnotify.set( userLivePointData.diffTime )
-- 	Runtime:addEventListener( 'enterFrame', livePointEventListener )
-- 	Runtime:removeEventListener( 'enterFrame', developLog )
-- end

-- local function stopBtnTapListener( event )
-- 	LPnotify.remove()
-- 	LP.stopPoint()
-- 	Runtime:removeEventListener( 'enterFrame', livePointEventListener )
-- end

-- local maxLivePointTitle = display.newText( '目標のLP', _W*0.5, 150, nil, 60 )

-- local maxLivePointText = display.newText( '0', _W*0.5, 230, nil, 60 )
-- maxLivePointText.point = 0

-- local maxLivePointRect = display.newRect( _W*0.5, 230, 300, 100 )
-- maxLivePointRect.isVisible = false
-- maxLivePointRect.isHitTestable = true
-- maxLivePointRect:addEventListener( 'tap', maxLivePointRectTapListener )

-- local currentLivePointTitle = display.newText( '現在のLP', _W*0.5, 330, nil, 60 )

-- local currentLivePointRect = display.newRect( _W*0.5, 410, 300, 100 )
-- currentLivePointRect.isVisible = false
-- currentLivePointRect.isHitTestable = true
-- currentLivePointRect:addEventListener( 'tap', currentLivePointRectTapListener )

-- local currentLivePointText = display.newText( '0', _W*0.5, 410, nil, 60 )
-- currentLivePointText.point = 0

-- local startBtn = display.newRect( _W*0.5-150, 650, 200, 100 )
-- startBtn.action = startBtnTapListener

-- local startText = display.newText( 'START', _W*0.5-150, 650, nil, 50 )
-- startText:setFillColor( 100/255 )

-- local stopBtn = display.newRect( _W*0.5+150, 650, 200, 100 )
-- stopBtn:addEventListener( 'tap', stopBtnTapListener )

-- local stopText = display.newText( 'STOP', _W*0.5+150, 650, nil, 50 )
-- stopText:setFillColor( 100/255 )

-- local timerText = display.newText( '0:00', 0, 0, nil, 60 )
-- timerText.timer = 0
-- timerText.x, timerText.y = _W*0.5, 510



-- -- -- textureMemoryUsed
-- -- local textMemTitle = display.newText( 'textureMemory', 0, 60, nil, 24 )
-- -- textMemTitle.x = _W-80
-- -- textMemTitle:setFillColor( 255, 0, 0, 100 )
-- -- local textMemText = display.newText( '0.00', 0, 90, nil, 24 )
-- -- textMemText.x = _W-80
-- -- textMemText:setFillColor( 255, 0, 0, 100 )

-- -- local memoryTitle = display.newText( 'totalMemory', 0, 120, nil, 24 )
-- -- memoryTitle.x = _W-80
-- -- memoryTitle:setFillColor( 255, 0, 0, 100 )
-- -- local memoryText = display.newText( '0.00', 0, 150, nil, 24 )
-- -- memoryText.x = _W-80
-- -- memoryText:setFillColor( 255, 0, 0, 100 )

-- -- -- fps
-- -- local fpsTitle = display.newText( 'fps', 0, 180, nil, 24 )
-- -- fpsTitle.x = _W-80
-- -- fpsTitle:setFillColor( 255, 0, 0, 100 )
-- -- local fps = display.newText( '00.00', 0, 210, nil, 24 )
-- -- fps.x = _W-80
-- -- fps:setFillColor( 255, 0, 0, 100 )


-- -- -- displayObjectNum
-- -- local displayObjTitle = display.newText( 'numChildren', 0, 240, nil, 24 )
-- -- displayObjTitle.x = _W-80
-- -- displayObjTitle:setFillColor( 255, 0, 0, 100 )
-- -- local displayObjText = display.newText( '0', 0, 270, nil, 24 )
-- -- displayObjText.x = _W-80
-- -- displayObjText:setFillColor( 255, 0, 0, 100 )


-- function developLog( event )
-- 	local curTime = event.time
-- 	local dt = curTime - prevTime
-- 	prevTime = curTime

--     collectgarbage()

-- 	if (curTime - userLivePointData.prevTime ) > 100 then
-- 		-- memoryText.text = tostring( collectgarbage('count') )
-- 		userLivePointData.prevTime = curTime

-- 		local maxLivePointWheelValues = maxLivePointWheel:getValues()
-- 		local currentLivePointWheelValues = currentLivePointWheel:getValues()

-- 		maxLivePointText.point = maxLivePointWheelValues[1].value or 0
-- 		currentLivePointText.point = currentLivePointWheelValues[1].value or 0

-- 		print(maxLivePointWheelValues[1].value)
		
-- 		maxLivePointText.text = maxLivePointText.point
-- 		currentLivePointText.text = currentLivePointText.point

-- 		if textMemText then
-- 			textMemText.text = tostring( system.getInfo( 'textureMemoryUsed' ) / 1000000 )
-- 		end

-- 		if displayObjText then
-- 			displayObjText.text = tostring( display.getCurrentStage().numChildren )
-- 		end


-- 		if fps then
-- 			fps.text = string.format( '%.2f', 1000 / dt )
-- 		end
-- 	end
-- end

-- function checkPushNum()
-- 	print(maxLivePointText.point, currentLivePointText.point)
-- 	if tonumber( maxLivePointText.point ) > tonumber( currentLivePointText.point ) then
-- 		local diffPoint = math.floor( maxLivePointText.point - currentLivePointText.point )
-- 		print(diffPoint)
-- 		local diffTime = recoverTime*diffPoint*10
-- 		print(diffTime)
-- 		return diffTime
-- 	end
-- end

-- function livePointEventListener( event )
-- 	local curTime2 = event.time
-- 	local dt = curTime2 - prevTime2
-- 	prevTime2 = curTime2

-- 	if (curTime2 - userLivePointData.prevTime2) > 100 then
-- 		userLivePointData.prevTime2 = curTime2

-- 		timerText.timer = timerText.timer - 1
-- 		local timerTextNum = math.floor(timerText.timer*0.1)
-- 		local dateText = changeSeconds(timerTextNum)
-- 		timerText.text = dateText

-- 		if timerTextNum%recoverTime == 0 then
-- 			local beforePoint = tonumber(currentLivePointText.text)
-- 			currentLivePointText.point = currentLivePointText.point + 1 
-- 			local currentLivePoint = math.floor(currentLivePointText.point*0.1)
-- 			currentLivePointText.text = currentLivePoint
-- 			if tonumber( currentLivePointText.point ) > tonumber( maxLivePointText.point ) then
-- 				Runtime:removeEventListener( 'enterFrame', livePointEventListener )
-- 			end
-- 		end

-- 	end

-- end

-- onAction = function()
-- 	LP.current_point = currentLivePointText.point
-- 	LP.target_point = maxLivePointText.point
-- 	LP.savePoint()
-- 	userLivePointData.diffTime = checkPushNum() or 0
-- 	timerText.timer = userLivePointData.diffTime
-- end


-- local res = LP.readPoint()
-- if res == 0 then
-- 	LP.UpdatePointFromCache()
-- 	if LP.current_point ~= 0 and LP.target_point ~= 0 and LP.current_point < LP.target_point then
-- 		Runtime:addEventListener( 'enterFrame', livePointEventListener )
-- 		currentLivePointText.point = LP.current_point
-- 		maxLivePointText.point = LP.target_point
-- 		-- LP.savePoint()
-- 		userLivePointData.diffTime = checkPushNum() or 0
-- 		timerText.timer = userLivePointData.diffTime
-- 		maxLivePointText.text = maxLivePointText.point
-- 		currentLivePointText.text = currentLivePointText.point
-- 	end
-- end