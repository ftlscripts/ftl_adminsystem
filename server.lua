ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterCommand(Config.Command, function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local isAllowed = false
        for _,group in pairs(Config.AllowedGroups) do
            if group == xPlayer.getGroup() then
                isAllowed = true
                break
            end
        end

        if isAllowed then
            TriggerClientEvent('relisoft_players:drawText',source)
        else
            TriggerEvent('chat:addMessage', source, { args = { 'Uživatelé', 'Na tento příkaz nemáte oprávnění' }, color = { 255, 50, 50 } })
        end
    end
end)


local onTimer       = {}
local savedCoords   = {}
local warnedPlayers = {}
local deadPlayers   = {}

Config.ateam = "https://discord.com/api/webhooks/952508118372343808/_jBHMvTgYk1kPn3mOF2wt02WozC4ludqjWs_poDjDkB3pyZVSW1f6uguQZXgaDqWj-8D"

local DISCORD_WEBHOOK = Config.WebHook
local DISCORD_NAME = Config.Name
local ATEAM_WEBHOOK = Config.ateam
local ATEAM2_WEBHOOK = Config.ateam2
local STEAM_KEY = Config.SteamApiKey
local DISCORD_IMAGE = Config.DiscordImage -- default is FiveM logo

function havePermission(player) 
	if player.group ~= "user" then
		return true
	else 
		return false
	end	
end

--[[
RegisterCommand("tpm", function(source, args, rawCommand)	-- /tpm		teleport to waypoint
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			TriggerClientEvent("esx_admin:tpm", xPlayer.source)
		end
	end
end, false)]]

--[[
RegisterCommand("coords", function(source, args, rawCommand)	-- /coords		print exact ped location in console/F8
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		local coords = GetEntityCoords(GetPlayerPed(source))
		if havePermission(xPlayer) then
			print(GetEntityCoords(GetPlayerPed(source)))
			PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = discordhookname, content = coords, avatar_url = DISCORD_IMAGE, tts = false}), { ['Content-Type'] = 'application/json' })
		end
	end
end, false)
]]

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('fnx_adminsystem:GetGroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(tonumber(source))
	if xPlayer then
		local playergroup = xPlayer.getGroup()

		cb(tostring(playergroup))
	else
		cb("user")
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end


RegisterCommand("report", function(source, args, raw)
	local xPlayer = ESX.GetPlayerFromId(source)
	local reportedname = GetPlayerName(source)
	local reporttext = table.concat(args, " ")
	TriggerClientEvent("sendReport", -1, source, reportedname, reporttext)
	            --------------------
				local connect = {
					{
						["color"] = "16718105",
						["title"] = "REPORT",
						["description"] = "**Hráč:** " ..reportedname.. "\n **ID:** "..xPlayer.source.."\n **Steam ID:** "..GetPlayerIdentifier(source).." \n**Důvod:** " ..reporttext.. "",
						["footer"] = {
						["text"] = os.date('%H:%M:%S - %d. %m. %Y', os.time()),
						["icon_url"] = "https://cdn.discordapp.com/attachments/933399138794614830/935569008428732416/PHOENIX_LOGO.gif",
						},
					}
				}
				
					PerformHttpRequest("https://discord.com/api/webhooks/952508211091619902/7vPTuISRf562xdwHWy8SvO_LKJgR59-DkDYc2AUgaK6m1b7momq3_AEnhFpT0Qg76JRM", function(err, text, headers) end, 'POST', json.encode({username = "Report", embeds = connect}), { ['Content-Type'] = 'application/json' })
					-----------------------
end)

RegisterCommand("reply", function(source, args, raw)
	local tPID = tonumber(cm[2])
			local names2 = GetPlayerName(tPID)
			local names3 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 and i ~=2 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
			local grupos = getIdentity(source)
		    if grupos.group ~= 'user' then
			    TriggerClientEvent('textmsg', tPID, source, textmsg, names2, names3)
			    TriggerClientEvent('textsent', source, tPID, names2)
	else
		TriggerClientEvent('chatMessage', source, "Retrix Team", {255, 0, 0}, "Nemas prava")
	end
end)
RegisterCommand("discord", function(source, args, rawCommand)	-- /coords		print exact ped location in console/F8
	if source ~= 0 then
		exports["esx_adminplus"]:getDiscord("447788790262530070")
	end
end, false)

--[[
RegisterCommand("heal", function(source, args, rawCommand)	-- /coords		print exact ped location in console/F8
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		local coords = GetEntityCoords(GetPlayerPed(source))
		if havePermission(xPlayer) then
	    	if args[1] and tonumber(args[1]) then
	      		local targetId = tonumber(args[1])
	      		local xTarget = ESX.GetPlayerFromId(targetId)
	      		if xTarget then
	        		TriggerClientEvent("esx_admin:alesdev", xTarget.source)
	      		else
	        		TriggerClientEvent("esx_admin:alesdev", xPlayer.source)
	      		end
	    	else
	      		TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'BRING'))
	    	end
	  	end
	end
end, false)

RegisterCommand("players", function(source, args, rawCommand)	-- players		show online players | console only
	isPlayerOnline = false
	if source == 0 then
		local xAll = ESX.GetPlayers()
		print("^2"..#xAll.." ^3online player(s)^0")
		for i=1, #xAll, 1 do
			local xPlayer = ESX.GetPlayerFromId(xAll[i])
			print("^4[ ^2ID : ^3"..xPlayer.source.." ^0| ^2Name : ^3"..xPlayer.getName().." ^0 | ^2Group : ^3"..xPlayer.getGroup().." ^4]^0\n")
			isPlayerOnline = true
		end
		if not isPlayerOnline then
			print(_U('no_online'))
		end
	end
end, false)]]

