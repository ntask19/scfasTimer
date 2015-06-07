---------------------------------------
-- print関連
---------------------------------------
_print = print

local function tsstring(o)
    return '"' .. tostring(o) .. '"'
end
 
local function recurse(o, indent)
    if indent == nil then indent = '' end
    local indent2 = indent .. '  '
    if type(o) == 'table' then
        local s = indent .. '{' .. '\n'
        local first = true
        for k,v in pairs(o) do
            if first == false then s = s .. ', \n' end
            if type(k) ~= 'number' then k = tsstring(k) end
            s = s .. indent2 .. '[' .. k .. '] = ' .. recurse(v, indent2)
            first = false
        end
        return s .. '\n' .. indent .. '}'
    else
        return tsstring(o)
    end
end
 
function var_dump(...)
    local args = {...}
    if #args > 1 then
        var_dump(args)
    else
        print('type => ' .. type(args[1]) .. ' : ' .. recurse(args[1]))
    end
end

function printTable(table, prefix)
	if not prefix then
		prefix = "### "
	end
	if __isDebug == true then 
		if type(table) == "table" then
			for key, value in pairs(table) do
				if type(value) == "table" then
					_print(prefix .. tostring(key))
					_print(prefix .. "{")
					printTable(value, prefix .. "   ")
					_print(prefix .. "}")
				else
					_print(prefix .. tostring(key) .. ": " .. tostring(value))
				end
			end
		end
	end
end

function tsprint( str1, str2, str3, str4, str5, str6, str7, str8, str9, str10)
	if __isDebug == true then
		if type(str1) == "table" then
			printTable(str1)
		else
			if str2 == nil then str2 = "" end 
			if str3 == nil then str3 = "" end 
			if str4 == nil then str4 = "" end 
			if str5 == nil then str5 = "" end 
			if str6 == nil then str6 = "" end 
			if str7 == nil then str7 = "" end 
			if str8 == nil then str8 = "" end 
			if str9 == nil then str9 = "" end 
			if str10 == nil then str10 = "" end 
			_print( tostring(str1), tostring(str2), tostring(str3), tostring(str4), tostring(str5), tostring(str6), tostring(str7), tostring(str8), tostring(str9), tostring(str10))
		end
	end
end

function print( str1, str2, str3, str4, str5, str6, str7, str8, str9, str10)

	local debugInfo = debug.getinfo(2)
	local fileName = debugInfo.source:match("[^/]*$")
	local currentLine = debugInfo.currentline
	if type(str1) == "table" then
		tsprint(fileName..":"..currentLine..":")
		tsprint( str1, str2, str3, str4, str5, str6, str7, str8, str9, str10)
	else
		tsprint( fileName..":"..currentLine..":",str1, str2, str3, str4, str5, str6, str7, str8, str9, str10)
	end
end
---------------------------------------------------------------------------------------------------------
---------------------------------------------

function returnTrue()
	return true
end

local function removeTableContents( array )
	if array and #array > 0 then
		for key = 1, #array do
			local value = array[key]
			key = nil
			value = nil
		end
		array = nil
		array = {}
	end
end


-- ダウンロードする関数
-- 既に持っているか、http:// or local://　かをチェックして画像を準備する
local counter = 1
function checkDownload(url, action, dir, root)

	checkRetryTime = 100
	checkCountNum = 0

	local directory = dir or system.TemporaryDirectory
	local filePath = root or ""
	if startsWith(url,"http://") then
		local path = system.pathForFile(basename(url), directory)
		local file = io.open(path, "r")
		if file then
			io.close(file)
			if action then
				action()
			end
		else

			_is_network_connect = true
			local function request()
				if _is_network_connect then

					-- print("checkDownload count = "..counter)
					-- counter = counter + 1

					local function listener(event)
						if event.isError then
						else
							if event.status ~= 200 then
								os.remove(system.pathForFile( basename(url), directory))
							end          
							if action then
								action()
							end
						end
					end
					
					local headers = {}
					headers["User-Agent"] = userAgent
					local params = {}
					params.headers = headers

					network.download(url, "GET", listener, filePath..basename(url), directory)
				else
					checkNetworkStatus( request )
				end
			end
			request()
		end
	else
		if action then
			action()
		end   
	end
