pat = { "^(plugs)$",
"^(reload)$",
       "^(pl) (+) (.*)$",
       "^(saveplug) (.*)$",
       "^(delplug) (.*)$",
       "^(getplug) (.*)$",

       "^(pl) (-) (.*)$"

       }
PLIST_TABLE = function()
    local files = {}
    for k, v in pairs(searchDirectory("plugins")) do
      if (v:match(".lua$")) then
        table.insert(files, v)
      end
    end
    return files
  end
saveplug = function(file_id,file_name, msg,name_real)
    tdbot.downloadFile(file_id, 32, nil, nil)
    if file_name:lower():find('.lua$') then
mainPTH = './CRCO-TG/documents/'..file_name
 if isFile(mainPTH) then
    text = "*Plug* : `"..name_real..".lua` has been saved ! \n `Message` *:* [You can now enable the plug](https://t.me/share/url?url=pl + "..name_real..")"
    os.rename(mainPTH, './plugins/'..name_real..'.lua')
 else
    text = '*Plug* : `'..name_real..'.lua` not found in PTH . pls redownload file again'
 end 
else
    text = '*The file not plug !*'
end

 return tdbot.editMessageText(msg.chat_id,msg.id,text,'md',false, 0, nil, nil, nil)

end

delplug = function(file_name,msg)
    mainPTH = './plugins/'..file_name..'.lua'
 if isFile(mainPTH) then
os.execute('rm ./plugins/'..file_name..'.lua')
table.remove(_EnvDB.data.plist,CHECK('plist',file_name))

text = '*Plug* : `'..file_name..'.lua` *Has been removed ! *'
else 
    text = '*Plug* : `'..file_name..'.lua` not found in PTH . pls use real name'
end
    -- body
    return tdbot.editMessageText(msg.chat_id,msg.id,text,'md',false, 0, nil, nil, nil)

 end
    PL_FOUND =  function( name )
    for k,v in pairs(
        PLIST_TABLE()
    ) do
        if name..'.lua' == v then
            return true
        end
    end
    return false
end
sendplug = function(filename,msg)
    if  PL_FOUND(filename) then
        tdbot.deleteMessages(msg.chat_id,{[1] =msg.id})
        tdbot.sendDocument(msg.chat_id, msg.id, './plugins/'..filename..'.lua','☤ *Plugin Name* `:` '..filename..'\n☤ *geted by self-project*', 'md', false, true, nil, nil, nil)
    else
        text= 	   '☤ Message : *Plugin not found in PTH*'
        return tdbot.editMessageText(msg.chat_id, msg.id,text ,'md',false, 0, nil, nil, nil)
    end
end
DIS = function(NAME)
	    if not PL_FOUND(NAME) then
            text= 	   '☤ Message : *Plugin not found in PTH*'
           return tdbot.editMessageText(msg.chat_id, msg.id,text ,'md',false, 0, nil, nil, nil)

	    end
	    if not CHECK('plist',NAME) then
            text= 	   '☤ Message : *Plugin Not Enabled*'
            return  tdbot.editMessageText(msg.chat_id, msg.id,text ,'md',false, 0, nil, nil, nil)
        end
       table.remove(_EnvDB.data.plist,CHECK('plist',NAME))
       CreateFile(_EnvDB , "./U-T/DB.lua")

         text= 	      '☤ Message : *Plugin Has been disabled* !'
        tdbot.editMessageText(msg.chat_id, msg.id,text ,'md',false, 0, nil, nil, nil)
        return     PluginLoad()
    end
    PluginsLIST =  function()
        local text = '*☤ Plugins ACTIVE ☤ * \n'
	    for k_, v_ in pairs(
            PLIST_TABLE()
        ) do
            local status = "`〘D〙`"
	          for k, v in pairs(_EnvDB.data.plist) do
                  if v_ == v..'.lua' then
                   
                    status = "`〘E〙`"
                    
	            end
	        end
	                 if status == '`〘D〙`'then
	                  v = v_:match("(.*)%.lua")
	                                     text = text.. '*'..v..'* '..status..' [〘E〙](https://t.me/share/url?url=pl%20%2B%20'..v..') [〘Receive〙](https://t.me/share/url?url=getplug '..v..')\n'
                                print(text)
                                        elseif  status == '`〘E〙`' then
                v = v_:match ("(.*)%.lua")
                
	            text = text..  '*'..v..'* '..status.." [〘D〙](https://t.me/share/url?url=pl - "..v..") [〘Receive〙](https://t.me/share/url?url=getplug "..v..")\n"
	        end
	    end
	    return text..'\n_pl + _*plugin name* `=>` *enable plugin*\n_pl -_ *plugin name* `=>` *disable plugin*'
	end

    EN_PL= function(NAME)
        if CHECK('plist',NAME) then
        return    tdbot.editMessageText(msg.chat_id, msg.id,'Message : *Plugins is Enabled !*' ,'md',false, 0, nil, nil, nil)
        end
            if PL_FOUND(NAME) then
                sadd('plist',NAME)
            tdbot.editMessageText(msg.chat_id, msg.id,'Message : *Plugin Has been enabled !*' ,'md',false, 0, nil, nil, nil)
            CreateFile(_EnvDB , "./U-T/DB.lua")
           return PluginLoad()
	    else
            
            return tdbot.editMessageText(msg.chat_id, msg.id,'Message : *Plugin not found in PTH*','md',false, 0, nil, nil, nil)
	    end
	end
Pre_= function(msg , crco)
    if is_sudo(msg.sender_user_id) then

    if crco[1] == 'saveplug' and crco[2] and tonumber(msg.reply_to_message_id) > 0 then
        getMeta = function(utc , update)
        if update.content._ == 'messageDocument' then
            File_Name = update.content.document.file_name
              File_ID = update.content.document.document.id
            return saveplug(File_ID , File_Name , msg,crco[2])
        end
    end
        return tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),getMeta,nil)
end
if crco[1] == 'delplug' and crco[2] then
   return delplug(crco[2],msg)
   
end
    if crco[1] == 'plugs'  then
        tdbot.editMessageText(msg.chat_id, msg.id,PluginsLIST(),'md',false, 0, nil, nil, nil)
end
        if crco[1] == 'reload' then
            tdbot.setAlarm(0.1, TypeKey, {text = 'Message : All Plugins Reloaded !', i = 1})

           return PluginLoad()
 
        end
    if crco[2] == '-' then
          return  DIS(crco[3])
	        end
               if crco[2] == '+' then
	             return EN_PL(crco[3])
            end
            if crco[1] == 'getplug' then
                return sendplug(crco[2],msg)
           end
        end
            end
        
            return { 
                patterns = pat,
                cmd = false,
                
                lower = false,
         runing = Pre_ ,
         }