RegisterCommand("announce", function(source, args, rawCommand)	-- /announce [MESSAGE]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if args[1] then
			local message = string.sub(rawCommand, 10)
			if xPlayer then
				if havePermission(xPlayer) then
					local jmeno = GetPlayerName(source)
					TriggerClientEvent('chat:addMessage', -1, {
						template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(24, 26, 32, 0.9); border-radius: 3px; border-right: 0px solid rgb(255, 0, 0);"><font style="padding: 0.22vw; margin: 0.22vw; background-color: rgb(255, 0, 0); border-radius: 5px; font-size: 15px;"> <b>OZNAMENI</b></font>   <font style="background-color:rgba(0, 0, 0, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"> <b> '..jmeno..' |</b></font>   <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;"> {1}</font></div>',
							args = {jmeno, message}
						})
					--TriggerClientEvent('chatMessage',-1 , _U('admin_announce', GetPlayerName(source), message))
				end
			end
		else
    		TriggerClientEvent('chatMessage', xPlayer.source, _U('invalid_input', 'ANNOUNCMENT'))
	 	end
	end
end, false)

------------ announcement -------------
--[[RegisterCommand("announce", function(source, args, rawCommand)	-- /announce [MESSAGE]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if args[1] then
			local message = string.sub(rawCommand, 10)
			if xPlayer then
				if havePermission(xPlayer) then
					TriggerClientEvent('chatMessage',-1 , _U('admin_announce', xPlayer.getName(), message))
				end
			end
		else
    		TriggerClientEvent('chatMessage', xPlayer.source, _U('invalid_input', 'ANNOUNCMENT'))
	 	end
	end
end, false)--]]
------------ Console Say -------------
RegisterCommand("say", function(source, args, rawCommand)	-- say [message]		only for server console
	if source == 0 then
		if args[1] then
			local message = string.sub(rawCommand, 4)
			print("^1SERVER Announcement ^0: "..message)
			TriggerClientEvent('chatMessage',-1 , _U('server_announce', message))
		else
			print(_U('invalid_input'))
		end
	end
end, false)

RegisterCommand("aleslookup", function(source, args, rawCommand)	-- say [message]		only for server console
	if source == 0 then
		MySQL.Async.fetchAll('SELECT ip FROM banlisthistory WHERE discord = @discord', {
			['@identifier'] = args[1],
		}, function(result)
			print(result)
		end)
	end
end, false)

---------- Bring / Bringback ----------
--[[
RegisterCommand("bring", function(source, args, rawCommand)	-- /bring [ID]
	if source ~= 0 then
	  	local xPlayer = ESX.GetPlayerFromId(source)
	  	if havePermission(xPlayer) then
	    	if args[1] and tonumber(args[1]) then
	      		local targetId = tonumber(args[1])
	      		local xTarget = ESX.GetPlayerFromId(targetId)
	      		if xTarget then
	        		local targetCoords = xTarget.getCoords()
	        		local playerCoords = xPlayer.getCoords()
	        		savedCoords[targetId] = targetCoords
	        		xTarget.setCoords(playerCoords)
	        		TriggerClientEvent("chatMessage", xPlayer.source, _U('bring_adminside', args[1]))
	        		--TriggerClientEvent("chatMessage", xTarget.source, _U('bring_playerside'))
	      		else
	        		TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'BRING'))
	      		end
	    	else
	      		TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'BRING'))
	    	end
	  	end
	end