end

-- 重複したURLをDLしないようにする
local tableOfCheckDownload = {}

local function addUrlEventTable( url )
	assert( url, 'ERROR : not found url!' )

	local allow = true
	for k, v in pairs( tableOfCheckDownload ) do
		if url == v then
			allow = false
		end
	end

	if allow == true then
		-- URLを追加
		table.insert( tableOfCheckDownload, url )
		return true
	else
		-- 既に追加済み
		return false
	end
end

-- URLを除去
local function removeUrlEventTable( url )
	for k, v in pairs( tableOfCheckDownload ) do
		if url == v then
			table.remove( tableOfCheckDownload, k )
		end
	end
end

--write text
function writeText(name, data, dir)
	tsprint("library.lua  - - - - -  writeText - - - - - ")
	local directory = dir or system.DocumentsDirectory
	local path = system.pathForFile(name, directory)
	local file = io.open(path, "w")
	if file then
		file:write(data)
		io.close(file)
	else -- ファイルがない場合は,ファイルを作成してテキストを書き込む
		local directoryName = ""
		for k, v in string.gmatch(name, "(%w+)/") do
			directoryName = directoryName..k.."/"
			createDirectory(directoryName,directory)
		end
		--writeTextライブラリが何重にもの呼び出される恐れがあるため一回のみ行う
		file = io.open(path, "w")
		if file then
			file:write(data)
			io.close(file)
		end
	end
end

--write text
function readText(name, dir)
	local directory = dir or system.DocumentsDirectory
	local path = system.pathForFile(name, directory)
	local file = io.open(path, "r")
	if file then
		local contents = file:read("*a")
		return contents
	else
		return nil
	end
end


--黒い触れない背景みたいなやつ
--引数：x,y,width,height
function createBlackFilter(x,y,width,height,group,color)
	local object = display.newRect(x,y,width, height)
	if group then
		group:insert(object)
	end
	if color then
		object:setFillColor(color[1],color[2],color[3],color[4] or 255) --(0,240)
	else
		object:setFillColor(0,0,0,220) --(0,240)
	end
	object:addEventListener("touch", function() return true end)
	object:addEventListener("tap", function() return true end)
	return object
end

--DocumentDirectoryにあるか確認して振り分ける
function isDownlaodFile(image)
	local path = system.pathForFile(image, system.DocumentsDirectory )
	local fhd = io.open( path )
 -- io.close(fhd)

	if fhd then
		return true
	else
		return false
	end
end

-- ====================文字列の長さ　日本語対応===============================
function utf8charbytes (s, i)
	 -- argument defaults
	 i = i or 1
	 local c = string.byte(s, i)
	 
	 -- determine bytes needed for character, based on RFC 3629
	 if c > 0 and c <= 127 then
			-- UTF8-1
			return 1
	 elseif c >= 194 and c <= 223 then
			-- UTF8-2
			local c2 = string.byte(s, i + 1)
			return 2
	 elseif c >= 224 and c <= 239 then
			-- UTF8-3
			local c2 = s:byte(i + 1)
			local c3 = s:byte(i + 2)
			return 3
	 elseif c >= 240 and c <= 244 then
			-- UTF8-4
			local c2 = s:byte(i + 1)
			local c3 = s:byte(i + 2)
			local c4 = s:byte(i + 3)
			return 4
	 end
end
 
-- returns the number of characters in a UTF-8 string
function utf8len (s)
	 local pos = 1
	 local bytes = string.len(s)
	 local len = 0
	 
	 while pos <= bytes and len ~= chars do
			local c = string.byte(s,pos)
			len = len + 1
			
			pos = pos + utf8charbytes(s, pos)
	 end
	 
	 if chars ~= nil then
			return pos - 1
	 end
	 
	 return len
end


