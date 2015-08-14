--[[
@
@ Project  : 
@
@ Filename : sound.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2015-07-11
@
@ Comment  : 
@
]]--

local _M = {}

-- _M.bgm     = audio.loadSound( AudioDir .. 'bgm.mp3' )
_M.push    = audio.loadSound( AudioDir .. 'push.mp3' )

_M.loopPlayer     = nil
_M.pushPlayer     = nil

function _M.loopPlay( src )
	if _M.loopPlayer == nil and src then
		_M.loopPlayer = audio.play( src, { loops = -1 } )
	end
end

function _M.play( audioHandle )
	local channel = audio.play( audioHandle )
	return channel
end

function _M.stop( channel )
	if channel then
		audio.stop( channel )
		channel = nil
	end
end

return _M
