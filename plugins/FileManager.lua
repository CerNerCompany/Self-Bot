patterns_ = {
  "^(files)$",
"^(gifs)$",
"^(chats)$",
"^(delchat) (.*)$",
"^(delfile) (.*)$",

"^(setchat) '(.*)' '(.*)'$",
"^(stickers)$",
"^(clean files)$",
"^(clean chats)$",
"^(upload)$",

"^(clean stickers)$",
"^(clean gifs)$",
 "^(stickerset) (.*)$",
 "^(gifset) (.*)$",
 "^(stickerdel) (.*)$",
 "^(gifdel) (.*)$",
  "^(save) (.*)$",
  "^(get) (.*)"
}
is_have = function(name,type_)
  local var = false
  if Get("FileManager:"..type_..":"..name) then
  var = Get("FileManager:"..type_..":"..name) 
  print(var)
end
return var
end
FileManager = function(msg,crco)
  if is_sudo(msg.sender_user_id) then
  if crco[1] == 'files' then
    local files = Get('FileManager:Files:') or {}
  
    local text = last..' *Files* `:` *in Database* `:` \n'
    for key,value in pairs(files) do
     
    local sixe = Get("FileManager:FileSize:"..value) or 5
  
    sive = getSixe(tonumber(sixe))
    local type = Get('FileManager:TypeFile:'..value) or 'UnSupported'
    text = text..key.." - *〘"..value.."〙*  *Type* `〘"..type.."〙`*"..sive.."* [〘Receive in a chat〙](https://t.me/share/url?url=get "..value..")\n" 
    end
    if #files == 0 then
    text = 'Message `:` *Empty*'
    end
    tdbot.editMessageText(msg.chat_id, msg.id, text, 'md', false, 0, nil, nil, nil)
    end
   
    if crco[1] == 'save' and crco[2] and tonumber(msg.reply_to_message_id) > 0 then
      getDataMessage = function(arg,co)

        if co.content['@type'] == 'messageAnimation' then
               savePre(crco[2],co.content.animation.animation.size,'Gif')
               save("FileManager:Gif:"..crco[2],co.content.animation.animation.remote.id)
               is_saved = 1
               
           elseif co.content['@type'] == 'messagePhoto' then
                       if co.content.photo.sizes[3] then
savePre(crco[2],co.content.photo.sizes[3].photo.size,'Photo')
save("FileManager:Photo:"..crco[2],co.content.photo.sizes[3].photo.remote.id)
is_saved = 1

            elseif co.content.photo.sizes[2] then
              savePre(crco[2],co.content.photo.sizes[2].photo.size,'Photo')
save("FileManager:Photo:"..crco[2],co.content.photo.sizes[2].photo.remote.id)
is_saved = 1
            elseif co.content.photo.sizes[1] then
              savePre(crco[2],co.content.photo.sizes[1].photo.size,'Photo')
save("FileManager:Photo:"..crco[2],co.content.photo.sizes[1].photo.remote.id)
is_saved = 1
            end
                elseif co.content['@type'] == 'messageVideoNote' then
                  savePre(crco[2],tonumber(co.content.video_note.video.size),'VideoNote')
                  save("FileManager:VideoNote:"..crco[2],co.content.video_note.video.remote.id)
                  is_saved = 1
                 
      elseif co.content['@type'] == 'messageVoiceNote' then
        savePre(crco[2],co.content.voice_note.voice.size,'VoiceNote')
        save("FileManager:VoiceNote:"..crco[2],co.content.voice_note.voice.remote.id)
        is_saved = 1

           elseif co.content['@type'] == 'messageAudio' then
            savePre(crco[2],co.content.audio.audio.size,'Audio')
            save("FileManager:Audio:"..crco[2],co.content.audio.audio.remote.id)
         is_saved = 1
        elseif co.content['@type']== 'messageVideo' then
          is_saved = 1
          savePre(crco[2],co.content.video.video.size,'Video')
            save("FileManager:Video:"..crco[2],co.content.video.video.remote.id)
                   elseif co.content['@type'] == 'messageDocument' then
                    savePre(crco[2],co.content.document.document.size,'Document')
                    save("FileManager:Document:"..crco[2],co.content.document.document.remote.id)
                    is_saved = 1

         elseif co.content['@type']== 'messageContact' then
          save("FileManager:Contact:"..crco[2],co.content.contact.phone_number)
          sadd('FileManager:Files:',crco[2])
          save("FileManager:Contact:Name:"..crco[2],co.content.contact.first_name)
          save('FileManager:TypeFile:'..crco[2],'Contact')
