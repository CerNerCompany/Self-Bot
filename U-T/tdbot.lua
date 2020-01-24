--[[
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
  MA 02110-1301, USA.
--]]

local tdbot = {}

function dl_cb(arg, data)
end
tdbot__ = require 'Bot.tdbot'
tdbot_function = tdbot__.getCallback()

local function getChatId(chat_id)
  local chat = {}
  local chat_id = tostring(chat_id)

  if chat_id:match('^-100') then
    local supergroup_id = string.sub(chat_id, 5)
    chat = {id = supergroup_id, type = 'supergroup'}
  else
    local basicgroup_id = string.sub(chat_id, 2)
    chat = {id = basicgroup_id, type = 'basicgroup'}
  end

  return chat
end

local function getInputFile(file, conversion_str, expected_size)
  local input = tostring(file)
  local infile = {}

  if (conversion_str and expectedsize) then
    infile = {
      ["@type"] = 'inputFileGenerated',
      original_path = tostring(file),
      conversion = tostring(conversion_str),
      expected_size = expected_size
    }
  else
    if input:match('/') then
      infile = {["@type"] = 'inputFileLocal', path = file}
    elseif input:match('^%d+$') then
      infile = {["@type"] = 'inputFileId', id = file}
    else
      infile = {["@type"] = 'inputFileRemote', id = file}
    end
  end

  return infile
 -- vardump
end

tdbot.getInputFile = getInputFile

local function getParseMode(parse_mode)
  local P = {}
  if parse_mode then
    local mode = parse_mode:lower()

    if mode == 'markdown' or mode == 'md' then
      P["@type"] = 'textParseModeMarkdown'
    elseif mode == 'html' then
      P["@type"] = 'textParseModeHTML'
    end
  end
  return P
end

local function parseTextEntities(text, parse_mode, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'parseTextEntities',
    text = tostring(text),
    parse_mode = getParseMode(parse_mode)
  }, callback or dl_cb, data))
end

tdbot.parseTextEntities = parseTextEntities

local function sendMessage(chat_id, reply_to_message_id, input_message_content, parse_mode, disable_notification, from_background, reply_markup, callback, data)
  local tdbody = {
    ["@type"] = 'sendMessage',
    chat_id = chat_id,
    reply_to_message_id = reply_to_message_id or 0,
    disable_notification = disable_notification or 0,
    from_background = from_background or 1,
    reply_markup = reply_markup,
    input_message_content = input_message_content
  }
  local text

  if input_message_content.text then
    text = input_message_content.text.text
  elseif input_message_content.caption then
    text = input_message_content.caption.text
  end

  if text then
    if parse_mode then
      parseTextEntities(text, parse_mode, function(a, d)
        if a.tdbody.input_message_content.text then
          a.tdbody.input_message_content.text = d
        else
          a.tdbody.input_message_content.caption = d
        end
        assert (tdbot_function (a.tdbody, a.callback or dl_cb, a.data))
      end, {tdbody = tdbody, callback = callback, data = data})
    else
      local message = {}
      local n = 1
      -- Send multiple messages if text is longer than 4096 characters.
      -- https://core.telegram.org/method/messages.sendMessage
      while #text > 4096 do
        message[n] = text:sub(1, 4096)
        text = text:sub(4096, #text)
        n = n + 1
      end
      message[n] = text

      for i = 1, #message do
        tdbody.reply_to_message_id = i > 1 and 0 or reply_to_message_id
        if input_message_content.text and input_message_content.text.text then
          tdbody.input_message_content.text.text = message[i]
        else
          tdbody.input_message_content.caption.text = message[i]
        end
        assert (tdbot_function (tdbody, callback or dl_cb, data))
      end
    end
  else
    assert (tdbot_function (tdbody, callback or dl_cb, data))
  end
end

tdbot.sendMessage = sendMessage

local function setLimit(limit, num)
  local limit = tonumber(limit)
  local number = tonumber(num or limit)

  return (number >= limit) and limit or number
end


local function vectorize(str)
  local v = {}
  local i = 1

  if not str then return v end

  for k in string.gmatch(str, '(-?%d+)') do
    v[i] = '[' .. i-1 .. ']="' .. k .. '"'
    i = i+1
  end
  v = table.concat(v, ',')
  return load('return {' .. v .. '}')()
end

function tdbot.getAuthorizationState(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getAuthorizationState'
  }, callback or dl_cb, data))
end

function tdbot.setTdlibParameters(use_test_dc, database_directory, files_directory, use_file_database, use_chat_info_database, use_message_database, use_secret_chats, api_id, api_hash, system_language_code, device_model, system_version, application_version, enable_storage_optimizer, ignore_file_names, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setTdlibParameters',
    parameters = {
      ["@type"] = 'tdlibParameters',
      use_test_dc = use_test_dc,
      database_directory = tostring(database_directory),
      files_directory = tostring(files_directory),
      use_file_database = use_file_database,
      use_chat_info_database = use_chat_info_database,
      use_message_database = use_message_database,
      use_secret_chats = use_secret_chats,
      api_id = api_id,
      api_hash = tostring(api_hash),
      system_language_code = tostring(system_language_code),
      device_model = tostring(device_model),
      system_version = tostring(system_version),
      application_version = tostring(application_version),
      enable_storage_optimizer = enable_storage_optimizer,
      ignore_file_names = ignore_file_names
    }
  }, callback or dl_cb, data))
end

function tdbot.checkDatabaseEncryptionKey(encryption_key, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'checkDatabaseEncryptionKey',
    encryption_key = encryption_key
  }, callback or dl_cb, data))
end

function tdbot.setAuthenticationPhoneNumber(phone_number, allow_flash_call, is_current_phone_number, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setAuthenticationPhoneNumber',
    phone_number = tostring(phone_number),
    allow_flash_call = allow_flash_call,
    is_current_phone_number = is_current_phone_number
  }, callback or dl_cb, data))
end

function tdbot.resendAuthenticationCode(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'resendAuthenticationCode'
  }, callback or dl_cb, data))
end

function tdbot.checkAuthenticationCode(code, first_name, last_name, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'checkAuthenticationCode',
    code = tostring(code),
    first_name = tostring(first_name),
    last_name = tostring(last_name)
  }, callback or dl_cb, data))
end

function tdbot.checkAuthenticationPassword(password, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'checkAuthenticationPassword',
    password = tostring(password)
  }, callback or dl_cb, data))
end

function tdbot.requestAuthenticationPasswordRecovery(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'requestAuthenticationPasswordRecovery'
  }, callback or dl_cb, data))
end

function tdbot.recoverAuthenticationPassword(recovery_code, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'recoverAuthenticationPassword',
    recovery_code = tostring(recovery_code)
  }, callback or dl_cb, data))
end

function tdbot.checkAuthenticationBotToken(token, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'checkAuthenticationBotToken',
    token = tostring(token)
  }, callback or dl_cb, data))
end

function tdbot.logOut(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'logOut'
  }, callback or dl_cb, data))
end

function tdbot.close(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'close'
  }, callback or dl_cb, data))
end

function tdbot.destroy(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'destroy'
  }, callback or dl_cb, data))
end

function tdbot.setDatabaseEncryptionKey(new_encryption_key, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setDatabaseEncryptionKey',
    new_encryption_key = new_encryption_key
  }, callback or dl_cb, data))
end

function tdbot.getPasswordState(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getPasswordState'
  }, callback or dl_cb, data))
end

function tdbot.setPassword(old_password, new_password, new_hint, set_recovery_email_address, new_recovery_email_address, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setPassword',
    old_password = tostring(old_password),
    new_password = tostring(new_password),
    new_hint = tostring(new_hint),
    set_recovery_email_address = set_recovery_email_address,
    new_recovery_email_address = tostring(new_recovery_email_address)
  }, callback or dl_cb, data))
end

function tdbot.getRecoveryEmailAddress(password, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getRecoveryEmailAddress',
    password = tostring(password)
  }, callback or dl_cb, data))
end

function tdbot.setRecoveryEmailAddress(password, new_recovery_email_address, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setRecoveryEmailAddress',
    password = tostring(password),
    new_recovery_email_address = tostring(new_recovery_email_address)
  }, callback or dl_cb, data))
end

