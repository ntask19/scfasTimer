--[[
@
@ Project  : 
@
@ Filename : playerInfo.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2015-08-13
@
@ Comment  : 
@
]]--

local this = object.new()
playerInfoData = {}

function this.set( key, value )
	assert( key, 'Fatal error : not found key' )
	assert( value, 'Fatal error : not found value' )
	playerInfoData[key] = value
	
	this.reload()
end

function this.setAll( data )
	assert( data, 'Fatal error : not found data' )
	print( data )

	playerInfoData['target_point']      = data['target_point'] or 50
	playerInfoData['current_point']     = data['current_point'] or 0
	playerInfoData['review']            = data['review'] or 0
	playerInfoData['app_ver']           = data['app_ver'] or __appVer

	this.reload()
end

function this.reload()
	this.save()
	local event = 
	{
		name = 'playerInfo-reload',
		data = playerInfoData
	}
	this:dispatchEvent( event )
end

function this.save()
	if playerInfoData then
		local res = json.encode( playerInfoData )
		if res and res ~= '[]' then
			writeText( 'playerInfo.txt', res )
			return 0
		else
			this.setAll( {} )
		end
	else
		return -1
	end
end

function this.load()
	local res = readText( 'playerInfo.txt' )
	if res then
		local decode_res = json.decode( res )
		if decode_res then
			this.setAll( decode_res )
			return 0
		end
		return -1
	else
		return -1
	end
end

function this.init()
	local res = this.load()
	if res == -1 then
		this.save()
	end
end

function this.reset()
	playerInfoData = nil
	playerInfoData = {}
	deleteDocument( 'playerInfo.txt' ) 
end

return this
