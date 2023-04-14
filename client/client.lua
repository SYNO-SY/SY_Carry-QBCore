
local PlayerData              = {}
local carryingBackInProgress  = false
local accepted = false
local sycarry = true

-----[REQUEST]-------
RegisterNetEvent("SY_Carry:senderrequest")
AddEventHandler("SY_Carry:senderrequest", function(CarryTypeChoosed)
	local reqstcarryanim = CarryTypeChoosed
    while true do
		Wait(1)
		if reqstcarryanim ~= nil then
			local coords = GetEntityCoords(PlayerPedId())
			local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer(coords)

			if closestPlayer ~= -1 and closestDistance <= 2.5 then
				ShowHelpNotification("~INPUT_PICKUP~ Suggest interactions \n~INPUT_VEH_DUCK~ Cancel")
				target_id = GetPlayerPed(closestPlayer)
				playerX, playerY, playerZ = table.unpack(GetEntityCoords(target_id))
				DrawMarker(0, playerX, playerY, playerZ+1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.2, 0.2, 0.2, 155, 77, 219, 70, true, true, 2, true, false, false, false)
				if IsControlJustPressed(0, 38) then
					TriggerServerEvent("SY_animations:animrequest", GetPlayerServerId(closestPlayer),reqstcarryanim)
					Notify("Request send",'sucess')
					break
				end
				if IsControlJustPressed(0, 73) then
                    ClearPedTasks(PlayerPedId())
                    Wait(200)
                    break
                end
			else
				Notify("No one nearby",'error')
				break
			end
		end
	end
end)

RegisterNetEvent("SY_animations:reciverrequest")
AddEventHandler("SY_animations:reciverrequest", function(revicer,reqstcarryanim)
    isRequestAnim = true
    PlaySound(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 0, 0, 1)
	Notify(Config.requestmessage,'info')
    local waiting = 0 
    CreateThread(function()
        while true do
            Wait(5)
            if isRequestAnim then
                if IsControlJustPressed(1, Config.acceptkey) then
					Notify("Request accepted",'success')
					local coords = GetEntityCoords(PlayerPedId())
                    target, distance = QBCore.Functions.GetClosestPlayer(coords)
                    if(distance ~= -1 and distance < 3) then
                        TriggerServerEvent("SY_animations:animationaccepted", revicer,reqstcarryanim)
                        accepted = true
                        isRequestAnim = false
                    else
						Notify("Nobody is close enough.",'info')
                    end
                elseif IsControlJustPressed(1, Config.declinekey) then
					Notify("Request denied.",'error')
					local target = QBCore.Functions.GetClosestPlayer(coords)
					sji = GetPlayerServerId(target)
					TriggerServerEvent("SY_animations:animationdenied", sji)
                    isRequestAnim = false
                end
            else
                break
            end
        end
    end)
    CreateThread(function()
        while true do 
            Wait(100)
            waiting = waiting + 1
            if isRequestAnim then
                if waiting > 100 then
                    isRequestAnim = false
					Notify("Request has expired",'info')
                end
            else
                break
            end
        end
    end)
end)

