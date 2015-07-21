--[[
@
@ Project  : 
@
@ Filename : notifications.lua
@
@ Author   : Task Nagashige
@
@ Date     : 
@
@ Comment  : 
@
]]--

local alertMsg = 
{
	'LPが回復したよ！ファイトだよっ！',
	'LPが回復したようです。ラブアローシュート！',
	'LPが回復したﾁｭﾝ(・8・)',
	'LPが回復したにゃ',
	'LPが回復したみたいです。ﾀﾞﾚｶﾀｽｹﾃｰ',
	'別にどうでもいいけど、LPが回復したみたい',
	'LP回復よ！ハラショー',
	'カードがLP回復したっていってるで',
	'LPが回復したにこー!!'
}


local this = object.new()

this.notify_log = {}
this.notify_time = os.date( '%c', os.time() )

local function notificationListener( event )

	print(json.encode(event))

    if ( event.type == "remote" ) then
        --handle the push notification

    elseif ( event.type == "local" ) then
        --handle the local notification
    end
end

--The notification Runtime listener should be handled from within "main.lua"


-- Schedule a notification using Coordinated Universal Time (UTC)
function this.set( time )
	local i = math.random(1, 9)
	local options = 
	{
	    alert = alertMsg[i],
	    badge = 2,
	    custom = { foo = "bar" }
	}
	local utcTime = os.date( "!*t", os.time() + time )
	print( utcTime.hour, utcTime.min, utcTime.sec )
	this.notify_time = os.date( '%m月%d日 %H:%M:%S', os.time() + time )
	local event = 
	{
		name = 'notifications-set-finish',
		time = this.notify_time,
	}
	this:dispatchEvent( event )
	this.notify_log[#this.notify_log + 1] = notifications.scheduleNotification( utcTime, options )
	Runtime:addEventListener( "notification", notificationListener )
end

function this.remove()
	notifications.cancelNotification( this.notify_log[#this.notify_log] )
end

return this