function tdbot.requestPasswordRecovery(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'requestPasswordRecovery'
  }, callback or dl_cb, data))
end

function tdbot.recoverPassword(recovery_code, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'recoverPassword',
    recovery_code = tostring(recovery_code)
  }, callback or dl_cb, data))
end

function tdbot.createTemporaryPassword(password, valid_for, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createTemporaryPassword',
    password = tostring(password),
    valid_for = valid_for
  }, callback or dl_cb, data))
end

function tdbot.getTemporaryPasswordState(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getTemporaryPasswordState'
  }, callback or dl_cb, data))
end

function tdbot.processDcUpdate(dc, addr, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'processDcUpdate',
    dc = tostring(dc),
    addr = tostring(addr)
  }, callback or dl_cb, data))
end

function tdbot.getMe(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getMe'
  }, callback or dl_cb, data))
end

function tdbot.getUser(user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getUser',
    user_id = user_id
  }, callback or dl_cb, data))
end
function tdbot.stopPoll(chat_id,msg_id)
   assert (tdbot_function ({
    ["@type"] = 'stopPoll',
    chat_id = chat_id,
    poll_id = msg_id
  }, callback or dl_cb, data))
end
function tdbot.getUserFullInfo(user_id, callback, data)
tdbot_function ({
    ["@type"] = 'getUserFullInfo',
    user_id = user_id
  }, callback or dl_cb, data)
end

function tdbot.getBasicGroup(basic_group_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getBasicGroup',
    basic_group_id = getChatId(basic_group_id).id
  }, callback or dl_cb, data))
end

function tdbot.getBasicGroupFullInfo(basic_group_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getBasicGroupFullInfo',
    basic_group_id = getChatId(basic_group_id).id
  }, callback or dl_cb, data))
end

function tdbot.getSupergroup(supergroup_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getSupergroup',
    supergroup_id = getChatId(supergroup_id).id
  }, callback or dl_cb, data))
end

function tdbot.getSupergroupFullInfo(supergroup_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getSupergroupFullInfo',
    supergroup_id = getChatId(supergroup_id).id
  }, callback or dl_cb, data))
end

function tdbot.getSecretChat(secret_chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getSecretChat',
    secret_chat_id = secret_chat_id
  }, callback or dl_cb, data))
end

function tdbot.getChat(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getChat',
    chat_id = chat_id
  }, callback or dl_cb, data))
end
function tdbot.StrikethroughMessage(chatid, messageid,qr,tezt)
  tdbot_function ({_="editMessageText", 
  chat_id=chatid,
   message_id=messageid,

  disable_notification=false,
   from_background=false, 
   reply_markup=nil,

  input_message_content={
    _="inputMessageText", 
    text = {
      ["@type"] = "formattedText",
    
      entities = {
        {
          ["@type"] = "textEntity",
     
          length = qr,
          offset = 0,
          type = {
            ["@type"] = "textEntityTypeStrikethrough",
         
          
          }
        }
      },
      text = tezt,
    },
    disable_web_page_preview=false,
    clear_draft=false
   }}
   , dl_cb,
    nil
   )
 end
 function tdbot.UnderlineMessage(chatid, messageid,qr,tezt)
  tdbot_function ({_="editMessageText", 
  chat_id=chatid,
   message_id=messageid,

  disable_notification=false,
   from_background=false, 
   reply_markup=nil,

  input_message_content={
    _="inputMessageText", 
    text = {
      ["@type"] = "formattedText",
    
      entities = {
        {
          ["@type"] = "textEntity",
     
          length = qr,
          offset = 0,
          type = {
            ["@type"] = "textEntityTypeUnderline",
         
          
          }
        }
      },
      text = tezt,
    },
    disable_web_page_preview=false,
    clear_draft=false
   }}
   , dl_cb,
    nil
   )
 end
function tdbot.editMessageTextMention(chatid, messageid,tezt,off,leg,user)
  tdbot_function ({_="editMessageText", 
  chat_id=chatid,
   message_id=messageid,

  disable_notification=false,
   from_background=false, 
   reply_markup=nil,

  input_message_content={
    _="inputMessageText", 
    text = {
      ["@type"] = "formattedText",
    
      entities = {
        {
          ["@type"] = "textEntity",
     
          length = leg,
          offset = off,
          type = {
            ["@type"] = "textEntityTypeMentionName",
         
            user_id = user
          }
        }
      },
      text = tezt,
    },

  disable_web_page_preview=false,
   clear_draft=false
  }}
  , dl_cb,
   nil
  )
end
function tdbot.getMessage(chat_id, message_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getMessage',
    chat_id = chat_id,
    message_id = message_id
  }, callback or dl_cb, data))
end

function tdbot.getRepliedMessage(chat_id, message_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getRepliedMessage',
    chat_id = chat_id,
    message_id = message_id
  }, callback or dl_cb, data))
end

function tdbot.getChatPinnedMessage(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getChatPinnedMessage',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.getMessages(chat_id, message_ids, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getMessages',
    chat_id = chat_id,
    message_ids = vectorize(message_ids)
  }, callback or dl_cb, data))
end

function tdbot.getFile(file_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getFile',
    file_id = file_id
  }, callback or dl_cb, data))
end

function tdbot.getRemoteFile(remote_file_id, file_type, callback, data)
  local file_type = file_type or 'Unknown'
  assert (tdbot_function ({
    ["@type"] = 'getRemoteFile',
    remote_file_id = tostring(remote_file_id),
    file_type = {
      ["@type"] = 'fileType' .. file_type
    }
  }, callback or dl_cb, data))
end

function tdbot.getChats(callback)
  tdbot_function ({
    ["@type"] = 'getChats',
    offset_order =  '9223372036854775807',
    offset_chat_id =  0,
    limit =  20
  }, callback )
end

function tdbot.searchPublicChat(username, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchPublicChat',
    username = tostring(username)
  }, callback or dl_cb, data))
end

function tdbot.searchPublicChats(query, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchPublicChats',
    query = tostring(query)
  }, callback or dl_cb, data))
end

function tdbot.searchChats(query, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchChats',
    query = tostring(query),
    limit = limit
  }, callback or dl_cb, data))
end

function tdbot.searchChatsOnServer(query, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchChatsOnServer',
    query = tostring(query),
    limit = limit
  }, callback or dl_cb, data))
end

function tdbot.getTopChats(category, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getTopChats',
    category = {
      ["@type"] = 'topChatCategory' .. category
    },
    limit = setLimit(30, limit)
  }, callback or dl_cb, data))
end

function tdbot.removeTopChat(category, chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'removeTopChat',
    category = {
      ["@type"] = 'topChatCategory' .. category
    },
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.addRecentlyFoundChat(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'addRecentlyFoundChat',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.removeRecentlyFoundChat(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'removeRecentlyFoundChat',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.clearRecentlyFoundChats(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'clearRecentlyFoundChats'
  }, callback or dl_cb, data))
end

function tdbot.checkChatUsername(chat_id, username, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'checkChatUsername',
    chat_id = chat_id,
    username = tostring(username)
  }, callback or dl_cb, data))
end

function tdbot.getCreatedPublicChats(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getCreatedPublicChats'
  }, callback or dl_cb, data))
end

function tdbot.getGroupsInCommon(user_id, offset_chat_id, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getGroupsInCommon',
    user_id = user_id,
    offset_chat_id = offset_chat_id or 0,
    limit = setLimit(100, limit)
  }, callback or dl_cb, data))
end

function tdbot.getChatHistory(chat_id, from_message_id, offset, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getChatHistory',
    chat_id = chat_id,
    from_message_id = from_message_id,
    offset = offset,
    limit = setLimit(100, limit),
    only_local = false
  }, callback or dl_cb, data))
end

function tdbot.deleteChatHistory(chat_id, remove_from_chat_list, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'deleteChatHistory',
    chat_id = chat_id,
    remove_from_chat_list = remove_from_chat_list
  }, callback or dl_cb, data))
end

function tdbot.searchChatMessages(chat_id, query, filter, sender_user_id, from_message_id, offset, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchChatMessages',
    chat_id = chat_id,
    query = tostring(query),
    sender_user_id = sender_user_id or 0,
    from_message_id = from_message_id or 0,
    offset = offset or 0,
    limit = setLimit(100, limit),
    filter = {
      ["@type"] = 'searchMessagesFilter' .. filter
    }
  }, callback or dl_cb, data))