end, false)
]]
RegisterCommand("bringback", function(source, args, rawCommand)	-- /bringback [ID] will teleport player back where he was before /bring
	if source ~= 0 then
  		local xPlayer = ESX.GetPlayerFromId(source)
  		if havePermission(xPlayer) then
    		if args[1] and tonumber(args[1]) then
      			local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
        			local playerCoords = savedCoords[targetId]
        			if playerCoords then
          			xTarget.setCoords(playerCoords)
          			TriggerClientEvent("chatMessage", xPlayer.source, _U('bringback_admin', 'BRINGBACK', args[1]))
          			--TriggerClientEvent("chatMessage", xTarget.source,  _U('bringback_player', 'BRINGBACK'))
          			savedCoords[targetId] = nil
        		else
          			TriggerClientEvent("chatMessage", xPlayer.source, _U('noplace_bring'))
        			end
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'BRINGBACK'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'BRINGBACK'))
    		end
  		end
	end
end, false)

---------- goto/goback --------
--[[
RegisterCommand("goto", function(source, args, rawCommand)	-- /goto [ID]
	if source ~= 0 then
  		local xPlayer = ESX.GetPlayerFromId(source)
  		if havePermission(xPlayer) then
    		if args[1] and tonumber(args[1]) then
      			local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					local entityplayer = GetPlayerPed(targetId)
					local targetCoords = GetEntityCoords(entityplayer)
        			TriggerClientEvent("esx_admin:SetEntityCoords", source, targetCoords)
					TriggerClientEvent('chat:addMessage', xPlayer.source, {
						template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(24, 26, 32, 0.4); border-radius: 3px; border-right: 0px solid rgb(255, 0, 0);"><font style="padding: 0.22vw; margin: 0.22vw; background-color: rgb(255, 0, 0); border-radius: 5px; font-size: 15px;"> <b>ADMIN</b></font>   <font style="background-color:rgba(0, 0, 0, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"> <b>  |</b></font>   <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;">Teleportnul jsi se na ID:  {0}</font></div>',
							args = {targetId}
						})
        		   -- TriggerClientEvent("chatMessage", xPlayer.source, _U('goto_admin', args[1]))
					--TriggerClientEvent("chatMessage", xTarget.source,  _U('goto_player'))
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'GOTO'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'GOTO'))
    		end
  		end
	end
end, false)
]]

RegisterCommand("goback", function(source, args, rawCommand)	-- /goback will teleport you back where you was befor /goto
	if source ~= 0 then
	  	local xPlayer = ESX.GetPlayerFromId(source)
	  	if havePermission(xPlayer) then
	    	local playerCoords = savedCoords[source]
	    	if playerCoords then
	      		xPlayer.setCoords(playerCoords)
				TriggerClientEvent("chatMessage", xPlayer.source, _U('goback'))
	      		savedCoords[source] = nil
	    	else
	      		TriggerClientEvent("chatMessage", xPlayer.source, _U('goback_error'))
	    	end
	  	end
	end
end, false)


---------- Noclip ------
--[[
RegisterCommand("noclip", function(source, args, rawCommand)	-- /goback will teleport you back where you was befor /goto
	if source ~= 0 then
	  	local xPlayer = ESX.GetPlayerFromId(source)
	  	if havePermission(xPlayer) then
	    	TriggerClientEvent("esx_admin:noclip", xPlayer.source)
	  	end
	end
end, false)
]]

RegisterNetEvent('esx_admin:ales')
AddEventHandler('esx_admin:ales', function(ales)
	_source = source
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
		  TriggerClientEvent("esx_admin:noclip", xPlayer.source)
		end
	end
end)


---------- kill ----------
RegisterCommand("kill", function(source, args, rawCommand)	-- /kill [ID]
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			if args[1] and tonumber(args[1]) then
				local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
					TriggerClientEvent("esx_admin:killPlayer", xTarget.source)
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('kill_admin', targetId))
					TriggerClientEvent('chatMessage', xTarget.source, _U('kill_by_admin'))
      			else
        			TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'KILL'))
      			end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'KILL'))
    		end
  		end
	end
end, false)

