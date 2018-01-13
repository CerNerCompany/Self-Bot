dofile('./bot/utils.lua')
my = '443636125'
URL = require('socket.url')
http = require('socket.http')
https = require('ssl.https')
json = dofile('./libs/JSON.lua')
CerNerCompany = 'اختصاصی کرنر کمپانی '
serpent = dofile("./libs/serpent.lua")
tdbot = dofile("./bot/function.lua")
--MsgTime = os.time() - 60
day = 86400
Redis =  require ('redis')
redis = Redis.connect('127.0.0.1', 6379)
function dl_cb(arg, data)
end
function GetMessages(msg,data)
if msg then
if not redis:sismember(my..'AllGroup',msg.chat_id) then
redis:sadd(my..'AllGroup',msg.chat_id)
end  
if chat_type(msg.chat_id) == 'private' then
if redis:get(my..'Flood:Pv:'..my) then
if not is_sudo(msg) then
local post_count = 'user:' .. msg.sender_user_id .. ':flooder'
local msgs = tonumber(redis:get(my..post_count) or 0)
if msgs > tonumber(flood_MAX) then
if redis:get(my..'user:'..msg.sender_user_id..':flooder') then
tdbot.Block(msg.sender_user_id)
return false
else
redis:setex(my..'user:'..msg.sender_user_id..':flooder', 15, true)
end
end
redis:setex(my..post_count, tonumber(TIME_CHECK), msgs+1)
end
end
end
if chat_id then
local id = tostring(msg.chat_id)
if id:match('-100(%d+)') then
if not redis:sismember(my.."SuperGroup",msg.chat_id) then
redis:sadd(my.."SuperGroup",msg.chat_id)
redis:sadd(my.."Addtoall",msg.chat_id)
end
-----------------------------------
elseif id:match('^-(%d+)') then
if not redis:sismember(my.."Groups",msg.chat_id) then
redis:sadd(my.."Groups",msg.chat_id)
redis:sadd(my.."Addtoall",msg.chat_id)
end
-----------------------------------------
elseif id:match('^(%d+)') then
if not redis:sismember(my.."Users",msg.chat_id) then
redis:sadd(my.."Users",msg.chat_id)
end
else
if not redis:sismember(my.."SuperGroup",msg.chat_id) then
redis:sadd(my.."SuperGroup",msg.chat_id)

end
end
end
-------------MSG MATCHES------------
local cerner = msg.content.text
local cernerw = msg.content.text
local cernerbk = msg.content.text
if cerner then
chat_id = msg.chat_id
cerner = cerner:lower()
end
if cernerbk then
cernerbk = cernerbk:lower()
end
 if MsgType == 'text' and cerner then
if cerner:match('^[/#!]') then
cerner= cerner:gsub('^[/#!]','')
end
end
 if MsgType == 'text' and cernerw then
