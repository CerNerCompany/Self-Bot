#!/usr/bin/env lua
PTH = '/usr/lib/x86_64-linux-gnu/lua/5.2/'
require("U-T.utils") 
reset = function()
if isFile('./CRCO-TG') then
  os.execute('rm -rf ./CRCO-TG')
    print("\027[" .. color.black[1] .. ";" .. color.red[2] .. "m ==> Self Bot reseted account \027[00m")
    else
print("\027[" .. color.black[1] .. ";" .. color.green[2] .. "m ==> Account not found\027[00m")
    end
      end

if config and config.info then
api_id = config.info.api_id 
api_hash = config.info.api_hash
end
 if exists(PTH..'tdlua.so')  then
 tdlua = require("tdlua") 

 tdlua.setLogLevel(5)
tdlua.setLogPath("tdlua.log")
 client = tdlua()
client:send(
  (
      {["@type"] = "getAuthorizationState"}
  )
)
end
dbpassword = ""

local color = {
    black = {30, 40},
    red = {31, 41},
    green = {32, 42},
    yellow = {33, 43},
    blue = {34, 44},
    magenta = {35, 45},
    cyan = {36, 46},
    white = {37, 47}
}
ConfigSelf = function()
  if isFile('./U-T/config.lua')  then
    print("==> Config File already exists")
  else
  io.write([[

 => Enter Self-ID : 
 
 Exapmle : 37134547 
 ]]
 )
   selfid = tonumber(io.read())
  io.write([[

 Enter your API-ID : 
 
 Exapmle : 123456
  ]]
 )
   API_ID = tonumber(io.read())
  io.write([[

 Enter API HASH  : 
 
 Exapmle : 59fdacaf9d5801315a16970a259d932a
 ]]
 )
   API_HASH = tostring(io.read())

   configEnv.info = {
   sudo_id = {selfid},
   api_id = API_ID, 
   api_hash = API_HASH
   }
   
CreateFile(configEnv , "./U-T/config.lua")
print("\027[" .. color.white[1] .. ";" .. color.black[2] .. "m ==> Config Created ! \027[00m")
end
end
local function vardump(wut)
  print(serpent.block(wut, {comment=false}))
end

  local function oldtonew(t)
    if type(t) ~= "table" then return t end
    for _, v in pairs(t) do
      if type(v) == "table" then
        oldtonew(v)
      end
    end
    if not t["@type"] then
      t["@type"] = t._
    end
    return t
  end
  
  local function newtoold(t)
    if type(t) ~= "table" then return t end
    for _, v in pairs(t) do
      if type(v) == "table" then
        newtoold(v)
      end
    end
    if t["@type"] then
      t._ = t["@type"]
    end
    return t
  end
 
  
 
  local function authstate(state)
 
    local ready = false
    
        if state["@type"] == "authorizationStateClosed" then
            return true
        elseif state["@type"] == "authorizationStateWaitTdlibParameters" then
            client:send({
                    ["@type"] = "setTdlibParameters",
                  parameters = {
                  ["@type"] = "setTdlibParameters",
                  use_message_database = true,
                  api_id = api_id,
                  api_hash = api_hash,
                  system_language_code = "en",
                  device_model = "CRCO-SELF",
                  system_version = "BETA: 2",
                  application_version = "BETA : 2",
                  enable_storage_optimizer = true,
                  use_pfs = true,
                  database_directory = "./CRCO-TG"
                    }
                }
            )
        elseif state["@type"] == "authorizationStateWaitEncryptionKey" then
            client:send({
                    ["@type"] = "checkDatabaseEncryptionKey",
                    encryption_key = dbpassword
                }
            )
        elseif state["@type"] == "authorizationStateWaitPhoneNumber" then
            print("\027[" .. color.black[1] .. ";" .. color.cyan[2] .. "m ==> Do you want to login as a Bot or as an User? [user/bot] \027[00m")
              if match('bot','b','api','botapi')[io.read():lower()] then
                print("\027[" .. color.black[1] .. ";" .. color.green[2] .. "m ==> Enter bot token:  \027[00m")
                local token = io.read()
                client:send({
                        ["@type"] = "checkAuthenticationBotToken",
                        token = token
                    }
                )
            else
                print("\027[" .. color.black[1] .. ";" .. color.green[2] .. "m ==> Enter phone Number :  \027[00m")
                local phone = io.read()
                client:send({
                        ["@type"] = "setAuthenticationPhoneNumber",
                        phone_number = phone
                    }
                )
            end
        elseif state["@type"] == "authorizationStateWaitCode" then
            print("\027[" .. color.black[1] .. ";" .. color.green[2] .. "m ==> Enter Code :  \027[00m")
            local code = io.read()
            client:send({
                    ["@type"] = "checkAuthenticationCode",
                    code = code
                }
            )
        elseif state["@type"] == "authorizationStateWaitPassword" then
            print("\027[" .. color.black[1] .. ";" .. color.green[2] .. "m ==> Enter password :  \027[00m")
            local password = io.read()
            client:send({
                    ["@type"] = "checkAuthenticationPassword",
                    password = password
                }
            )
        elseif state["@type"] == "authorizationStateReady" then
            ready = true
            print("==> Login Successfully Let's rock :)")
            client:close(true)
        end
      
        return false
    end
    
    local function err(e)
      return e .. " " .. debug.traceback()
    end
  
   local client = setmetatable({_client = client}, {__index = function(_, call) return function(self, params)
        return newtoold(self._client[call](self._client, type(params) == "table" and oldtonew(params) or params)) end end})
     function run(cb)
        local callback = cb 
        while true do
            local res = client:receive(1)
            if res then
            
  
                if type(res) ~= "table" then
                    goto continue
                end
                if not ready or res["@type"] == "updateAuthorizationState" then
                    local mustclose = authstate(res.authorization_state and res.authorization_state or res)
                    if mustclose then
                        client = nil
                        break
                    end
                    goto continue
                end
              ::continue::
            end
        end
    end
    
  


  if arg[1] == 'LOGIN_BOT' then
    run()
  elseif arg[1] == 'CONFIG_BOT' then
    ConfigSelf() 
elseif arg[1] == 'RESET_BOT' then
    reset()
  
elseif arg[1] == 'START_BOT' then
  os.execute('lua ./Bot/MAIN.lua'):print(read('*a'))
end

