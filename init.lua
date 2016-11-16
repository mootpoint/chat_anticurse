-- Minetest 0.4.10+ mod: chat_anticurse
-- remind player chat should stay pg. no punishment for cursing.
--
--  Created in 2015 by Andrey. 
--  This mod is Free and Open Source Software, released under the LGPL 2.1 or later.
-- 
-- See README.txt for more information.


chat_anticurse = {}
chat_anticurse.simplemask = {}
-- some english and some russian curse words
-- i don't want to keep these words as cleartext in code, so they are stored like this.
-- eventually to be exported in cleartext to a .txt file
-- french and spanish curse words courtesy of mok
-- note from mok cojer in MExico means the F word, but in peru cojer means to take and is common dialect. not added to this list for that reason
-- due partially to laziness and partially to the fact that i am going to be transcoding these to /txt soon, french and spanish words will not be masked


local x1 = 'a'
local x2 = 'i'
local x3 = 'u'
local x4 = 'e'
local x5 = 'o'
local y1 = 'y'
local y2 = 'и'
local y3 = 'о'
local y4 = 'е'
local y5 = 'я'

chat_anticurse.simplemask[1] = ' d' .. ''..x2..'ck'
chat_anticurse.simplemask[2] = ' p'..x4..'n' .. 'is'
chat_anticurse.simplemask[3] = ' p' .. ''..x3..'ssy'
chat_anticurse.simplemask[4] = ' b'..x2..'' .. 'tch'
chat_anticurse.simplemask[5] = ' b'..x2..'' .. 'tche'
chat_anticurse.simplemask[6] = ' s'..x4..'' .. 'x'
chat_anticurse.simplemask[7] = ' '..y4..'б' .. 'а'
chat_anticurse.simplemask[8] = ' бл'..y5..'' .. ' '
chat_anticurse.simplemask[9] = ' ж' .. ''..y3..'п'
chat_anticurse.simplemask[10] = ' х' .. ''..y1..'й'
chat_anticurse.simplemask[11] = ' ч' .. 'л'..y4..'н'
chat_anticurse.simplemask[12] = ' п'..y2..'' .. 'зд'
chat_anticurse.simplemask[13] = ' в'..y3..'' .. 'збуд'
chat_anticurse.simplemask[14] = ' в'..y3..'з' .. 'б'..y1..'ж'
chat_anticurse.simplemask[15] = ' сп'..y4..'' .. 'рм'
chat_anticurse.simplemask[16] = ' бл'..y5..'' .. 'д'
chat_anticurse.simplemask[17] = ' бл'..y5..'' .. 'ть'
chat_anticurse.simplemask[18] = ' с' .. ''..y4..'кс'
chat_anticurse.simplemask[19] = 'f' .. ''..x3..'ck'
chat_anticurse.simplemask[20] = ' c'..x3..'nt '
chat_anticurse.simplemask[21] = ' '..x1..'s' .. 'sh'..x5..'le'
chat_anticurse.simplemask[22] = 'caliss'
chat_anticurse.simplemask[23] = 'câliss'
chat_anticurse.simplemask[24] = 'viarge'
chat_anticurse.simplemask[25] = 'criss'
chat_anticurse.simplemask[26] = 'crisse'
chat_anticurse.simplemask[27] = 'pute'
chat_anticurse.simplemask[28] = 'salope'
chat_anticurse.simplemask[29] = 'nique ta mère'
chat_anticurse.simplemask[30] = 'pétasse'
chat_anticurse.simplemask[31] = 'enfoiré'
chat_anticurse.simplemask[32] = 'enfoirée'
chat_anticurse.simplemask[33] = 'baise'
chat_anticurse.simplemask[34] = 'bâtard'
chat_anticurse.simplemask[35] = 'batard'
chat_anticurse.simplemask[36] = 'puta'
chat_anticurse.simplemask[37] = 'puto'
chat_anticurse.simplemask[38] = 'concha su madre'
chat_anticurse.simplemask[39] = 'concha tu madre'
chat_anticurse.simplemask[40] = 'perra'
chat_anticurse.simplemask[41] = 'pinche'
chat_anticurse.simplemask[42] = 'pendejo'
chat_anticurse.simplemask[43] = 'maricon'
chat_anticurse.simplemask[44] = 'joto'
chat_anticurse.simplemask[45] = 'bastardo'
chat_anticurse.simplemask[46] = 'verga'
chat_anticurse.simplemask[47] = 'chinga'
chat_anticurse.simplemask[48] = 'chingados'
chat_anticurse.simplemask[49] = 'jode'
chat_anticurse.simplemask[50] = 'faggot'



chat_anticurse.check_message = function(name, message)
    local checkingmessage=string.lower( name..' '..message ..' ' )
	local uncensored = 0
    for i=1, #chat_anticurse.simplemask do
        if string.find(checkingmessage, chat_anticurse.simplemask[i], 1, true) ~=nil then
            uncensored = 2
            break
        end
    end
    return uncensored
end

minetest.register_on_chat_message(function(name, message)
    local uncensored = chat_anticurse.check_message(name, message)
    if uncensored == 1 or uncensored == 2 then
        minetest.chat_send_player(name, 'Please help us keep the chat rated PG, if you would like to curse use /channels')
        minetest.log('action', 'Player '..name..' warned for cursing. Chat:'..message)
        return false
    end

    
end)

if minetest.chatcommands['me'] then
    local old_command = minetest.chatcommands['me'].func
    minetest.chatcommands['me'].func = function(name, param)
        local uncensored = chat_anticurse.check_message(name, param)

        if uncensored == 1 or uncensored ==2 then
            minetest.chat_send_player(name, 'Please help us keep the chat rated PG, if you want to curse use /channels')
            minetest.log('action', 'Player '..name..' warned for cursing Msg:'..param)
            return false
        end

        return old_command(name, param)
    end
end
