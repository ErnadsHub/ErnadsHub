local bootTime = os.time()
local disconnected = false

local altctrl = _G.ALTCTRL or false
local SPIN_POWER = 100
local FLOAT_HEIGHT = 9

local bot = game.Players.LocalPlayer
local HH = bot.Character.Humanoid.HipHeight

for i, plr in pairs(game.Players:GetPlayers()) do
	for i, obj in pairs(plr:GetChildren()) do
		if obj.Name == "BotBlacklist" then
			obj:Destroy()		
		end
	end
end

--[[ configuration ]]--

local whitelisted = {
	bot.Name,
	"TYPEYOURNAMEHERE"
}


local showbotchat = _G.showBotChat or false --setting this to true will cause all messages sent by either commands or to begin with [Bot]
local allwhitelisted = _G.defaultAllWhitelisted or false --set to true if you want everyone to be whitelisted, nicK is not responsible for anything players make you do or say.
local randommoveinteger = _G.defaultRandomMoveInteger or 15 --interval in which how long randommove waits until choosing another direction
local prefix = _G.defaultPrefix or "." --DO NOT SET TO MORE THAN 1 CHARACTER!

if _G.preWhitelisted and type(_G.preWhitelisted) == "table" then
	for i, v in pairs(_G.preWhitelisted) do
		table.insert(whitelisted, v)
	end
end

if prefix:len() > 1 then
	warn("Bot // Prefix cannot be more than 1 character long!")
	return
end

