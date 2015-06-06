--[[
@
@ ProjectName : Talkspace
@
@ Filename	  : patch.lua
@
@ Author	  : Task Nagashige
@
@ Created	  : 2015-06-05
@
@ Comment	  : グローバルを検出
@
]]--


local _KNOWN_GLOBALS = {
    nowPage = true,
    openspace_id  = true,
    filter_openspace_reply = true,
    filter_openspace_setVoice = true,
    recEndActionNotRemove = true,
    recEndAction = true,
    picVoice = true,
    replyID = true,
    pageStatus = true,
    filter_closespace_setVoice = true,
    filter_closespace_reply  = true,
    editThread = true,
    groupMemberNum = true,
    userListType = true,
    is_tutorial = true,
    setVoiceGroup = true,
    filter_userTimeline_setVoice      = true,
    filter_userTimeline_reply         = true,
    userpageReplyGroup = true,
    target_uid = true,
    coverLargePic = true,
    userpagePictureGroup = true,
    searchWord = true,
    searchType = true,
    isTuto = true,
}

setmetatable(_G, {
    __index = function( t, k )
        if _KNOWN_GLOBALS[k] then
            return
        end    
        print("ERROR", debug.traceback("access of undefined global "..tostring(k), 2))
        _KNOWN_GLOBALS[k] = true
    end,
    __newindex = function( t, k, v )
        rawset(t, k, v)
        if _KNOWN_GLOBALS[k] then
            return
        end
        print("ERROR", debug.traceback("creating new global "..tostring(k).."="..tostring(v), 2))
    end
})