is_saved = 1
         else
        return tdbot.editMessageText(msg.chat_id, msg.id,'Message : *File* :`'..ec_name(crco[2])..'` * is Not Found *','md',false, 0, nil, nil, nil)
        end
        if is_saved then
        return tdbot.editMessageText(msg.chat_id, msg.id,'Message : *File* :`'..ec_name(crco[2])..'` *has been saved*','md',false, 0, nil, nil, nil)
        end
        end
        tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),getDataMessage,nil)
        end
    --- 
   
   if crco[1] == 'bioadd' then
    bio = crco[2] 
  sadd('MainBio')
  end
    if crco[1] == 'get' then
       Size = Get("FileManager:FileSize:"..crco[2]) or 100
       caption ='*File name* `:` *〘'..(crco[2])..'〙*\n*File Size* `:` *〘'..getSixe(Size)..'〙*'
      if is_have(crco[2],'Gif') then 
        Del = true
         tdbot.sendAnimation(msg.chat_id, msg.id, is_have(crco[2],'Gif'), caption, 'md', false, true, nil, nil, nil)
      elseif is_have(crco[2],'Photo') then
         Del = true
          tdbot.sendPhoto(msg.chat_id,msg.id, is_have(crco[2],'Photo'), caption, 'md',0, 0, 0, false, true, nil, nil, nil)
      elseif is_have(crco[2],'VideoNote') then
        Del = true
         tdbot.sendVideoNote(msg.chat_id, (msg.id or 0),is_have(crco[2],'VideoNote'),46,480,nil,0,0,false, true, nil, nil, nil)
        elseif is_have(crco[2],'Video') then
          Del = true
       tdbot.sendVideo(msg.chat_id,0,is_have(crco[2],'Video'),caption,'md')
      elseif is_have(crco[2],'VoiceNote') then
        Del = true
 tdbot.sendVoiceNote(msg.chat_id, msg.id, is_have(crco[2],'VoiceNote'), caption, 'md',  true, true, nil, nil, nil)

      elseif is_have(crco[2],'Audio') then
        Del = true
         tdbot.sendAudio(msg.chat_id, 0, is_have(crco[2],'Audio'), caption, 'md','CRCO', 'CRCO',  true, true, nil, nil, nil)
      elseif is_have(crco[2],'Document') then
         Del = true
          tdbot.sendDocument(msg.chat_id, msg.id, is_have(crco[2],'Document'), caption, 'md', false, true, nil, nil, nil)
      elseif is_have(crco[2],'Contact') then
        Del = true
         tdbot.sendContact(msg.chat_id, msg.id, is_have(crco[2],'Contact'), Get("FileManager:Contact:Name:"..crco[2]), 'CRCO', 0, false, true, nil, nil, nil)

      else
        return tdbot.editMessageText(msg.chat_id, msg.id,'Message : *File* :`'..ec_name(crco[2])..'` * is Not Found *','md',false, 0, nil, nil, nil)
      end
      if Del then 
        tdbot.deleteMessages(msg.chat_id,{[1] =msg.id})
      end
      end
      if crco[1] == 'delfile' then
        if CHECK('FileManager:Files:',crco[2]) then
        del("FileManager:Gif:"..crco[2]) 
        

         Del = true
        del("FileManager:Photo:"..crco[2]) 

        del("FileManager:VideoNote:"..crco[2]) 

          del("FileManager:Video:"..crco[2]) 

        del("FileManager:VoiceNote:"..crco[2]) 

 
        del("FileManager:Audio:"..crco[2]) 

        del("FileManager:Document:"..crco[2]) 

         
         del("FileManager:Contact:"..crco[2])
         del("FileManager:Contact:Name:"..crco[2])
         
       else
         return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message : *File* :`'..ec_name(crco[2])..'` * is Not Found *','md',false, 0, nil, nil, nil)
       end
       if Del then 
        sremove('FileManager:Files:',crco[2])
        return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message : *File* :`'..ec_name(crco[2])..'` * Removed ! *','md',false, 0, nil, nil, nil)

       end
       end
  if crco[1] == 'setchat' and crco[2] and crco[3] then
        sadd('Chats:',crco[2])
        save('Chats:Name:'..crco[2],crco[3])
        text = '☤Message : *Answer for* (`'..crco[2]..'`) *was set to * `:` (`'..crco[3]..'`)'
        return tdbot.editMessageText(msg.chat_id, msg.id,text,'md',false, 0, nil, nil, nil)

        end
   if crco[1] == 'delchat' and crco[2] then
    sremove('Chats:',crco[2])
    del('Chats:Name:'..crco[2])
           text = '☤ Message : *Answer* (`'..crco[2]..'`) *was removed *'
           return tdbot.editMessageText(msg.chat_id, msg.id,text,'md',false, 0, nil, nil, nil)

           end
      if crco[1] == 'chats' then
           chats = Get('Chats:') or {}
          local  text= '*☤ Chats ☤*\n'
          for key,value in pairs(chats) do
              local answer = Get("Chats:Name:"..value) or ''
              text = text..key.." - `"..value.."` Anwser : `"..answer.."`\n" 
          end
          if #chats == 0 then
            text = '☤ Message `:` *Empty*'
          end
          return tdbot.editMessageText(msg.chat_id, msg.id,text,'md',false, 0, nil, nil, nil)
          end
          if crco[1] == 'clean chats' then
            va = Get('Chats:') or {}
            text = '☤ Message : *Chats Cleared !*'
           for k,v in pairs(va) do
             del("Chats:Name:"..v)
           del('Chats:')
           end
           if #va == 0 then
           text = '☤ Message : *Empty*'
           end
            return tdbot.editMessageText(msg.chat_id, msg.id,text,'md',false, 0, nil, nil, nil)
           end