if cernerw:match('^[/#!]') then
cernerw= cernerw:gsub('^[/#!]','')
end
end
if cerner == 'self off' and is_sudo(msg) then
if redis:get(my..'SelfOnline:'..chat_id) then
tdbot.send(msg.chat_id, msg.id, '• `Self`   is _Already_ `Offlined in group !`' , 'md')
else
tdbot.send(msg.chat_id, msg.id, '• `Self` *Has Been Offlined in group !*' , 'md')
redis:set(my..'SelfOnline:'..msg.chat_id,true)
end
end
if cerner == 'self on' and is_sudo(msg) then
if redis:get(my..'SelfOnline:'..chat_id) then
tdbot.send(msg.chat_id, msg.id, '• `Self` *Has Been Onlined in group !*' , 'md')
redis:del(my..'SelfOnline:'..chat_id)
else
tdbot.send(msg.chat_id, msg.id, '• `Self`  is _Already_  `Onlined in group !`' , 'md')
end
end
if cerner == 'help' and is_sudo(msg) then
local text = [[
#self on 
شروع بکار ! 
#self off 
پایان دادن به  تمام عملکرد ها در گروه
#panel 
وضعیت عکس العمل 
#clerk on 
فعال سازی حالت منشی 
{در وضیت افلاینی شما شروع به کار میکند ! }
#clerk off 
غیرفعال سازی منشی {خاموش کردن چکینگ وضعیت شما}
#answer on 
فعال سازی حالت پاسخگویی {
هر فردی که اسم شما یا لقب شما را بگوید !}
#asnwer off
غیرفعال سازی پاسخگویی خودکار
#markread on
تیک خوردن پیام ها 
#markread off 
تیک نخوردن پیام
#echo on 
فعال سازی echo در تمام گروه ها
#echo off
#غیرفعال سازی echo در تمامی گروه
#typing on
فعال سازی حالت تایپینگ
#typing off 
غیرفعال سازی تایپینگ 
#save 
فروارد پیام به فضای ابری
#malevolent on 
فعال سازی وضعیت مواجه با بد خواه 
#malevolent off
غیرفعال سازی وضیت مواجه با بد خواه 
#Flood [num] > [reply]
فلود کردن 
#save [file]
دخیره فایل مورد نظر در دیتابیس
#get [files]
دریافت فایل ذخیره شده در دیتابیس
#delfile [filecmd]
حذف فایل ذخیره شده در دیتابیس
#files
دیافت لیست فایل های ذخیره شده با فرمت و  حجم آن
#stickerset [cmd]
دخیره استیکر در دیتابیس + دستور گت
#stickers 
 لیست استیکر های ذخیره شده 
#stickerdel [cmd]
حذف استیکر از دیتابیس با دستور گت آن
#gifset [cmd]
ذخیره گیف در دیتابیس + دستور گت
#gifdel [cmd]
حذف گیف از دیتا بیس با دستور گت آن
#gifs 
لیست گیف های دخیره شده

#reload 
بازنگری ربات
#setenemy [reply] or [user_id] or [mention] or [@username]
افزودن کاربر به لیست دشمنان
#delenemy [reply] or [user_id] or [mention] or [@username]
حدف کاربر از لیست دشمنان
#kick [reply] or [user_id] or [mention] or [@username]
اخراج کاربر از گروه 
#delall [reply] or [user_id] or [mention] or [@username]
پاکسازی تمام پیام های فرد
#del
پاک کردن پیام
#id [reply] or [user_id] or [mention] or [@username]
دریافت شناسه کاربر مورد نظر
#mydel 
پاکسازی تمام پیام های شما 
#clean msgs
پاکسازی پیام ها تا حد امکان
#enemylist
لیست دشمنان
#bk
ارسال گیف BK
#res [user_id] or [mention] 
دریافت اطلاعات کاربر مورد نظر
#share [reply]
ارسال شما شما 
#addc 
افزودن شما مورد نظر
#inv [reply] or [username] or [user_id]
دعوت کاربر مورد نظر
#fwd 
فروارد پیام به همه
#block [reply] or [user_id] or [mention] or [@username]
مسدود کردن کاربر
#unblock [reply] or [user_id] or [mention] or [@username]
آزاد کردن کاربر
#web [webpage]
دریافت اطلاعات در مورد سایت مورد نظر
#mute [reply] or [user_id] or [mention] or [@username]
محدود کردن کامل شخص در گروه 
#mute media [reply] or [user_id] or [mention] or [@username]
محدود کردن کاربر برای ارسال رسانه در گروه
#mute links [reply] or [user_id] or [mention] or [@username]
محدود کردن کاربر برای تعبیه لینک در پیام
#unmute [reply] or [user_id] or [mention] or [@username]
 رفع تمام محدودیت ها !
#pin [reply]
سنجاق کردن پیام در گروه
#unpin
حذف سنجاق پیام در گروه ! 
#backup 
ارسال اخرین نسخه سورس به پیوی شما
#setclerkmessage [reply]
ذخیره متن جدید منشی 
#call [reply] or [user_id] or [mention] or [@username]
تماس با فرد مورد نظر
#dlapk [link]
دانلود فایل با فرمت apk
#dlmp3 [link]
دانلود موزیک با لینک
#dlmp4 [link]
دانلود ویدیو با لینک
#calc (.*)
ماشین حساب
#boobs
ارسال تصاویر +18
#9gag
ارسال تصاویر جذاب
#flood lock
فعال کردن انتی فلود پیوی
#flood unlock
غیرفعال کردن انتی فلود پیوی
#setflood [num]
تنظیم حداکثر فلود در پیوی
#setfloodtime [num]
تنظیم زمان حساسیت فلود 
#tosticker
تبدیل عکس به استیکر
]]
tdbot.send(chat_id,msg.id,text,'html')
end
if is_private(msg) and not is_sudo(msg) then
if cerner and not redis:get(my..'Time'..msg.sender_user_id) then 
if redis:get(my..'Monshi') and redis:get(my..'MonshiStatus') then
if redis:get(my..'MessageClerk') then
textclerk = redis:get(my..'MessageClerk')
else
textclerk = 'مشترک مورد نظر در دسترس نمیباشد'
end
tdbot.sendText(msg.chat_id,msg.id,textclerk,'md')
redis:setex(my..'Time'..msg.sender_user_id,120,true)
end
end
end
if msg.content._== "messageText" then
MsgType = 'text'
end
if msg.content._== "messageText" then
local function GetM(Company,CerNer)
local function GetName(Companys,Company)
print("\027[" ..color.blue[1].. "m["..os.date("%H:%M:%S").."]\027[00m ["..CerNer.title.."]  >>>> "..msg.content.text.."")
end
tdbot.getUser(msg.sender_user_id,GetName)
end
tdbot.getChat(msg.chat_id,GetM)
end
if msg.content.caption then
function GetM(Company,CerNer)
function GetName(Companys,Company)
print("["..os.date("%H:%M:%S").."] "..CerNer.title.."  >>>> "..msg.content.caption.."")
end
tdbot.getUser(msg.sender_user_id,GetName)
end
tdbot.getChat(msg.chat_id,GetM)
end
if msg.content._ == "messageChatAddMembers" then
function GetM(Company,CerNer)
function GetName(Companys,Company)
for i=0,#msg.content.member_user_ids do
msg.add = msg.content.member_user_ids[i]
print("["..os.date("%H:%M:%S").."] "..CerNer.title.." "..Company.first_name.." >>>> Added members "..msg.content.member_user_ids[i].." "..Company.first_name.."")
MsgType = 'AddUser'
end
end
tdbot.getUser(msg.sender_user_id,GetName)
end
tdbot.getChat(msg.chat_id,GetM)
end
if msg.content._ == "messageChatJoinByLink" then
function GetM(Company,CerNer)
function GetName(Companys,Company)
print("["..os.date("%H:%M:%S").."] "..CerNer.title.." >>>> Joined By link "..Company.first_name.."")
MsgType = 'JoinedByLink'
end
tdbot.getUser(msg.sender_user_id,GetName)
end
tdbot.getChat(msg.chat_id,GetM)
end
if msg.content._ == "messageDocument" then
function GetM(Company,CerNer)
function GetName(Companys,Company)
MsgType = 'Document'
end
tdbot.getUser(msg.sender_user_id,GetName)
end
tdbot.getChat(msg.chat_id,GetM)
end
if not redis:get(my..'SelfOnline:'..msg.chat_id) then
if not is_channel(msg) then
if redis:get(my..'MarkRead:') then
if cerner then
tdbot.Markread(msg.chat_id, {[0] = msg.id})   
end
end
if not redis:get(my..'Action:'..msg.chat_id) then
if cerner then
tdbot.Action(msg.chat_id,'Typing')
end
end
end
if is_supergroup(msg) or is_group(msg) then
if redis:get(my..'Malevolent') then
for k,v in pairs(badkhah) do
if cerner == v and not is_sudo(msg) then
tdbot.sendText(msg.chat_id,msg.id,YML[math.random(#YML)],'md')
end
end
end
if redis:get(my..'Answer')  then
for k,v in pairs(myname) do
if cerner == v and not is_sudo(msg) then
tdbot.sendText(msg.chat_id,msg.id,Answer[math.random(#Answer)],'md')
end
end
end
if redis:get(my..'Echo'..msg.chat_id) then
if cerner and not is_sudo(msg) then
tdbot.forwardMessage(msg.chat_id, msg.chat_id, {[0] = msg.id}, 1)
end
end
end --- SuperGP
if msg.content._ == "messageAudio" then
print("[ CerNerCompany ]\nThis is [ Audio ]")
MsgType = 'Audio'
end
if msg.content._ == "messageVoice" then
print("[ CerNerCompany ]\nThis is [ Voice ]")
MsgType = 'Voice'
end
if msg.content._ == "messageVideo" then
print("[ CerNerCompany ]\nThis is [ Video ]")
MsgType = 'Video'
end
if msg.content._ == "messageAnimation" then
print("[ CerNerCompany ]\nThis is [ Gif ]")
MsgType = 'Gif'
end
if msg.content._ == "messageLocation" then
print("[ CerNerCompany ]\nThis is [ Location ]")
MsgType = 'Location'
end
if msg.content._ == "messageForwardedFromUser" then
print("[ CerNerCompany ]\nThis is [ messageForwardedFromUser ]")
MsgType = 'messageForwardedFromUser'
end

if msg.content._ == "messageContact" then
print("[ CerNerCompany ]\nThis is [ Contact ]")
MsgType = 'Contact'
end
if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
print(serpent.block(data))
print("[ CerNerCompany ]\nThis is [ MarkDown ]")
MsgType = 'Markread'
end
if msg.content.game then
print("[ CerNerCompany ]\nThis is [ Game ]")
MsgType = 'Game'
end
if msg.content._ == "messagePhoto" then
MsgType = 'Photo'
end

if redis:get(my..'Monshi') then
function Check(CerNer,Company)
if Company.status._ == "userStatusOnline" then
print('\027[' ..color.cyan[2]..';'..color.white[1]..'m                     I am Online                                \027[00m')
redis:del(my..'MonshiStatus') 
local time = os.date("%H : %M")
redis:set(my..'Onlined:',time)
end
end
tdbot.getUser(my,Check)
end
if redis:get(my..'Monshi') then
function Check(CerNer,Company)
if Company.status._ == "userStatusOffline" then
print('\027[' ..color.red[2]..';'..color.white[1]..'m                     I am Offline                                \027[00m')  
if not redis:get(my..'MonshiStatus') then
redis:set(my..'MonshiStatus',true)
local time = os.date("%H : %M")
redis:set(my..'Offlined:',time)
end                    
end
end
tdbot.getUser(my,Check)
end
if is_supergroup(msg) then
if is_Enemy(msg) and not is_sudo(msg) then
tdbot.sendText(msg.chat_id,msg.id,fohsh[math.random(#fohsh)],'md')
end
end
if is_sudo(msg) then
if cerner == 'markread off'then
if redis:get(my..'MarkRead:') then
tdbot.send(msg.chat_id, msg.id, '*Mark Read* `Has Been Disable`' , 'md')
redis:del(my..'MarkRead:')
else
tdbot.send(msg.chat_id, msg.id, '*Mark Reed*  is _Already_  `Disable`' , 'md')
end
end
if cerner == 'markread on' then
if redis:get(my..'MarkRead:') then
tdbot.send(msg.chat_id, msg.id, '*Mark Read*  is _Already_ `Enable`' , 'md')
else
tdbot.send(msg.chat_id, msg.id, '*Mark Read* `Has Been Enable`' , 'md')
redis:set(my..'MarkRead:',true)
end
end
if cerner == 'answer off'then
if redis:get(my..'Answer') then
tdbot.send(msg.chat_id, msg.id, '*Answer* `Has Been Disable`' , 'md')
redis:del(my..'Answer')
else
tdbot.send(msg.chat_id, msg.id, '*Answer*  is _Already_  `Disable`' , 'md')
end
end
if cerner == 'answer on' then
if redis:get(my..'Answer') then
tdbot.send(msg.chat_id, msg.id, '*Answer*  is _Already_ `Enable`' , 'md')
else
tdbot.send(msg.chat_id, msg.id, '*Answer* `Has Been Enable`' , 'md')
redis:set(my..'Answer',true)
end
end
if cerner == 'save' and tonumber(msg.reply_to_message_id) > 0 then
function CerNerCompany(CerNer,Company)
tdbot.forwardMessage(my, msg.chat_id, {[0] = Company.id}, 1)
tdbot.send(msg.chat_id,msg.id,'The message has been saved in the cloud','md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),CerNerCompany)
end
if cerner == 'clerk off'then
if redis:get(my..'Monshi') then
tdbot.send(msg.chat_id, msg.id, '*Clerk* `Has Been Disable`' , 'md')
redis:del(my..'Monshi')
else
tdbot.send(msg.chat_id, msg.id, '*Clerk*  is _Already_  `Disable`' , 'md')
end
end
if cerner == 'clerk on' then
if redis:get(my..'Monshi') then
tdbot.send(msg.chat_id, msg.id, '*Clerk*  is _Already_ `Enable`' , 'md')
else
tdbot.send(msg.chat_id, msg.id, '*Clerk* `Has Been Enable`' , 'md')
redis:set(my..'Monshi',true)
end
end
if cerner == 'typing on'then
if redis:get(my..'Action:'..msg.chat_id) then
tdbot.send(msg.chat_id, msg.id, '*Typing* `Has Been Enable`' , 'md')
redis:del(my..'Action:'..msg.chat_id)
else
tdbot.send(msg.chat_id, msg.id, '*Typing*  is _Already_  `Enable`' , 'md')
end
end
if cerner == 'typing off' then
if redis:get(my..'Action:'..msg.chat_id) then
tdbot.send(msg.chat_id, msg.id, '*Typing*  is _Already_ `Disable`' , 'md')
else
tdbot.send(msg.chat_id, msg.id, '*Typing* `Has Been Disable`' , 'md')
redis:set(my..'Action:'..msg.chat_id,true)
end
end
if cerner == 'flood lock' then
if redis:get(my..'Flood:Pv:'..my) then
tdbot.send(msg.chat_id, msg.id, '*Flood lock*  is _Already_  `Enable`' , 'md')
else
tdbot.send(msg.chat_id, msg.id, '*Flood lock* `Has Been Enable`' , 'md')
redis:set(my..'Flood:Pv:'..my,true)
end
end
if cerner == 'malevolent off'then
if redis:get(my..'Malevolent') then
tdbot.send(msg.chat_id, msg.id, '*Malevolent* `Has Been Disable`' , 'md')
redis:del(my..'Malevolent')
else
tdbot.send(msg.chat_id, msg.id, '*Malevolent*  is _Already_  `Disable`' , 'md')
end
end--
if cerner == 'malevolent on' then
if redis:get(my..'Malevolent') then
tdbot.send(msg.chat_id, msg.id, '• *Malevolent*  is _Already_ `Enable`' , 'md')
else
tdbot.send(msg.chat_id, msg.id, '• *Malevolent* `Has Been Enable`' , 'md')
redis:set(my..'Malevolent',true)
end
end
if cerner == 'echo off'then
if redis:get(my..'Echo'..msg.chat_id) then
tdbot.send(msg.chat_id, msg.id, '• *Echo* `Has Been Disable`' , 'md')
redis:del(my..'Echo'..msg.chat_id)
else
tdbot.send(msg.chat_id, msg.id, '•  *Echo*  is _Already_  `Disable`' , 'md')
end
end
if cerner == 'echo on' then
if redis:get(my..'Echo'..msg.chat_id) then
tdbot.send(msg.chat_id, msg.id, '• *Echo*  is _Already_ `Enable`' , 'md')
else
tdbot.send(msg.chat_id, msg.id, '• *Echo* `Has Been Enable`' , 'md')
redis:set(my..'Echo'..msg.chat_id,true)
end
end
if cerner == 'bc' and tonumber(msg.reply_to_message_id) > 0 then
function CerNerCompany(CerNer,Company)
local text = Company.content.text
local list = redis:smembers(my..'AllGroup')
for k,v in pairs(list) do
tdbot.sendText(v, 0, text, 'md')
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),CerNerCompany)
end
if cerner == 'panel' then
local text = '`Settings For SelfBot`'
if not redis:get(my..'Action:'..msg.chat_id) then
Typing = 'Enable'
else
Typing = 'Disable'
end
if redis:get(my..'MessageClerk') then
clerk = redis:get(my..'MessageClerk')
else
clerk = 'مشترک مورد نظر در دسترس نمیباشد'
end
if redis:get(my..'MarkReed:') then
Mark = 'Enable'
else
Mark = 'Disable'
end
if redis:get(my..'Echo'..msg.chat_id) then
Echo = 'Enable'
else
Echo = 'Disable'
end
if redis:get(my..'Monshi') then
Clerk = 'Enable'
else
Clerk = 'Disable'
end
if redis:get(my..'Answer') then
Answer = 'Enable'
else
Answer = 'Disable'
end
if redis:get(my..'Flood:Pv:'..my) then
flood = 'Enable'
else
flood = 'disable'
end
if redis:get(my..'Malevolent') then
Malevolent = 'Enable'
else
Malevolent = 'Disable'
end
local totalredis = io.popen("du -h /var/lib/redis/dump.rdb"):read("*a")
sizered= string.gsub(totalredis, "/var/lib/redis/dump.rdb","")
local totalbot = io.popen("du -h ./bot/bot.lua"):read("*a")
SourceSize = string.gsub(totalbot, "./bot/bot.lua","")
local timeoff = redis:get(my..'Offlined:') or 'نامعلوم'
local timeon = redis:get(my..'Onlined:') or 'نامعلوم'
text = text..'\n☢️ Typing ~ '..Typing..'\n\n✅Markread ~ '..Mark..'\n\n📛Malevolent ~ '..Malevolent..'\n\n📣Answer ~ '..Answer..'\n\n🔈Echo ~ '..Echo..'\n\n👩‍⚕Clerk ~ '..Clerk..'\n\nClerk Message : '..clerk..'\n\n[ ⏸Onlined ~ '..timeon..' ]\n\n[ ▶️Offlined ~ '..timeoff..' ]\n\nPersonal security : \n{\nFlood : '..flood..'\nFlood max : '..flood_MAX..'\nTime Check : '..TIME_CHECK..'\n}\nRedis Size : '..sizered..'\nSource Size : '..SourceSize..'\nCerNerCopmpany'
tdbot.send(msg.chat_id,msg.id,text,'md')
end
if cerner == 'mydel' then
tdbot.deleteMessagesFromUser(msg.chat_id, msg.sender_user_id) 
end
if cerner == 'setclerkmessage' and tonumber(msg.reply_to_message_id) > 0 then
function CerNerCompany(CerNer,Company)
redis:set(my..'MessageClerk',Company.content.text)
tdbot.send(msg.chat_id,msg.id,'Done ! \nClerk Message Has been saved !','md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),CerNerCompany)
end
if cerner and cerner:match('^setflood (%d+)') then
local num = cerner:match('^setflood (%d+)')
if tonumber(num) < 2 then
tdbot.send(msg.chat_id, msg.id," Select a number *Greater* than `2` !", "md")
else
redis:set(my..'Flood:Max:'..my,num)
tdbot.send(msg.chat_id, msg.id, "Flood *Sensitivity* Change to `" ..num.. "` !", "md")
end
end
if cerner and cerner:match('^setfloodtime (%d+)') then
local num = cerner:match('^setfloodtime (%d+)')
if tonumber(num) < 2 then
tdbot.send(msg.chat_id, msg.id," Select a number *Greater* than `2` !", "md")
else
redis:set(my..'Flood:Time:'..my,num)
tdbot.send(msg.chat_id, msg.id, "Flood Time *Sensitivity* Change to `" ..num.. "` !", "md")
end
end
 if cerner == 'fwd' and tonumber(msg.reply_to_message_id) > 0 then
function CerNerCompany(CerNer,Company)
local list = redis:smembers(my..'AllGroup')
for k,v in pairs(list) do
tdbot.forwardMessage(v, msg.chat_id, {[0] = Company.id}, 1)
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),CerNerCompany)
end
if cerner and cerner:match('^gifset (.*)') and tonumber(msg.reply_to_message_id) > 0 then
local cmd = cerner:match('^gifset (.*)')
function Tonote(CerNer,Company)
if Company.content._ == 'messageAnimation' then
local gif = Company.content.animation.animation.persistent_id
redis:set(my..'Gifs:'..cmd,gif)
redis:sadd(my..'GifsCloud:',cmd)
tdbot.send(msg.chat_id,msg.id,'Done\nGif : '..cmd..' Has been Saved','md')
else
tdbot.send(msg.chat_id,msg.id,'Error not found !','md')
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Tonote)
end
if cerner and cerner:match('^gifdel (.*)') then local gif = cerner:match('^gifdel (.*)') redis:del(my..'Gifs:'..gif) redis:srem(my..'GifsCloud:',gif) tdbot.send(msg.chat_id,msg.id,'Done\nGif : '..gif..' Has been Deleted !','md') 
end
if cerner == 'gifs' then
local GifsCloud = redis:smembers(my..'GifsCloud:')
local t = 'gifs: \n'
for k,v in pairs(GifsCloud) do
t = t..k.." - `"..v.."`\n" 
end
if #GifsCloud == 0 then
t = 'Empty'
end
tdbot.send(msg.chat_id, msg.id,t, 'md')
end
if cernerw and redis:get(my.."Gifs:"..cernerw) then
local  s = redis:get(my.."Gifs:"..cernerw)
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
tdbot.sendGif(msg.chat_id, msg.reply_to_message_id or msg.id,s,'')
end
if cerner and cerner:match('^save (.*)') and tonumber(msg.reply_to_message_id) > 0 then
local get = cerner:match('^save (.*)')
function Save(CerNer,Company)
if Company.content._ == 'messageDocument' then
redis:set(my.."DOC:"..get,Company.content.document.document.persistent_id)
redis:sadd(my.."Files:",get)
redis:set(my..'filetype:'..get,'Document')
redis:set(my.."FileSize:"..get,Company.content.document.document.size)
tdbot.send(msg.chat_id,msg.id,'Done! File saved !\nFor getfile  : get '..get..'\nTypeFile : Document','md')
elseif Company.content._ == 'messagePhoto' then
redis:set(my.."PHOTO:"..get,Company.content.photo.sizes[0].photo.persistent_id)
redis:set(my.."FileSize:"..get,Company.content.photo.sizes[0].photo.size)
redis:sadd(my.."Files:",get)
redis:set(my..'filetype:'..get,'Photo')
tdbot.send(msg.chat_id,msg.id,'Done! File saved !\nFor getfile  : get '..get..'\nTypeFile : Photo','md')
elseif Company.content._ == 'messageAnimation' then
local gif = Company.content.animation.animation.persistent_id
redis:set(my..'GIFS:'..get,gif)
redis:set(my.."FileSize:"..get,Company.content.animation.animation.size)
redis:sadd(my.."Files:",get)
redis:set(my..'filetype:'..get,'Gif')
tdbot.send(msg.chat_id,msg.id,'Done! File saved !\nFor getfile  : get '..get..'\nTypeFile : Gif','md')
elseif Company.content._ == 'messageVideo' then
redis:set(my.."VIDEO:"..get,Company.content.video.video.persistent_id)
redis:set(my.."FileSize:"..get,Company.content.video.video.size)
redis:sadd(my.."Files:",get)
redis:set(my..'filetype:'..get,'Video')
tdbot.send(msg.chat_id,msg.id,'Done! File saved !\nFor getfile  : get '..get..'\nTypeFile : Video','md')
elseif Company.content._ == 'messageAudio' then
redis:set(my.."AUDIO:"..get,Company.content.audio.audio.persistent_id)
redis:set(my.."FileSize:"..get,Company.content.audio.audio.size)
redis:sadd(my.."Files:",get)
redis:set(my..'filetype:'..get,'Audio')
tdbot.send(msg.chat_id,msg.id,'Done! File saved !\nFor getfile  : get '..get..'\nTypeFile : Audio','md')
elseif Company.content._ == 'messageVoice' then
redis:set(my.."VOICE:"..get,Company.content.voice.voice.persistent_id)
redis:set(my.."FileSize:"..get,Company.content.voice.voice.size)
redis:sadd(my.."Files:",get)
redis:set(my..'filetype:'..get,'Voice')
tdbot.send(msg.chat_id,msg.id,'Done\nFor Get : '..get,'md')
tdbot.send(msg.chat_id,msg.id,'Done! File saved !\nFor getfile  : get '..get..'\nTypeFile : Voice','md')
elseif Company.content._ == 'messageVideoNote' then
redis:set(my.."VIDEONOTE:"..get,Company.content.video_note.video.persistent_id)
redis:set(my.."FileSize:"..get,Company.content.video_note.video.size)
redis:sadd(my.."Files:",get)
redis:set(my..'filetype:'..get,'VideoNote')
tdbot.send(msg.chat_id,msg.id,'Done! File saved !\nFor getfile  : get '..get..'\nTypeFile : VideoNote','md')
elseif Company.content._ == 'messageContact' then
redis:set(my.."Contact:"..get,Company.content.contact.phone_number)
redis:sadd(my.."Files:",get)
redis:set(my..'filetype:'..get,'Contact')
tdbot.send(msg.chat_id,msg.id,'Done! File saved !\nFor getfile  : get '..get..'\nTypeFile : Contact','md')
else
tdbot.send(msg.chat_id,msg.id,'Error not found !','md')
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Save)
end
if cerner == 'files' then
local files = redis:smembers(my..'Files:')
local ww = io.popen('cd DWN && ls'):read("*all") or 'Empty'
local t = 'Files: in Dwn folder : \n'..ww..'\nFiles: in Database : \n'
for k,v in pairs(files) do
local sixe = redis:get(my.."FileSize:"..v) or ''
local type = redis:get(my..'filetype:'..v) or 'UnSupported'
t = t..k.." - *"..v.."*  Type > `"..type.."`  *"..sixe.."* KB\n" 
end
if #files == 0 then
t = 'Empty'
end
tdbot.send(msg.chat_id, msg.id,t, 'md')
end
if cerner == 'clean files' then
local files = redis:smembers(my..'Files:')
local t = 'Done \n'
for k,v in pairs(files) do
t = t..#files.." Files deleted\n" 
redis:srem(my..'Files:',v)
redis:del(my.."FileSize:"..v)
redis:del(my..'filetype:'..v)
end
if #files == 0 then
t = 'Empty'
end
tdbot.send(msg.chat_id, msg.id,t, 'md')
end
if cerner and cerner:match('^stickerset (.*)') and tonumber(msg.reply_to_message_id) > 0 then
local cmd = cerner:match('^stickerset (.*)')
function Saved(CerNer,Company)
if Company.content._ == 'messageSticker' then
redis:set(my..'STICKERS:'..cmd,Company.content.sticker.sticker.persistent_id)
redis:sadd(my..'StickersCloud:',cmd)
tdbot.send(msg.chat_id,msg.id,'Done\nSticker : '..cmd..' Has been Saved','md')
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Saved)
end
if cerner == 'stickers' then
local StickersCloud = redis:smembers(my..'StickersCloud:')
local t = 'Stickers: \n'
for k,v in pairs(StickersCloud) do
t = t..k.." - `"..v.."`\n" 
end
if #StickersCloud == 0 then
t = 'Empty'
end
tdbot.send(msg.chat_id, msg.id,t, 'md')
end
if cerner and cerner:match('^stickerdel (.*)')  then
local sticker = cerner:match('^stickerdel (.*)')
redis:del(my..'STICKERS:'..sticker)
redis:srem(my..'StickersCloud:',sticker)
tdbot.send(msg.chat_id,msg.id,'Done\nSticker : '..sticker..' Has been Deleted !','md')
end
if cernerw and redis:get(my.."STICKERS:"..cernerw) then
local  s = redis:get(my.."STICKERS:"..cernerw)
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
tdbot.sendSticker(msg.chat_id, msg.reply_to_message_id or msg.id ,s)
end
if cerner and cerner:match('^get (.*)') then
local get = cerner:match('^get (.*)')
if redis:get(my.."DOC:"..get) then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
local file = redis:get(my.."DOC:"..get)
local Size = redis:get(my.."FileSize:"..get)
tdbot.sendDocument(chat_id,0,file,'File name : '..get..'\nFile Size : '..Size..' KB')
elseif redis:get(my.."GIFS:"..get) then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
local file = redis:get(my.."GIFS:"..get)
local Size = redis:get(my.."FileSize:"..get)
tdbot.sendGif(msg.chat_id, msg.reply_to_message_id or msg.id,file,'File name : '..get..'\nFile Size : '..Size..' KB')
elseif redis:get(my.."VIDEONOTE:"..get) then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
local file = redis:get(my.."VIDEONOTE:"..get)
local Size = redis:get(my.."FileSize:"..get)
tdbot.sendVideoNote(msg.chat_id,0,file)
elseif redis:get(my.."Contact:"..get) then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
local file = redis:get(my.."Contact:"..get)
tdbot.sendContact(msg.chat_id,0,file,'Nil','#CerNerCompany', 0)
elseif redis:get(my.."VOICE:"..get) then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
local file = redis:get(my.."VOICE:"..get)
local Size = redis:get(my.."FileSize:"..get)
tdbot.sendVoice(msg.chat_id,0, file,'File name : '..get..'\nFile Size : '..Size..' KB')
elseif redis:get(my.."AUDIO:"..get) then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
local file = redis:get(my.."AUDIO:"..get)
local Size = redis:get(my.."FileSize:"..get)
tdbot.sendAudio(msg.chat_id,0,file,'File name : '..get..'\nFile Size : '..Size..' KB')
elseif redis:get(my.."PHOTO:"..get) then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
local file = redis:get(my.."PHOTO:"..get) 
local Size = redis:get(my.."FileSize:"..get)
tdbot.sendPhoto(msg.chat_id,0,file,'File name : '..get..'\nFile Size : '..Size..' KB')
elseif redis:get(my.."VIDEO:"..get) then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
local file = redis:get(my.."VIDEO:"..get)
local Size = redis:get(my.."FileSize:"..get)
tdbot.sendVideo(msg.chat_id,0,file,'File name : '..get..'\nFile Size : '..Size..' KB')
-----------------------------------------------------------------------------------------------------------------------
else
tdbot.send(msg.chat_id,msg.id,'Error not found !','md')
end
end
if cerner == '9gag' then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
    local url, title = get_9GAG()
    local gag_file = '/tmp/gag.jpg'
    local g_file = ltn12.sink.file(io.open(gag_file, 'w'))
    http.request {
        url = url,
        sink = g_file,
      }
tdbot.sendPhoto(msg.chat_id, msg.id, gag_file,'')
    end
local url = nil
if cerner == "boobs" then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
url = getRandomBoobs()
url = getRandomButts()
if url ~= nil then
local url = DownloadFile(url,'DWN/boobs.png')
tdbot.sendPhoto(msg.chat_id,0,url,'')
else
tdbot.send(msg.chat_id,msg.id,'Error not found !','md')
end
end
if cernerw and cernerw:match('^dlmp3 (http://%S+).[mp3]') or cernerw and cernerw:match('^dlmp3 (https://%S+).[mp3]') then
if cernerw:match('^dlmp3 http://%S+.mp3') or cernerw:match('^dlmp3 https://%S+.mp3') then
print 'Dowload Mp3 File' 
local ul = cernerw:match('^dlmp3 (.+)') 
tdbot.send(msg.chat_id,msg.id,'Downloading.....!','md')
local url = download(ul,'/1366.mp3')
tdbot.sendAudio(msg.chat_id,0,url,'Self Downloader','')
else
tdbot.send(msg.chat_id,msg.id,'Error 404! \nThis is not a mp3 . !','md')
end
end
if cernerw and cernerw:match('^dlmp4 (http://%S+).[mp4]') or cernerw and cernerw:match('^dlmp4 (https://%S+).[mp4]') then
if cernerw and cernerw:match('^dlmp4 http://%S+.mp4') or cernerw and cernerw:match('^dlmp4 https://%S+.mp4') then
tdbot.send(msg.chat_id,msg.id,'Downloading.....!','md')
print 'Dowload Mp4 File' 
local ul = cernerw:match('^dlmp4 (.+)') 
local url = download(ul,'/1364.mp4')
tdbot.sendVideo(msg.chat_id,0,url,'Self Downloader')
else
tdbot.send(msg.chat_id,msg.id,'Error 404! \nThis is not a mp4 . !','md')
end
end
if cernerw and cernerw:match('^dlmkv (http://%S+).[mkv]') or cernerw and cernerw:match('^dlmkv (https://%S+).[mkv]') then
if cernerw and cernerw:match('^dlmkv http://%S+.mkv') or cernerw and cernerw:match('^dlmkv https://%S+.mkv') then
tdbot.send(msg.chat_id,msg.id,'Downloading.....!','md')
print 'Dowload mkv File' 
local ul = cernerw:match('^dlmkv (.+)') 
local url = download(ul,'/13689.mkv')
tdbot.send(msg.chat_id,msg.id,'Downloaded. !','md')
tdbot.send(msg.chat_id,msg.id,'Uploading.....!','md')
tdbot.sendVideo(msg.chat_id,0,url,'Self Downloader')
else
tdbot.send(msg.chat_id,msg.id,'Error 404! \nThis is not a mkv . !','md')
end
end
if cernerw and cernerw:match('^dlapk (http://%S+).[apk]') or cernerw and cernerw:match('^dlapk (https://%S+).[apk]') then
if cernerw and cernerw:match('^dlapk http://%S+.apk') or cernerw:match('^dlapk https://%S+.apk') then
tdbot.send(msg.chat_id,msg.id,'Downloading.....!','md')
print 'Dowload apk File' 
local ul = cernerw:match('^dlapk (.+)') 
local url = download(ul,'/1378.apk')
tdbot.sendDocument(chat_id,0,url,'Self Downloader')
else
tdbot.send(msg.chat_id,msg.id,'Error 404! \nThis is not a apk . !','md')
end
end
if cerner and cerner:match('^web (https?://)') then
local web = cerner:match('^web (.+).mp3')
print(web)
function Webpage(CerNer,Company)
if Company.photo then
tdbot.sendPhoto(msg.chat_id, msg.id, Company.photo.sizes[0].photo.persistent_id,'')
tdbot.send(msg.chat_id, msg.id,'Description : '..(Company.description or 'nil')..'\nSite Name : '..(Company.site_name or 'nil')..'\nTitle : '..(Company.title or 'nil'),'md')
else
tdbot.send(msg.chat_id, msg.id,'Description : '..(Company.description or 'nil')..'\nSite Name : '..(Company.site_name or 'nil')..'\nTitle : '..(Company.title or 'nil'),'md')
end
end
tdbot.GetWeb(web,Webpage)
end
if cerner and cerner:match('^calc (.*)') then
local calca = cerner:match('^calc (.*)')
Calculate(msg,calca)
end
if cerner == 'backup' then
tdbot.sendDocument(my,0,'./bot/bot.lua','Bot.lua')
tdbot.sendDocument(my,0,'./bot/utils.lua','utils.lua')
tdbot.sendDocument(my,0,'./bot/function.lua','function.lua')
tdbot.sendDocument(my,0,'/var/lib/redis/dump.rdb','redis.rdb')
tdbot.send(msg.chat_id,msg.id,'Sented!','md')
end
if cerner and cerner:match('^delfile (.*)') then
local get = cerner:match('^delfile (.*)')
if redis:get(my.."DOC:"..get) then
redis:del(my.."DOC:"..get)
redis:srem(my.."Files:",get)
redis:del(my..'filetype:'..get)
redis:del(my.."FileSize:"..get)
tdbot.send(msg.chat_id,msg.id,'Done\nFile  : '..get..' Has been Deleted !','md')
elseif redis:get(my.."GIFS:"..get) then
redis:del(my.."GIFS:"..get)
redis:srem(my.."Files:",get)
redis:del(my..'filetype:'..get)
redis:del(my.."FileSize:"..get)
tdbot.send(msg.chat_id,msg.id,'Done\nFile  : '..get..' Has been Deleted !','md')
elseif redis:get(my.."VIDEONOTE:"..get) then
redis:del(my.."VIDEONOTE:"..get)
redis:srem(my.."Files:",get)
redis:del(my..'filetype:'..get)
redis:del(my.."FileSize:"..get)
tdbot.send(msg.chat_id,msg.id,'Done\nFile  : '..get..' Has been Deleted !','md')
elseif redis:get(my.."Contact:"..get) then
redis:del(my.."Contact:"..get)
redis:srem(my.."Files:",get)
redis:del(my..'filetype:'..get)
tdbot.send(msg.chat_id,msg.id,'Done\nFile  : '..get..' Has been Deleted !','md')
elseif redis:get(my.."VOICE:"..get) then
redis:del(my.."VOICE:"..get)
redis:srem(my.."Files:",get)
redis:del(my..'filetype:'..get)
redis:del(my.."FileSize:"..get)
tdbot.send(msg.chat_id,msg.id,'Done\nFile  : '..get..' Has been Deleted !','md')
elseif redis:get(my.."AUDIO:"..get) then
redis:del(my.."AUDIO:"..get)
redis:srem(my.."Files:",get)
redis:del(my..'filetype:'..get)
redis:del(my.."FileSize:"..get)
tdbot.send(msg.chat_id,msg.id,'Done\nFile  : '..get..' Has been Deleted !','md')
elseif redis:get(my.."PHOTO:"..get) then
redis:del(my.."PHOTO:"..get) 
redis:srem(my.."Files:",get)
redis:del(my..'filetype:'..get)
redis:del(my.."FileSize:"..get)
tdbot.send(msg.chat_id,msg.id,'Done\nFile  : '..get..' Has been Deleted !','md')
elseif redis:get(my.."VIDEO:"..get) then
redis:del(my.."VIDEO:"..get)
redis:srem(my.."Files:",get)
redis:del(my..'filetype:'..get)
redis:del(my.."FileSize:"..get)
tdbot.send(msg.chat_id,msg.id,'Done\nFile  : '..get..' Has been Deleted !','md')
-----------------------------------------------------------------------------------------------------------------------
else
tdbot.send(msg.chat_id,msg.id,'Error not found !','md')
end
end
 if cerner == 'delall' and tonumber(msg.reply_to_message_id) > 0  then
function DelallByReply(CerNer,Company)
tdbot.deleteMessagesFromUser(msg.chat_id, Company.sender_user_id) 
tdbot.send(msg.chat_id, msg.id,  '`All messages user :` *'..Company.sender_user_id..'* Has Been *Deleted* ', 'md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DelallByReply)
end
if cerner == 'reload' then
for k,v in pairs(reloading) do
tdbot.send(msg.chat_id,msg.id,v,'md')
end
dofile('./bot/bot.lua')
end
if cerner == 'dump' then 
function VarDump(CerNer,Company)
local TeXT = serpent.block(Company, {comment=false})
text= string.gsub(TeXT, "\n","\n\r\n")
tdbot.send(msg.chat_id, msg.id, text,'html')
 end
if tonumber(msg.reply_to_message_id) == 0 then
else
tdbot.getMessage(msg.chat_id, 
tonumber(msg.reply_to_message_id),VarDump)
end
end

if cerner == 'inv' and tonumber(msg.reply_to_message_id) > 0 then
function InviteByReply(CerNer,Company)
tdbot.addChatMembers(msg.chat_id,Company.sender_user_id)
tdbot.send(msg.chat_id, msg.id,  '`User :` *'..Company.sender_user_id..'* Has Been *Add* to Group', 'md')
end
tdbot.getMessage(msg.chat_id,tonumber(msg.reply_to_message_id),InviteByReply)
end
if cerner and cerner:match('^inv (%d+)') then
local ID = cerner:match('^inv (%d+)')
tdbot.addChatMembers(msg.chat_id,ID)
tdbot.send(msg.chat_id, msg.id,  '`User :` *'..ID..'* Has Been *Add* to Group', 'md')
end
if cerner == 'call' and tonumber(msg.reply_to_message_id) > 0 then
function InviteByReply(CerNer,Company)
tdbot.createCall(Company.sender_user_id)
tdbot.send(msg.chat_id, msg.id,  'Call is ongoing!', 'md')
end
tdbot.getMessage(msg.chat_id,tonumber(msg.reply_to_message_id),InviteByReply)
end
if cerner and cerner:match('^call @(.*)') then
local username = cerner:match('^call @(.*)')
function CreateCallByUsername(CerNer,Company)
if Company.id then
text = 'Call is ongoing!'
tdbot.createCall(Company.id)
else 
text = 'User Not Found !'
end
tdbot.send(msg.chat_id, msg.id, text, 'html')
end
tdbot.ResolveUsername(username,CreateCallByUsername)
end 
if cerner and cerner:match('^call (%d+)') then
local ID = cerner:match('^call (%d+)')
tdbot.createCall(ID)
tdbot.send(msg.chat_id, msg.id,  'Call is ongoing!', 'md')
end
if cerner and cerner:match('^addtoall (%d+)') then
local ID = cerner:match('^addtoall (%d+)')
local list = redis:smembers(my..'AllGroup')
for k,v in pairs(list) do
tdbot.addChatMember(v, ID,5)
end
tdbot.send(msg.chat_id, msg.id,  'done !', 'md')
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^call (.*)')then
local ID = cerner:match('^call (.*)')
id = msg.content.entities[0].type.user_id
tdbot.createCall(id)
tdbot.send(msg.chat_id, msg.id,  'Call is ongoing!', 'md')
end
if cerner and cerner:match('^inv @(.*)') then
local username = cerner:match('^inv @(.*)')
function InviteByUsername(CerNer,Company)
if Company.id then
text = 'User '..username.. '  Has Been *Add* to Group'
tdbot.addChatMembers(msg.chat_id,Company.id)
else 
text = 'User Not Found !'
end
tdbot.send(msg.chat_id, msg.id, text, 'html')
end
tdbot.ResolveUsername(username,InviteByUsername)
end 
if cerner == 'kick' and tonumber(msg.reply_to_message_id) > 0  then
function KickUserByReply(CerNer,Company)
tdbot.KickUser(msg.chat_id,Company.sender_user_id) 
tdbot.send(msg.chat_id, msg.id,  '*User :* `'..Company.sender_user_id..'`  Has Been *Kicked* ', 'md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),KickUserByReply)
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^id (.*)')then
local ID = cerner:match('^id (.*)')
local function GetName(CerNer, Company)
id = msg.content.entities[0].type.user_id
tdbot.send(msg.chat_id, msg.id,'`'..id..'`', 'md')
end
tdbot.getUser(id,GetName)
end
---UnMute All
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^unmute (.*)')then
local ID = cerner:match('^unmute (.*)')
local function Restrictq(CerNer, Company)
local Fid = msg.content.entities[0].type.user_id
tdbot.Restrict(msg.chat_id,Fid, 'Restricted', {1,1, 1, 1, 1, 1})
tdbot.send(msg.chat_id, msg.id,  '*User :* `'..ID..'` *can be send message and media in group* ', 'md')
end
tdbot.getUser(id,Restrictq)
end
if cerner and cerner:match('^unmute @(.*)') then
local username = cerner:match('^unmute @(.*)')
function RestrictByUsername(CerNer,Company)
if Company.id then
local ID = Company.id
text =  '*User :* `'..ID..'` *can be send message and media in group* '
tdbot.Restrict(msg.chat_id,ID, 'Restricted', {1,1, 1, 1, 1, 1})
else 
text = 'Error Not found !'
end
tdbot.send(msg.chat_id, msg.id, text, 'md')
end
tdbot.ResolveUsername(username,RestrictByUsername)
end 
if cerner == 'unmute' and tonumber(msg.reply_to_message_id) > 0  then
function KickUserByReply(CerNer,Company)
tdbot.Restrict(msg.chat_id,Company.sender_user_id, 'Restricted', {1,1, 1, 1, 1, 1})
tdbot.send(msg.chat_id, msg.id,  '*User :* `'..Company.sender_user_id..'` *can be send message and media in group* ', 'md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),KickUserByReply)
end
if cerner and cerner:match('^unmute (%d+)')then
local ID = cerner:match('^unmute (%d+)')
tdbot.Restrict(msg.chat_id,ID, 'Restricted', {1,1, 1, 1, 1, 1})
tdbot.send(msg.chat_id, msg.id,  '*User :* `'..ID..'` *can be send message and media in group* ', 'md')
end
--Mute Links
if cerner and cerner:match('^mutelinks (%d+)')then
local ID = cerner:match('^mutelinks (%d+)')
tdbot.Restrict(msg.chat_id,ID, 'Restricted', {1,0, 1, 1, 1, 0})
tdbot.send(msg.chat_id, msg.id,  '*not user:* `'..ID..'` *may add web page preview to his messages in group* ', 'md')
end
if cerner == 'mutelinks' and tonumber(msg.reply_to_message_id) > 0  then
function KickUserByReply(CerNer,Company)
tdbot.Restrict(msg.chat_id,Company.sender_user_id, 'Restricted', {1,0, 1, 1, 1, 0})
tdbot.send(msg.chat_id, msg.id,  '*not user:* `'..Company.sender_user_id..'` *may add web page preview to his messages in group* ', 'md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),KickUserByReply)
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^mutelinks (.*)')then
local ID = cerner:match('^mutelinks (.*)')
local function Restrictq(CerNer, Company)
local Fid = msg.content.entities[0].type.user_id
tdbot.Restrict(msg.chat_id,Fid, 'Restricted', {1,0, 1, 1, 1, 0})
tdbot.send(msg.chat_id, msg.id,  '*not user:* `'..ID..'` *may add web page preview to his messages in group* ', 'md')
end
tdbot.getUser(id,Restrictq)
end
if cerner and cerner:match('^mutelinks @(.*)') then
local username = cerner:match('^mute links@(.*)')
function RestrictByUsername(CerNer,Company)
if Company.id then
local ID = Company.id
text =  '*Not user:* `'..ID..'` *may add web page preview to his messages in group* '
tdbot.Restrict(msg.chat_id,ID, 'Restricted', {1,0, 1, 1, 1, 0})
else 
text = 'Error Not found !'
end
tdbot.send(msg.chat_id, msg.id, text, 'md')
end
tdbot.ResolveUsername(username,RestrictByUsername)
end 
---Mute All
if cerner == 'mute' and tonumber(msg.reply_to_message_id) > 0  then
function MuteUserByReply(CerNer,Company)
tdbot.Restrict(msg.chat_id,Company.sender_user_id, 'Restricted', {1,0, 0, 0, 0, 0})
tdbot.send(msg.chat_id, msg.id,  '*Restrict user :* `'..Company.sender_user_id..'` *from send message in group* ', 'md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),MuteUserByReply)
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^mute (.*)')then
local ID = cerner:match('^mute (.*)')
local function Restrictq(CerNer, Company)
local Fid = msg.content.entities[0].type.user_id
tdbot.Restrict(msg.chat_id,Fid, 'Restricted', {1,0, 0, 0, 0, 0})
tdbot.send(msg.chat_id, msg.id,  '*Restrict user :* `'..ID..'` *from send messagesn in group* ', 'md')
end
tdbot.getUser(id,Restrictq)
end
if cerner and cerner:match('^mute @(.*)') then
local username = cerner:match('^mute @(.*)')
function RestrictByUsername(CerNer,Company)
if Company.id then
local ID = Company.id
text =  '*Restrict user :* `'..ID..'` *from send message in group* '
tdbot.Restrict(msg.chat_id,ID, 'Restricted', {1,0, 0, 0, 0, 0})
else 
text = 'Error Not found !'
end
tdbot.send(msg.chat_id, msg.id, text, 'md')
end
tdbot.ResolveUsername(username,RestrictByUsername)
end 
if cerner and cerner:match('^mute (%d+)')then
local ID = cerner:match('^mute (%d+)')
tdbot.Restrict(msg.chat_id,ID, 'Restricted', {1,0, 0, 0, 0, 0})
tdbot.send(msg.chat_id, msg.id,  '*Restrict user :* `'..ID..'` *from send messagesn in group* ', 'md')
end
----------Mute Media
if cerner == 'mutemedia' and tonumber(msg.reply_to_message_id) > 0  then
function KickUserByReply(CerNer,Company)
tdbot.Restrict(msg.chat_id,Company.sender_user_id, 'Restricted', {1,1, 0, 0, 0, 1})
tdbot.send(msg.chat_id, msg.id,  '*Restrict user :* `'..Company.sender_user_id..'` *from send media in group* ', 'md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),KickUserByReply)
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^mutemedia (.*)')then
local ID = cerner:match('^mutemedia (.*)')
local function Restrictq(CerNer, Company)
local Fid = msg.content.entities[0].type.user_id
tdbot.Restrict(msg.chat_id,Fid, 'Restricted', {1,1, 0, 0, 0, 1})
tdbot.send(msg.chat_id, msg.id,  '*Restrict user :* '..ID..' *from send media in group* ', 'md')
end
tdbot.getUser(id,Restrictq)
end
if cerner and cerner:match('^mutemedia (%d+)')then
local ID = cerner:match('^mutemedia (%d+)')
tdbot.Restrict(msg.chat_id,ID, 'Restricted', {1,1, 0, 0, 0, 1})
tdbot.send(msg.chat_id, msg.id,  '*Restrict user :* `'..ID..'` *from send media in group* ', 'md')
end
if cerner and cerner:match('^mute media @(.*)') then
local username = cerner:match('^mute media @(.*)')
function RestrictByUsername(CerNer,Company)
if Company.id then
local ID = Company.id
text =  '*Restrict user :* `'..ID..'` *from send media in group* '
tdbot.Restrict(msg.chat_id,ID, 'Restricted', {1,1, 0, 0, 0, 1})
else 
text = 'Error Not found !'
end
tdbot.send(msg.chat_id, msg.id, text, 'md')
end
tdbot.ResolveUsername(username,RestrictByUsername)
end 
----Done
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^res (.*)')then
local ID = msg.content.entities[0].type.user_id
local function GetName(CerNer, Company)
function Get(extra, result, success) 
if Company.first_name then
CompanyName = ec_name(Company.first_name)
else  
CompanyName = 'nil'
end
if result.about then
CompanyAbout = check_markdown(result.about)
else  
CompanyAbout = 'nil'
end
if result.common_chat_count  then
Companycommon_chat_count  = result.common_chat_count 
else 
Companycommon_chat_count  = 'nil'
end
local text = [[
Firstname : ]]..CompanyName..
[[

UserName : ]]..check_markdown(Company.username)..
[[

Bio : ]]..CompanyAbout..
[[

Common Chat : ]]..Companycommon_chat_count
tdbot.send(msg.chat_id,msg.id,text,'md')
end
tdbot.getUserFull(ID,Get)
end
tdbot.getUser(ID,GetName)
end
if cerner and cerner:match('^res (%d+)') then
local ID = cerner:match('^res (%d+)')
local function GetName(CerNer, Company)
function Get(extra, result, success) 
if Company.first_name then
CompanyName = ec_name(Company.first_name)
else  
CompanyName = 'nil'
end
if result.about then
CompanyAbout = result.about
else  
CompanyAbout = 'nil'
end
if result.common_chat_count  then
Companycommon_chat_count  = result.common_chat_count 
else 
Companycommon_chat_count  = 'nil'
end
local text = [[
Firstname : ]]..CompanyName..
[[

UserName : ]]..(check_markdown(Company.username) or 'nil')..
[[

Bio : ]]..CompanyAbout..
[[

Common Chat : ]]..Companycommon_chat_count
tdbot.send(msg.chat_id,msg.id,text,'md')
end
tdbot.getUserFull(ID,Get)
end
tdbot.getUser(ID,GetName)
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^kick (.*)')then
local ID = cerner:match('^kick (.*)')
local function GetName(CerNer, Company)
id = msg.content.entities[0].type.user_id
tdbot.send(msg.chat_id, msg.id,  '`User :` *'..id..'* Has Been *Kicked* ', 'md')
KickUser(msg.chat_id,id) 
end
tdbot.getUser(id,GetName)
end
if cerner and cerner:match('^kick (%d+)') then
local ID = cerner:match('^kick (%d+)')
tdbot.KickUser(msg.chat_id,ID) 
tdbot.send(msg.chat_id, msg.id,  '`User :` *'..ID..'* Has Been *Kicked* ', 'md')
end
if cerner and cerner:match('^kick @(.*)') then
local username = cerner:match('^kick @(.*)')
function kickbyusername(CerNer,Company)
if Company.id then
text = 'User '..username.. ' Has Been kicked !'
tdbot.KickUser(msg.chat_id,Company.id) 
else 
text = 'User Not Found !'
end
tdbot.send(msg.chat_id, msg.id, text, 'html')
end
tdbot.ResolveUsername(username,kickbyusername)
end 
if cerner == 'flood unlock' then
if not redis:get(my..'Flood:Pv:'..my) then
tdbot.send(msg.chat_id, msg.id, '*Flood lock*  is _Already_  Disable' , 'md')
else
tdbot.send(msg.chat_id, msg.id, '*Flood lock* Has Been Disable' , 'md')
redis:del(my..'Flood:Pv:'..my)
end
end
if cerner == 'setenemy' and tonumber(msg.reply_to_message_id) > 0 then
function SetEnemyByReply(CerNer,Company)
if redis:sismember(my..'EnemyList:',Company.sender_user_id) then
tdbot.send(msg.chat_id, msg.id,  '`User : ` *'..Company.sender_user_id..'* is *Already* `a Enemy..!`', 'md')
else
tdbot.send(msg.chat_id, msg.id,'_ User : _ `'..Company.sender_user_id..'` *Added* to `EnemyList` ..', 'md')
redis:sadd(my..'EnemyList:',Company.sender_user_id)
tdbot.Block(Company.sender_user_id)
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetEnemyByReply)
end
if cerner and cerner:match('^setenemy @(.*)') then
local username = cerner:match('^setenemy @(.*)')
function SetVipByUsername(CerNer,Company)
if Company.id then
local ID = Company.id
if redis:sismember(my..'EnemyList:',Company.id) then
text =   '`User : ` *'..Company.id..'* is *Already* `a Enemy !`'
else
text = '_ User : _ `'..Company.id..'` *Added* to `EnemyList` !'
tdbot.Block(ID)
redis:sadd(my..'EnemyList:', Company.id)
end
else 
text = 'Error Notfound !'
end
tdbot.send(msg.chat_id, msg.id, text, 'md')
end
tdbot.ResolveUsername(username,SetVipByUsername)
end 
if cerner and cerner:match('^delenemy @(.*)') then
local username = cerner:match('^delenemy @(.*)')
function SetVipByUsername(CerNer,Company)
if Company.id then
local ID = Company.id
if redis:sismember(my..'EnemyList:',Company.id) then
text = '_ User : _ `'..ID..'` *Removed* from `EnemyList` ..'
redis:srem(my..'EnemyList:',ID)
tdbot.Unblock(ID)
else
text =  '`User : ` *'..ID..'* is *Not* ` Enemy..!`'
end
else 
text = 'Error Notfound !'
end
tdbot.send(msg.chat_id, msg.id, text, 'md')
end
tdbot.ResolveUsername(username,SetVipByUsername)
end 
if cerner and cerner:match('^setenemy (%d+)') then
local ID = cerner:match('^setenemy (%d+)')
if redis:sismember(my..'EnemyList:',ID) then
tdbot.send(msg.chat_id, msg.id,  '`User : ` *'..ID..'* is *Already* `a Enemy..!`', 'md')
else
tdbot.send(msg.chat_id, msg.id,'_ User : _ `'..ID..'` *Added* to `EnemyList..`', 'md')
redis:sadd(my..'EnemyList:',ID)
tdbot.Block(ID)
end
end
if cerner and cerner:match('^delenemy (%d+)') then
local ID = cerner:match('^delenemy (%d+)')
if redis:sismember(my..'EnemyList:',ID) then
tdbot.send(msg.chat_id, msg.id,'_ User : _ `'..ID..'` *Removed* from `EnemyList` ..', 'md')
redis:srem(my..'EnemyList:',ID)
tdbot.Unblock(ID)
else
tdbot.send(msg.chat_id, msg.id,  '`User : ` *'..ID..'* is *Not* ` Enemy..!`', 'md')
end
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^setenemy (.*)')then
local ID = cerner:match('^setenemy (.*)')
local function GetName(CerNer, Company)
id = msg.content.entities[0].type.user_id

if redis:sismember(my..'EnemyList:',id) then
tdbot.send(msg.chat_id, msg.id,  '`User : ` *'..ID..'* is *Already* `a Enemy..!`', 'md')
else
tdbot.send(msg.chat_id, msg.id,'_ User : _ `'..ID..'` *Added* to `EnemyList..`', 'md')
redis:sadd(my..'EnemyList:',id)
tdbot.Block(id)
end
end
tdbot.getUser(ID,GetName)
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^delenemy (.*)')then
local ID = cerner:match('^delenemy (.*)')
local function GetName(CerNer, Company)
id = msg.content.entities[0].type.user_id
if redis:sismember(my..'EnemyList:',id) then
tdbot.send(msg.chat_id, msg.id,'_ User : _ `'..ID..'` *Removed* from `EnemyList` ..', 'md')
redis:srem(my..'EnemyList:',id)
tdbot.Unblock(id)
else
tdbot.send(msg.chat_id, msg.id,  '`User : ` *'..ID..'* is *Not* ` Enemy..!`', 'md')
end
end
tdbot.getUser(id,GetName)
end
if cerner == 'delenemy' and tonumber(msg.reply_to_message_id) > 0 then
function SetEnemyByReply(CerNer,Company)
if redis:sismember(my..'EnemyList:',Company.sender_user_id) then
tdbot.send(msg.chat_id, msg.id,'_ User : _ `'..Company.sender_user_id..'` *Removed* from `EnemyList` ..', 'md')
redis:srem(my..'EnemyList:',Company.sender_user_id)
tdbot.Unblock(Company.sender_user_id)
else
tdbot.send(msg.chat_id, msg.id,  '`User : ` *'..Company.sender_user_id..'* is *Not* ` Enemy..!`', 'md')
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetEnemyByReply)
end
function cleanbydeleteMessagesFromUser(msg)
 local function pro(arg,data)
for k,v in pairs(data.members) do
tdbot.deleteMessagesFromUser(msg.chat_id, v.user_id) 
print(k)
end
end
print 'Clean By Del From User ' 
tdbot.getChannelMembers(msg.chat_id, 0, 200, "Recent",pro)
tdbot.send(msg.chat_id, msg.id,'All Msgs Has Been Cleaned' ,'md')
end
function cleanbysearch(msg)
local function pro(arg,data)
for k,v in pairs(data.members) do
 tdbot.deleteMessagesFromUser(msg.chat_id, v.user_id) 
print(k)
end
end
print 'Clean By Search' 
tdbot.getChannelMembers(msg.chat_id, 0, 200, "Search",pro)
end
function cleanbygetChatHistory(msg)
local function cb(arg,data)
for k,v in pairs(data.messages) do
tdbot.deleteMessages(msg.chat_id,{[0] =v.id})
print(k)
end
end
print 'Clean By getChatHistory' 
tdbot.getChatHistory(msg.chat_id,msg.id, 0,  500,cb)
end
if cerner == 'clean msgs'  then
cleanbydeleteMessagesFromUser(msg)
cleanbysearch(msg)
cleanbygetChatHistory(msg)
end
if cerner and cerner:match('^flood (%d+)')  then
function BlockedByReply(CerNer,Company)
local limit = tonumber(cerner:match('^flood (%d+)'))
for i=1,limit do
tdbot.forwardMessage(msg.chat_id, msg.chat_id, {[0] = msg.reply_to_message_id}, 1)
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),BlockedByReply)
end
if cerner == 'tosticker' and tonumber(msg.reply_to_message_id) > 0 then
function tophoto(CerNer,Company)
if Company.content._ == "messagePhoto" then
local usr = redis:get(my.."UserID")
print(usr)
if usr:match("^root$") then
tg = "/root/.telegram-bot/main"
elseif not usr:match("^root$") then
tg = "/home/" .. usr .. "/.telegram-bot/main"
tgq = "/home/" .. usr .. "/.telegram-bot/"
end
 file = Company.content.photo.id
print(file)
local pathf = tg .. "/files/photos/" .. file .. ".jpg"
print(pathf)
tdbot.sendSticker(msg.chat_id, 0, pathf)
tdbot.sendDocument(chat_id,0,pathf,'')
end
end
tdbot.getMessage(msg.chat_id, msg.reply_to_message_id, tophoto)
end
if cerner and cerner:match('^block @(.*)') then
local username = cerner:match('^block @(.*)')
function blockbyusername(CerNer,Company)
if Company.id then
text = 'User `'..username.. '` Has Been blocked !'
tdbot.Block(Company.id) 
else 
text = 'User Not Found !'
end
tdbot.send(msg.chat_id, msg.id, text, 'html')
end
tdbot.ResolveUsername(username,blockbyusername)
end
if cerner and cerner:match('^unblock @(.*)') then
local username = cerner:match('^unblock @(.*)')
function unblockbyusername(CerNer,Company)
if Company.id then
text = 'User `'..username.. '` Has Been unblocked !'
tdbot.Unblock(Company.id) 
else 
text = 'User Not Found !'
end
tdbot.send(msg.chat_id, msg.id, text, 'html')
end
tdbot.ResolveUsername(username,unblockbyusername)
end
if cerner == 'block' and tonumber(msg.reply_to_message_id) > 0 then
function BlockedByReply(CerNer,Company)
tdbot.Block(Company.sender_user_id)
tdbot.send(msg.chat_id,msg.id,'User `'..Company.sender_user_id..'` Has been blocked !','md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),BlockedByReply)
end
if cerner == 'unblock' and tonumber(msg.reply_to_message_id) > 0 then
function BlockedByReply(CerNer,Company)
tdbot.Unblock(Company.sender_user_id)
tdbot.send(msg.chat_id,msg.id,'User `'..Company.sender_user_id..'` Has been unblocked !','md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),BlockedByReply)
end
if cerner and cerner:match('^block (%d+)')  then
local id = tonumber(cerner:match('^block (%d+)'))
tdbot.Block(id)
tdbot.send(msg.chat_id,msg.id,'User `'..id..'` Has been blocked !','md')
end
if cerner and cerner:match('^unblock (%d+)')  then
local id = tonumber(cerner:match('^unblock (%d+)'))
tdbot.Unblock(id)
tdbot.send(msg.chat_id,msg.id,'User `'..id..'` Has been unblocked !','md')
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^block (.*)')then
local ID = cerner:match('^block (.*)')
local function GetName(CerNer, Company)
id = msg.content.entities[0].type.user_id
tdbot.send(msg.chat_id,msg.id,'User `'..ID..'` Has been blocked !','md')
tdbot.Block(id)
end
tdbot.getUser(id,GetName)
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^unblock (.*)')then
local ID = cerner:match('^unblock (.*)')
local function GetName(CerNer, Company)
id = msg.content.entities[0].type.user_id
tdbot.send(msg.chat_id,msg.id,'User `'..ID..'` Has been unblocked !','md')
tdbot.Unblock(id)
end
tdbot.getUser(id,GetName)
end
if cerner == 'enemylist' then
local Cleaner = redis:smembers(my..'EnemyList:')
local t = 'EnemyList: \n'
for k,v in pairs(Cleaner) do
t = t..k.." - `"..v.."`\n" 
end
if #Cleaner == 0 then
t = 'Empty'
end
tdbot.send(msg.chat_id, msg.id,t, 'md')
end
if cerner == 'share' then
function Share(CerNer,Company)
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
tdbot.sendContact(msg.chat_id,msg.id,Company.phone_number,Company.first_name, (Company.last_name or ''), 0)
end
tdbot.getMe(Share)
end
if cernerbk == '#bk' then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
tdbot.sendVideoNote(msg.chat_id,msg.reply_to_message_id or msg.id ,'./bot/BK.jpg','06')
end
if cerner == 'addc' and tonumber(msg.reply_to_message_id) > 0 then
function SaveCo(CerNer,Company)
if Company.content._ == 'messageContact' then
tdbot.importContact(Company.content.contact.phone_number,Company.content.contact.first_name,'#CerNerCompany', 0)
tdbot.send(msg.chat_id, msg.id,'`Contact Has Been Saved !`', 'md')
end
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SaveCo)
end
if cerner == 'id' and tonumber(msg.reply_to_message_id) > 0 then
function GetID(CerNer,Company)
tdbot.send(msg.chat_id, msg.id,'`'..Company.sender_user_id..'`', 'md')
end
tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GetID)
end
if cerner and msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" and cerner:match('^id (.*)')then
local ID = cerner:match('^id (.*)')
local function GetName(CerNer, Company)
id = msg.content.entities[0].type.user_id
tdbot.send(msg.chat_id, msg.id,  '`'..id..'`\n'..ID, 'md')
end
tdbot.getUser(id,GetName)
end
if cerner == 'del' and tonumber(msg.reply_to_message_id) > 0 then
tdbot.deleteMessages(msg.chat_id,{[0] =msg.reply_to_message_id})
tdbot.deleteMessages(msg.chat_id,{[0] =msg.id})
end
if cerner == 'pin' and tonumber(msg.reply_to_message_id) > 0 then
tdbot.Pin(msg.chat_id,msg.reply_to_message_id,0)
tdbot.send(msg.chat_id,msg.id,'`Message has been pinned !`', 'md')
end
if cerner == 'unpin'  then
tdbot.Unpin(msg.chat_id)
tdbot.send(msg.chat_id,msg.id,'`Message has been Unpinned !`', 'md')
end
if cerner == 'ping' then
tdbot.send(msg.chat_id, msg.id,'`pong`', 'md')
end
if cerner and cerner:match('^id @(.*)') then
local UserName = cerner:match('^id @(.*)')
function ID(CerNer,Company)
if Company.id then
text = '[`'..Company.id..'`]'
tdbot.send(msg.chat_id, msg.id, text, 'md')
end
end
tdbot.ResolveUsername(UserName,ID)
end
end
--------
end
end --Nmd
end --Ch
--------------
function tdbot_update_callback(data)
if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then
GetMessages(data.message,data)
 local msg = data.message 
elseif (data._== "updateMessageEdited") then
GetMessages(data.message,data)
data = data
local function edit(sepehr,amir,hassan)
GetMessages(amir,data)
end
assert (tdbot_function ({_ = "getMessage", chat_id = data.chat_id,message_id = data.message_id }, edit, nil))
assert (tdbot_function ({_ = "openChat",chat_id = data.chat_id}, dl_cb, nil) )
assert (tdbot_function ({_="getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=20}, dl_cb, nil))
end
end
--End Version 1 