end

function tdbot.searchMessages(query, offset_date, offset_chat_id, offset_message_id, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchMessages',
    query = tostring(query),
    offset_date = offset_date or 0,
    offset_chat_id = offset_chat_id or 0,
    offset_message_id = offset_message_id or 0,
    limit = setLimit(100, limit)
  }, callback or dl_cb, data))
end

function tdbot.searchSecretMessages(chat_id, query, from_search_id, limit, filter, callback, data)
  local filter = filter or 'Empty'
  assert (tdbot_function ({
    ["@type"] = 'searchSecretMessages',
    chat_id = chat_id or 0,
    query = tostring(query),
    from_search_id = from_search_id or 0,
    limit = setLimit(100, limit),
    filter = {
      ["@type"] = 'searchMessagesFilter' .. filter
    }
  }, callback or dl_cb, data))
end

function tdbot.searchCallMessages(from_message_id, limit, only_missed, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchCallMessages',
    from_message_id = from_message_id or 0,
    limit = setLimit(100, limit),
    only_missed = only_missed
  }, callback or dl_cb, data))
end

function tdbot.searchChatRecentLocationMessages(chat_id, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchChatRecentLocationMessages',
    chat_id = chat_id,
    limit = limit
  }, callback or dl_cb, data))
end

function tdbot.getActiveLiveLocationMessages(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getActiveLiveLocationMessages'
  }, callback or dl_cb, data))
end

function tdbot.getChatMessageByDate(chat_id, date, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getChatMessageByDate',
    chat_id = chat_id,
    date = date
  }, callback or dl_cb, data))
end

function tdbot.getPublicMessageLink(chat_id, message_id, for_album, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getPublicMessageLink',
    chat_id = chat_id,
    message_id = message_id,
    for_album = for_album
  }, callback or dl_cb, data))
end

function tdbot.sendMessageAlbum(chat_id, reply_to_message_id, photo,caption,width,height, disable_notification, from_background, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendMessageAlbum',
    chat_id = chat_id,
    reply_to_message_id = reply_to_message_id or 0,
    disable_notification = disable_notification,
    from_background = from_background
  }, callback or dl_cb, data))
end

function tdbot.sendBotStartMessage(bot_user_id, chat_id, parameter, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendBotStartMessage',
    bot_user_id = bot_user_id,
    chat_id = chat_id,
    parameter = tostring(parameter)
  }, callback or dl_cb, data))
end

function tdbot.sendInlineQueryResultMessage(chat_id, reply_to_message_id, disable_notification, from_background, query_id, result_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendInlineQueryResultMessage',
    chat_id = chat_id,
    reply_to_message_id = reply_to_message_id,
    disable_notification = disable_notification,
    from_background = from_background,
    query_id = query_id,
    result_id = tostring(result_id)
  }, callback or dl_cb, data))
end

function tdbot.forwardMessages(chat_id, from_chat_id, message_id, from_background)
  tdbot_function ({
    _ = "forwardMessages",
    chat_id = chat_id,
    from_chat_id = from_chat_id,
    message_ids = message_id,
    disable_notification = 0,
    from_background = from_background
    }, dl_cb, nil)
    end

function tdbot.sendChatSetTtlMessage(chat_id, ttl, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendChatSetTtlMessage',
    chat_id = chat_id,
    ttl = ttl
  }, callback or dl_cb, data))
end

function tdbot.sendChatScreenshotTakenNotification(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendChatScreenshotTakenNotification',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.deleteMessages(chat_id, message_ids, callback, data)
tdbot_function ({
    ["@type"] = 'deleteMessages',
    chat_id = chat_id,
    message_ids = message_ids,
    revoke = false
  }, callback or dl_cb, data)
end

function tdbot.deleteChatMessagesFromUser(chat_id, user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'deleteChatMessagesFromUser',
    chat_id = chat_id,
    user_id = user_id
  }, callback or dl_cb, data))
end

function tdbot.editMessageText(chat_id, message_id, text, parse_mode, disable_web_page_preview, clear_draft, reply_markup, callback, data)
  local tdbody = {
    ["@type"] = 'editMessageText',
    chat_id = chat_id,
    message_id = message_id,
    reply_markup = reply_markup,
    input_message_content = {
      ["@type"] = 'inputMessageText',
      disable_web_page_preview = disable_web_page_preview,
      text = {text = text},
      clear_draft = clear_draft
    }
  }
  if parse_mode then
    parseTextEntities(text, parse_mode, function(a, d)
      a.tdbody.input_message_content.text = d
       tdbot_function (a.tdbody, a.callback or dl_cb, a.data)
    end, {tdbody = tdbody, callback = callback, data = data})
  else
     tdbot_function (tdbody, callback or dl_cb, data)
  end
end

function tdbot.editMessageLiveLocation(chat_id, message_id, latitude, longitude, reply_markup, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'editMessageLiveLocation',
    chat_id = chat_id,
    message_id = message_id,
    reply_markup = reply_markup,
    location = {
      ["@type"] = 'location',
      latitude = latitude,
      longitude = longitude
    }
  }, callback or dl_cb, data))
end

function tdbot.editMessageCaption(chat_id, message_id, text, parse_mode, reply_markup, callback, data)
  local tdbody = {
    ["@type"] = 'editMessageCaption',
    chat_id = chat_id,
    message_id = message_id,
    reply_markup = reply_markup
  }
  if parse_mode then
    parseTextEntities(text, parse_mode, function(a, d)
      a.tdbody.caption = d
      assert (tdbot_function (a.tdbody, a.callback or dl_cb, a.data))
    end, {tdbody = tdbody, callback = callback, data = data})
  else
    assert (tdbot_function (tdbody, callback or dl_cb, data))
  end
end

function tdbot.editMessageReplyMarkup(chat_id, message_id, reply_markup, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'editMessageReplyMarkup',
    chat_id = chat_id,
    message_id = message_id,
    reply_markup = reply_markup
  }, callback or dl_cb, data))
end

function tdbot.editInlineMessageText(inline_message_id, reply_markup, input_message_content, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'editInlineMessageText',
    inline_message_id = tostring(inline_message_id),
    reply_markup = reply_markup,
    input_message_content = input_message_content
  }, callback or dl_cb, data))
end

function tdbot.editInlineMessageLiveLocation(inline_message_id, latitude, longitude, reply_markup, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'editInlineMessageLiveLocation',
    inline_message_id = tostring(inline_message_id),
    reply_markup = reply_markup,
    location = {
      ["@type"] = 'location',
      latitude = latitude,
      longitude = longitude
    }
  }, callback or dl_cb, data))
end

function tdbot.editInlineMessageCaption(inline_message_id, caption, reply_markup, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'editInlineMessageCaption',
    inline_message_id = tostring(inline_message_id),
    reply_markup = reply_markup,
    caption = {
      ["@type"] = 'formattedText',
      text = tostring(caption)
    }
  }, callback or dl_cb, data))
end

function tdbot.editInlineMessageReplyMarkup(inline_message_id, reply_markup, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'editInlineMessageReplyMarkup',
    inline_message_id = tostring(inline_message_id),
    reply_markup = reply_markup
  }, callback or dl_cb, data))
end

function tdbot.getTextEntities(text, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getTextEntities',
    text = tostring(text)
  }, callback or dl_cb, data))
end

function tdbot.getFileMimeType(file_name, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getFileMimeType',
    file_name = tostring(file_name)
  }, callback or dl_cb, data))
end

function tdbot.getFileExtension(mime_type, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getFileExtension',
    mime_type = tostring(mime_type)
  }, callback or dl_cb, data))
end

function tdbot.getInlineQueryResults(bot_user_id, chat_id, latitude, longitude, query, offset, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getInlineQueryResults',
    bot_user_id = bot_user_id,
    chat_id = chat_id,
    user_location = {
      ["@type"] = 'location',
      latitude = latitude,
      longitude = longitude
    },
    query = tostring(query),
    offset = tostring(offset)
  }, callback or dl_cb, data))
end