if crco[1] == 'clean files' then
 files = Get('FileManager:Files:') or {}
 text = '☤ Message : *DataBase Cleared !*'
for k,v in pairs(files) do
  del("FileManager:Contact:"..v)
del("FileManager:Contact:Name:"..v)
  del('FileManager:TypeFile:'..v)
   del("FileManager:FileSize:"..v)
 del("FileManager:Gif:"..v) 
del("FileManager:Video:"..v) 
del("FileManager:VideoNote:"..v) 
del("FileManager:Document:"..v) 
del("FileManager:Contact:"..v) 
del("FileManager:Audio:"..v) 
del("FileManager:VoiceNote:"..v) 
del("FileManager:Photo:"..v) 
del('FileManager:Files:')
end
if #files == 0 then
text = '☤ Message : *Empty*'
end
 return tdbot.editMessageText(msg.chat_id, msg.id,text,'md',false, 0, nil, nil, nil)
end
if crco[1] == 'gifs' then
local GifsCloud = Get('Gifs:Cloud:') or {}
local text = 'gifs CMD database : \n'
for key,value in pairs(GifsCloud) do
text = text..key.." - `"..value.."`\n" 
end
if #GifsCloud == 0 then
text = '☤ Message : *Empty*'
end
 return tdbot.editMessageText(msg.chat_id, msg.id,text,'md',false, 0, nil, nil, nil)
end
if crco[1] == 'stickers' then
local GifsCloud = Get('Stickers:Cloud:') or {}
local text = 'Stickers CMD database : \n'
for key,value in pairs(GifsCloud) do
text = text..key.." - `"..value.."`\n" 
end
if #GifsCloud == 0 then
text = '☤ Message : *Empty*'
end
 return tdbot.editMessageText(msg.chat_id, msg.id,text,'md',false, 0, nil, nil, nil)
end
if crco[1] == 'gifset' and tonumber(msg.reply_to_message_id) > 0 then
convertcmd = function(arg,co)
if co.content['@type'] == 'messageAnimation' then
local gif = co.content.animation.animation.remote.id
save('Gifs:'..crco[2],gif)
sadd('Gifs:Cloud:',crco[2])
        return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message : *Gif seted to cmd* `:` '..crco[2],'md',false, 0, nil, nil, nil)