--時間の表示を〇〇分前等にかえる
function diffTime(dateTime)
	dateTime = string.gsub(dateTime, " ", "-")
	dateTime = string.gsub(dateTime, ":", "-")
	function split(str, d)
		local s = str
		local t = {}
		local p = "%s*(.-)%s*"..d.."%s*"
		local f = function(v)
			table.insert(t, v)
		end
		if s ~= nil then
			string.gsub(s, p, f)
			f(string.gsub(s, p, ""))
		end
		return t
	end
	
	dateTime = split(dateTime, "-")
	local returnTime = nil
	local Year, Month, Day, Hour, Minute, Second= dateTime[1],dateTime[2],dateTime[3],dateTime[4],dateTime[5],dateTime[6]
	local t1 = os.time({year=Year, month=Month, day=Day, hour=Hour, min=Minute, sec=Second})
	local date = os.date( '*t' )
	local t2 = os.time({year=date.year, month=date.month, day=date.day, hour=date.hour, min=date.min, sec=date.sec})
	local now=os.difftime( t2, t1 )
	local niti = math.floor(now/86400)
	local jikan = math.floor(now/3600)
	local hun = math.floor(now/60)
	local byou = math.floor(now)

	if byou<60 then
		returnTime = translations.get("FewSeconds")
	elseif hun<60 then
		returnTime = hun..translations.get("Minute")
	elseif jikan<24 then
		returnTime = jikan..translations.get("Hours")
	elseif 10<niti then
		returnTime = Month.."."..Day
	elseif niti>=1 then 
		returnTime =  niti..translations.get("Day")
	end
	return returnTime
end

--時間の表示を〇〇分前等にかえる
function diffTime2(dateTime)
	dateTime = string.gsub(dateTime, " ", "-")
	dateTime = string.gsub(dateTime, ":", "-")
	function split(str, d)
		local s = str
		local t = {}
		local p = "%s*(.-)%s*"..d.."%s*"
		local f = function(v)
			table.insert(t, v)
		end
		if s ~= nil then
			string.gsub(s, p, f)
			f(string.gsub(s, p, ""))
		end
		return t
		end
		dateTime = split(dateTime, "-")
		local Year, Month, Day, Hour, Minute, Second= dateTime[1],dateTime[2],dateTime[3],dateTime[4],dateTime[5],dateTime[6]
		local t1 = os.time({year=Year, month=Month, day=Day, hour=Hour, min=Minute, sec=Second})
		local date = os.date( '*t' )
	local t2 = os.time({year=date.year, month=date.month, day=date.day, hour=date.hour, min=date.min, sec=date.sec})
	now=os.difftime( t2, t1 )
	niti = math.floor(now/86400)
	jikan = math.floor(now/3600)
	hun = math.floor(now/60)
	byou = math.floor(now)

	returnTime = Month.."."..Day.." "..Hour..":"..Minute
	
	return returnTime
end

--時間の表示を〇〇分前等にかえる
function diffTime3(dateTime)
	dateTime = string.gsub(dateTime, " ", "-")
	dateTime = string.gsub(dateTime, ":", "-")
	function split(str, d)
		local s = str
		local t = {}
		local p = "%s*(.-)%s*"..d.."%s*"
		local f = function(v)
			table.insert(t, v)
		end
		if s ~= nil then
			string.gsub(s, p, f)
			f(string.gsub(s, p, ""))
		end
		return t
		end
		dateTime = split(dateTime, "-")
		local Year, Month, Day, Hour, Minute, Second= dateTime[1],dateTime[2],dateTime[3],dateTime[4],dateTime[5],dateTime[6]
		local t1 = os.time({year=Year, month=Month, day=Day, hour=Hour, min=Minute, sec=Second})
		local date = os.date( '*t' )
	local t2 = os.time({year=date.year, month=date.month, day=date.day, hour=date.hour, min=date.min, sec=date.sec})
	now=os.difftime( t2, t1 )
	niti = math.floor(now/86400)
	jikan = math.floor(now/3600)
	hun = math.floor(now/60)
	byou = math.floor(now)

	returnTime = Hour..":"..Minute
	
	return returnTime
end

--曜日を返す
function dayOfWeek()
	local wday = os.date("*t").wday
	local wdayText
	if wday == 1 then
		wdayText = "日"
	elseif wday == 2 then
		wdayText = "月"
	elseif wday == 3 then
		wdayText = "火"
	elseif wday == 4 then
		wdayText = "水"
	elseif wday == 5 then
		wdayText = "木"
	elseif wday == 6 then
		wdayText = "金"
	elseif wday == 7 then
		wdayText = "土"
	end

	return wdayText
