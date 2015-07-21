--[[
@
@ Project  : ditch_boyfriend
@
@ Filename : popup_view.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2015-06-23
@
@ Comment  : 
@
]]--

local this = object.new()
local blackBack
local customOption = {
	width = _W-200,
	height = 240,
	x = 0,
	y = 0,
	background = false
}

function this.show( option )
	local o = option or customOption
	-----------------
	-- type       :
	-- width      : 
	-- height     :
	-- x          :
	-- y          :
	-----------------

	local width  = o.width or _W-200
	local height = o.height or 240
	local x = o.x or _W*0.5
	local y = o.y or _H*0.5
	local size = o.size or 32
	local icon

	local group = display.newGroup()

	local blackBack = createBlackFilter(0, 0,_W, _H, group,{255,255,255,0})


	local background = display.newRoundedRect( group, 0, 0, 300, 200, 10 )
	background:setFillColor( 0, 200 )
	background.x, background.y = x,y

	background:addEventListener( "tap", returnTrue )
	background:addEventListener( "touch", returnTrue )

	local messageTemp, messageTempSub, iconTemp
	local top, center, bottom = nil, nil, nil
	local topMsg, bottomMsg, msg1, msg2 = nil, nil, nil, nil

	if o.top == 1 then
		top = 1
	end

	if o.center == 1 then
		center = 1
	end

	if o.bottom == 1 then
		bottom = 1
	end

	if o.type ~= nil then
		if o.type == 'center' then
			-- 自由入力
			messageTemp = o.text
			center=1
		elseif o.type == 35 then
			messageTemp = o.text
			messageTempSub = o.subText
			center = 1
		elseif o.type == 45 then
			messageTemp = o.text
			msg1 = o.tText
			msg2 = o.bText
			top=1
		elseif o.type == 0 then
			messageTemp = o.text
			iconTemp = o.image
		end

		if iconTemp then
			icon = display.newImage(group,iconTemp,0,0)
			icon.x,icon.y = background.x, background.y-30
		end

		local message = display.newText(group,messageTemp,0,0, native.systemFontBold, size)
		
		if o.type == 0 then
			display.remove(message);
			message = display.newText( group, messageTemp, 0, 0, native.systemFontBold, 32)
		end


		if o.type == 45 then
			topMsg = display.newText( group, msg1, 0, 0, native.systemFontBold, size )
			topMsg.x, topMsg.y = background.x, background.y - 45
			bottomMsg = display.newText( group, msg2, 0, 0, native.systemFontBold, size )
			bottomMsg.x, bottomMsg.y = background.x, background.y + 45
		end

		message.x, message.y = background.x, background.y+55

		if top == 1 then
			message.y = background.y
			if icon then
				icon.alpha = 0
			end
		end
		if center == 1 then
			message.y = background.y
			if icon then
				icon.alpha = 0
			end
		end
		if messageTempSub then
			message.y = background.y - 18
			bottomMsg = display.newText( group, messageTempSub, 0, 0, native.systemFontBold, size )
			bottomMsg.x, bottomMsg.y = background.x, background.y + 38
		end
	end

	group.alpha = 0
	transition.to( group, { time = 200, alpha = 1, onComplete =
		function()
			timer.performWithDelay( o.duration or 1000, 
				function()
					this.close(group)
					if o.action then
						o.action()
					end
				end
			)
		end
	})

	return group
end

function this.create( option )
	local o = option or customOption
	-----------------
	-- width      : 
	-- height     :
	-- x          :
	-- y          :
	-- background : 黒背景（デフォルト：true）
	-- close      : 
	-----------------

	local width  = o.width or _W-100
	local height = o.height or 300
	local x = o.x or 0
	local y = o.y or 0
	local close = o.close or 0

	local group = display.newGroup()

	--黒の背景画像
	if o.background then
		local blackBack = createBlackFilter(0, 0,_W, _H, group)
	end

	local background = display.newRoundedRect(0, 0, width*10, height*10, 2*10 ) -- 4*10
	background:scale(0.1, 0.1)
	background.x, background.y = x,y -- o.x ,o.y
	group:insert(background)
	background:setFillColor(255)

	background:addEventListener( "tap", returnTrue )
	background:addEventListener( "touch", returnTrue )

	if close == 1 then
		local closeBtn = btn.newRect{
			x = 0,
			y = 0,
			width = 490,
			height = 65,
			str = o.str or '',
			fontSize = 27,
			fontColor = {255,255,255},
			color = { 210, 157, 70 },
			rounded = 10,
			action = o.action,
		}
		closeBtn.x = -245; closeBtn.y = 70;
		group:insert(closeBtn)
	end

	group.alpha = 0
	transition.to( group, { time = 200, alpha = 1, onComplete=
		function()
			if o.action then o.action() end
		end
	})

	return group
end

function this.close(group, action)
	transition.to( group, { time = 200, alpha = 0, onComplete =
		function()
			if group and group ~= nil then
				display.remove( group )
				group = nil
			end

			if action then action() end
		end
	})
end

return this