else
 return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message : *Gifs only*','md',false, 0, nil, nil, nil)
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),convertcmd,nil)
end
if crco[1] == 'gifdel' then
if CHECK('Gifs:Cloud:',crco[2]) then
del('Gifs:'..crco[2])
sremove('Gifs:Cloud:',crco[2])
 return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message `:` *Gif CMD* `:` 〘'..crco[2]..'〙 *Has been Deleted* !','md',false, 0, nil, nil, nil)
else
 return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message : *Gif CMD  is not found*','md',false, 0, nil, nil, nil)
end
end
if crco[1] == 'stickerdel' then
if CHECK('Stickers:Cloud:',crco[2]) then
del('Stickers:'..crco[2])
sremove('Stickers:Cloud:',crco[2])
 return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message `:` *Sticker CMD* `:` 〘'..gif..'〙 *Has been Deleted* !','md',false, 0, nil, nil, nil)
else
 return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message : *Sticker CMD is not found*','md',false, 0, nil, nil, nil)
end
end
if crco[1] == 'clean stickers' then
 files = Get('Stickers:Cloud:') or {}
 text = '☤ Message : *Stickers Cleared !*'
for k,v in pairs(files) do
  del("Stickers:"..v)
del('Stickers:Cloud:')
end
if #files == 0 then
text = '☤ Message : *Empty*'
end
 return tdbot.editMessageText(msg.chat_id, msg.id,text,'md',false, 0, nil, nil, nil)
end
if crco[1] == 'clean gifs' then
 files = Get('Gifs::Cloud:') or {}
 text = '☤ Message : *Gifs Cleared !*'
for k,v in pairs(files) do
  del("Gifs::"..v)
del('Gifs:Cloud:')
end
if #files == 0 then
text = '☤ Message : *Empty*'
end
 return tdbot.editMessageText(msg.chat_id, msg.id,text,'md',false, 0, nil, nil, nil)
end
if crco[1] == 'stickerset' and tonumber(msg.reply_to_message_id) > 0 then
convertcmd = function(arg,co)
if co.content['@type'] == 'messageSticker' then
save('Stickers:'..crco[2],co.content.sticker.sticker.remote.id)
sadd('Stickers:Cloud:',crco[2])
        return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message : *Sticker seted to cmd* `:` '..crco[2],'md',false, 0, nil, nil, nil)

else
 return tdbot.editMessageText(msg.chat_id, msg.id,'☤ Message : *Stickers only*','md',false, 0, nil, nil, nil)
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),convertcmd,nil)
end
---
  end 
end
PreMessage = function(msg,fast_update)
if msg then
  if msg.content._ == "messageText" and  msg.content.text.text then
  if  Get('chat:mod'..msg.chat_id) and  Get("Chats:Name:"..msg.content.text.text)  and not is_sudo(msg.sender_user_id)  then
   return tdbot.sendText(msg.chat_id,msg.id, Get("Chats:Name:"..msg.content.text.text) , 'md', false, false, false, 0, nil, nil, nil)
    end
  end
  if is_sudo(msg.sender_user_id) then
if msg.content._ == "messageText" and  msg.content.text.text then
    if  Get('Stickers:'..msg.content.text.text)  then
tdbot.deleteMessages(msg.chat_id,{[1] =msg.id})
 tdbot.sendSticker(msg.chat_id, (msg.reply_to_message_id or msg.id), Get('Stickers:'..msg.content.text.text), false, true, nil, nil, nil)
end

  if  Get('Gifs:'..msg.content.text.text)  then
tdbot.deleteMessages(msg.chat_id,{[1] =msg.id})
         tdbot.sendAnimation(msg.chat_id,(msg.reply_to_message_id or msg.id), Get('Gifs:'..msg.content.text.text), '', 'md', false, true, nil, nil, nil)

end
end
end
end
end
return {patterns = patterns_,
  runing = FileManager,
    cmd = false,
                lower = false,
        run = PreMessage
}
