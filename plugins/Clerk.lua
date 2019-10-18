patterns_ = {
    '^(setclerktext)$',
'^(setclerk)$',
"^(clerk) (.*)$"
}

ClerkMod = function (msg,crco)
    if is_sudo(msg.sender_user_id) then

if crco[1] == 'clerk' then
  if crco[2] == 'on' then
        clerk = true
    elseif crco[2] == 'off' then
        clerk = nil
    else
        return
    end
    if clerk then
        save('other','ClerkMod',true)
        return tdbot.editMessageText(msg.chat_id, msg.id, '☤ Message : *Clerk has been enabled*','md',false, 0, nil, nil, nil)
    else
        del('other','ClerkMod')
        return  tdbot.editMessageText(msg.chat_id, msg.id, '☤ Message : *Clerk Has been Disable*','md',false, 0, nil, nil, nil)
    end
end
if crco[1] == 'setclerktext' and tonumber(msg.reply_to_message_id)> 0 then
    getMessageMain = function(main,CR)
        if CR.content.text and CR.content.text.text then
        save('other','clerk:text',CR.content.text.text)
        type_ = true
    else
        return  tdbot.editMessageText(msg.chat_id, msg.id, "☤ Message : *You Can't set this* !",'md',false, 0, nil, nil, nil)
end
if type_ then
    return  tdbot.editMessageText(msg.chat_id, msg.id, '☤ Message : *Clerk Text Seted to* : '..CR.content.text.text,'md',false, 0, nil, nil, nil)
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),getMessageMain,nil)
end
if crco[1] == 'setclerk' and tonumber(msg.reply_to_message_id)> 0 then
getMessageMain = function(main,CR)
if CR.content.text and CR.content.text.text then
save('other','clerkID',CR.content.text.text)
save('other','clerk:text',CR.content.text.text)
save('other','clerkTYPE','Message')
type_ = 'TEXT'

elseif CR.content._ == 'messageAnimation' then
save('other','clerkID',CR.content.animation.animation.remote.id)
save('other','clerkTYPE','Gif')
type_ = 'GIF'
elseif CR.content._ == 'messageVoiceNote' then
id = CR.content.voice_note.voice.remote.id
save('other','clerkID',id)
save('other','clerkTYPE','VoiceNote')
type = 'VoiceNote'

elseif CR.content._ == 'messageVideoNote' then
id = CR.content.video_note.video.remote.id
save('other','clerkID',id)

save('other','clerkTYPE','VideoNote')
type_ = 'VideoNote'

else
        return  tdbot.editMessageText(msg.chat_id, msg.id, "☤ Message : *You Can't Save this* !",'md',false, 0, nil, nil, nil)
end
if type_ then
    return  tdbot.editMessageText(msg.chat_id, msg.id, '☤ Message : *Clerk Seted to* : '..type_,'md',false, 0, nil, nil, nil)
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),getMessageMain,nil)
end
end
end -- END OFF PLUG
PreMessage = function(msg,fast_update)
if msg then
    if Get('other','ClerkMod') then
         Chekinguser = function(C,CR)
        if CR.status._ == "userStatusOnline" then
        del('other','Self-OFFED') 
    elseif CR.status._ == "userStatusOffline" then
        save('other','Self-OFFED',true)
    end
        end
        tdbot.getUser(bot.id,Chekinguser,nil)
        end
     if msg.content._ == "messageText" and  msg.content.text.text and tonumber(msg.edit_date) == 0 and  not is_sudo(msg.sender_user_id) then
    if  not redis:get(bot.id..'Time:'..msg.sender_user_id)  and is_private(msg) and Get('other','ClerkMod') and Get('other','clerkTYPE') and Get('other','clerk:text') and Get('other','Self-OFFED')  then
        if Get('other','clerkTYPE') == 'Message' then
   tdbot.sendText(msg.chat_id, msg.id, Get('other','clerk:text'), 'md', false, false, false, 0, nil, nil, nil)
elseif Get('other','clerkTYPE') == 'Gif' then
     id = Get('other','clerkID')
   tdbot.sendAnimation(msg.chat_id,msg.reply_to_message_id or msg.id,id, (Get('other','clerk:text') or '*Sorry :(*'), 'md', false, true, nil, nil, nil)
    elseif Get('other','clerkTYPE') == 'VoiceNote' then
        id = Get('other','clerkID')
  tdbot.sendVoiceNote(msg.chat_id, msg.id,id, (Get('other','clerk:text') or '*Sorry :(*'), 'md',  true, true, nil, nil, nil)
        elseif Get('other','clerkTYPE') == 'VideoNote' then
            id = Get('other','clerkID')
  tdbot.sendVideoNote(msg.chat_id, msg.id,id, 0, 0, 0, 0, 0, false, true, nil, nil, nil)
 
        end
        redis:setex(bot.id..'Time:'..msg.sender_user_id,120,true)
    end
    end
end
end
return {patterns = patterns_,runing = ClerkMod,cmd = false,
lower = false,run = PreMessage}