end

-- 秒数を◯◯：○○形式に変換
function changeSeconds( duration )
	local duration = duration
	local minutes = math.floor((duration / 60) % 60)
	local seconds = math.floor( duration % 60 )
	if seconds*0.1 < 1 then
		seconds = '0' .. seconds
	end
	local hms = minutes .. ':' .. seconds
	return hms
end


------------------------------------
-- 特定の文字がいくつ含まれるかを返す関数
------------------------------------
function countSpecificCharacterInString(str, chara)
	assert(str, "Not Found str!")
	assert(chara, "Not Found chara!")

	local num = 0
	local nextNum = 1
	local count = 0 
	while nextNum ~= nil and count < 100 do
		count = count + 1 
		local ms, me = str:find(chara, nextNum)
		if ms ~= nil then
			num = num + 1
			nextNum = me + 1
		else
			nextNum = nil
		end
	end
	
	return num 
end




--文字列の改行したときに必要な高さを返す
function getTextHeight(W, text,family, size)
	tsprint(text, family, size)
	local obj = display.newText(text, 0,0, family, size)
	obj.y = _H/2
	local width = obj.width
	local height = obj.height
	local line 

	if width%W == 0 then
		line = math.floor(width/W)
	else
		line = math.floor(width/W)+1
	end
	print("row", countSpecificCharacterInString(text, "\n"))
	line = line + countSpecificCharacterInString(text, "\n")

	display.remove(obj)
	return (height+size*0.2)*line
end

-------------------------------------------
-- textTruncate
--　
-- 文字、置き換える文字、文章の幅、サイズ、書体を書くと幅に合わした文字列を返してくれる
-- local text = display.newText(textTruncate(str, "...", 470, 38, native.systemFont), 100,100, native.systemFont, 38)
-- 文字（１行）が指定の幅を超えたら特定の文字に置き換える
function textTruncate(str, replaceText, width, size, family)
	str = string.gsub(str,"\n","") 
	local text = display.newText(str,0,0,family,size)
	local length = text.width
	display.remove(text)
	text = nil

	if width <= length then
		--仮に１００で
		local str2, returnStr, strNum
		local count = 1

		for i=1, 600 do
			local wordByte = string.byte(str,count)
			--[[if 0 <= wordByte and wordByte <= 127 then
				strNum = 1
			elseif 128 <= wordByte and wordByte <= 159 then
				strNum = 3
			else
				strNum = 1
			end]]
			if wordByte > 223 then
				count = count + 2
			end
			str2 = string.sub(str,1,count)
			str2 = str2 .. replaceText
			local text3 = display.newText(str2, 0,0,family, size)
			if text3.width <= width then
				display.remove(text3)
				text3=nil
				returnStr = str2
			else
				display.remove(text3)
				text3=nil
				return returnStr
			end
			count = count+1
		end
	else
		--tsprint("textTrimcate:length = "..length.." width="..width)
		return str
	end
end

