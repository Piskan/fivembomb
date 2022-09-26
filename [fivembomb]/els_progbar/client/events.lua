RegisterNetEvent("els_progbar:progress")
AddEventHandler("els_progbar:progress", function(action, finish)
	Process(action, nil, nil, finish)
end) 

RegisterNetEvent("els_progbar:ProgressWithStartEvent")
AddEventHandler("els_progbar:ProgressWithStartEvent", function(action, start, finish)
	Process(action, start, nil, finish)
end)

RegisterNetEvent("els_progbar:ProgressWithTickEvent")
AddEventHandler("els_progbar:ProgressWithTickEvent", function(action, tick, finish)
	Process(action, nil, tick, finish)
end)

RegisterNetEvent("els_progbar:ProgressWithStartAndTick")
AddEventHandler("els_progbar:ProgressWithStartAndTick", function(action, start, tick, finish)
	Process(action, start, tick, finish)
end)

RegisterNetEvent("els_progbar:cancel")
AddEventHandler("els_progbar:cancel", function()
	Cancel()
end)

RegisterNUICallback('actionFinish', function(data, cb)
	Finish()
end)