function tdbot.answerInlineQuery(inline_query_id, is_personal, results, cache_time, next_offset, switch_pm_text, switch_pm_parameter, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'answerInlineQuery',
    inline_query_id = inline_query_id,
    is_personal = is_personal,
    --results = vector<InputInlineQueryResult>,
    cache_time = cache_time,
    next_offset = tostring(next_offset),
    switch_pm_text = tostring(switch_pm_text),
    switch_pm_parameter = tostring(switch_pm_parameter)
  }, callback or dl_cb, data))
end

function tdbot.getCallbackQueryAnswer(chat_id, message_id, payload, data, game_short_name, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getCallbackQueryAnswer',
    chat_id = chat_id,
    message_id = message_id,
    payload = {
      ["@type"] = 'callbackQueryPayload' .. payload,
      data = data,
      game_short_name = game_short_name
    }
  }, callback or dl_cb, data))
end

function tdbot.answerCallbackQuery(callback_query_id, text, show_alert, url, cache_time, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'answerCallbackQuery',
    callback_query_id = callback_query_id,
    text = tostring(text),
    show_alert = show_alert,
    url = tostring(url),
    cache_time = cache_time
  }, callback or dl_cb, data))
end

function tdbot.answerShippingQuery(shipping_query_id, shipping_options, error_message, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'answerShippingQuery',
    shipping_query_id = shipping_query_id,
    -- shipping_options = vector<shippingOption>,
    error_message = tostring(error_message)
  }, callback or dl_cb, data))
end

function tdbot.answerPreCheckoutQuery(pre_checkout_query_id, error_message, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'answerPreCheckoutQuery',
    pre_checkout_query_id = pre_checkout_query_id,
    error_message = tostring(error_message)
  }, callback or dl_cb, data))
end

function tdbot.setGameScore(chat_id, message_id, edit_message, user_id, score, force, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setGameScore',
    chat_id = chat_id,
    message_id = message_id,
    edit_message = edit_message,
    user_id = user_id,
    score = score,
    force = force
  }, callback or dl_cb, data))
end

function tdbot.setInlineGameScore(inline_message_id, edit_message, user_id, score, force, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setInlineGameScore',
    inline_message_id = tostring(inline_message_id),
    edit_message = edit_message,
    user_id = user_id,
    score = score,
    force = force
  }, callback or dl_cb, data))
end

function tdbot.getGameHighScores(chat_id, message_id, user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getGameHighScores',
    chat_id = chat_id,
    message_id = message_id,
    user_id = user_id
  }, callback or dl_cb, data))
end

function tdbot.getInlineGameHighScores(inline_message_id, user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getInlineGameHighScores',
    inline_message_id = tostring(inline_message_id),
    user_id = user_id
  }, callback or dl_cb, data))
end

function tdbot.deleteChatReplyMarkup(chat_id, message_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'deleteChatReplyMarkup',
    chat_id = chat_id,
    message_id = message_id
  }, callback or dl_cb, data))
end

function tdbot.sendChatAction(chat_id, action, progress, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendChatAction',
    chat_id = chat_id,
    action = {
      ["@type"] = 'chatAction' .. action,
      progress = progress or 100
    }
  }, callback or dl_cb, data))
end

function tdbot.openChat(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'openChat',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.closeChat(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'closeChat',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.viewMessages(chat_id, message_ids, force_read)
  tdbot_function ({
    ["@type"] = 'viewMessages',
    chat_id = chat_id,
    message_ids = message_ids,
    force_read = force_read
  }, dl_cb)
end

function tdbot.openMessageContent(chat_id, message_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'openMessageContent',
    chat_id = chat_id,
    message_id = message_id
  }, callback or dl_cb, data))
end

function tdbot.readAllChatMentions(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'readAllChatMentions',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.createPrivateChat(user_id, force, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createPrivateChat',
    user_id = user_id,
    force = force
  }, callback or dl_cb, data))
end

function tdbot.createBasicGroupChat(basic_group_id, force, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createBasicGroupChat',
    basic_group_id = getChatId(basic_group_id).id,
    force = force
  }, callback or dl_cb, data))
end

function tdbot.createSupergroupChat(supergroup_id, force, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createSupergroupChat',
    supergroup_id = getChatId(supergroup_id).id,
    force = force
  }, callback or dl_cb, data))
end

function tdbot.createSecretChat(secret_chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createSecretChat',
    secret_chat_id = secret_chat_id
  }, callback or dl_cb, data))
end

function tdbot.createNewBasicGroupChat(user_ids, title, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createNewBasicGroupChat',
    user_ids = vectorize(user_ids),
    title = tostring(title)
  }, callback or dl_cb, data))
end

function tdbot.createNewSupergroupChat(title, is_channel, description, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createNewSupergroupChat',
    title = tostring(title),
    is_channel = is_channel,
    description = tostring(description)
  }, callback or dl_cb, data))
end

function tdbot.createNewSecretChat(user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createNewSecretChat',
    user_id = tonumber(user_id)
  }, callback or dl_cb, data))
end

function tdbot.upgradeBasicGroupChatToSupergroupChat(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'upgradeBasicGroupChatToSupergroupChat',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.setChatTitle(chat_id, title, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setChatTitle',
    chat_id = chat_id,
    title = tostring(title)
  }, callback or dl_cb, data))
end

function tdbot.setChatPhoto(chat_id, photo, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setChatPhoto',
    chat_id = chat_id,
    photo = getInputFile(photo)
  }, callback or dl_cb, data))
end

function tdbot.setChatDraftMessage(chat_id, reply_to_message_id, text, parse_mode, disable_web_page_preview, clear_draft, callback, data)
  local tdbody = {
    ["@type"] = 'setChatDraftMessage',
    chat_id = chat_id,
    draft_message = {
      ["@type"] = 'draftMessage',
      reply_to_message_id = reply_to_message_id,
      input_message_text = {
        ["@type"] = 'inputMessageText',
        disable_web_page_preview = disable_web_page_preview,
        text = {text = text},
        clear_draft = clear_draft
      }
    }
  }
  if parse_mode then
    parseTextEntities(text, parse_mode, function(a, d)
      a.tdbody.draft_message.input_message_text.text = d
      assert (tdbot_function (a.tdbody, a.callback or dl_cb, a.data))
    end, {tdbody = tdbody, callback = callback, data = data})
  else
    assert (tdbot_function (tdbody, callback or dl_cb, data))
  end
end

function tdbot.toggleChatIsPinned(chat_id, is_pinned, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'toggleChatIsPinned',
    chat_id = chat_id,
    is_pinned = is_pinned
  }, callback or dl_cb, data))
end

function tdbot.setChatClientData(chat_id, client_data, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setChatClientData',
    chat_id = chat_id,
    client_data = tostring(client_data)
  }, callback or dl_cb, data))
end

function tdbot.addChatMember(chat_id, user_id, forward_limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'addChatMember',
    chat_id = chat_id,
    user_id = user_id,
    forward_limit = setLimit(300, forward_limit)
  }, callback or dl_cb, data))
end

function tdbot.addChatMembers(chat_id, user_ids, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'addChatMembers',
    chat_id = chat_id,
    user_ids = vectorize(user_ids)
  }, callback or dl_cb, data))
end

function tdbot.Restrict(chat_id, user_id,right,callback, data)
    assert (tdbot_function ({
      _ = 'setChatMemberStatus',
      chat_id = chat_id,
      status = {
        ["@type"] = "chatMemberStatusRestricted",
        is_member = right[1] or 1,
        permissions = {
          ["@type"] = "chatPermissions",
          can_add_web_page_previews = right[2] or 0,
          can_send_messages = right[3] or 0,
          can_invite_users = right[4] or 0,
          can_send_other_messages = right[5] or 0 ,
          can_send_media_messages = right[6] or 0,
          can_send_polls = right[7] or 0
        },
        restricted_until_date = right[8] or 0 
      },
      user_id = user_id,
  

    }, callback or dl_cb, data))
  

  end



function tdbot.getChatMember(chat_id, user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getChatMember',
    chat_id = chat_id,
    user_id = user_id
  }, callback or dl_cb, data))
end

function tdbot.leaveChat(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'leaveChat',
    chat_id = chat_id
  }, callback or dl_cb, data))
