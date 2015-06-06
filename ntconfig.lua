--ステータスバーの設定
-- display.setStatusBar( display.DefaultStatusBar )
--display.setStatusBar( display.HiddenStatusBar )
display.setStatusBar( display.TranslucentStatusBar )

--画面幅を_W、画面高さを_H、ステータスバー高さを_SHとする
_W  = display.contentWidth
--_H  = display.contentHeight
_H  = display.actualContentHeight
--_SH = display.topStatusBarContentHeight --display.statusBarHeight + 20
local tmpSH = display.topStatusBarContentHeight

local _diffH = (display.actualContentHeight - display.contentHeight)*0.5
--端末ごとに位置調整が必要なため、ステータスバーを作ってから位置を調節する
local statuBar = display.newRect(0,-1*_diffH,_W,tmpSH)
statuBar:setFillColor(0,0) --(255,0)
statuBar.strokeWidth = 1
statuBar:setStrokeColor(10,0)
if system.getInfo("platformName") == "Android" then
	_SH = 45
else
	_SH = statuBar.y+statuBar.height*0.5
end

--呼び出すディレクトリ
ImgDir = 'Images/'
viewDir = "View."
modelDir = "Model."
contDir = "Controller."
modDir = "Module."

object = require( modDir .. 'object' )