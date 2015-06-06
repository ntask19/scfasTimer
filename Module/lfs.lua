--[[
@
@ ProjectName : Talkspace
@
@ Filename	  : lfs.lua
@
@ Author	  : Task Nagashige
@
@ Created	  : 2015-06-05
@
@ Comment	  : ファイルやディレクトリを管理する
@
]]--

local lfs = require 'lfs'

-- DocumentsDirectoryにディレクトリを作成
function lfs.createDir( dirName, dirSrc )
	assert( dirName, 'Fatal error : dirName not found')

	local dirName = tostring(dirName)
	local directory = dirSrc or system.DocumentsDirectory
	local dir_path = system.pathForFile( '', directory )

	local success = lfs.chdir( dir_path )
	local new_folder_path

	if success then
		lfs.mkdir(dirName)
		print( ' lfs.currentdir() ' .. lfs.currentdir()  )
		new_folder_path = lfs.currentdir() .. '/'..dirName
	end
end

-- print all files you select directory
function lfs.checkDir( dirName, dirSrc )
	assert( dirName, 'Fatal error : dirName not found')

	local dirName = tostring(dirName)
	local directory = dirSrc or system.DocumentsDirectory
	local docs_path = system.pathForFile( dirName, directory )

	local lfs = require( 'lfs' )
	for file in lfs.dir( docs_path ) do
		 --file is the current file or directory name
		
		if file and file ~= '' and file ~= '.' and file ~= '..' then
			print( 'Found file: ' .. file )
		else
			print( 'Found not file!!' )
		end

	end
end

function lfs.existsDir( dirName, dirSrc )
	assert( dirName, 'Fatal error : dirName not found')

	local dirName = tostring(dirName)
	local directory = dirSrc or system.DocumentsDirectory
	local docs_path = system.pathForFile( dirName, directory )

	local is_exists = lfs.chdir( docs_path )
	if is_exists then
		return true
	else
		return false
	end
end

-- delete all files you select directory
function lfs.cleanDir( dirName, dirSrc )
	assert( dirName, 'Error!: dirName is nil value' )

	local dirName = tostring(dirName)
	local directory = dirSrc or system.DocumentsDirectory
	local docs_path = system.pathForFile( dirName, directory )

	if docs_path then
		for file in lfs.dir( docs_path ) do
			 --file is the current file or directory name
			if file ~= nil then
				print( 'Found file: ' .. file )
				lfs.deleteDocs( file, dirName )
			else
				print( 'Found not file!!' )
			end
		end
	else
		print('docs_path does not exist')
	end
end


function lfs.renameDocs( oldName, newName, docSrc )
	assert( oldName, 'Fatal error : oldName not found')
	assert( newName, 'Fatal error : newName not found')

	local destDir = docSrc or system.DocumentsDirectory  -- where the file is stored
	local results, reason = os.rename( system.pathForFile( oldName, destDir  ),system.pathForFile( newName, destDir  ) )
	
	if results then
	   print( 'file renamed' )
	else
	   print( 'file not renamed', reason )
	end
end

 -- delete file you select
function lfs.deleteDocs( docsName, docSrc )
	assert( docsName, 'Error!: docsName is nil value' )

	local doc = nil

	if docSrc ~= nil then
		doc = docSrc .. '/' .. docsName
	else
		doc = docsName
	end

	local results = os.remove( system.pathForFile( doc, system.DocumentsDirectory  ) )

	if results then
		 print( 'deleteDocument: file removed' )
	else
		 print( 'deleteDocument: file does not exist' )
	end
end

-- you can check document whether or not it exsits
function lfs.checkDocs( docsName, dirSrc )
	assert( docsName, 'Fatal error : dirName not found')

	if docsName ~= nil then
		local directory = dirSrc or system.DocumentsDirectory
		local docs_path = system.pathForFile( docsName, directory )

		if docs_path then
			docs_path = io.open( docs_path, 'r' )
		end

		if  docs_path then
			print( 'File found -> ' .. docsName )
			docs_path:close()
					
			return true
		else
			print( 'File does not exist -> ' .. docsName )
			return false
		end
	else
		print( 'docsName is nil value!!' )
		return nil
	end

end