function url_encode(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
				function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str  
end

function url_decode(str)
	str = string.gsub (str, "+", " ")
	str = string.gsub (str, "%%(%x%x)",
			function(h) return string.char(tonumber(h,16)) end)
	str = string.gsub (str, "\r\n", "\n")
	return str
end

-- 日付のXXXX-XX-XX表記をXXXX/XX/XX表記に変換する
function date_cast( date )
	local date = string.sub( date, 1, 4 ) .. "/" .. string.sub( date, 6, 7 ) .. "/" .. string.sub( date, 9, 10 )
	return date
end


---------------------------------------------------
-- サブディレクトリを作成する関数
-- dirName：サブディレクトリの名前
-- dirSrc：サブディレクトリを作成する場所（デフォルトではDocumentsDirectory） 
-- 使い方：createDirectory( "folder1", system.DocumentsDirectory )
-- 注意：require"lfs"をしておくこと！
local lfs = require "lfs";
function createDirectory( dirName, dirSrc )
	assert( dirName, "Error!: dirName is nil value" )
	local dirName = tostring(dirName)
	local directory = dirSrc or system.DocumentsDirectory
	local dir_path = system.pathForFile( "", directory )

	local success = lfs.chdir( dir_path )
	local new_folder_path

	if success then
		lfs.mkdir(dirName)
		tsprint( " lfs.currentdir() " .. lfs.currentdir()  )
		new_folder_path = lfs.currentdir() .. "/"..dirName
	end
end

-- print all files you select directory
function checkDirectory( dirName, dirSrc )
	assert( dirName, "Error!: dirName is nil value" )
	local dirName = tostring(dirName)
	local directory = dirSrc or system.DocumentsDirectory
	local doc_path = system.pathForFile( dirName, directory )

	local lfs = require( 'lfs' )
	for file in lfs.dir( doc_path ) do
		 --file is the current file or directory name
		
		if file and file ~= '' and file ~= '.' and file ~= '..' then
			print( "Found file: " .. file )
		else
			print( "Found not file!!" )
		end

	end
end

function existsDirectory( dirName, dirSrc )
	assert( dirName, "Error!: dirName is nil value" )

	local dirName = tostring(dirName)
	local directory = dirSrc or system.DocumentsDirectory
	local doc_path = system.pathForFile( dirName, directory )

	local is_exists = lfs.chdir( doc_path )
	if is_exists then
		return true
	else
		return false
	end
end

function renameDocument( oldName, newName, docSrc )
	local destDir = docSrc or system.DocumentsDirectory  -- where the file is stored
	local results, reason = os.rename( system.pathForFile( oldName, destDir  ),
	        system.pathForFile( newName, destDir  ) )
	
	if results then
	   print( "file renamed" )
	else
	   print( "file not renamed", reason )
	end
	--> file not renamed    orange.txt: No such file or directory
end

 -- delete file you select
function deleteDocument( docName, docSrc )
	assert( docName, "Error!: docName is nil value" )
	local doc = nil

	if docSrc ~= nil then
		doc = docSrc .. "/" .. docName
	else
		doc = docName
	end

	local results = os.remove( system.pathForFile( doc, system.DocumentsDirectory  ) )

	if results then
		 print( "deleteDocument: file removed" )
	else
		 print( "deleteDocument: file does not exist" )
	end
end

-- delete all files you select directory
function cleanDirectory( dirName, dirSrc )
	assert( dirName, "Error!: dirName is nil value" )
	local dirName = tostring(dirName)
	local directory = dirSrc or system.DocumentsDirectory
	local doc_path = system.pathForFile( dirName, directory )

	print("library.lua  createDirectory",doc_path)

	if doc_path ~= nil then
		for file in lfs.dir( doc_path ) do
			 --file is the current file or directory name
			if file ~= nil then
				tsprint( "Found file: " .. file )
				deleteDocument( file, dirName )
			else
				tsprint( "Found not file!!" )
			end
		end
	else
		tsprint("doc_path does not exist")
	end
end

-- you can check document whether or not it exsits
function checkDocument( docName, dirSrc )

	if docName ~= nil then
		local directory = dirSrc or system.DocumentsDirectory
		local doc_path = system.pathForFile( docName, directory )

		if doc_path then
			doc_path = io.open( doc_path, "r" )
		end

		if  doc_path then
			tsprint( "File found -> " .. docName )
			doc_path:close()
					
			return true
		else
			tsprint( "File does not exist -> " .. docName )
			return false
		end
	else
		tsprint( "docName is nil value!!" )
		return nil
	end

end

-- 乱数を返す
function _tsCreateInvalidValue()
	local invalidTable = {}

	for i = 1, 10 do
		local invalidValue = math.random()

		invalidTable[ #invalidTable + 1 ] = invalidValue
	end
	local invalidJson = json.encode( invalidTable )

	return invalidJson
end

-- 文字列の分解
function split(str, delim)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end

    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local lastPos
    for part, pos in string.gfind(str, pat) do
        table.insert(result, part)
        lastPos = pos
    end
    table.insert(result, string.sub(str, lastPos))
    return result
end

function stringFromHex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end


-- scaleの調整
function tsscale(width, height, obj)
	assert(width, "ERROR : NOT FOUND width")
	assert(height, "ERROR : NOT FOUND height")
	assert(obj, "ERROR : NOT FOUND obj")
	
	if obj.width/obj.height > width/height then
		obj:scale(height/obj.height, height/obj.height)
	else
		obj:scale(width/obj.width,width/obj.width)
	end
end



-- create a table listener object for the bkgd image
local ZOOMMAX = 5
local ZOOMMIN =1
local function calculateDelta( previousTouches, event )
    local id,touch = next( previousTouches )
    if event.id == id then
        id,touch = next( previousTouches, id )
        assert( id ~= event.id )
    end

    local dx = touch.x - event.x
    local dy = touch.y - event.y
    return dx, dy
end

function pinchAndMove( event )
	system.activate( "multitouch" )
    local result = true

    local phase = event.phase
    local self = event.target
    local previousTouches = self.previousTouches
    local t = event.target
    local numTotalTouches = 1
    if ( previousTouches ) then
        -- add in total from previousTouches, subtract one if event is already in the array
        numTotalTouches = numTotalTouches + self.numPreviousTouches
        if previousTouches[event.id] then
            numTotalTouches = numTotalTouches - 1
        end
    end

    if "began" == phase then
        -- Very first "began" event
        if ( not self.isFocus ) then
            -- Subsequent touch events will target button even if they are outside the stageBounds of button
            display.getCurrentStage():setFocus( self )
            self.isFocus = true
			t.x0 = event.x - t.x
			t.y0 = event.y - t.y

            previousTouches = {}
            self.previousTouches = previousTouches
            self.numPreviousTouches = 0
        elseif ( not self.distance ) then
            local dx,dy

            if previousTouches and ( numTotalTouches ) >= 2 then
                    dx,dy = calculateDelta( previousTouches, event )
            end

            -- initialize to distance between two touches
            if ( dx and dy ) then
                local d = math.sqrt( dx*dx + dy*dy )
                if ( d > 0 ) then
                    self.distance = d
                    self.xScaleOriginal = self.xScale
                    self.yScaleOriginal = self.yScale

                    tsprint( "distance = " .. self.distance )
                end
            end
        end

        if not previousTouches[event.id] then
            self.numPreviousTouches = self.numPreviousTouches + 1
        end
        previousTouches[event.id] = event

    elseif self.isFocus then
        if "moved" == phase then
            if ( self.distance ) then
                local dx,dy
                if previousTouches and ( numTotalTouches ) >= 2 then
                    dx,dy = calculateDelta( previousTouches, event )
                end

                if ( dx and dy ) then
                    local newDistance = math.sqrt( dx*dx + dy*dy )
                    local scale = newDistance / self.distance
                    if ( scale > 0 ) then
                        self.xScale = self.xScaleOriginal * scale
                        self.yScale = self.yScaleOriginal * scale
                    end
                end
            end
			if numTotalTouches == 1 then
				
				t.x = event.x - t.x0
				t.y = event.y - t.y0
				--xの上限
				if t.x < 0 then
					t.x = 0
				elseif t.x > _W then
					t.x = _W
				end
				--yの上限
				if t.y < 0 then
					t.y = 0
				elseif t.y > _H then
					t.y = _H
				end

			end
            if not previousTouches[event.id] then
                self.numPreviousTouches = self.numPreviousTouches + 1
            end
            previousTouches[event.id] = event

        elseif "ended" == phase or "cancelled" == phase then
        	system.deactivate( "multitouch" )
            if previousTouches[event.id] then
                self.numPreviousTouches = self.numPreviousTouches - 1
                previousTouches[event.id] = nil
            end

            if ( #previousTouches > 0 ) then
                -- must be at least 2 touches remaining to pinch/zoom
                self.distance = nil
            else
                -- previousTouches is empty so no more fingers are touching the screen
                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )

                self.isFocus = false
                self.distance = nil

                self.xScaleOriginal = nil
                self.yScaleOriginal = nil

                -- reset array
                self.previousTouches = nil
                self.numPreviousTouches = nil
            end
        end
    end

    return result
end