--[[ end configs, don't edit this especially if you have no idea what Lua is lmao ]]--

local botversion = "v0.1.3 Public Beta Release"
local botchangelogs = "Added a few commands!"

local gameData = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local status = nil
local followplr = nil
local copychatplayer = nil

local TS = game:GetService("TweenService")

local TI = TweenInfo.new(
	2.5,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.Out,
	0,
	false,
	0
)

local function chat(msg)
	game.TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
end

local funfacts = {
	"My dad came back from getting the milk 0.03 seconds ago.",
	"We are playing Roblox.",
	"If you spend a penny, you lose that penny.",
	"Press 'Y' to jump.",
	"Among Us is extremely old.",
	"Press Alt + F4 to get 1 billion dollars on the spot.",
	"Press U to walk forward.",
	"I found a lucky penny!",
	"You found this fun fact.",
	"The sandwich was invented in the 1700s.",
	"If you drink poison, you might die.",
	"Hot water will turn into ice faster than cold water.",
	"The Mona Lisa has no eyebrows.",
	"The strongest muscle in the body is the tongue.",
	"Ants take rest for around 8 minutes in a 12-hour period.",
	"'I am' is the shortest complete sentence in the English language.",
	"Coca-Cola was originally green.",
	"I got most of these fun facts from Google.",
	"Rabbits can't get sick.",
	"McDonald's invented a sweet-tasting type of broccoli.",
	"Water makes different sounds depending on its temperature.",
}

local messageReceived = game.TextChatService.TextChannels.RBXGeneral.MessageReceived

local commandsMessage = {
	"cmds, reset, say <message>, pick <options>, dance, whitelist <player>, blacklist <player>, coinflip, random <min> <max>, bring, walkto <player>",
	"setprefix <newPrefix>, setstatus <newStatus>, clearStatus, point, wave, funfact, time, speed, fps, sit, rush, randommove, randomplayer, rickroll, disablecommand <command>",
	"salute, announce <announcement>, help <command>, jobid, aliases <command>, math <operation> <nums>, changelogs, gamename, playercount, maxplayers, toggleall, setinterval",
	"lua <lua>, ping, catch <player>, copychat <player>, cheer, stadium, spin <speed>, float <height>, orbit <speed> <radius>, jump, follow, unfollow, executor",
}

local orbitcon

local function orbit(target, speed, radius)
	local r = tonumber(radius) or 10
	local rps = tonumber(speed) or math.pi
	local orbiter = bot.Character.HumanoidRootPart
	local angle = 0
	orbitcon = game:GetService("RunService").Heartbeat:Connect(function(dt)
		if not target.Character then return end
		origin = target.Character.HumanoidRootPart.CFrame
		angle = (angle + dt * rps) % (2 * math.pi)
		orbiter.CFrame = origin * CFrame.new(math.cos(angle) * r, 0, math.sin(angle) * r)
	end)
end

local function unorbit()
	orbitcon:Disconnect()
end

local commands --don't change, could lead to errors

local function checkCommands(cmd)
	for i, cmds in pairs(commands) do
		if cmds == cmd or table.find(cmds.Aliases, cmd) or cmds.Name == cmd then
			return cmds	
		end
	end
	
	return nil
end

local rushing = false
local rickrolling = false

local function searchPlayers(query)
	query = string.lower(query)
	
	for i, player in pairs(game.Players:GetPlayers()) do
		if string.find(string.lower(player.DisplayName), query) or string.find(string.lower(player.Name), query) then
			return player
		end
	end
	
	return nil
end

commands = {
	cmds = {
		Name = "cmds",
		Aliases = {"commands"},
		Use = "Lists all commands!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			task.spawn(function()
				for i, cmd in pairs(commandsMessage) do
					chat(cmd)
					wait(0.5)
				end
			end)
		end,
	},
	aliases = {
		Name = "aliases",
		Aliases = {},
		Use = "Lists the aliases for the given command!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			task.spawn(function()
				if not args[2] then return end
				
				local cmd = checkCommands(args[2])
				
				local function getAliases(c)
					local str = ""
					
					if #c.Aliases == 0 then return "None" end
					
					for i, a in pairs(c.Aliases) do
						str = str .. a .. ", "
					end
					
					return str
				end
				
				if cmd then
					chat(cmd.Name .. " - " .. getAliases(cmd))
				else
					chat("Invalid command!")
				end
			end)
		end,
	},
	help = {
		Name = "help",
		Aliases = {"help"},
		Use = "Tells you the use of <command>!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			task.spawn(function()
				if not args[2] then
					return
				end
				
				if string.sub(args[2], 1, 1) == prefix then
					args[2] = string.sub(args[2], 2)
				end
			
				local cmd = checkCommands(args[2])
				
				if cmd then
					chat(cmd.Name .. " - " .. cmd.Use)
				else
					chat("Invalid command!")
				end
			end)
		end,
	},
	reset = {
		Name = "reset",
		Aliases = {"re"},
		Use = "Respawns bot!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			local hum = bot.Character:FindFirstChildWhichIsA("Humanoid")
			
			if hum then
				hum.Health = 0
			end
		end,
	},
	rejoin = {
		Name = "rejoin",
		Aliases = {"rj"},
		Use = "Rejoins bot!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			if speaker ~= bot.Name and altctrl == false then chat("Invalid permissions to rejoin.") return end
		
			if #game.Players:GetPlayers() <= 1 then
				print("Rejoining (NEW SERVER)")
				game.Players.LocalPlayer:Kick("\nBot - Rejoining...")
				wait()
				game:GetService('TeleportService'):Teleport(game.PlaceId, game.Players.LocalPlayer)
			else
				print("Bot is rejoining...")
				game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
			end
		end,
	},
	catch = {
		Name = "catch",
		Aliases = {"catchin4k", "c14"},
		Use = "Makes bot catch the given player in 4K!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			local plr
			
			if args[2] then
				if args[2] == "random" then
					local players = game.Players:GetPlayers()
					
					plr = players[math.random(1, #players)]
				else
					local searched = searchPlayers(args[2])
				
					if searched ~= nil then
						plr = searched
					else
						chat("Invalid player!")
						return
					end
				end
			else
				plr = game.Players:FindFirstChild(speaker)
			end
			
			if plr then
				bot.Character:SetPrimaryPartCFrame(CFrame.new(plr.Character.HumanoidRootPart.Position))
				chat("📸 CAUGHT IN 4K 📸")
			end
		end,
	},
	ping = {
		Name = "ping",
		Aliases = {"getping"},
		Use = "Chats bot's ping!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			chat("Ping: " .. tostring(math.floor(game:GetService("Stats").PerformanceStats.Ping:GetValue() + 0.5)) .. " ms")
		end,
	},
	executor = {
		Name = "executor",
		Aliases = {"identifyexecutor", "getexec", "exec"},
		Use = "Gives you the executor that is running!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			chat("Executor: " .. identifyexecutor() or "Unknown")
		end,
	},
	lua = {
		Name = "lua",
		Aliases = {"runlua", "run", "luau"},
		Use = "Gives you the executor that is running!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			if speaker ~= bot.Name then
				chat("You do not have permission to run LuaU.")
				return
			end
			
			local torun = string.sub(msg, 5)
			
			local success, errMsg = pcall(function()
				loadstring(torun)()
			end)
			
			if success then
				chat("Successfully ran LuaU with no errors.")
			elseif not success and errMsg then
				chat("Failed to run LuaU with error in Developer Console [F9]!")
			end
		end,
	},
	setinterval = {
		Name = "setinterval",
		Aliases = {"setrandommoveinterval", "setint", "setinteger"},
		Use = "Respawns!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			if speaker ~= bot.Name then return end
		
			if not args[2] then return end
			if not tonumber(args[2]) then return end
		
			randommoveinteger = tonumber(args[2])
		end,
	},
	toggleall = {
		Name = "toggleall",
		Aliases = {"all", "allwl", "wlall"},
		Use = "Respawns!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			task.spawn(function()
				if speaker ~= bot.Name then return end
			
				allwhitelisted = not allwhitelisted
				
				wait()
				
				chat("Set all_whitelisted to " .. tostring(allwhitelisted))
			end)
		end,
	},
	gamename = {
		Name = "gamename",
		Aliases = {"gn"},
		Use = "Chats the current game's name!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			chat(gameData.Name)
		end,
	},
	playercount = {
		Name = "playercount",
		Aliases = {"plrcount"},
		Use = "Chats the current amount of players!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			chat(tostring(#game.Players:GetPlayers()))
		end,
	},
	maxplayers = {
		Name = "maxplayers",
		Aliases = {"maxplrs"},
		Use = "Chats the current server's maximum player count!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			chat(tostring(game.Players.MaxPlayers))
		end,
	},
	unfollow = {
		Name = "unfollow",
		Aliases = {"unfollowplr"},
		Use = "Respawns!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				task.spawn(function()
					followplr = nil
					wait()
					bot.Character.Humanoid:MoveTo(bot.Character.HumanoidRootPart.Position)
				end)
			end)
		end,
	},
	follow = {
		Name = "follow",
		Aliases = {"followplr"},
		Use = "Makes bot follow you or the given player!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			local plr
			
			if args[2] then
				if args[2] == "random" then
					local players = game.Players:GetPlayers()
					
					plr = players[math.random(1, #players)]
				else
					local searched = searchPlayers(args[2])
				
					if searched ~= nil then
						plr = searched
					else
						chat("Invalid player!")
						return
					end
				end
			else
				plr = game.Players:FindFirstChild(speaker)
			end
			
			followplr = plr
		end,
	},
	jobid = {
		Name = "jobid",
		Aliases = {"serverid"},
		Use = "Returns the current server's Server ID, or Job ID.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			chat(game.JobId)
		end,
	},
	say = {
		Name = "say",
		Aliases = {"chat"},
		Use = "Says the <message> in chat!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			local tosay
			
			if args[1] == "say" then
				tosay = string.sub(msg, 6)
			else
				tosay = string.sub(msg, 8)
			end
			
			local speakerplayer = game.Players:FindFirstChild(speaker)
			
			if not speakerplayer then return end
			
			if altctrl then chat(tosay) else chat(speakerplayer.DisplayName .. ": " .. tosay) end
		end,
	},
	pick = {
		Name = "pick",
		Aliases = {"choose"},
		Use = "Picks an item from the given arguments.",
		Enabled = true,
		CommandFunction = function(msg, args)
			local choosefrom = {}
		
			for i, opt in pairs(args) do
				if i >= 2 then
					table.insert(choosefrom, opt)
				end
			end
			
			local chosen = choosefrom[math.random(1, #choosefrom)]
			
			if chosen then
				chat("Bot chose: " .. chosen)
			end
		end,
	},
	dance = {
		Name = "dance",
		Aliases = {},
		Use = "Makes dance!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			game:GetService("Players"):Chat("/e dance")
		end,
	},
	point = {
		Name = "point",
		Aliases = {},
		Use = "Makes bot point!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			game:GetService("Players"):Chat("/e point")
		end,
	},
	stadium = {
		Name = "stadium",
		Aliases = {},
		Use = "Makes bot do the stadium emote!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			game:GetService("Players"):Chat("/e stadium")
		end,
	},
	cheer = {
		Name = "cheer",
		Aliases = {},
		Use = "Makes bot cheer!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			game:GetService("Players"):Chat("/e cheer")
		end,
	},
	wave = {
		Name = "wave",
		Aliases = {},
		Use = "Makes bot wave!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			game:GetService("Players"):Chat("/e wave")
		end,
	},
	sit = {
		Name = "sit",
		Aliases = {},
		Use = "Makes bot sit!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			bot.Character.Humanoid.Sit = true
		end,
	},
	salute = {
		Name = "salute",
		Aliases = {},
		Use = "Makes bot salute!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			game.Players:Chat("/e salute")
		end,
	},
	jump = {
		Name = "jump",
		Aliases = {},
		Use = "Makes bot jump!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			bot.Character.Humanoid.Jump = true
		end,
	},
	announce = {
		Name = "announce",
		Aliases = {},
		Use = "Makes an announcement via chat, a owner-only command!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			if speaker ~= bot.Name then return end
		
			chat("-- ANNOUNCEMENT -- ")
			wait()
			chat(string.sub(msg, 10))
			wait()
			chat("-- ANNOUNCEMENT --")
		end,
	},
	whitelist = {
		Name = "whitelist",
		Aliases = {"wl"},
		Use = "Whitelists a player, meaning they can use the bot. An owner-only command!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			local towhitelist = args[2]
			
			if speaker ~= bot.Name then return end
			
			if towhitelist then
				if towhitelist == "all" then
					for i, player in pairs(game.Players:GetPlayers()) do
						table.insert(whitelisted, player.Name)
						local bl = player:FindFirstChild("BotBlacklist")
						if bl then bl:Destroy() else warn(player.DisplayName .. " was not blacklisted!") end
					end
					
					allwhitelisted = true
					
					chat("Whitelisted all players that are currently in the game! Type .cmds to view commands.")
				else
					local plr = searchPlayers(towhitelist)
					
					if plr then
						table.insert(whitelisted, plr.Name)
						local bl = plr:FindFirstChild("BotBlacklist")
						if bl then bl:Destroy() else warn(player.DisplayName .. " was not blacklisted!") end
						chat("Whitelisted " .. plr.DisplayName .. "! Type .cmds to view commands.")
					else
						chat("Failed to whitelist player - User not found!")
					end
				end
			end
		end,
	},
	blacklist = {
		Name = "blacklist",
		Aliases = {"bl"},
		Use = "Blacklists a player meaning they cannot use bot commands. Owner-only command!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			local toblacklist = args[2]
			
			if speaker ~= bot.Name then return end
			
			if toblacklist then
				if toblacklist == "all" then
					for i, p in pairs(game.Players:GetPlayers()) do
						local alrbl = p:FindFirstChild("BotBlacklist")
						
						if alrbl then alrbl:Destroy() end
					
						local new = Instance.new("BoolValue")
						new.Parent = p
						new.Name = "BotBlacklist"
						new.Value = true
					end
					
					allwhitelisted = false
					
					chat("Blacklisted all players that are currently in the game! They can no longer run commands.")
				else
					local plr = searchPlayers(toblacklist)
					
					if plr then
						local alrbl = plr:FindFirstChild("BotBlacklist")
						
						if alrbl then alrbl:Destroy() end
					
						local new = Instance.new("BoolValue")
						new.Parent = plr
						new.Name = "BotBlacklist"
						new.Value = true
						alwhitelisted = false
						chat("Blacklisted " .. plr.DisplayName .. "! They can no longer run commands.")
					else
						chat("Failed to blacklist player - User not found!")
					end
				end
			end
		end,
	},
	coinflip = {
		Name = "coinflip",
		Aliases = {"flip", "coin"},
		Use = "Flips a coin using a randomly generated number from 1 to 2.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			local flipped = math.random(1, 2)
			
			if flipped == 1 then
				chat("HEADS!")
			elseif flipped == 2 then
				chat("TAILS!")
			else
				chat("Whoops! An unknown error occured while flipping the coin. That's a bit embarrasing.")
			end
		end,
	},
	random = {
		Name = "random",
		Aliases = {},
		Use = "Generates a random number between the given numbers!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			if args[2] and args[3] then
				local rnd = math.random(tonumber(args[2]), tonumber(args[3]))
				
				if rnd then
					chat("Bot // Generated random number between " .. args[2] .. " and " .. args[3] .. ": " .. rnd)
				else
					chat("Aw, snap! An error occured while generating a random number.")
				end
			end
		end,
	},
	bring = {
		Name = "bring",
		Aliases = {},
		Use = "Brings bot to the player that chatted the command.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				local plr = game.Players:FindFirstChild(speaker)
			
				if plr then
					bot.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame)
				end
			end)
		end,
	},
	copychat = {
		Name = "copychat",
		Aliases = {"cc", "copyc", "cchat"},
		Use = "Copies everything the given player says.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				local player = nil
			
				if args[2] then
					if args[2] == "random" then
						player = game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]
					else
						player = searchPlayers(args[2])
					end
				else
					player = game.Players:FindFirstChild(speaker)
				end
				
				if player then
					copychatplayer = player
					chat("Now copying " .. player.DisplayName .. "'s chat!")
				else
					chat("Invalid player!")
				end
			end)
		end,
	},
	uncopychat = {
		Name = "uncopychat",
		Aliases = {"uncc", "uncopyc", "uncchat"},
		Use = "Makes bot stop copying everything the copychat player says.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if copychatplayer then
					chat("Stopped copying " .. copychatplayer.DisplayName .. "!")
					copychatplayer = nil
				else
					chat("Bot is not copying anyone!")
				end
			end)
		end,
	},
	to = {
		Name = "to",
		Aliases = {},
		Use = "Teleports bot to the <player> given.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if not args[2] then return end
			
				local plr = nil
				
				if args[2] == "random" then
					local players = game.Players:GetPlayers()
					
					plr = players[math.random(1, #players)]
				else
					plr = searchPlayers(args[2])
				end
			
				if plr then
					bot.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame)
				else
					chat("Invalid player!")
				end
			end)
		end,
	},
	walkto = {
		Name = "walkto",
		Aliases = {"come"},
		Use = "Makes bot walk to you or the given player!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				local plr
				
				if not args[2] then plr = game.Players:FindFirstChild(speaker) end
				
				if args[2] and args[2] == "random" then
					plr = game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]
				elseif args[2] then
					plr = searchPlayers(args[2])
				end
			
				if plr and plr:IsA("Player") then
					bot.Character.Humanoid:MoveTo(plr.Character.HumanoidRootPart.Position)
				else
					chat("Could not find player!")
				end
			end)
		end,
	},
	setprefix = {
		Name = "setprefix",
		Aliases = {"prefix"},
		Use = "Sets the prefix of bot! Owner-only command!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if not args[2] then return end
			
				if speaker == bot.Name then
					if args[2] == "#" then return end
					if string.len(args[2]) >= 2 then chat("Maximum prefix length is 1 character!") return end
				
					prefix = args[2]
					chat("Successfully set prefix to '" .. prefix .. "'!")
				else
					chat("You do not have the permissions to run .setprefix!")
				end
			end)
		end,
	},
	setstatus = {
		Name = "setstatus",
		Aliases = {},
		Use = "Sets the status of bot. When a status is set, the bot will no longer take commands.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if not args[2] then return end
			
				if speaker == bot.Name then
					status = string.sub(msg, 12)
					chat("Successfully set status to '" .. status .. "'!")
				else
					chat("You do not have the permissions to run .setstatus!")
				end
			end)
		end,
	},
	clearstatus = {
		Name = "clearstatus",
		Aliases = {"nostatus"},
		Use = "Clears the status and allows the bot to take commands again!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if speaker == bot.Name then
					status = nil
					chat("Successfully cleared status!")
				else
					chat("You do not have the permissions to run .clearstatus!")
				end
			end)
		end,
	},
	funfact = {
		Name = "funfact",
		Aliases = {"fact", "randomfact"},
		Use = "Gives you a random fun fact!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				local rnd = funfacts[math.random(1, #funfacts)]
				
				chat("Fun Fact: " .. rnd)
			end)
		end,
	},
	time = {
		Name = "time",
		Aliases = {"currenttime"},
		Use = "Gives you bot's current time in its timezone.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				chat("Bot's current time is: " .. os.date("%I:%M:%S %p"))
			end)
		end,
	},
	rickroll = {
		Name = "rickroll",
		Aliases = {"rick", "roll", "rr"},
		Use = "Rickrolls the chat!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				task.spawn(function()
					rickrolling = true
					chat("Never gonna give you up!")
					wait(1)
					chat("Never gonna let you down!")
					wait(1)
					chat("Never gonna run around, and")
					wait(1)
					chat("Desert you!")
					rickrolling = false
				end)
			end)
		end,
	},
	walkspeed = {
		Name = "walkspeed",
		Aliases = {"speed"},
		Use = "Sets bot's walkspeed to <speed>!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if not args[2] then return end
				if not tonumber(args[2]) then return end
				
				if tonumber(args[2]) > 1000 then
					chat("Whoops! That speed is over the speed limit of 1000.")
					return
				end
			
				bot.Character.Humanoid.WalkSpeed = tonumber(args[2])
				
				chat("Changed walkspeed to " .. args[2] .. "!")
			end)
		end,
	},
	fps = {
		Name = "fps",
		Aliases = {},
		Use = "Chats bot's current FPS!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				chat("FPS is: " .. tostring(math.round(game.Workspace:GetRealPhysicsFPS())))
			end)
		end,
	},
	math = {
		Name = "math",
		Aliases = {},
		Use = "Does <operation> on arguments.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if not args[2] then return end
				if not args[3] then return end
				if not args[4] then return end
				
				local operations = {
					"add",
					"subtract",
					"multiply",
					"divide"
				}
				
				local operation = args[2]
				
				if not table.find(operations, operation) then
					chat("Invalid operation!")
					return
				end
				
				local result
				
				local nums = {}
				
				for i, arg in pairs(args) do
					if i > 2 then
						if tonumber(arg) then
							table.insert(nums, tonumber(arg))
						else
							chat("Attempt to do math on unknown characters!")
							return	
						end
					end
				end
				
				for i, num in pairs(nums) do
					if i == 1 then
						result = num
					else
						if operation == "add" then
							result = result + num
						elseif operation == "subtract" then
							result = result - num
						elseif operation == "divide" then
							result = result / num
						elseif operation == "multiply" then
							result = result * num
						end
					end
				end
				
				chat("Result: " .. tostring(result))
			end)
		end,
	},
	disablecommand = {
		Name = "disablecommand",
		Aliases = {"disablecmd", "cmddisable"},
		Use = "Disables the specified command. Owner-only command!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if not speaker == bot.Name then chat("You do not have permission to disable this command.") return end
			
				if not args[2] then return end
			
				local cmd = checkCommands(args[2])
			
				if not cmd then
					chat("Invalid command!")
					return
				end
				
				cmd.Enabled = false
				chat("Disabled command: " .. cmd.Name .. "!")
			end)
		end,
	},
	enablecommand = {
		Name = "enablecommand",
		Aliases = {"enablecmd", "cmdenable"},
		Use = "Enables the specified command! Owner-only command!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if not speaker == bot.Name then chat("You do not have permission to disable this command.") return end
			
				if not args[2] then return end
			
				local cmd = checkCommands(args[2])
			
				if not cmd then
					chat("Invalid command!")
					return
				end
				
				cmd.Enabled = true
				chat("Enabled command: " .. cmd.Name .. "!")
			end)
		end,
	},
	randomplayer = {
		Name = "randomplayer",
		Aliases = {"rndplayer", "randomplr", "player"},
		Use = "Gets a random player that is currently in the server and chats their display name!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				local rnd = game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]
				
				if rnd then
					chat("Random player: " .. rnd.DisplayName)
				end
			end)
		end,
	},
	randommove = {
		Name = "randommove",
		Aliases = {"rndmove", "autowalk"},
		Use = "Toggles bot's random movement feature!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				randommove = not randommove
				
				if randommove == true then
					chat("Enabled random move!")
				else
					chat("Disabled random move!")
				end
			end)
		end,
	},
	rush = {
		Name = "rush",
		Aliases = {"rushbegin"},
		Use = "Makes bot turn into Rush from DOORS!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				if rushing == true then return end
				rushing = true
				chat("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
				local origin = bot.Character.HumanoidRootPart.Position
				local startpos = bot.Character.HumanoidRootPart.Position - Vector3.new(-150, 0, 0)
				bot.Character:SetPrimaryPartCFrame(CFrame.new(startpos))
				wait(1.5)
				chat("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
				local movetween = TS:Create(bot.Character.HumanoidRootPart, TI, {CFrame = CFrame.new(origin)})
				movetween:Play()
				movetween.Completed:Wait()
				chat("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
				wait(10)
				rushing = false
			end)
		end,
	},
	altcontrol = {
		Name = "altcontrol",
		Aliases = {"altctrl"},
		Use = "Removes the name from the .say command.",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				altctrl = true
				chat("Enabled alt control mode!")
			end)
		end,
	},
	spin = {
		Name = "spin",
		Aliases = {"rotate"},
		Use = "Makes the bot spin!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				local pwr = 100
				
				if args[2] and tonumber(args[2]) then pwr = tonumber(args[2]) end
			
				local already = bot.Character.HumanoidRootPart:FindFirstChild("Spinner")
				
				if already then already:Destroy() end
			
				local spinner = Instance.new("BodyAngularVelocity")
				spinner.Name = "Spinner"
				spinner.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
				spinner.MaxTorque = Vector3.new(0,math.huge,0)
				spinner.AngularVelocity = Vector3.new(0,pwr,0)
			end)
		end,
	},
	unspin = {
		Name = "unspin",
		Aliases = {"unrotate"},
		Use = "Stops the spinning bot!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				local spinner = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Spinner")
				if spinner then spinner:Destroy() end
			end)
		end,
	},
	float = {
		Name = "float",
		Aliases = {"levitate"},
		Use = "Floats the bot!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				local f = 9
				if args[2] and tonumber(args[2]) then f = tonumber(args[2]) end
				bot.Character.Humanoid.HipHeight = f
			end)
		end,
	},
	unfloat = {
		Name = "unfloat",
		Aliases = {"unlevitate"},
		Use = "Unfloats the bot!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				bot.Character.Humanoid.HipHeight = HH
			end)
		end,
	},
	orbit = {
		Name = "orbit",
		Aliases = {"orbit"},
		Use = "Orbits the bot around you!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				local player = game.Players:FindFirstChild(speaker)
				
				if not player then return end
			
				orbit(player, args[2], args[3])
			end)
		end,
	},
	unorbit = {
		Name = "unorbit",
		Aliases = {"unorbit"},
		Use = "Halts the orbit!",
		Enabled = true,
		CommandFunction = function(msg, args, speaker)
			pcall(function()
				unorbit()
			end)
		end,
	},
}


