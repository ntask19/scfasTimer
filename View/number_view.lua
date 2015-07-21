--[[
@
@ Project  : 
@
@ Filename : number_view.lua
@
@ Author   : Task Nagashige
@
@ Date     : 
@
@ Comment  : 
@
]]--

local _M = {}

local numberImage = {}
numberImage[0] = ImgDir .. 'number/0.png'
numberImage[1] = ImgDir .. 'number/1.png'
numberImage[2] = ImgDir .. 'number/2.png'
numberImage[3] = ImgDir .. 'number/3.png'
numberImage[4] = ImgDir .. 'number/4.png'
numberImage[5] = ImgDir .. 'number/5.png'
numberImage[6] = ImgDir .. 'number/6.png'
numberImage[7] = ImgDir .. 'number/7.png'
numberImage[8] = ImgDir .. 'number/8.png'
numberImage[9] = ImgDir .. 'number/9.png'

function _M.displayPoint( value )
	local group = display.newGroup()
	local num3 = math.floor( value * 0.01 )
	local num2 = math.floor( ( value * 0.1 ) % 10 )
	local num1 = math.floor( value % 10 )

	if num3 ~= 0 then
		local numImage1 = display.newImage( numberImage[num1], 80, 0 )
		local numImage2 = display.newImage( numberImage[num2], 0, 0 )
		local numImage3 = display.newImage( numberImage[num3], -60, 0 )
		group:insert( numImage1 )
		group:insert( numImage2 )
		group:insert( numImage3 )

	elseif num2 ~= 0 then
		local numImage1 = display.newImage( numberImage[num1], 30, 0 )
		local numImage2 = display.newImage( numberImage[num2], -30, 0 )
		group:insert( numImage1 )
		group:insert( numImage2 )

	else
		local numImage1 = display.newImage( numberImage[num1] )
		group:insert( numImage1 )

	end
	
	return group
end

function _M.displayTimer( value )


end
return _M