tdbot_function = require('Bot.tdbot').getCallback()
 tdbot  =  require'U-T.tdbot'
bot = {}
plugin = {}
MsgTime_ = os.time() - 5
getINFO = function(IN, WIT)
 bot.id = WIT.id
 bot.name = WIT.first_name
 bot.last_name = WIT.last_name or ''
 bot.username = WIT.username or ''
 bot.phone_number = WIT.phone_number
end
getInfo_ = function(INT,crco_WIT)
  bot.bio = crco_WIT.bio
end
TimeNow = os.time()

timenow_ = os.date("%M:%S")
function dl_cb(extra, res)
 -- vardump(res)
 -- vardump(extra)
 if res.message then

 print("\027[" .. color.black[1] .. ";" .. color.red[2] .. "m ==> ERROR "..res.message.." \027[00m")
 end
end
M_T = function(PT,TX,lower,cmd)
  if cmd then
        PT_ = PT:gsub("[%?%[%]%[#!/%]%$%%]", "")
  else
    PT_ = PT
  end
 if TX then
  if lower == 1 then
    PG_ = { TX:lower():match(PT_) }
  else
    PG_ = { TX:match(PT_) }
  end
     if next(PG_) then
       vardump(PG_)
       return PG_

     end
     end
         end
function match_(...)
 val = {}
for no,crco in ipairs({...}) do 
    val[crco] = true 

    end
return val
end

local clock = os.clock
function sleep(n) 
local t0 = clock()
while clock() - t0 <= n do 
end 
end

 local function l_PL(...)
   crco = {...}
   msg = crco[1] 
   plug = crco[2] 
   match = crco[3]
   if plug.runing and match  then
       local result = plug.runing(msg, 
       match
     )
       if result then
         tdbot.editMessageText(msg.chat_id,msg.id,result,'html',false, 0, nil, nil, nil)

     end
   end
   end
last = '☤ '
Valid_ = function (CR_)
 if tonumber(CR_.date) < tonumber(MsgTime_) then
   print("\027[" .. color.black[1] .. ";" .. color.green[2] .. "m ==> OLD MESSAGE \027[00m")
  return false
 else
   return true
 end
end


run_BOT= function (...)
 arg_ = {...}
 msg = arg_[1] 
 data_ = arg_[2]
 if (data_ or msg) then
   for name, plugint in pairs(plugin) do
     if plugint.run  then
    msg_ = plugint.run(msg,data_)
    if msg_ then
     end
     
   end
 if msg then
  for key, value in pairs(plugint.patterns) do  
       PT= value
      TX_ = msg.on.text or msg.on.caption
     
   

if plugint.lower then

      MT_ = M_T(PT, TX_,1,plugint.cmd)
else
  MT_ = M_T(PT, TX_,0)
end
         if MT_ then 
         print('PAT : ',PT)
       end  
       l_PL(msg,plugint,MT_)
     
     end
   end
     end
end
----
end
PluginLoad = function()
if not _EnvDB then 
 return 
end

   for _, files in pairs(_EnvDB.data.plist) do
   
       print ("-> Loaded Plugin : ", files)
   local ok, err =  pcall(function()
   local PL_LOAD = loadfile("./plugins/"..files..'.lua')()
   plugin[files] = PL_LOAD
   end)
   if not ok then
        print('\27[31mError loading plugins '..files..'\27[39m',err)

   end
 
  end
  

--
end

PluginLoad()


local x = 1
 
function tdbot_update_callback (data_)
  if data_ 
  then
x = x + 1
 if x then
redis:save(bot.id.."RunTime",tonumber(x))
 -- save("other","RunTime",tonumber())
  if redis:get(bot.id..''RunTime') and tonumber(redis:get(bot.id..'RunTime')) > 528 then
    io.popen('rm ./CRCO-TG/thumbnails/*')
    io.popen('rm ./CRCO-TG/stickers/*')
    io.popen('rm ./CRCO-TG/photos/*')
    os.exit(400)
  end
   end
    end
 tdbot.getMe( getINFO,nil)
 tdbot.getUserFullInfo(bot.id,getInfo_,nil)
 getMainMessage(data_,nil,data_)
 if (data_._ == "updateDeleteMessages")  then
 elseif ( data_._ == "updateNewMessage" or data_._ == "updateNewChannelMessage") then
  tdbot.openChat(data_.message.chat_id, nil, nil)
   if data_ and  Valid_(data_.message) or (data_.message.date and Valid_(data_.message)) then
   
   getMainMessage(data_,data_.message,data_)
   end
 elseif (data_ or data_._== "updateMessageEdited") then
   getMainMessage(data_,data_.message,data_)
 function updateMessageEdited(amir,crco)
   if crco and crco.date and Valid_(crco) then
   getMainMessage(data_,crco,data_)
   end
 end
 tdbot.getMessage(data_.chat_id, data_.message_id, updateMessageEdited, nil)
 end
end
 require('Bot.tdbot').run(tdbot_update_callback)
