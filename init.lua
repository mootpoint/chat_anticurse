-- Minetest 0.4.10+ mod: chat_anticurse
-- punish player for cursing by disconnecting them in increments ending ultimately in permanent ban
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
-- due partially to laziness and partially to the fact that i am going to be transcoding these to /txt soon, franch and spanish words will not be masked


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

chat_anticurse.simplemask[1] = ' '..x1..'s' .. 's '
chat_anticurse.simplemask[2] = ' d' .. ''..x2..'ck'
chat_anticurse.simplemask[3] = ' p'..x4..'n' .. 'is'
chat_anticurse.simplemask[4] = ' p' .. ''..x3..'ssy'
chat_anticurse.simplemask[5] = ' h'..x5..'' .. 'r'..'ny '
chat_anticurse.simplemask[6] = ' b'..x2..'' .. 'tch'
chat_anticurse.simplemask[7] = ' b'..x2..'' .. 'tche'
chat_anticurse.simplemask[8] = ' s'..x4..'' .. 'x'
chat_anticurse.simplemask[9] = ' '..y4..'б' .. 'а'
chat_anticurse.simplemask[10] = ' бл'..y5..'' .. ' '
chat_anticurse.simplemask[11] = ' ж' .. ''..y3..'п'
chat_anticurse.simplemask[12] = ' х' .. ''..y1..'й'
chat_anticurse.simplemask[13] = ' ч' .. 'л'..y4..'н'
chat_anticurse.simplemask[14] = ' п'..y2..'' .. 'зд'
chat_anticurse.simplemask[15] = ' в'..y3..'' .. 'збуд'
chat_anticurse.simplemask[16] = ' в'..y3..'з' .. 'б'..y1..'ж'
chat_anticurse.simplemask[17] = ' сп'..y4..'' .. 'рм'
chat_anticurse.simplemask[18] = ' бл'..y5..'' .. 'д'
chat_anticurse.simplemask[19] = ' бл'..y5..'' .. 'ть'
chat_anticurse.simplemask[20] = ' с' .. ''..y4..'кс'
chat_anticurse.simplemask[21] = 'f' .. ''..x3..'ck'
chat_anticurse.simplemask[22] = ''..x1..'rs'..x4..'h'..x5..'l'..x4..''
chat_anticurse.simplemask[23] = ' c'..x3..'nt '
chat_anticurse.simplemask[24] = ' '..x1..'s' .. 'sh'..x5..'le'
chat_anticurse.simplemask[25] = ' h'..x4..'ll'
chat_anticurse.simplemask[26] = 'n00b'
chat_anticurse.simplemask[27] = 'noob'
chat_anticurse.simplemask[28] = 'stupid'
chat_anticurse.simplemask[29] = 'hate'
chat_anticurse.simplemask[30] = 'tabarnak'
chat_anticurse.simplemask[31] = 'osti'
chat_anticurse.simplemask[32] = 'calisse'
chat_anticurse.simplemask[33] = 'câlisse'
chat_anticurse.simplemask[34] = 'viarge'
chat_anticurse.simplemask[35] = 'criss'
chat_anticurse.simplemask[36] = 'crisse'
chat_anticurse.simplemask[37] = 'putain'
chat_anticurse.simplemask[38] = 'pute'
chat_anticurse.simplemask[39] = 'salope'
chat_anticurse.simplemask[40] = 'nique ta mère'
chat_anticurse.simplemask[41] = 'pétasse'
chat_anticurse.simplemask[42] = 'enfoiré'
chat_anticurse.simplemask[43] = 'enfoirée'
chat_anticurse.simplemask[44] = 'sacrament'
chat_anticurse.simplemask[45] = 'simonaque'
chat_anticurse.simplemask[46] = 'merde'
chat_anticurse.simplemask[47] = 'marde'
chat_anticurse.simplemask[48] = 'imbécile'
chat_anticurse.simplemask[49] = 'idiot'
chat_anticurse.simplemask[50] = 'pénis'
chat_anticurse.simplemask[51] = 'sexe'
chat_anticurse.simplemask[52] = 'baise'
chat_anticurse.simplemask[53] = 'bâtard'
chat_anticurse.simplemask[54] = 'batard'
chat_anticurse.simplemask[55] = 'puta'
chat_anticurse.simplemask[56] = 'puto'
chat_anticurse.simplemask[57] = 'concha su madre'
chat_anticurse.simplemask[58] = 'concha tu madre'
chat_anticurse.simplemask[59] = 'perra'
chat_anticurse.simplemask[60] = 'pinche'
chat_anticurse.simplemask[61] = 'pendejo'
chat_anticurse.simplemask[62] = 'sexo'
chat_anticurse.simplemask[63] = 'maricon'
chat_anticurse.simplemask[64] = 'joto'
chat_anticurse.simplemask[65] = 'bastardo'
chat_anticurse.simplemask[66] = 'culo'
chat_anticurse.simplemask[67] = 'verga'
chat_anticurse.simplemask[68] = 'mierda'
chat_anticurse.simplemask[69] = 'chinga'
chat_anticurse.simplemask[70] = 'chingados'
chat_anticurse.simplemask[71] = 'jode'
chat_anticurse.simplemask[72] = 'faggot'