end
function tdbot.searchChatMembers(chat_id, query, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchChatMembers',
    chat_id = chat_id,
    query = tostring(query),
    limit = setLimit(200, limit)
  }, callback or dl_cb, data))
end

function tdbot.getChatAdministrators(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getChatAdministrators',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.setPinnedChats(chat_ids, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setPinnedChats',
    chat_ids = vectorize(chat_ids)
  }, callback or dl_cb, data))
end

function tdbot.downloadFile(file_id, priority, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'downloadFile',
    file_id = file_id,
    priority = priority or 32
  }, callback or dl_cb, data))
end

function tdbot.cancelDownloadFile(file_id, only_if_pending, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'cancelDownloadFile',
    file_id = file_id,
    only_if_pending = only_if_pending
  }, callback or dl_cb, data))
end

function tdbot.uploadFile(file, file_type, priority, callback, data)
  local ftype = file_type or 'Unknown'
  assert (tdbot_function ({
    ["@type"] = 'uploadFile',
    file = getInputFile(file),
    file_type = {
      ["@type"] = 'fileType' .. ftype
    },
    priority = priority or 32
  }, callback or dl_cb, data))
end

function tdbot.cancelUploadFile(file_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'cancelUploadFile',
    file_id = file_id
  }, callback or dl_cb, data))
end

function tdbot.setFileGenerationProgress(generation_id, expected_size, local_prefix_size, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setFileGenerationProgress',
    generation_id = generation_id,
    expected_size = expected_size or 0,
    local_prefix_size = local_prefix_size
  }, callback or dl_cb, data))
end

function tdbot.finishFileGeneration(generation_id, error, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'finishFileGeneration',
    generation_id = generation_id,
    error = error
  }, callback or dl_cb, data))
end

function tdbot.deleteFile(file_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'deleteFile',
    file_id = file_id
  }, callback or dl_cb, data))
end

function tdbot.generateChatInviteLink(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'generateChatInviteLink',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.checkChatInviteLink(invite_link, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'checkChatInviteLink',
    invite_link = tostring(invite_link)
  }, callback or dl_cb, data))
end

function tdbot.joinChatByInviteLink(invite_link, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'joinChatByInviteLink',
    invite_link = tostring(invite_link)
  }, callback or dl_cb, data))
end

function tdbot.createCall(user_id, udp_p2p, udp_reflector, min_layer, max_layer, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createCall',
    user_id = user_id,
    protocol = {
      ["@type"] = 'callProtocol',
      udp_p2p = udp_p2p,
      udp_reflector = udp_reflector,
      min_layer = min_layer or 65,
      max_layer = max_layer or 65
    }
  }, callback or dl_cb, data))
end

function tdbot.acceptCall(call_id, udp_p2p, udp_reflector, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'acceptCall',
    call_id = call_id,
    protocol = {
      ["@type"] = 'callProtocol',
      udp_p2p = udp_p2p,
      udp_reflector = udp_reflector,
      min_layer = 65,
      max_layer = 65
    }
  }, callback or dl_cb, data))
end

function tdbot.discardCall(call_id, is_disconnected, duration, connection_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'discardCall',
    call_id = call_id,
    is_disconnected = is_disconnected,
    duration = duration,
    connection_id = connection_id
  }, callback or dl_cb, data))
end

function tdbot.sendCallRating(call_id, rating, comment, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendCallRating',
    call_id = call_id,
    rating = rating,
    comment = tostring(comment)
  }, callback or dl_cb, data))
end

function tdbot.sendCallDebugInformation(call_id, debug_information, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendCallDebugInformation',
    call_id = call_id,
    debug_information = tostring(debug_information)
  }, callback or dl_cb, data))
end

function tdbot.blockUser(user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'blockUser',
    user_id = user_id
  }, callback or dl_cb, data))
end

function tdbot.unblockUser(user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'unblockUser',
    user_id = user_id
  }, callback or dl_cb, data))
end

function tdbot.getBlockedUsers(offset, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getBlockedUsers',
    offset = offset or 0,
    limit = setLimit(100, limit)
  }, callback or dl_cb, data))
end

function tdbot.importContacts(phone_number, first_name, last_name, user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'importContacts',
    contacts = {
      ["@type"] = 'contact',
      phone_number = tostring(phone_number),
      first_name = tostring(first_name),
      last_name = tostring(last_name),
      user_id = user_id or 0
    }
  }, callback or dl_cb, data))
end

function tdbot.searchContacts(query, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchContacts',
    query = tostring(query),
    limit = limit
  }, callback or dl_cb, data))
end

function tdbot.removeContacts(user_ids, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'removeContacts',
    user_ids = vectorize(user_ids)
  }, callback or dl_cb, data))
end

function tdbot.getImportedContactCount(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getImportedContactCount'
  }, callback or dl_cb, data))
end

function tdbot.changeImportedContacts(phone_number, first_name, last_name, user_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'changeImportedContacts',
    contacts = {
      ["@type"] = 'contact',
      phone_number = tostring(phone_number),
      first_name = tostring(first_name),
      last_name = tostring(last_name),
      user_id = user_id or 0
    }
  }, callback or dl_cb, data))
end

function tdbot.clearImportedContacts(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'clearImportedContacts'
  }, callback or dl_cb, data))
end

function tdbot.getUserProfilePhotos(user_id, offset, limit, callback, data)
  tdbot_function ({
    ["@type"] = 'getUserProfilePhotos',
    user_id = user_id,
    offset = offset or 0,
    limit = setLimit(100, limit)
  }, callback or dl_cb, data)
end

function tdbot.getStickers(emoji, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getStickers',
    emoji = tostring(emoji),
    limit = setLimit(100, limit)
  }, callback or dl_cb, data))
end

function tdbot.searchStickers(emoji, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchStickers',
    emoji = tostring(emoji),
    limit = limit
  }, callback or dl_cb, data))
end

function tdbot.getInstalledStickerSets(is_masks, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getInstalledStickerSets',
    is_masks = is_masks
  }, callback or dl_cb, data))
end

function tdbot.getArchivedStickerSets(is_masks, offset_sticker_set_id, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getArchivedStickerSets',
    is_masks = is_masks,
    offset_sticker_set_id = offset_sticker_set_id,
    limit = limit
  }, callback or dl_cb, data))
end

function tdbot.getTrendingStickerSets(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getTrendingStickerSets'
  }, callback or dl_cb, data))
end

function tdbot.getAttachedStickerSets(file_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getAttachedStickerSets',
    file_id = file_id
  }, callback or dl_cb, data))
end

function tdbot.getStickerSet(set_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getStickerSet',
    set_id = set_id
  }, callback or dl_cb, data))
end

function tdbot.searchStickerSet(name, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchStickerSet',
    name = tostring(name)
  }, callback or dl_cb, data))
end

function tdbot.searchInstalledStickerSets(is_masks, query, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchInstalledStickerSets',
    is_masks = is_masks,
    query = tostring(query),
    limit = limit
  }, callback or dl_cb, data))
end

function tdbot.searchStickerSets(query, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchStickerSets',
    query = tostring(query)
  }, callback or dl_cb, data))
end

function tdbot.changeStickerSet(set_id, is_installed, is_archived, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'changeStickerSet',
    set_id = set_id,
    is_installed = is_installed,
    is_archived = is_archived
  }, callback or dl_cb, data))
end

function tdbot.viewTrendingStickerSets(sticker_set_ids, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'viewTrendingStickerSets',
    sticker_set_ids = vectorize(sticker_set_ids)
  }, callback or dl_cb, data))
end

function tdbot.reorderInstalledStickerSets(is_masks, sticker_set_ids, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'reorderInstalledStickerSets',
    is_masks = is_masks,
    sticker_set_ids = vectorize(sticker_set_ids)
  }, callback or dl_cb, data))
end

function tdbot.getRecentStickers(is_attached, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getRecentStickers',
    is_attached = is_attached
  }, callback or dl_cb, data))
end

function tdbot.addRecentSticker(is_attached, sticker, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'addRecentSticker',
    is_attached = is_attached,
    sticker = getInputFile(sticker)
  }, callback or dl_cb, data))
end

function tdbot.removeRecentSticker(is_attached, sticker, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'removeRecentSticker',
    is_attached = is_attached,
    sticker = getInputFile(sticker)
  }, callback or dl_cb, data))
