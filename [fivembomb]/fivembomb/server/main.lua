
local armedBombs = {}
local defaultBomb = Config.Defaultbombtime



if Config.type == 'esx' then
	local ESX = nil
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	ESX.RegisterUsableItem(Config.bombitem, function(playerId, item)
		local src = playerId
		local xPlayer = ESX.GetPlayerFromId(src)
		if xPlayer.getInventoryItem(Config.bagitem).count > 0 then
			TriggerClientEvent('abomb:assemble', src, item)
		end
    end)


	ESX.RegisterUsableItem(Config.bombbagitem, function(playerId, item)
   
		TriggerClientEvent('abomb:plant', playerId, item)
    end)



	RegisterServerEvent('abomb:givebomb')
   AddEventHandler('abomb:givebomb', function(data)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer.getInventoryItem(Config.bombitem).count > 0 and xPlayer.getInventoryItem(Config.bagitem).count > 0 then
		xPlayer.removeInventoryItem(data, tonumber(1))
		xPlayer.removeInventoryItem(Config.bagitem, tonumber(1))
		xPlayer.addInventoryItem(Config.bombbagitem, tonumber(1))

	end

   end)



   RegisterServerEvent('abomb:bombplanted')
   AddEventHandler('abomb:bombplanted', function (bomb, xx, yy, zz, data)
	   local src = source
	   local xPlayer = ESX.GetPlayerFromId(src)
	   
	   if xPlayer.getInventoryItem(Config.bombbagitem).count > 0 then
		   xPlayer.removeInventoryItem(data, tonumber(1))
		   table.insert(armedBombs, {id=bomb, x=xx, y=yy, z=zz, timeLeft=defaultBomb, countdownStatus = false, disarmStatus = false, prevTime = 0, planter = _src})
		   startCountdown(bomb)
	   end
  end)
elseif Config.type == 'qb' then
	local QBCore = exports['qb-core']:GetCoreObject()
	QBCore.Functions.CreateUseableItem(Config.bombitem, function(playerId, item)
		local src = playerId
		local Player = QBCore.Functions.GetPlayer(src)
		print(Player)
		local dd = Player.Functions.GetItemByName(Config.bagitem)
		if dd ~= nil then
			if dd.amount > 0 then
				TriggerClientEvent('abomb:assemble', src, item)
			end
			
		end
	
	end)

	QBCore.Functions.CreateUseableItem(Config.bombbagitem, function(playerId, item)
		local src = playerId
		local Player = QBCore.Functions.GetPlayer(src)
		TriggerClientEvent('abomb:plant', src, item)
	
	end)




	
	RegisterServerEvent('abomb:givebomb')
    AddEventHandler('abomb:givebomb', function(data)
		local src = source
		local Player = QBCore.Functions.GetPlayer(src)
		local item1 = Player.Functions.GetItemByName(Config.bombitem)
		local item2 = Player.Functions.GetItemByName(Config.bagitem)
       if item1 ~= nil then
			if item1.amount > 0 and item2.amount > 0 then
				print(json.encode(data))
				Player.Functions.RemoveItem(data.name, tonumber(1))
				Player.Functions.RemoveItem(Config.bagitem, tonumber(1))
				Player.Functions.AddItem(Config.bombbagitem, tonumber(1))


			end
		end

     end)




	 RegisterServerEvent('abomb:bombplanted')
	 AddEventHandler('abomb:bombplanted', function (bomb, xx, yy, zz, data)
		 local src = source
		 local Player = QBCore.Functions.GetPlayer(src)
		--  local item1 = Player.Functions.GetItemByName(Config.bombbagitem)
		--  if item1 > 0 then
		
			 Player.Functions.RemoveItem(data.name, tonumber(1))
			 table.insert(armedBombs, {id=bomb, x=xx, y=yy, z=zz, timeLeft=defaultBomb, countdownStatus = false, disarmStatus = false, prevTime = 0, planter = _src})
			 startCountdown(bomb)
		--  end
	end)
end





RegisterServerEvent('abomb:endBomb')
AddEventHandler('abomb:endBomb', function (bomb)
	local src = source
	local bombToEnd = bomb
	for k,v in pairs(armedBombs) do
		if v.id == bombToEnd then
			v.countdownStatus = false
			armedBombs[k] = nil
			break
		end
	end
	TriggerClientEvent('abomb:endOwner', -1, bomb)
end)

RegisterServerEvent('abomb:defusing')
AddEventHandler('abomb:defusing', function (bomb, status)
	local src = source
	local bombToEnd = bomb
	for k,v in pairs(armedBombs) do
		if v.id == bombToEnd then
			v.disarmStatus = status
			break
		end
	end
end)

function startCountdown(bomb)
	for k, v in pairs(armedBombs) do
		if v.id == bomb then
			v.countdownStatus = true
			bombId = k
			break
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(armedBombs) do
			if v.countdownStatus then
				if v.timeLeft >= 0 then 
					if v.timeLeft == 0 then
						TriggerEvent('abomb:endBomb', v.id)
						TriggerClientEvent('abomb:boom', -1, v.id, v.x, v.y, v.z)
						TriggerClientEvent('abomb:closeUi', -1)
						
					else
						TriggerClientEvent('abomb:beep', -1, v.x, v.y, v.z)
						v.timeLeft = v.timeLeft - 1
						TriggerClientEvent('abomb:updateUi', -1, v.timeLeft)
					end
				end
			end
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		TriggerClientEvent('abomb:updateBombs', -1, armedBombs)
	end
end)




RegisterServerEvent('abomb:server:soundactivecoord')
AddEventHandler('abomb:server:soundactivecoord', function(distance, soundname ,soundvolume, soundcoords)
    local src = source
    TriggerClientEvent('abomb:client:soundactivecoord', -1 , distance, soundname, soundvolume, soundcoords)


end)
