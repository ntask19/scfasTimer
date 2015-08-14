--[[
@
@ Project  : 
@
@ Filename : livePoint.lua
@
@ Author   : Task Nagashige
@
@ Date     : 
@
@ Comment  : 
@
]]--

local this = object.new()

local recoverTime = 360
if __isDebug then
	recoverTime = 10
end

-- unixTime
this.diffTime = 0
this.date = nil
this.began_time = nil

this.current_point = playerInfoData['current_point']
this.target_point = playerInfoData['target_point']

function this.stopPoint()
	print('stop event')
	deleteDocument( 'lp_log.txt' )
end

function this.setPoint( num, type )
	if num then
		if type == 'target' then
			this.target_point = tonumber( num ) or 50
		elseif type == 'current' then
			this.current_point = tonumber( num ) or 0
		end
	end
end

function this.savePoint( data)
	local data = data or {}
	data['current_point'] = this.current_point
	data['target_point'] = this.target_point
	data['began_time'] = data['began_time'] or os.time( os.date( '*t' ) )
	data['ended_time'] = data['ended_time'] or this.getEndedTime()

	writeText('lp_log.txt', json.encode(data)) 
end

function this.readPoint()
	local encodeData = readText('lp_log.txt')
	if encodeData then
		local data = json.decode( encodeData )
		this.current_point = tonumber( data['current_point'] )
		this.target_point = tonumber( data['target_point'] )
		this.began_time = data['began_time']
		this.endedTime = data['ended_time']

		local notify_time = os.date( '%m月%d日 %H:%M:%S', this.endedTime )
		local event = 
		{
			name = 'livePoint-readPoint-finish',
			time = notify_time,
		}
		this:dispatchEvent( event )

		return 0
	else
		return -1
	end
end

function this.UpdatePointFromCache()
	if this.began_time then
		local diffPoint = this.getDiffPoint( this.began_time )
		this.current_point = this.current_point + diffPoint
		if this.current_point >= this.target_point then
			this.current_point = this.target_point
			this.stopPoint()
		end
	end
end

function this.getEndedTime()
	this.getDiffTime()
	return os.time( os.date( '*t' ) ) + this.diffTime
end

function this.getDiffPoint( beganTime )
	assert( beganTime )
	local now = os.time( os.date( '*t' ) )
	local diffPoint = math.floor( ( now - beganTime ) / recoverTime )
	return diffPoint
end

function this.setDiffTime( endedTime )
	assert( endedTime )
	local now = os.time( os.date( '*t' ) )
	this.diffTime = tonumber( endedTime ) - now
end

function this.getDiffTime()
	print( this.current_point, this.target_point )
	this.current_point = tonumber( this.current_point ) or 0
	this.target_point = tonumber( this.target_point ) or 0
	if this.target_point >= this.current_point then
		this.diffTime = ( this.target_point - this.current_point ) * recoverTime
		return 0
	else
		return -1
	end
end

function this.changedate()
	return changeSeconds( this.diffTime )
end

function this.getDate()
	this.getDiffTime()
	return this.changedate()
end

function this.init()
	this.point = 0
end

return this
