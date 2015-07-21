-- Filename : analytics.lua
--
-- Creater : Ryo Takahashi
--
-- Date : 2015-06-28
--
-- Comment : 
--
---------------------------------------------------------------------
local analytics = require('analytics')

-------------------------------
-- FlurryサイトよりAPI Keyを取得
-------------------------------
local app_key = nil
if system.getInfo( "platformName" ) == 'Android' then
	app_key = 'K3DZJ5KZX849CQ8B4KYK'
elseif system.getInfo( "platformName" ) == 'iPhone OS' then
	app_key = ''
end
analytics.init(app_key)

return analytics