local judge_name = 'Server'
local seconds = '30'
local cause = 'Cursing or Hate Speech'

chat_anticurse.check_message = function(name, message)
    local checkingmessage=string.lower( name..' '..message ..' ' )
	local uncensored = 0
    for i=1, #chat_anticurse.simplemask do
        if string.find(checkingmessage, chat_anticurse.simplemask[i], 1, true) ~=nil then
            uncensored = 2
            break
        end
    end
    
    --additional checks
    if 
        string.find(checkingmessage, ' c'..x3..'' .. 'm ', 1, true) ~=nil and 
        not (string.find(checkingmessage, ' c'..x3..'' .. 'm ' .. 'se', 1, true) ~=nil) and
        not (string.find(checkingmessage, ' c'..x3..'' .. 'm ' .. 'to', 1, true) ~=nil)
    then
        uncensored = 2
    end
    return uncensored
end

minetest.register_on_chat_message(function(name, message)
    local uncensored = chat_anticurse.check_message(name, message)
    if uncensored == 1 then
        justice.sentence(judge_name, name, tonumber(seconds), cause)
        minetest.log('action', 'Player '..name..' jailed for '..cause..'. Chat:'..message)
        return true
    end

    if uncensored == 2 then
        justice.sentence(judge_name, name, tonumber(seconds), cause)
        -- minetest.chat_send_all('Player <'..name..'> jailed for '..cause..'.' )
        minetest.log('action', 'Player '..name..' warned for '..cause..'. Chat:'..message)
        return true
    end

end)

if minetest.chatcommands['me'] then
    local old_command = minetest.chatcommands['me'].func
    minetest.chatcommands['me'].func = function(name, param)
        local uncensored = chat_anticurse.check_message(name, param)

        if uncensored == 1 then
            justice.sentence(judge_name, name, tonumber(seconds), cause)
            minetest.log('action', 'Player '..name..' warned for '..cause..'. Msg:'..param)
            return
        end

        if uncensored == 2 then
            justice.sentence(judge_name, name, tonumber(seconds), cause)
            --minetest.chat_send_all('Player <'..name..'> warned for '..cause..'.' )
            minetest.log('action', 'Player '..name..' warned for '..cause..'. Me:'..param)
            return
        end
        
        return old_command(name, param)
    end
end

if minetest.chatcommands['msg'] then
    local old_command = minetest.chatcommands['msg'].func
    minetest.chatcommands['msg'].func = function(name, param)
        local uncensored = chat_anticurse.check_message(name, param)

        if uncensored == 1 then
            justice.sentence(judge_name, name, tonumber(seconds), cause)
            minetest.log('action', 'Player '..name..' warned for '..cause..'. Msg:'..param)
            return
        end

        if uncensored == 2 then
            justice.sentence(judge_name, name, tonumber(seconds), cause)
           -- minetest.chat_send_all('Player <'..name..'> warned for '..cause..'' )
            minetest.log('action', 'Player '..name..' warned for '..cause..'. Msg:'..param)
            return
        end
        
        return old_command(name, param)
    end
end