end

function tdbot.clearRecentStickers(is_attached, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'clearRecentStickers',
    is_attached = is_attached
  }, callback or dl_cb, data))
end

function tdbot.getFavoriteStickers(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getFavoriteStickers'
  }, callback or dl_cb, data))
end

function tdbot.addFavoriteSticker(sticker, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'addFavoriteSticker',
    sticker = getInputFile(sticker)
  }, callback or dl_cb, data))
end

function tdbot.removeFavoriteSticker(sticker, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'removeFavoriteSticker',
    sticker = getInputFile(sticker)
  }, callback or dl_cb, data))
end

function tdbot.getStickerEmojis(sticker, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getStickerEmojis',
    sticker = getInputFile(sticker)
  }, callback or dl_cb, data))
end

function tdbot.getSavedAnimations(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getSavedAnimations'
  }, callback or dl_cb, data))
end

function tdbot.addSavedAnimation(animation, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'addSavedAnimation',
    animation = getInputFile(animation)
  }, callback or dl_cb, data))
end

function tdbot.removeSavedAnimation(animation, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'removeSavedAnimation',
    animation = getInputFile(animation)
  }, callback or dl_cb, data))
end

function tdbot.getRecentInlineBots(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getRecentInlineBots'
  }, callback or dl_cb, data))
end

function tdbot.searchHashtags(prefix, limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'searchHashtags',
    prefix = tostring(prefix),
    limit = limit
  }, callback or dl_cb, data))
end

function tdbot.removeRecentHashtag(hashtag, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'removeRecentHashtag',
    hashtag = tostring(hashtag)
  }, callback or dl_cb, data))
end

function tdbot.getWebPagePreview(text, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getWebPagePreview',
    text = {
      text = text
    }
  }, callback or dl_cb, data))
end

function tdbot.getWebPageInstantView(url, force_full, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getWebPageInstantView',
    url = tostring(url),
    force_full = force_full
  }, callback or dl_cb, data))
end

function tdbot.getNotificationSettings(scope, chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getNotificationSettings',
    scope = {
      ["@type"] = 'notificationSettingsScope' .. scope,
      chat_id = chat_id
    }
  }, callback or dl_cb, data))
end

function tdbot.setNotificationSettings(scope, chat_id, mute_for, sound, show_preview, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setNotificationSettings',
    scope = {
      ["@type"] = 'notificationSettingsScope' .. scope,
      chat_id = chat_id
    },
    notification_settings = {
      ["@type"] = 'notificationSettings',
      mute_for = mute_for,
      sound = tostring(sound),
      show_preview = show_preview
    }
  }, callback or dl_cb, data))
end

function tdbot.setNotificationSettings(scope, notification_settings, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setNotificationSettings',
    scope = NotificationSettingsScope,
    notification_settings = notificationSettings
  }, callback or dl_cb, data))
end

function tdbot.resetAllNotificationSettings(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'resetAllNotificationSettings'
  }, callback or dl_cb, data))
end

function tdbot.setProfilePhoto(photo)
  assert (tdbot_function ({
    ["@type"] = 'setProfilePhoto',
    photo = getInputFile(photo)
  }, dl_cb))
end

function tdbot.deleteProfilePhoto(profile_photo_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'deleteProfilePhoto',
    profile_photo_id = profile_photo_id
  }, callback or dl_cb, data))
end

function tdbot.setName(first_name, last_name, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setName',
    first_name = tostring(first_name),
    last_name = tostring(last_name)
  }, callback or dl_cb, data))
end

function tdbot.setBio(bio, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setBio',
    bio = tostring(bio)
  }, callback or dl_cb, data))
end

function tdbot.setUsername(username, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setUsername',
    username = tostring(username)
  }, callback or dl_cb, data))
end

function tdbot.changePhoneNumber(phone_number, allow_flash_call, is_current_phone_number, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'changePhoneNumber',
    phone_number = tostring(phone_number),
    allow_flash_call = allow_flash_call,
    is_current_phone_number = is_current_phone_number
  }, callback or dl_cb, data))
end

function tdbot.resendChangePhoneNumberCode(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'resendChangePhoneNumberCode'
  }, callback or dl_cb, data))
end

function tdbot.checkChangePhoneNumberCode(code, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'checkChangePhoneNumberCode',
    code = tostring(code)
  }, callback or dl_cb, data))
end

function tdbot.getActiveSessions(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getActiveSessions'
  }, callback or dl_cb, data))
end

function tdbot.terminateSession(session_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'terminateSession',
    session_id = session_id
  }, callback or dl_cb, data))
end

function tdbot.terminateAllOtherSessions(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'terminateAllOtherSessions'
  }, callback or dl_cb, data))
end

function tdbot.getConnectedWebsites(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getConnectedWebsites'
  }, callback or dl_cb, data))
end

function tdbot.disconnectWebsite(website_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'disconnectWebsite',
    website_id = website_id
  }, callback or dl_cb, data))
end

function tdbot.disconnectAllWebsites(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'disconnectAllWebsites'
  }, callback or dl_cb, data))
end

function tdbot.toggleBasicGroupAdministrators(basic_group_id, everyone_is_administrator, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'toggleBasicGroupAdministrators',
    basic_group_id = getChatId(basic_group_id).id,
    everyone_is_administrator = everyone_is_administrator
  }, callback or dl_cb, data))
end

function tdbot.setSupergroupUsername(supergroup_id, username, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setSupergroupUsername',
    supergroup_id = getChatId(supergroup_id).id,
    username = tostring(username)
  }, callback or dl_cb, data))
end

function tdbot.setSupergroupStickerSet(supergroup_id, sticker_set_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setSupergroupStickerSet',
    supergroup_id = getChatId(supergroup_id).id,
    sticker_set_id = sticker_set_id
  }, callback or dl_cb, data))
end

function tdbot.toggleSupergroupInvites(supergroup_id, anyone_can_invite, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'toggleSupergroupInvites',
    supergroup_id = getChatId(supergroup_id).id,
    anyone_can_invite = anyone_can_invite
  }, callback or dl_cb, data))
end

function tdbot.toggleSupergroupSignMessages(supergroup_id, sign_messages, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'toggleSupergroupSignMessages',
    supergroup_id = getChatId(supergroup_id).id,
    sign_messages = sign_messages
  }, callback or dl_cb, data))
end

function tdbot.toggleSupergroupIsAllHistoryAvailable(supergroup_id, is_all_history_available, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'toggleSupergroupIsAllHistoryAvailable',
    supergroup_id = getChatId(supergroup_id).id,
    is_all_history_available = is_all_history_available
  }, callback or dl_cb, data))
end

function tdbot.setSupergroupDescription(supergroup_id, description, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setSupergroupDescription',
    supergroup_id = getChatId(supergroup_id).id,
    description = tostring(description)
  }, callback or dl_cb, data))
end

function tdbot.pinSupergroupMessage(supergroup_id, message_id, disable_notification, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'pinSupergroupMessage',
    supergroup_id = getChatId(supergroup_id).id,
    message_id = message_id,
    disable_notification = disable_notification
  }, callback or dl_cb, data))
end

function tdbot.unpinSupergroupMessage(supergroup_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'unpinSupergroupMessage',
    supergroup_id = getChatId(supergroup_id).id
  }, callback or dl_cb, data))
end

function tdbot.reportSupergroupSpam(supergroup_id, user_id, message_ids, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'reportSupergroupSpam',
    supergroup_id = getChatId(supergroup_id).id,
    user_id = user_id,
    message_ids = vectorize(message_ids)
  }, callback or dl_cb, data))
end

function tdbot.getSupergroupMembers(supergroup_id, filter, offset, limit, callback, data)
  local filter = filter or 'Recent'
  assert (tdbot_function ({
    ["@type"] = 'getSupergroupMembers',
    supergroup_id = getChatId(supergroup_id).id,
    filter = {
      ["@type"] = 'supergroupMembersFilter' .. filter
    },
    offset = offset or 0,
    limit = setLimit(200, limit)
  }, callback or dl_cb, data))
end

function tdbot.deleteSupergroup(supergroup_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'deleteSupergroup',
    supergroup_id = getChatId(supergroup_id).id
  }, callback or dl_cb, data))
