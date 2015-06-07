application =
{

    content =
    {
        -- graphicsCompatibility = 1,
        width = 640,
        height = (640/display.pixelWidth) * display.pixelHeight,
        scale = "letterbox",
        fps = 60,
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
	},
    notification = 
    {
        google =
        {
            projectNumber = "418410993667"
        },
    }
	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
