-- You must provide a handle function, otherwise bad things will happen
 
function handle(msg, message)
  -- msg is the original msg object
  -- message is substring of text following robo's name, which is a string
  if string.match(message, 'congratulate(.*)') then
    reply(msg, 'Well Done' .. string.match(message, 'congratulate(.*)'))
  elseif message == 'sleep' then
    reply(msg, 'Robo never sleeps: Sleep is for wimps.')
  else 
    reply(msg, 'Sorry ' .. tostring(msg.from.print_name) .. ", I don't understand")
  end