end

function tdbot.closeSecretChat(secret_chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'closeSecretChat',
    secret_chat_id = secret_chat_id
  }, callback or dl_cb, data))
end

function tdbot.getChatEventLog(chat_id, query, from_event_id, limit, filters, user_ids, callback, data)
  local filters = filters or {1,1,1,1,1,1,1,1,1,1}

  assert (tdbot_function ({
    ["@type"] = 'getChatEventLog',
    chat_id = chat_id,
    query = tostring(query) or '',
    from_event_id = from_event_id or 0,
    limit = setLimit(100, limit),
    filters = {
      ["@type"] = 'chatEventLogFilters',
      message_edits = filters[0],
      message_deletions = filters[1],
      message_pins = filters[2],
      member_joins = filters[3],
      member_leaves = filters[4],
      member_invites = filters[5],
      member_promotions = filters[6],
      member_restrictions = filters[7],
      info_changes = filters[8],
      setting_changes = filters[9]
    },
    user_ids = vectorize(user_ids)
  }, callback or dl_cb, data))
end

function tdbot.getPaymentForm(chat_id, message_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getPaymentForm',
    chat_id = chat_id,
    message_id = message_id
  }, callback or dl_cb, data))
end

function tdbot.validateOrderInfo(chat_id, message_id, order_info, allow_save, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'validateOrderInfo',
    chat_id = chat_id,
    message_id = message_id,
    order_info = orderInfo,
    allow_save = allow_save
  }, callback or dl_cb, data))
end

function tdbot.sendPaymentForm(chat_id, message_id, order_info_id, shipping_option_id, credentials, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendPaymentForm',
    chat_id = chat_id,
    message_id = message_id,
    order_info_id = tostring(order_info_id),
    shipping_option_id = tostring(shipping_option_id),
    credentials = InputCredentials
  }, callback or dl_cb, data))
end

function tdbot.getPaymentReceipt(chat_id, message_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getPaymentReceipt',
    chat_id = chat_id,
    message_id = message_id
  }, callback or dl_cb, data))
end

function tdbot.getSavedOrderInfo(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getSavedOrderInfo'
  }, callback or dl_cb, data))
end

function tdbot.deleteSavedOrderInfo(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'deleteSavedOrderInfo'
  }, callback or dl_cb, data))
end

function tdbot.deleteSavedCredentials(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'deleteSavedCredentials'
  }, callback or dl_cb, data))
end

function tdbot.getSupportUser(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getSupportUser'
  }, callback or dl_cb, data))
end

function tdbot.getWallpapers(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getWallpapers'
  }, callback or dl_cb, data))
end

function tdbot.registerDevice(device, token, device_token, is_app_sandbox, access_token, channel_uri, endpoint, p256dh_base64url, auth_base64url, reg_id, other_user_ids, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'registerDevice',
    device_token = {
      ["@type"] = deviceToken .. device,
      device_token = device_token,
      is_app_sandbox = is_app_sandbox,
      access_token = access_token,
      channel_uri = channel_uri,
      endpoint = endpoint,
      p256dh_base64url = p256dh_base64url,
      auth_base64url = auth_base64url,
      token = token,
      reg_id = reg_id
    },
    other_user_ids = vectorize(other_user_ids)
  }, callback or dl_cb, data))
end

function tdbot.getRecentlyVisitedTMeUrls(referrer, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getRecentlyVisitedTMeUrls',
    referrer = tostring(referrer)
  }, callback or dl_cb, data))
end

function tdbot.setUserPrivacySettingRules(setting, rules, allowed_user_ids, restricted_user_ids, callback, data)
  local setting_rules = {
    [0] = {
      ["@type"] = "userPrivacySettingRule" .. rules
    }
  }

  if allowed_user_ids then
    setting_rules[#setting_rules + 1] = {
      {
        ["@type"] = "userPrivacySettingRuleAllowUsers",
        user_ids = vectorize(allowed_user_ids)
      }
    }
  elseif restricted_user_ids then
    setting_rules[#setting_rules + 1] = {
      {
        ["@type"] = "userPrivacySettingRuleRestrictUsers",
        user_ids = vectorize(restricted_user_ids)
      }
    }
  end

  assert (tdbot_function ({
    ["@type"] = 'setUserPrivacySettingRules',
    setting = {
      ["@type"] = "userPrivacySetting" .. setting
    },
    rules = {
      ["@type"] = "userPrivacySettingRules",
      rules = setting_rules
    }
  }, callback or dl_cb, data))
end

function tdbot.getUserPrivacySettingRules(setting, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getUserPrivacySettingRules',
    setting = {
      ["@type"] = 'userPrivacySetting' .. setting
    }
  }, callback or dl_cb, data))
end

function tdbot.getOption(name, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getOption',
    name = tostring(name)
  }, callback or dl_cb, data))
end

function tdbot.setOption(name, option_value, value, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setOption',
    name = tostring(name),
    value = {
      ["@type"] = 'optionValue' .. option_value,
      value = value
    }
  }, callback or dl_cb, data))
end

function tdbot.setAccountTtl(ttl, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setAccountTtl',
    ttl = {
      ["@type"] = 'accountTtl',
      days = ttl
    }
  }, callback or dl_cb, data))
end

function tdbot.getAccountTtl(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getAccountTtl'
  }, callback or dl_cb, data))
end

function tdbot.deleteAccount(reason, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'deleteAccount',
    reason = tostring(reason)
  }, callback or dl_cb, data))
end

function tdbot.getChatReportSpamState(chat_id, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getChatReportSpamState',
    chat_id = chat_id
  }, callback or dl_cb, data))
end

function tdbot.changeChatReportSpamState(chat_id, is_spam_chat, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'changeChatReportSpamState',
    chat_id = chat_id,
    is_spam_chat = is_spam_chat
  }, callback or dl_cb, data))
end

function tdbot.reportChat(chat_id, reason, text, message_ids, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'reportChat',
    chat_id = chat_id,
    reason = {
      ["@type"] = 'chatReportReason' .. reason,
      text = text
    },
    message_ids = vectorize(message_ids)
  }, callback or dl_cb, data))
end

function tdbot.getStorageStatistics(chat_limit, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getStorageStatistics',
    chat_limit = chat_limit
  }, callback or dl_cb, data))
end

function tdbot.getStorageStatisticsFast(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getStorageStatisticsFast'
  }, callback or dl_cb, data))
end

function tdbot.optimizeStorage(size, ttl, count, immunity_delay, file_type, chat_ids, exclude_chat_ids, chat_limit, callback, data)
  local file_type = file_type or ''
  assert (tdbot_function ({
    ["@type"] = 'optimizeStorage',
    size = size or -1,
    ttl = ttl or -1,
    count = count or -1,
    immunity_delay = immunity_delay or -1,
    file_type = {
      ["@type"] = 'fileType' .. file_type
    },
    chat_ids = vectorize(chat_ids),
    exclude_chat_ids = vectorize(exclude_chat_ids),
    chat_limit = chat_limit
  }, callback or dl_cb, data))
end

function tdbot.setNetworkType(type, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setNetworkType',
    type = {
      ["@type"] = 'networkType' .. type
    },
  }, callback or dl_cb, data))
end

function tdbot.getNetworkStatistics(only_current, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getNetworkStatistics',
    only_current = only_current
  }, callback or dl_cb, data))
end

function tdbot.addNetworkStatistics(entry, file_type, network_type, sent_bytes, received_bytes, duration, callback, data)
  local file_type = file_type or 'None'
  assert (tdbot_function ({
    ["@type"] = 'addNetworkStatistics',
    entry = {
      ["@type"] = 'networkStatisticsEntry' .. entry,
      file_type = {
        ["@type"] = 'fileType' .. file_type
      },
      network_type = {
        ["@type"] = 'networkType' .. network_type
      },
      sent_bytes = sent_bytes,
      received_bytes = received_bytes,
      duration = duration
    }
  }, callback or dl_cb, data))
end

function tdbot.resetNetworkStatistics(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'resetNetworkStatistics'
  }, callback or dl_cb, data))
end

function tdbot.setBotUpdatesStatus(pending_update_count, error_message, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setBotUpdatesStatus',
    pending_update_count = pending_update_count,
    error_message = tostring(error_message)
  }, callback or dl_cb, data))