RegisterCommand("a", function(source, args, rawCommand)	-- /a command for adminchat
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		local playerName = GetPlayerName(source)
		if havePermission(xPlayer) then
			if args[1] then
				local message = string.sub(rawCommand, 3)
				local xAll = ESX.GetPlayers()
				for i=1, #xAll, 1 do
					local xTarget = ESX.GetPlayerFromId(xAll[i])
					if havePermission(xTarget) then
						TriggerClientEvent('chat:addMessage', xTarget.source, {
							template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(24, 26, 32, 0.9); border-radius: 3px; border-right: 0px solid rgb(255, 0, 0);"><font style="padding: 0.22vw; margin: 0.22vw; background-color: rgb(255, 128, 0); border-radius: 5px; font-size: 15px;"> <b>ADMIN - CHAT</b></font>   <font style="background-color:rgba(0, 0, 0, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"> <b> ID: ' ..source.. ' '..playerName..  ' |</b></font>  <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;">'..message..'</font></div>',
								args = {}
							})
						--TriggerClientEvent('chatMessage', xTarget.source, _U('adminchat', "ID: "..source.."", playerName, message))
						PerformHttpRequest(ATEAM_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = playerName .. " - /a" .. message .. "", content = toSay, avatar_url = DISCORD_IMAGE, tts = false}), { ['Content-Type'] = 'application/json' })
					end
				end
			else
				TriggerClientEvent('chat:addMessage', xPlayer.source, {
					template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(24, 26, 32, 0.9); border-radius: 3px; border-right: 0px solid rgb(255, 0, 0);"><font style="padding: 0.22vw; margin: 0.22vw; background-color: rgb(255, 128, 0); border-radius: 5px; font-size: 15px;"> <b>ADMIN - CHAT</b></font>   <font style="background-color:rgba(0, 0, 0, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"> <b>  |</b></font>  <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;">Prázdná zpráva</font></div>',
						args = {}
					})
			end
		end
	end
end, false)

RegisterCommand("kick", function(source, args, rawCommand)	-- /warn [ID] , will warn player and kick if execeed max warns
	if source ~= 0 then
  		local xPlayer = ESX.GetPlayerFromId(source)
  		if havePermission(xPlayer) then
    		if args[1] and tonumber(args[1]) then
					if source == tonumber(args[1]) then
						TriggerClientEvent("chatMessage", xPlayer.source, _U('selfkick'))
					else
      					local targetId = tonumber(args[1])
      					local xTarget = ESX.GetPlayerFromId(targetId)
      					if xTarget then
							if havePermission(xTarget) then
								TriggerClientEvent("chatMessage", xPlayer.source, _U('adminwarn'))
								TriggerClientEvent("chatMessage", xTarget.source, _U('adminwarn_to', args[1],xPlayer.getName(), xPlayer.getGroup()))
							else
								local warnCount = warnedPlayers[targetId] or 1
								if warnCount >= 1 then
									--DropPlayer(targetId, "Byl jsi vyhozen ze serveru"))
									TriggerClientEvent("chatMessage", xPlayer.source, _U('playerkicked1', args[2]))
									warnedPlayers[targetId] = nil
								end
							end
      					else
        				TriggerClientEvent("chatMessage", xPlayer.source, _U('not_online', 'WARN'))
      				end
				end
    		else
      			TriggerClientEvent("chatMessage", xPlayer.source, _U('invalid_input', 'WARN'))
    		end
  		end
	end
end, false)

------------ functions and events ------------
RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	deadPlayers[source] = data
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
	if deadPlayers[source] then
		deadPlayers[source] = nil
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	-- empty tables when player no longer online
	if onTimer[playerId] then
		onTimer[playerId] = nil
	end
    if savedCoords[playerId] then
    	savedCoords[playerId] = nil
    end
	if warnedPlayers[playerId] then
		warnedPlayers[playerId] = nil
	end
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
	end
end)

function havePermission(xPlayer, exclude)	-- you can exclude rank(s) from having permission to specific commands 	[exclude only take tables]
	if exclude and type(exclude) ~= 'table' then exclude = nil;print("^3[esx_admin] ^1ERROR ^0exclude argument is not table..^0") end	-- will prevent from errors if you pass wrong argument

	local playerGroup = xPlayer.getGroup()
	for k,v in pairs(Config.adminRanks) do
		if v == playerGroup then
			if not exclude then
				return true
			else
				for a,b in pairs(exclude) do
					if b == v then
						return false
					end
				end
				return true
			end
		end
	end
	return false
end

function sendToDiscord(name, message, color)
	local connect = {
		  {
			  ["color"] = color,
			  ["title"] = "**".. name .."**",
			  ["description"] = message,
			  ["footer"] = {
			  ["text"] = "MYTHICRP",
			  },
		  }
	  }
	PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end


