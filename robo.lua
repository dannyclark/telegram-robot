if loadfile('env.lua') then
  dofile('env.lua')
  if not me then
    print('ERROR: env.lua needs to define me as the name of this robot')
    os.exit(1)
  end
else
  print('ERROR: There needs to be a file env.lua which defines a variable me as the name of this robot')
  os.exit(1)
end

print ("Robot: " .. me .. " has woken up")

function load_recipes()
  dofile('recipes.lua')
  info_found = nil
  f = io.open('recipes.lua', 'r')
  line = f:read()
  repeat
    info_found = string.match(line, '^--META:(.*):META$')
    line = f:read()
  until not line or info_found
  f.close()
  return info_found or "I have no information on the current recipe book" 
end

if loadfile('recipes.lua') then
  recipe_book = load_recipes()
else
  function handle(msg, message)
  end
  recipe_book = "No recipes are currently installed"
end

print('Recipe Book: ' .. recipe_book)

function reply(msg, text)
  if tostring(msg.to.print_name) == me then
    destination = msg.from.print_name
  else
    destination = msg.to.print_name
  end
  print ('sending: ' .. text .. ' to: ' .. tostring(destination))
  send_msg(destination, text, ok_cb, false)
end

function append_recipe_book(msg, url)
  f = io.open('recipes.lua', 'a')
  f:write("\n--META:The current recipe book was downloaded from: " .. url .. " by: " .. tostring(msg.from.print_name) .. " at: " .. os.date("%a %d %b %X") .. ":META\n")
  f:close()
end

function reload(msg, s)
  url = s
  if not string.match(s, 'raw$') then
    url = s .. '/raw'
    print('raw url: ' .. url)
  end
  command = 'wget ' .. url .. ' -O new_recipes.lua'
  print (command)
  if os.execute(command) then
    if loadfile('new_recipes.lua') then
      os.execute('mv new_recipes.lua recipes.lua')
      append_recipe_book(msg, s)
      recipe_book = load_recipes()
      reply(msg, 'Thanks ' .. tostring(msg.from.print_name) .. ", I've grabbed the new recipe book from: " .. s)
    else
      reply(msg, 'Sorry ' .. tostring(msg.from.print_name) .. ", but that recipe book from: " .. url .. " is rubbish. It doesn't contain valid lua.")
    end
  else
    reply(msg, 'Sorry ' .. tostring(msg.from.print_name) .. ", I know you don't tend to make mistakes, but I can't find a recipe book at: " .. url)
  end
end

function on_msg_receive (msg)
  if tostring(msg.from.print_name) == me then
    return -- don't respond to own messages
  end
  print ('got msg: ' .. msg.text .. ' from: ' .. tostring(msg.from.print_name))
  if string.match(msg.text, '^[Rr]obo load (http.*)') then
    url = string.match(msg.text, '^[Rr]obo load (http.*)')
    reload(msg, url) 
  elseif string.match(msg.text, '[Rr]obo help') then
    reply(msg, 'Robo is a community robot. You can send him a new recipe book with "Robo load <gist_url>". ' .. recipe_book)
  else
    message = string.match(msg.text, '^[Rr]obo (.*)')
    if message then
      handle(msg, message)
    end 
  end
end

function on_secret_chat_update (user, what_changed)
end

function on_user_update (user)
end

function on_chat_update (user)
end

function on_get_difference_end ()
end

function on_binlog_replay_end ()
end

function on_our_id(our_id)
end

function ok_cb(extra, success, result)
end