local cmdcon = messageReceived:Connect(function(data)
	local message = data.Text
	
	local speakerplayer = game.Players:GetPlayerByUserId(data.TextSource.UserId)
    local speaker = speakerplayer.Name
	
	if not speakerplayer then return end

	local msg = string.lower(message)
	
	if string.sub(msg, 1, 1) == prefix then
		if speakerplayer:FindFirstChild("BotBlacklist") then
			return
		end

		if not table.find(whitelisted, speaker) and allwhitelisted == false then
			return
		end
		
		if rickrolling == true then return end
	
		msg = string.sub(msg, 2)
		
		local args = string.split(msg, " ")
		
		local cmd = checkCommands(args[1])
		
		if status ~= nil and speaker ~= bot.Name then
			chat(status .. " // Commands are disabled.")
			return
		end
		
		if cmd ~= nil then
			if cmd.Enabled == false then
				chat("The command " .. cmd.Name .. " is currently disabled. Please request it to be re-enabled by " .. bot.DisplayName .. ".")
				print("Bot CMDLogs // " .. speaker .. " attempted to run command: " .. cmd.Name .. " with arguments: " .. tts(args) .. "while the command was disabled.")
				return
			else
				cmd.CommandFunction(message, args, speaker)
				
				local function tts(t)
					local r = ""
					
					for i, v in pairs(t) do
						r = r .. v .. ", "
					end
					
					return r
				end
				
				print("Bot CMDLogs // " .. speaker .. " ran command: " .. cmd.Name .. " with arguments: " .. tts(args))
			end
		else
			warn("Could not find command: " .. args[1] .. "!")
		end
	elseif speakerplayer == copychatplayer then
		if altctrl then chat(message) else chat(speakerplayer.DisplayName .. ": " .. message) end
	end
end)

bot.Chatted:Connect(function(msg)
	if (string.lower(msg) == "disable()" or string.lower(msg) == "disconnect()") and disconnected == false then
		cmdcon:Disconnect()
		disconnected = true
		wait()
		chat("Successfully disconnected.")
	end
end)

task.spawn(function()
	while wait(randommoveinteger) do
		if randommove == true and disconnected == false then
			local rndnum = math.random(1,4)
			local add = Vector3.new(0,0,0)
			
			if rndnum == 1 then
				add = Vector3.new(15,0,0)
			elseif rndnum == 2 then
				add = Vector3.new(-15,0,0)
			elseif rndnum == 3 then
				add = Vector3.new(0,0,15)
			else
				add = Vector3.new(0,0,-15)
			end
			
			bot.Character.Humanoid:MoveTo(bot.Character.HumanoidRootPart.Position + add)
		end
	end
end)
task.spawn(function()
	chat("Bot Enabled.")
end)

task.spawn(function()
	while wait() do
		if followplr and disconnected == false then
			local hum = bot.Character.Humanoid
			
			if hum then
				hum:MoveTo(followplr.Character.HumanoidRootPart.Position)		
			end
		end
	end
end)
