


characterLoaded, playerData = nil, false, nil
local armedBombsT = {}
local hasPlanted, showingText = 0, false
local guiEnabled = false
local action = nil

-- local QBCore = exports['qb-core']:GetCoreObject()
-- GLOBAL_PED = PlayerPedId()
-- GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
-- characterLoaded = true
-- playerData = QBCore.Functions.GetPlayerData()
-- playerjob = QBCore.Functions.GetPlayerData().job

if Config.type == 'esx' then
	ESX = nil
	Citizen.CreateThread(function()
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
	
		end
	
		while ESX.GetPlayerData().job == nil do
			Citizen.Wait(10)
		end
	end)



	RegisterNetEvent('esx:playerLoaded')
	AddEventHandler('esx:playerLoaded',function()
		GLOBAL_PED = PlayerPedId()
		GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
		characterLoaded = true
		playerData = ESX.GetPlayerData()
		playerjob = ESX.GetPlayerData().job
		
	end)



	Citizen.CreateThread(function()
		while true do
		Citizen.Wait(500)
			if characterLoaded then
				local playerPed = PlayerPedId()
				if playerPed ~= GLOBAL_PED then
					GLOBAL_PED = playerPed
				end
			end
		end
	end)
	
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(200)
			if characterLoaded then
				GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
			end
		end
	end)
	
	
	
	RegisterNetEvent('abomb:updateBombs')
	AddEventHandler('abomb:updateBombs', function(bombTable)
		armedBombsT = bombTable
	end)
	
	RegisterNetEvent('abomb:assemble')
	AddEventHandler('abomb:assemble', function(data)
		-- coloca saco no chao
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local fwVec = GetEntityForwardVector(ped)
		local x, y, z = table.unpack(pedCoords + fwVec * 0.7 + 0.15)
		x = x - 0.705
		y = y - 0.05
		
		local bag = 'prop_cs_heist_bag_02'
		RequestModel(GetHashKey(bag))
		while (not HasModelLoaded(bag)) do
			Wait(1)
		end
		
		Citizen.CreateThread(function()
			if DoesEntityExist(ped) then
				local ad = "weapons@projectile@sticky_bomb"
				local anim = "plant_floor"
				loadAnimDict(ad)
				TaskPlayAnim( ped, ad, anim, 1.0, -5.0, -1, 0, 0, 0, 0, 0 )
				local c4 = nil
				if c4 == nil then
					c4 = CreateObject(GetHashKey(bag), 0, 0, 0, true, true, true) 
				end			
				AttachEntityToEntity(c4, ped, GetPedBoneIndex(ped, 57005), 0.356, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) 
				Citizen.Wait(1000)
				if c4 ~= nil then
					DeleteEntity(c4) 
					c4 = nil
					bagProp = CreateObject(GetHashKey(bag), x, y, z, true, false, true)
					PlaceObjectOnGroundProperly(bagProp)
					SetModelAsNoLongerNeeded(bag)
					SetEntityAsMissionEntity(bagProp)
				end
			end
		end)
	
		TriggerEvent('els_progbar:progress',
			{
				name = 'assemble_bomb',
				duration = 1500,
				label = 'Preparing the bag',
				useWhileDead = false,
				canCancel = false,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = true,
					disableCombat = true,
				},
			},
			function(status)
				if not status then
					ClearPedTasks(ped)
					FreezeEntityPosition(ped, true)
					Citizen.Wait(1000)
					FreezeEntityPosition(ped, false)
					Citizen.CreateThread(function()
						if DoesEntityExist(ped) then
							local ad = "weapons@projectile@sticky_bomb"
							local anim = "plant_floor" 
							loadAnimDict(ad)
							TaskPlayAnim( ped, ad, anim, 1.0, -5.0, -1, 0, 0, 0, 0, 0 )
							local c4 = nil
							if c4 == nil then
								c4 = CreateObject(GetHashKey("prop_ld_bomb"), 0, 0, 0, true, true, true) 
							end			
							AttachEntityToEntity(c4, ped, GetPedBoneIndex(ped, 57005), 0.356, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) 
							Citizen.Wait(1000)
							if c4 ~= nil then
								DeleteEntity(c4) 
								c4 = nil
							end
						end
					end)
	
					TriggerEvent('els_progbar:progress',
						{
							name = 'assemble_bomb',
							duration = 1500,
							label = 'Placing explosives inside the bag',
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = false,
								disableMouse = true,
								disableCombat = true,
							},
						},
						function(status)
							if not status then
								ClearPedTasks(ped)
								DeleteObject(bagProp)
								TriggerServerEvent('abomb:givebomb', data)
							end
						end)
				end
			end)
	end)
	
	RegisterNetEvent('abomb:plant')
	AddEventHandler('abomb:plant', function(data)
		if hasPlanted == 0 then
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)
			local fwVec = GetEntityForwardVector(ped)
			local x, y, z = table.unpack(pedCoords + fwVec * 0.7 + 0.15)
			x = x - 0.705
			y = y - 0.05
			
			local bag = 'prop_cs_heist_bag_02'
			RequestModel(GetHashKey(bag))
			while (not HasModelLoaded(bag)) do
				Wait(1)
			end
			
			Citizen.CreateThread(function()
				if DoesEntityExist(ped) then
					local ad = "weapons@projectile@sticky_bomb"
					local anim = "plant_floor"
					loadAnimDict(ad)
					TaskPlayAnim( ped, ad, anim, 1.0, -5.0, -1, 0, 0, 0, 0, 0 )
					local c4 = nil
					if c4 == nil then
						c4 = CreateObject(GetHashKey(bag), 0, 0, 0, true, true, true) 
					end			
					AttachEntityToEntity(c4, ped, GetPedBoneIndex(ped, 57005), 0.356, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) 
					Citizen.Wait(1000)
					if c4 ~= nil then
						DeleteEntity(c4) 
						c4 = nil
						bagProp = CreateObject(GetHashKey(bag), x, y, z, true, false, true)
						PlaceObjectOnGroundProperly(bagProp)
						SetModelAsNoLongerNeeded(bag)
						SetEntityAsMissionEntity(bagProp)
					end
				end
			end)
	
			TriggerEvent('els_progbar:progress',
				{
					name = 'assemble_bomb',
					duration = 1500,
					label = 'Preparing the bag',
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = false,
						disableMouse = true,
						disableCombat = true,
					},
				},
				function(status)
					if not status then
						ClearPedTasks(ped)
						FreezeEntityPosition(ped, true)
						Citizen.Wait(1000)
						FreezeEntityPosition(ped, false)
						Citizen.CreateThread(function()
							if DoesEntityExist(ped) then
								local ad = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"--"misstrevor2ig_7"
								local anim = "machinic_loop_mechandplayer"--"plant_bomb" 
								
								loadAnimDict(ad)
								TaskPlayAnim( ped, ad, anim, 5.0, -5.0, -1, 0, 0, 0, 0, 0 )
							end
						end)
	
						TriggerEvent('els_progbar:progress',
							{
								name = 'assemble_bomb',
								duration = 5500,
								label = 'Activating explosives',
								useWhileDead = false,
								canCancel = false,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = false,
									disableMouse = true,
									disableCombat = true,
								},
							},
							function(status)
								if not status then
									ClearPedTasks(ped)
									hasPlanted = bagProp
									TriggerServerEvent('abomb:bombplanted', bagProp, x, y, z, data)
								end
							end)
					end
				end)
		end
	end)
	
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if armedBombsT ~= nil then
				for k, v in pairs(armedBombsT) do
					local ped = GLOBAL_PED
					local currentCoords = GLOBAL_COORDS
					local distance = #(currentCoords - vector3(v.x, v.y, v.z))
					if distance < 5.0 and v.countdownStatus and v.timeLeft > 0 then
					
						if playerjob ~= nil and playerjob.name == "police" then
							if not showingText or v.prevTime ~= v.timeLeft then
								showingText = v.id
								armedBombsT[k].prevTime = v.timeLeft
								exports['blaze_draw']:DrawGonder(true, 'Timeleft:' .. v.timeLeft ..'seconds. Press [E] to disarm','kirmizi' )
								
							end
							if not v.disarmStatus then
								DrawMarker(25, v.x, v.y, v.z-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, true, false, false, false)
								if IsControlJustPressed(0, 38) then
									TriggerServerEvent('abomb:defusing', v.id, true)
									v.disarmStatus = true
	
									TriggerEvent('els_progbar:progress',
										{
											name = 'preparing_lockpick',
											duration = 5000,
											label = 'Preparing disarming tools',
											useWhileDead = false,
											canCancel = false,
											controlDisables = {
												disableMovement = true,
												disableCarMovement = false,
												disableMouse = true,
												disableCombat = true,
											},
											animation = {
												animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
												anim = "machinic_loop_mechandplayer",
											}
										},
										function(status)
											if not status then
												TriggerEvent('adefuse:StartDefuse', v.timeLeft, v.id, function(outcome)
													if outcome then
														ClearPedTasks(ped)
														exports['mythic_notify']:DoHudText('success', 'Bomb successfuly disarmed', 5000)
														TriggerServerEvent('abomb:endBomb', v.id)
														DeleteObject(v.id)
														if showingText == v.id then
															exports['blaze_draw']:DrawGonder(false)
												
															showingText = false
														end
														armedBombsT[k].timeLeft = 0
													else
														ClearPedTasks(ped)
														TriggerServerEvent('abomb:endBomb', v.id)
														TriggerEvent('abomb:boom', v.id, v.x, v.y, v.z)
														if showingText == v.id then
															showingText = false
															exports['blaze_draw']:DrawGonder(false)
															
														end
													end
												end)
											end
										end)
								end
							end
						else
							if not showingText or v.prevTime ~= v.timeLeft then
								showingText = v.id
								armedBombsT[k].prevTime = v.timeLeft
								exports['blaze_draw']:DrawGonder(true, 'Timeleft:' .. v.timeLeft ..' seconds','kirmizi' )
								
							end
						end
					else
						showingText = false
						exports['blaze_draw']:DrawGonder(false)
				
					end
				end
			end
		end
	end)
	
	RegisterNetEvent('abomb:boom')
	AddEventHandler('abomb:boom', function (bomb, x, y, z)
		if hasPlanted == bomb then
			hasPlanted = 0
		end
		AddExplosion(x, y, z, 16, 200.0, true, false, true, false)
		DeleteObject(bomb)
	end)
	
	RegisterNetEvent('abomb:endOwner')
	AddEventHandler('abomb:endOwner', function (bomb)
		if showingText == bomb then
			showingText = false
			exports['blaze_draw']:DrawGonder(false)
	
		end
		if hasPlanted == bomb then
			hasPlanted = 0
		end
		DeleteObject(bomb)
	end)
	
	RegisterNetEvent('abomb:beep')
	AddEventHandler('abomb:beep', function(x, y, z)
		TriggerServerEvent('els_house:server:soundactivecoord', 5.0, 'beep', 0.55, {x = x, y = y, z = z})

	end)
	
	function loadAnimDict(dict)
		while (not HasAnimDictLoaded(dict)) do
			RequestAnimDict(dict)
			Citizen.Wait(5)
		end
	end
	
	RegisterNetEvent('adefuse:StartDefuse')
	AddEventHandler('adefuse:StartDefuse', function(tL, bI, cb)    
				
		SetNuiFocus(true, true)
		guiEnabled = true
		SendNUIMessage({
			type = "enableui",
			timeLeft = tL + 1,
			bombId = bI,
			enable = true,
		})
		Citizen.CreateThread(function()
			while true do
				if action == 'success' then
					action = nil
					cb(true)
					break
				elseif action == 'failed' then
					action = nil
					exports['mythic_notify']:DoHudText('error', 'You failed the disarm', 5000)
			
					cb(false)
					break
				end
				Citizen.Wait(0)
			end
		end)
	
	end)
	
	RegisterNUICallback('escape', function(data, cb)    
		SetNuiFocus(false, false)	
		guiEnabled = false
		if data.bomb then
			local bId = data.bomb
			TriggerServerEvent('abomb:defusing', bId, false)
		end
		SendNUIMessage({
			type = "enableui",
			timeLeft = 0,
			enable = false,
		})
		cb('ok')
	end)
	
	RegisterNUICallback('process', function(data, cb)
		SetNuiFocus(false, false)
		guiEnabled = false
		if data.state then
			action = 'success'
		else
			action = 'failed'
		end
		cb('ok')
	end)
	
	Citizen.CreateThread(function()
		while true do
			if guiEnabled then
				DisableControlAction(0, 142, guiEnabled)
				DisableControlAction(0, 106, guiEnabled)            
			end
			Citizen.Wait(0)
		end
	end)
	
	RegisterNetEvent('abomb:updateUi')
	AddEventHandler('abomb:updateUi', function (timeL)
		if guiEnabled then
			SendNUIMessage({
				type = "updateTime",
				timeLeft = timeL,
			})
		end
	end)
	
	RegisterNetEvent('abomb:closeUi')
	AddEventHandler('abomb:closeUi', function ()
		if guiEnabled then
			SendNUIMessage({
				type = "enableui",
				timeLeft = 0,
				enable = false,
			})
			SetNuiFocus(false, false)
			guiEnabled = false
		end
	end)