end

function tdbot.uploadStickerFile(user_id, png_sticker, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'uploadStickerFile',
    user_id = user_id,
    png_sticker = getInputFile(png_sticker)
  }, callback or dl_cb, data))
end

function tdbot.createNewStickerSet(user_id, title, name, is_masks, stickers, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'createNewStickerSet',
    user_id = user_id,
    title = tostring(title),
    name = tostring(name),
    is_masks = is_masks,
    -- stickers = vector<inputSticker>
  }, callback or dl_cb, data))
end

function tdbot.addStickerToSet(user_id, name, sticker, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'addStickerToSet',
    user_id = user_id,
    name = tostring(name),
    sticker = getInputFile(sticker)
  }, callback or dl_cb, data))
end

function tdbot.setStickerPositionInSet(sticker, position, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setStickerPositionInSet',
    sticker = getInputFile(sticker),
    position = position
  }, callback or dl_cb, data))
end

function tdbot.removeStickerFromSet(sticker, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'removeStickerFromSet',
    sticker = getInputFile(sticker)
  }, callback or dl_cb, data))
end

function tdbot.sendCustomRequest(method, parameters, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'sendCustomRequest',
    method = tostring(method),
    parameters = tostring(parameters)
  }, callback or dl_cb, data))
end

function tdbot.answerCustomQuery(custom_query_id, data, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'answerCustomQuery',
    custom_query_id = custom_query_id,
    data = tostring(data)
  }, callback or dl_cb, data))
end

function tdbot.setAlarm(seconds, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setAlarm',
    seconds = seconds
  }, callback or dl_cb, data))
end

function tdbot.getCountryCode(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getCountryCode'
  }, callback or dl_cb, data))
end

function tdbot.getInviteText(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getInviteText'
  }, callback or dl_cb, data))
end

function tdbot.getTermsOfService(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getTermsOfService'
  }, callback or dl_cb, data))
end

function tdbot.setProxy(proxy, server, port, username, password, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'setProxy',
    proxy = {
      ["@type"] = 'proxy' .. proxy,
      server = server,
      port = port,
      username = username,
      password = password
    }
  }, callback or dl_cb, data))
end

function tdbot.getProxy(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'getProxy'
  }, callback or dl_cb, data))
end

function tdbot.testCallEmpty(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testCallEmpty'
  }, callback or dl_cb, data))
end

function tdbot.testCallString(x, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testCallString',
    x = tostring(x)
  }, callback or dl_cb, data))
end

function tdbot.testCallBytes(x, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testCallBytes',
    x = x
  }, callback or dl_cb, data))
end

function tdbot.testCallVectorInt(x, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testCallVectorInt',
    x = vectorize(x)
  }, callback or dl_cb, data))
end

function tdbot.testCallVectorIntObject(x, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testCallVectorIntObject',
    x = vectorize(x)
  }, callback or dl_cb, data))
end

function tdbot.testCallVectorString(x, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testCallVectorString',
    x = vectorize(x)
  }, callback or dl_cb, data))
end

function tdbot.testCallVectorStringObject(x, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testCallVectorStringObject',
    x = vectorize(x)
  }, callback or dl_cb, data))
end

function tdbot.testSquareInt(x, callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testSquareInt',
    x = x
  }, callback or dl_cb, data))
end

function tdbot.testNetwork(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testNetwork'
  }, callback or dl_cb, data))
end

function tdbot.testGetDifference(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testGetDifference'
  }, callback or dl_cb, data))
end

function tdbot.testUseUpdate(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testUseUpdate'
  }, callback or dl_cb, data))
end

function tdbot.testUseError(callback, data)
  assert (tdbot_function ({
    ["@type"] = 'testUseError'
  }, callback or dl_cb, data))
end

function tdbot.sendText(chat_id, reply_to_message_id, text, parse_mode, disable_web_page_preview, clear_draft, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageText',
    disable_web_page_preview = disable_web_page_preview,
    text = {text = text},
    clear_draft = clear_draft
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, parse_mode, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendAnimation(chat_id, reply_to_message_id, animation, caption, parse_mode, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageAnimation',
    animation = getInputFile(animation),
    caption = {text = caption}
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, parse_mode, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendAudio(chat_id, reply_to_message_id, audio, caption, parse_mode, title, performer,  disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageAudio',
    audio = getInputFile(audio),
    caption = {text = caption},
    title = tostring(title),
    performer = tostring(performer)
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, parse_mode, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendDocument(chat_id, reply_to_message_id, document, caption, parse_mode, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageDocument',
    document = getInputFile(document),
   
    caption = {text = caption}
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, parse_mode, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendPhoto(chat_id, reply_to_message_id, photo,caption, parse_mode,width, height, ttl, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessagePhoto',
    photo = getInputFile(photo),
    caption = {text = caption},
    added_sticker_file_ids = {},
    width = width,
    height = height,
    ttl = ttl or 0
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, parse_mode, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendSticker(chat_id, reply_to_message_id, sticker, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageSticker',
    sticker = getInputFile(sticker),
    width = 0,
    height = 0
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, nil, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendVideo(chat_id, reply_to_message_id, video, caption, parse_mode)
  local input_message_content = {
    ["@type"] = 'inputMessageVideo',
    video = getInputFile(video),
    caption = {text = caption}

  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, parse_mode, true, true, nil, nil, nil)
end

function tdbot.sendVideoNote(chat_id, reply_to_message_id, video_note, duration, length, thumbnail, thumb_width, thumb_height, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageVideoNote',
    video_note = getInputFile(video_note),
    thumbnail = {
      ["@type"] = 'inputThumbnail',
      thumbnail = getInputFile(thumbnail),
      width = thumb_width,
      height = thumb_height
    },
    duration = duration,
    length = length
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, nil, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendVoiceNote(chat_id, reply_to_message_id, voice_note, caption, parse_mode,  disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageVoiceNote',
    voice_note = getInputFile(voice_note),
    caption = {text = caption}
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, parse_mode, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendLocation(chat_id, reply_to_message_id, latitude, longitude, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageLocation',
    location = {
      ["@type"] = 'location',
      latitude = latitude,
      longitude = longitude
    },
    live_period = liveperiod
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, nil, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendVenue(chat_id, reply_to_message_id, latitude, longitude, title, address, provider, id, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageVenue',
    venue = {
      ["@type"] = 'venue',
      location = {
        ["@type"] = 'location',
        latitude = latitude,
        longitude = longitude
      },
      title = tostring(title),
      address = tostring(address),
      provider = tostring(provider),
      id = tostring(id)
    }
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, nil, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendContact(chat_id, reply_to_message_id, phone_number, first_name, last_name, user_id, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageContact',
    contact = {
      ["@type"] = 'contact',
      phone_number = tostring(phone_number),
      first_name = tostring(first_name),
      last_name = tostring(last_name),
      user_id = user_id
    }
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, nil, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendGame(chat_id, reply_to_message_id, bot_user_id, gameshortname, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageGame',
    bot_user_id = bot_user_id,
    game_short_name = tostring(gameshortname)
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, nil, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendInvoice(chat_id, reply_to_message_id, invoice, title, description, photo_url, photo_size, photo_width, photo_height, payload, provider_token, provider_data, start_parameter, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageInvoice',
    invoice = invoice,
    title = tostring(title),
    description = tostring(description),
    photo_url = tostring(photo_url),
    photo_size = photo_size,
    photo_width = photo_width,
    photo_height = photo_height,
    payload = payload,
    provider_token = tostring(provider_token),
    provider_data = tostring(provider_data),
    start_parameter = tostring(start_parameter)
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, nil, disable_notification, from_background, reply_markup, callback, data)
end

function tdbot.sendForwarded(chat_id, reply_to_message_id, from_chat_id, message_id, in_game_share, disable_notification, from_background, reply_markup, callback, data)
  local input_message_content = {
    ["@type"] = 'inputMessageForwarded',
    from_chat_id = from_chat_id,
    message_id = message_id,
    in_game_share = in_game_share
  }
  sendMessage(chat_id, reply_to_message_id, input_message_content, nil, disable_notification, from_background, reply_markup, callback, data)
end

return tdbot