RegisterNetEvent("SY_animations:playsharedsource")
AddEventHandler("SY_animations:playsharedsource", function(reqstcarryanim,player)
	akmon = reqstcarryanim
	if akmon == "carry1" then 
		carryingBackInProgress = true
		local closestPlayer = GetClosestPlayer(3)
		target = player
		if closestPlayer ~= nil then
			TriggerServerEvent('SY_Carry_anim1:server:Sync', closestPlayer, 'missfinale_c2mcs_1','nm', 'fin_c2_mcs_1_camman', 'firemans_carry', 0.15,0.27,0.63,target,100000,0.0,49,33,1)
			isCarry = true
		end
	elseif akmon == "carry2" then
		carryingBackInProgress = true
        Citizen.Wait(100)
        local dict = "anim@heists@box_carry@"	
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(100)
        end
		targetplayer = player
        TriggerServerEvent('SY_Carry:onhandanim', targetplayer)		
        TaskPlayAnim(PlayerPedId(), dict, "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
    elseif akmon == "carry3" then
        carryingBackInProgress = true	
		local closestPlayer = GetClosestPlayer(3)
		target = player
		if closestPlayer ~= nil then
			TriggerServerEvent('SY_Carry_anim2:server:Sync', closestPlayer, 'anim@arena@celeb@flat@paired@no_props@', 'piggyback_c_player_a', 'piggyback_c_player_b', -0.07, 0.0, 0.45,target,100000,0.0,49,33,1)
		end
	end
end)

-----[END REQUEST]-------

RegisterCommand(Config.command, function(source, args)
	if sycarry then
		if carryingBackInProgress == true then
			local closestPlayer = GetClosestPlayer(3)
			target = GetPlayerServerId(closestPlayer)
			TriggerServerEvent("SY_Carry_Anim:stop",target)
			Wait(1000)
			TriggerEvent('SY_Carry_Anim:client:stop')
			carryingBackInProgress = false
			local accepted = false
		else
			SetNuiFocus(true, true)
			SendNUIMessage({
				message	= "showtypes"
			})
			--TriggerEvent("SY_Carry:senderrequest","type1")
		end
    end
end)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
    SendNUIMessage({message = "hide"})
end)

RegisterNUICallback("selectedtype", function(data)
    CarryTypeChoosed = data
    SetNuiFocus(false, false)
	if CarryTypeChoosed == "carry1" then
		if not carryingBackInProgress then
			TriggerEvent("SY_Carry:senderrequest",CarryTypeChoosed)       
		end
	end
	if CarryTypeChoosed == "carry2" then
		if not carryingBackInProgress then
			TriggerEvent("SY_Carry:senderrequest",CarryTypeChoosed)	
		end
	end
	if CarryTypeChoosed == "carry3" then
		if not carryingBackInProgress then
			TriggerEvent("SY_Carry:senderrequest",CarryTypeChoosed)
		end
	end
end)

--------[ANIMATION FUNCTION]--------

function LoadAnimationDictionary(animationD)
	while(not HasAnimDictLoaded(animationD)) do
		RequestAnimDict(animationD)
		Wait(1)
	end
end
  
RegisterNetEvent('SY_Carry:onhandanimcarry')
AddEventHandler('SY_Carry:onhandanimcarry', function(target)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	local lPed = PlayerPedId()
	local dict = "amb@code_human_in_car_idles@low@ps@"
	LoadAnimationDictionary("amb@code_human_in_car_idles@generic@ps@base")
	TaskPlayAnim(lPed, "amb@code_human_in_car_idles@generic@ps@base", "base", 8.0, -8, -1, 33, 0, 0, 40, 0)
	AttachEntityToEntity(PlayerPedId(), targetPed, 9816, 0.015, 0.38, 0.11, 0.9, 0.30, 90.0, false, false, false, false, 2, false)
end)
  

RegisterNetEvent('SY_Carry_anim2:SyncTarget')
AddEventHandler('SY_Carry_anim2:SyncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
end)
  
RegisterNetEvent('SY_Carry_anim1:SyncTarget')
AddEventHandler('SY_Carry_anim1:SyncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
end)
  
  
RegisterNetEvent('SY_Carry_anim2:Sync')
AddEventHandler('SY_Carry_anim2:Sync', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	Citizen.Wait(length)
end)

RegisterNetEvent('SY_Carry_Anim:client:stop')
AddEventHandler('SY_Carry_Anim:client:stop', function()
	carryingBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)
  
  
function GetPlayers()
	local players = {}
	for i = 0, 255 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end
	return players
end
  
function GetClosestPlayer(radius)
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	for index,value in pairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

function ShowHelpNotification(msg, thisFrame, beep, duration)
    AddTextEntry('HelpNotification', msg)

    if thisFrame then
        DisplayHelpTextThisFrame('HelpNotification', false)
    else
        if beep == nil then
            beep = true
        end
        BeginTextCommandDisplayHelp('HelpNotification')
        EndTextCommandDisplayHelp(0, false, beep, duration or -1)
    end
end