elseif Config.type == 'qb' then
	local QBCore = exports['qb-core']:GetCoreObject()

	RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
		GLOBAL_PED = PlayerPedId()
		GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
		characterLoaded = true
		playerData = QBCore.Functions.GetPlayerData()
		playerjob = QBCore.Functions.GetPlayerData().job
	end)


	Citizen.CreateThread(function()
		while true do
		Citizen.Wait(500)
			if characterLoaded then
				local playerPed = PlayerPedId()
				if playerPed ~= GLOBAL_PED then
					GLOBAL_PED = playerPed
				end
			end
		end
	end)
	
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(200)
			if characterLoaded then
				GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
			end
		end
	end)
	
	
	
	RegisterNetEvent('abomb:updateBombs')
	AddEventHandler('abomb:updateBombs', function(bombTable)
		armedBombsT = bombTable
	end)
	
	RegisterNetEvent('abomb:assemble')
	AddEventHandler('abomb:assemble', function(data)
		-- coloca saco no chao
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local fwVec = GetEntityForwardVector(ped)
		local x, y, z = table.unpack(pedCoords + fwVec * 0.7 + 0.15)
		x = x - 0.705
		y = y - 0.05
		
		local bag = 'prop_cs_heist_bag_02'
		RequestModel(GetHashKey(bag))
		while (not HasModelLoaded(bag)) do
			Wait(1)
		end
		
		Citizen.CreateThread(function()
			if DoesEntityExist(ped) then
				local ad = "weapons@projectile@sticky_bomb"
				local anim = "plant_floor"
				loadAnimDict(ad)
				TaskPlayAnim( ped, ad, anim, 1.0, -5.0, -1, 0, 0, 0, 0, 0 )
				local c4 = nil
				if c4 == nil then
					c4 = CreateObject(GetHashKey(bag), 0, 0, 0, true, true, true) 
				end			
				AttachEntityToEntity(c4, ped, GetPedBoneIndex(ped, 57005), 0.356, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) 
				Citizen.Wait(1000)
				if c4 ~= nil then
					DeleteEntity(c4) 
					c4 = nil
					bagProp = CreateObject(GetHashKey(bag), x, y, z, true, false, true)
					PlaceObjectOnGroundProperly(bagProp)
					SetModelAsNoLongerNeeded(bag)
					SetEntityAsMissionEntity(bagProp)
				end
			end
		end)
	
		TriggerEvent('els_progbar:progress',
			{
				name = 'assemble_bomb',
				duration = 1500,
				label = 'Preparing the bag',
				useWhileDead = false,
				canCancel = false,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = false,
					disableMouse = true,
					disableCombat = true,
				},
			},
			function(status)
				if not status then
					ClearPedTasks(ped)
					FreezeEntityPosition(ped, true)
					Citizen.Wait(1000)
					FreezeEntityPosition(ped, false)
					Citizen.CreateThread(function()
						if DoesEntityExist(ped) then
							local ad = "weapons@projectile@sticky_bomb"
							local anim = "plant_floor" 
							loadAnimDict(ad)
							TaskPlayAnim( ped, ad, anim, 1.0, -5.0, -1, 0, 0, 0, 0, 0 )
							local c4 = nil
							if c4 == nil then
								c4 = CreateObject(GetHashKey("prop_ld_bomb"), 0, 0, 0, true, true, true) 
							end			
							AttachEntityToEntity(c4, ped, GetPedBoneIndex(ped, 57005), 0.356, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) 
							Citizen.Wait(1000)
							if c4 ~= nil then
								DeleteEntity(c4) 
								c4 = nil
							end
						end
					end)
	
					TriggerEvent('els_progbar:progress',
						{
							name = 'assemble_bomb',
							duration = 1500,
							label = 'Placing explosives inside the bag',
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = false,
								disableMouse = true,
								disableCombat = true,
							},
						},
						function(status)
							if not status then
								ClearPedTasks(ped)
								DeleteObject(bagProp)
								TriggerServerEvent('abomb:givebomb', data)
							end
						end)
				end
			end)
	end)
	
	RegisterNetEvent('abomb:plant')
	AddEventHandler('abomb:plant', function(data)
		if hasPlanted == 0 then
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)
			local fwVec = GetEntityForwardVector(ped)
			local x, y, z = table.unpack(pedCoords + fwVec * 0.7 + 0.15)
			x = x - 0.705
			y = y - 0.05
			
			local bag = 'prop_cs_heist_bag_02'
			RequestModel(GetHashKey(bag))
			while (not HasModelLoaded(bag)) do
				Wait(1)
			end
			
			Citizen.CreateThread(function()
				if DoesEntityExist(ped) then
					local ad = "weapons@projectile@sticky_bomb"
					local anim = "plant_floor"
					loadAnimDict(ad)
					TaskPlayAnim( ped, ad, anim, 1.0, -5.0, -1, 0, 0, 0, 0, 0 )
					local c4 = nil
					if c4 == nil then
						c4 = CreateObject(GetHashKey(bag), 0, 0, 0, true, true, true) 
					end			
					AttachEntityToEntity(c4, ped, GetPedBoneIndex(ped, 57005), 0.356, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) 
					Citizen.Wait(1000)
					if c4 ~= nil then
						DeleteEntity(c4) 
						c4 = nil
						bagProp = CreateObject(GetHashKey(bag), x, y, z, true, false, true)
						PlaceObjectOnGroundProperly(bagProp)
						SetModelAsNoLongerNeeded(bag)
						SetEntityAsMissionEntity(bagProp)
					end
				end
			end)
	
			TriggerEvent('els_progbar:progress',
				{
					name = 'assemble_bomb',
					duration = 1500,
					label = 'Preparing the bag',
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = false,
						disableMouse = true,
						disableCombat = true,
					},
				},
				function(status)
					if not status then
						ClearPedTasks(ped)
						FreezeEntityPosition(ped, true)
						Citizen.Wait(1000)
						FreezeEntityPosition(ped, false)
						Citizen.CreateThread(function()
							if DoesEntityExist(ped) then
								local ad = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"--"misstrevor2ig_7"
								local anim = "machinic_loop_mechandplayer"--"plant_bomb" 
								
								loadAnimDict(ad)
								TaskPlayAnim( ped, ad, anim, 5.0, -5.0, -1, 0, 0, 0, 0, 0 )
							end
						end)
	
						TriggerEvent('els_progbar:progress',
							{
								name = 'assemble_bomb',
								duration = 5500,
								label = 'Activating explosives',
								useWhileDead = false,
								canCancel = false,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = false,
									disableMouse = true,
									disableCombat = true,
								},
							},
							function(status)
								if not status then
									ClearPedTasks(ped)
									hasPlanted = bagProp
									TriggerServerEvent('abomb:bombplanted', bagProp, x, y, z, data)
								end
							end)
					end
				end)
		end
	end)
	
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if armedBombsT ~= nil then
				for k, v in pairs(armedBombsT) do
					local ped = GLOBAL_PED
					local currentCoords = GLOBAL_COORDS
					local distance = #(currentCoords - vector3(v.x, v.y, v.z))
					if distance < 5.0 and v.countdownStatus and v.timeLeft > 0 then
					
						if playerjob ~= nil and playerjob.name == "police" then
							if not showingText or v.prevTime ~= v.timeLeft then
								showingText = v.id
								armedBombsT[k].prevTime = v.timeLeft
								exports['blaze_draw']:DrawGonder(true, 'Timeleft:' .. v.timeLeft ..'seconds. Press [E] to disarm','kirmizi' )
								
							end
							if not v.disarmStatus then
								DrawMarker(25, v.x, v.y, v.z-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, true, false, false, false)
								if IsControlJustPressed(0, 38) then
									TriggerServerEvent('abomb:defusing', v.id, true)
									v.disarmStatus = true
	
									TriggerEvent('els_progbar:progress',
										{
											name = 'preparing_lockpick',
											duration = 5000,
											label = 'Preparing disarming tools',
											useWhileDead = false,
											canCancel = false,
											controlDisables = {
												disableMovement = true,
												disableCarMovement = false,
												disableMouse = true,
												disableCombat = true,
											},
											animation = {
												animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
												anim = "machinic_loop_mechandplayer",
											}
										},
										function(status)
											if not status then
												TriggerEvent('adefuse:StartDefuse', v.timeLeft, v.id, function(outcome)
													if outcome then
														ClearPedTasks(ped)
														QBCore.Functions.Notify('Bomb successfuly disarmed', "error", 3500)
											
														TriggerServerEvent('abomb:endBomb', v.id)
														DeleteObject(v.id)
														if showingText == v.id then
															exports['blaze_draw']:DrawGonder(false)
												
															showingText = false
														end
														armedBombsT[k].timeLeft = 0
													else
														ClearPedTasks(ped)
														TriggerServerEvent('abomb:endBomb', v.id)
														TriggerEvent('abomb:boom', v.id, v.x, v.y, v.z)
														if showingText == v.id then
															showingText = false
															exports['blaze_draw']:DrawGonder(false)
															
														end
													end
												end)
											end
										end)
								end
							end
						else
							if not showingText or v.prevTime ~= v.timeLeft then
								showingText = v.id
								armedBombsT[k].prevTime = v.timeLeft
								exports['blaze_draw']:DrawGonder(true, 'Timeleft:' .. v.timeLeft ..' seconds','kirmizi' )
								
							end
						end
					else
						showingText = false
						exports['blaze_draw']:DrawGonder(false)
				
					end
				end
			end
		end
	end)
	
	RegisterNetEvent('abomb:boom')
	AddEventHandler('abomb:boom', function (bomb, x, y, z)
		if hasPlanted == bomb then
			hasPlanted = 0
		end
		AddExplosion(x, y, z, 16, 200.0, true, false, true, false)
		DeleteObject(bomb)
	end)
	
	RegisterNetEvent('abomb:endOwner')
	AddEventHandler('abomb:endOwner', function (bomb)
		if showingText == bomb then
			showingText = false
			exports['blaze_draw']:DrawGonder(false)
	
		end
		if hasPlanted == bomb then
			hasPlanted = 0
		end
		DeleteObject(bomb)
	end)
	
	RegisterNetEvent('abomb:beep')
	AddEventHandler('abomb:beep', function(x, y, z)
		TriggerServerEvent('abomb:server:soundactivecoord', 5.0, 'beep', 0.25, {x = x, y = y, z = z})
	
	end)
	
	function loadAnimDict(dict)
		while (not HasAnimDictLoaded(dict)) do
			RequestAnimDict(dict)
			Citizen.Wait(5)
		end
	end
	
	RegisterNetEvent('adefuse:StartDefuse')
	AddEventHandler('adefuse:StartDefuse', function(tL, bI, cb)    
				
		SetNuiFocus(true, true)
		guiEnabled = true
		SendNUIMessage({
			type = "enableui",
			timeLeft = tL + 1,
			bombId = bI,
			enable = true,
		})
		Citizen.CreateThread(function()
			while true do
				if action == 'success' then
					action = nil
					cb(true)
					break
				elseif action == 'failed' then
					action = nil
					QBCore.Functions.Notify('You failed the disarm', "error", 3500)

			
					cb(false)
					break
				end
				Citizen.Wait(0)
			end
		end)
	
	end)
	
	RegisterNUICallback('escape', function(data, cb)    
		SetNuiFocus(false, false)	
		guiEnabled = false
		if data.bomb then
			local bId = data.bomb
			TriggerServerEvent('abomb:defusing', bId, false)
		end
		SendNUIMessage({
			type = "enableui",
			timeLeft = 0,
			enable = false,
		})
		cb('ok')
	end)
	
	RegisterNUICallback('process', function(data, cb)
		SetNuiFocus(false, false)
		guiEnabled = false
		if data.state then
			action = 'success'
		else
			action = 'failed'
		end
		cb('ok')
	end)
	
	Citizen.CreateThread(function()
		while true do
			if guiEnabled then
				DisableControlAction(0, 142, guiEnabled)
				DisableControlAction(0, 106, guiEnabled)            
			end
			Citizen.Wait(0)
		end
	end)
	
	RegisterNetEvent('abomb:updateUi')
	AddEventHandler('abomb:updateUi', function (timeL)
		if guiEnabled then
			SendNUIMessage({
				type = "updateTime",
				timeLeft = timeL,
			})
		end
	end)
	
	RegisterNetEvent('abomb:closeUi')
	AddEventHandler('abomb:closeUi', function ()
		if guiEnabled then
			SendNUIMessage({
				type = "enableui",
				timeLeft = 0,
				enable = false,
			})
			SetNuiFocus(false, false)
			guiEnabled = false
		end
	end)

end









RegisterNetEvent('abomb:client:soundactivecoord')
AddEventHandler('abomb:client:soundactivecoord', function(maxDistance, soundname, soundvolume , soundcoords)
    local myCoords = GetEntityCoords(PlayerPedId())
    local distance = #(myCoords - vector3(soundcoords.x, soundcoords.y,soundcoords.z))

    if distance < maxDistance then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile  = soundname,
            transactionVolume = soundvolume or 0.5
        })
    end

end)