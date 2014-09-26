telegram-robot
==============

A programmable robot for the telegram CLI
* Download & build telegram CLI here: https://github.com/vysheng/tg
* Create a file env.lua (in the current directory) containing "me = 'Name_Of_Current_Robot'"
* Run with "./bin/telegram-cli -s robo.lua"

Send messages to Robo over telegram.
* "Robo help" to get a current status 
* "Robo load &lt;gist url&gt;" to tell the robot to download recipes 

If robo is in a group conversation, he will reply to the group. If it's a private conversation, he'll just reply to the sender.
