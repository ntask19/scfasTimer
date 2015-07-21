-- ProjectName : ads
--
-- Filename : chartboost.lua
--
-- Creater : Ryo Takahashi
--
-- Date : 2015-07-08
--
-- Comment :
---------------------------------------------------------
local admob = require("ads")

local this = object.new()

this.initialized = false
this.chartboost_appID = ''
this.chartboost_appSignature = ''

------------------------------
-- イベントのリスナー
------------------------------
local function adListener(event)
	print(event)
	if event.name == 'adsRequest' then
		if not event.event.isError then
			
		end
	end

	local dispatchEvent = {
		name = event.response,
	}
	this:dispatchEvent( dispatchEvent )
end

-------------------------
-- initialize
-------------------------
function this.init(option)
	admob.init('admob', option.appId, adListener)
	this.initialized = true
end

-------------------------
-- prepare
-------------------------
function this.prepare(ads_type)
	assert(this.initialized == true, 'ERROR : ads.init() をして下さい')
	assert(ads_type, 'ERROR : ads_typeが指定されていません')

	-- prepare
	admob.load( 'interstitial' , {testMode = _isDebug})
end


-------------------------
-- show
-------------------------
function this.show(ads_type, option)
	if ads_type == 'header' or ads_type == 'footer' then
		ads_type = 'banner'
	end
	assert(this.initialized == true, 'ERROR : ads.init() をして下さい')
	assert(ads_type, 'ERROR : ads_typeが指定されていません')
	assert(ads_type == 'interstitial' or
			ads_type == 'banner', 'ERROR : 存在しないads_typeです')

	-- prepare
	admob.show( ads_type, {x = option.x or 0, y = option.y or 0 } )
end


--------------------------
-- remove
--------------------------
function this.remove()
	admob.hide()
end
return this