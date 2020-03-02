https = require("requests")
client = require("redis")
  redis = client.connect('127.0.0.1', 6379)
json = require("dkjson")
hash = redis:get('WARP:W8:')
function genString(number)
  arg_ = io.popen('python ./WARP/genString.py '..number):read('all')
  return arg_
end
serpent = require "serpent"
function vardump(PRE)
  print(serpent.block(PRE, {comment=false}))
  end
  function sleep(n)
    os.execute("sleep " .. tonumber(n))
  end
  function sendUpdates()
install_id = genString(11):gsub("\n","")
  body_ = {
    ["key"] = genString(42):gsub("\n",""),
  ["install_id"] = install_id,
  ["fcm_token"] = ""..install_id..":APA91b"..genString(134):gsub("\n",""),
  ["referrer"] = tostring(hash),
  ["warp_enabled"] = false,
  ["tos"] = os.date("%Y-%m-%dT%H:%m:%S.000+07:00"),
  ["type"] = "Android",
  ["locale"] =  "zh-CN"
}

 body = json.encode(body_)
    url = "https://api.cloudflareclient.com/v0a745/reg"
 
    headers = {
        ['Content-Type'] =  'application/json; charset=UTF-8',

               ['Host'] = 'api.cloudflareclient.com',
               ['Connection'] = 'Keep-Alive',
              ['Accept-Encoding'] = 'gzip',
              ['User-Agent'] = 'okhttp/3.12.1'
               }

               r = https.post{url, data=body, headers=headers}
               return r 
            end
           if hash then
while true do
  if   not redis:get('WARP:stop:') then
    result  = sendUpdates()
    if  result.status_code == 200 then
        redis:del(hash..'WARP:SLEEP')
     
        amir = (redis:get(hash..'GB:ADD') or 0) + 1
        redis:set(hash..'GB:ADD',amir)

        print('added', amir)
        dofile('./WARP/warp.lua')
    else 
        sleep(60)
        print('sleep')
        
        redis:set(hash..'WARP:SLEEP','true')
    end

  end

  end

end
