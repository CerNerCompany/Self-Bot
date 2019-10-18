require("U-T.utils")
 tdlua = require "tdlua"
local client = tdlua()
client:send(
    (
        {["@type"] = "getAuthorizationState"}
    )

)
local api_id = config.info.api_id
local api_hash = config.info.api_hash
local dbpassword = ""
tdlua.setLogLevel(5)
tdlua.setLogPath("tdlua.log")
local ready = false

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
                system_version = "CRCO-BASE: 1.3",
                application_version = "BETA : 2.1",
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
    print("\027[" .. color.black[1] .. ";" .. color.cyan[2] .. "m ==> Login Again : ./XPM login \027[00m")
    os.execute('rm -rf ./CRCO-TG tdlua.log')
    os.exit(1)
elseif state["@type"] == "authorizationStateReady" then
    ready = true
    print("==> Launch Successfully Let's rock")

end
return false
end


local function err(e)
  return e .. " " .. debug.traceback()
end

local function _call(params, cb, extra)
    local res = client:execute(params)
    if type(cb) == "function" then
        if type(res) == "table" then
            local ok, rres = xpcall(cb, err, extra, res)
            if not ok then
                print("Result cb failed", rres, debug.traceback())
                --vardump(res)
                return false
            end
            return true
        end
    end
end

local function getCallback()
    return _call
end

client = setmetatable({_client = client}, {__index = function(_, call) return function(self, params)
    return newtoold(self._client[call](self._client, type(params) == "table" and oldtonew(params) or params)) end end})

local function run(cb)
    local callback = cb or vardump
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
            if res["@type"] == "connectionStateUpdating" then
              goto continue
            end
            local ok, rres = xpcall(callback, err, res)
            if not ok then
              print("Update cb failed", rres)
            
            end
            ::continue::
        end
    end
end

return {
    run = run,
    getCallback = getCallback,
}
