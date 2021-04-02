ESX = nil
OrganizationBlip = {}
local PlayerData, CurrentAction = {}
local currentjoblocation = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
  	end
  
  	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	refreshBlip()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	PlayerData.hiddenjob = hiddenjob
	deleteBlip()
	refreshBlip()
end)

CreateThread(function()
	while true do 
		Citizen.Wait(10000)
		deleteBlip()
		Citizen.Wait(100)
		refreshBlip()
	end
end)

function refreshBlip()
	if PlayerData.hiddenjob ~= nil and Config.Blips[PlayerData.hiddenjob.name] then
		local blip = AddBlipForCoord(Config.Blips[PlayerData.hiddenjob.name])
		SetBlipSprite (blip, 84)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Dom organizacji")
		EndTextCommandSetBlipName(blip)
		table.insert(OrganizationBlip, blip)
	end
end

function deleteBlip()
	if OrganizationBlip[1] ~= nil then
		for i=1, #OrganizationBlip, 1 do
			RemoveBlip(OrganizationBlip[i])
			table.remove(OrganizationBlip, i)
		end
	end
end

function OpenOrganisationActionsMenu()
    ESX.UI.Menu.CloseAll()
	local elements = {}
	if PlayerData.hiddenjob.grade >= Config.Interactions[PlayerData.hiddenjob.name].handcuffs then
		table.insert(elements, { label = 'Kajdanki', value = 'handcuffs' })
	end
	if PlayerData.hiddenjob.grade >= Config.Interactions[PlayerData.hiddenjob.name].repair then
		table.insert(elements, { label = 'Napraw pojazd', value = 'repair' })
	end
	if PlayerData.hiddenjob.grade >= Config.Interactions[PlayerData.hiddenjob.name].worek then
		table.insert(elements, { label = 'Worek', value = 'worek' })
	end

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'organisation_actions',
    {
        title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Settings.Label,
        align    = 'center',
        elements = elements
	}, function(data, menu)
		if data.current.value == 'handcuffs' then
			menu.close()
			HandcuffsAction()
		elseif data.current.value == 'repair' then
			menu.close()
			local playerPed = GetPlayerPed(-1)
			local vehicle   = ESX.Game.GetVehicleInDirection()
			local coords    = GetEntityCoords(playerPed)

			if IsPedSittingInAnyVehicle(playerPed) then
				ESX.ShowNotification(_U('inside_vehicle'))
				return
			end

			if DoesEntityExist(vehicle) then
				IsBusy = true
				TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
				Citizen.CreateThread(function()
				Citizen.Wait(20000)

				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				SetVehicleEngineOn(vehicle, true, true)
				ClearPedTasksImmediately(playerPed)

				ESX.ShowNotification(_U('vehicle_repaired'))
				IsBusy = false
				end)
			else
				ESX.ShowNotification(_U('no_vehicle_nearby'))
			end
		elseif data.current.value == 'worek' then
			TriggerServerEvent('szymczakovv_stocks:CheckHeadBag')
		end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenInventoryMenu(station)
	if Config.Organisations[PlayerData.hiddenjob.name] and PlayerData.hiddenjob.grade >= Config.Organisations[PlayerData.hiddenjob.name].Inventory.from then
		ESX.UI.Menu.CloseAll()
		local elements = {
			{label = "Włóż", value = 'deposit'},
			{label = "Wyciągnij", value = 'withdraw'}
		}
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
		{
			title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Settings.Label,
			align    = 'center',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'withdraw' then
				ESX.TriggerServerCallback('szymczakovv_stocks:getSharedInventoryInJob', function(inventory)
					local elements = {}
					for i=1, #inventory.items, 1 do
						local item = inventory.items[i]
						if item.count > 0 then
						table.insert(elements, {
							label = item.label .. ' x' .. item.count,
							type = 'item_standard',
							value = item.name
						})
						end
					end
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'stocks_menu',
						{
						title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Settings.Label,
						align    = 'center',
						elements = elements
						},
						function(data, menu)
						local itemName = data.current.value
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
							{
							title = "Ilość",
							},
							function(data2, menu2)
								local count = tonumber(data2.value)
								if count == nil then
									ESX.ShowNotification("~r~Nieprawidłowa wartość!")
								else
									menu2.close()
									menu.close()
									TriggerServerEvent('szymczakovv_stocks:getItemInStock', data.current.type, data.current.value, count, station)
									ESX.SetTimeout(500, function()
										OpenInventoryMenu(PlayerData.hiddenjob.name, Config.Organisations[PlayerData.hiddenjob.name].Inventory.from)
									end)
								end
							end,
							function(data2, menu2)
								menu2.close()
							end
						)
						end,
						function(data, menu)
							menu.close()
						end
					)
				end, station)
			else
				ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerInventory', function(inventory)
					local elements = {}
					for i=1, #inventory.items, 1 do
						local item = inventory.items[i]
						if item.count > 0 then
						table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
						end
					end
					ESX.UI.Menu.Open(
						'default', GetCurrentResourceName(), 'stocks_menu',
						{
						title    = "Ekwipunek",
						align    = 'center',
						elements = elements
						},
						function(data, menu)
						local itemName = data.current.value
						local itemType = data.current.type
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
							{
							title = "Ilość"
							},
							function(data2, menu2)
								local count = tonumber(data2.value)
								if count == nil then
									ESX.ShowNotification("~r~Nieprawidłowa wartość!")
								else
									menu2.close()
									menu.close()
									TriggerServerEvent('szymczakovv_stocks:putItemInStock', itemType, itemName, count, station)
									ESX.SetTimeout(500, function()
										OpenInventoryMenu(PlayerData.hiddenjob.name, Config.Organisations[PlayerData.hiddenjob.name].Inventory.from)

									end)
								end
							end,
							function(data2, menu2)
							menu2.close()
							end
						)
						end,
						function(data, menu)
						menu.close()
						end
					)
				end)
			end
		end, function(data, menu)
			menu.close()
			if isUsing then
				isUsing = false
				TriggerServerEvent('szymczakovv_organizations:setStockUsed', 'society_'..PlayerData.hiddenjob.name, 'inventory', false)
			end
		end)
	else
		ESX.ShowNotification('~o~Nie jesteś osobą, która może korzystać z szafki.')
	end
end

AddEventHandler('esx_organisation:hasEnteredMarker', function(zone)
	print(zone)
	if zone == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć przebieralnie.')
		CurrentActionData = {}
	elseif zone == 'Inventory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę.')
		CurrentActionData = {station = station}
	elseif zone == 'Weapons' then
		CurrentAction     = 'menu_armory_weapons'
		CurrentActionMsg  = ('~y~Naciśnij ~INPUT_CONTEXT~ aby otworzyć zbrojownie.')
		CurrentActionData = {station = station}
	elseif zone == "BossMenu" then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = "~y~Naciśnij ~INPUT_PICKUP~ aby otworzyć panel zarządzania"
		CurrentActionData = {}
	elseif zone == "Contract" then
		CurrentAction     = 'menu_contract_actions'
		CurrentActionMsg  = "~ys~Naciśnij ~INPUT_PICKUP~ aby zakupić kontrakt na broń"
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_organisation:hasExitedMarker', function(zone)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	zoneName = nil
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData.hiddenjob ~= nil then
			if Config.Organisations[PlayerData.hiddenjob.name] then
				local playerPed = PlayerPedId()
				local isInMarker  = false
				local currentZone = nil
				local coords, letSleep = GetEntityCoords(playerPed), true
				
				for k,v in pairs(Config.Organisations[PlayerData.hiddenjob.name]) do
					if GetDistanceBetweenCoords(coords, v.coords, true) < Config.DrawDistance then
						letSleep = false
						DrawMarker(22, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 22, 219, 101, 80, false, true, 2, false, false, false, false)
					end

					if(GetDistanceBetweenCoords(coords, v.coords, true) < 1.5) then
						isInMarker  = true
						currentZone = k
					end
				end

				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('esx_organisation:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('esx_organisation:hasExitedMarker', LastZone)
				end

				if letSleep then
					Citizen.Wait(1000)
				end
			else
				Citizen.Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 38) and PlayerData.hiddenjob and Config.Organisations[PlayerData.hiddenjob.name] then
				if CurrentAction == 'menu_armory' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestDistance > 3 or closestPlayer == -1 then
						ESX.TriggerServerCallback('szymczakovv_organizations:checkStock', function()
							if not isUsed then
								isUsing = true
								TriggerServerEvent('szymczakovv_organizations:setStockUsed', 'society_'..PlayerData.hiddenjob.name, 'inventory', true)
								zoneName = 'inventory'
									OpenInventoryMenu('society_' .. PlayerData.hiddenjob.name)
							else
								ESX.ShowNotification("~r~Ktoś właśnie używa tej szafki")
							end
						end, 'society_'..PlayerData.hiddenjob.name, 'inventory')
					else
						ESX.ShowNotification('Stoisz za blisko innego gracza!')
					end
				elseif CurrentAction == 'menu_armory_weapons' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestDistance > 3 or closestPlayer == -1 then
							OpenWeaponsMenu(CurrentActionData.station)
						else
							ESX.ShowNotification('Stoisz za blisko innego gracza!')
						end
				elseif CurrentAction == 'menu_cloakroom' then
					ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerDressing', function(dressing)
						local elements = {}
			
						for i=1, #dressing, 1 do
							table.insert(elements, {
								label = dressing[i],
								value = i
							})
						end
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
							title = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Settings.Label,
							align    = 'center',
							elements = elements
						}, function(data2, menu2)
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
			
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end, data2.current.value)
							end)
						end, function(data2, menu2)
							menu2.close()
						end)
					end)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					OpenAddonBossMenu()
				elseif CurrentAction == 'menu_contract_actions' then
					OpenContractMenu()
				end
				CurrentAction = nil
			end
		end
		if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			if IsControlJustReleased(0, 168) and GetEntityHealth(GetPlayerPed(-1)) > 100 and PlayerData.hiddenjob and Config.Interactions[PlayerData.hiddenjob.name] then
				OpenOrganisationActionsMenu(PlayerData.hiddenjob.name)
			end
		end
	end		
end)

function OpenAddonBossMenu()
    ESX.UI.Menu.CloseAll()
	local elements = {}
		table.insert(elements, { label = 'Zarządzanie Organizacja', value = 'bossmenu' })
		table.insert(elements, { label = 'Informacje Organizacji', value = 'info' })

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'organisation_boss',
    {
        title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Settings.Label,
        align    = 'center',
        elements = elements
	}, function(data, menu)
		if data.current.value == 'bossmenu' then
			OpenBossMenu(PlayerData.hiddenjob.name, Config.Organisations[PlayerData.hiddenjob.name].BossMenu.from)
		elseif data.current.value == 'info' then
			OpenInfoBossMenu()
		end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenInfoBossMenu()
	local praca = PlayerData.hiddenjob
	ESX.TriggerServerCallback('szymczakovv_stokcs:GetCounter', function(aktualnie)
		local limit = Config.Organisations[PlayerData.hiddenjob.name].Settings.Limit
		ESX.UI.Menu.CloseAll()
		local elements = {
			{label = 'Aktualnie do organizacji przynależy: '..aktualnie..'/'..limit..' osób', value = 'nil'}
		}

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'organisation_boss',
		{
			title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Settings.Label,
			align    = 'center',
			elements = elements
		}, function(data, menu)
		end, function(data, menu)
			OpenAddonBossMenu()
		end)
	end)
end

function OpenContractMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label =  Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Label..' $'..Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Price, value = Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Price},
		{label = 'Amunicja $'..Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Ammo.Price, value = 'ammo'}
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'szymczakovv_jest_git', { title = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Settings.Label, align = 'center', elements = elements}, function(data, menu) if data.current.value == Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Price then klameczka = Config.Organisations[PlayerData.hiddenjob.name].Contract.Utils.Weapon TriggerServerEvent('szymczakovv_organizations', klameczka) elseif data.current.value == 'ammo' then TriggerServerEvent('szymczakovv_stocks:Magazynek') end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenOrganisationPrywatne()
    ESX.UI.Menu.CloseAll()
	local elements = {
		{label = 'Ubrania Prywatne', value = 'player_dressing'},
	}

    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'organisation_actions',
    {
        title    = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Settings.Label,
        align    = 'center',
        elements = elements
	}, function(data, menu)
	if data.current.value == 'player_dressing' then

		ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerDressing', function(dressing)
			local elements = {}

			for i=1, #dressing, 1 do
				table.insert(elements, {
					label = dressing[i],
					value = i
				})
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
				title = 'Organizacja '..Config.Organisations[PlayerData.hiddenjob.name].Settings.Label,
				align    = 'center',
				elements = elements
			}, function(data2, menu2)
				TriggerEvent('skinchanger:getSkin', function(skin)
					ESX.TriggerServerCallback('szymczakovv_stocks:getPlayerOutfit', function(clothes)
						TriggerEvent('skinchanger:loadClothes', skin, clothes)
						TriggerEvent('esx_skin:setLastSkin', skin)

						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)
					end, data2.current.value)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end)
	end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenBossMenu(org, grade)
	if PlayerData.hiddenjob.grade >= grade then
		TriggerEvent('esx_society:openBossMenu2', org, function(data, menu)
			menu.close()
		end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true })
	else
		TriggerEvent('esx_society:openBossMenu2', org, function(data, menu)
			menu.close()
		end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false })
	end
end

function GetLimitEmployee()
	return Config.Organisations[PlayerData.hiddenjob.name].Settings.Limit
end

local oldError = error
local oldTrace = Citizen.Trace

local BadGlobalWrods = {
    "failure", 
    "error", 
    "not", 
    "failed",
    "not safe", 
    "invalid", 
    "cannot",
    ".lua", 
    "server", 
    "client", 
    "attempt", 
    "traceback", 
    "stack", 
    "function",
	"export"
}

function error(...)
	if Config.DebugDeveloper == true then
		local resource = GetCurrentResourceName()
		print("------------------ ERROR W SKRYPCIE: " .. resource)
		print(...)
		print("------------------ KONIEC ERRORU")
		TriggerServerEvent("szymczakovv_organisations:Debug", resource, args)
	end
end

function Citizen.Trace(...)
    oldTrace(...)

    if type(...) == "string" then
        args = string.lower(...)
        
        for _, word in ipairs(BadGlobalWrods) do
            if string.find(args, word) then
                error(...)
                return
            end
        end
    end
end


function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

local timeLeft = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if timeLeft ~= nil then
			local coords = GetEntityCoords(PlayerPedId())	
			DrawText3D(coords.x, coords.y, coords.z + 0.1, timeLeft .. '~g~%', 0.4)
		end
	end
end)

function procent(time, cb)
	if cb ~= nil then
		Citizen.CreateThread(function()
			timeLeft = 0
			repeat
				timeLeft = timeLeft + 1
				Citizen.Wait(time)
			until timeLeft == 100
			timeLeft = nil
			cb()
		end)
	else
		timeLeft = 0
		repeat
			timeLeft = timeLeft + 1
			Citizen.Wait(time)
		until timeLeft == 100
		timeLeft = nil
	end
end

function HandcuffsAction()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu', {
		title = 'Kajdanki',
		align = 'center',
		elements = {
			{label = 'Skuj / Rozkuj',		value = 'handcuff'},
			{label = 'Przeszukaj',			value = 'body_search'},
			{label = 'Chwyć / Puść',		value = 'drag'},
			{label = 'Włóż do pojazdu',		value = 'put_in_vehicle'},
			{label = 'Wyjmij z pojazdu',	value = 'out_the_vehicle'},
		}
	}, function(data, menu)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			ESX.ShowNotification("~r~Nie można wykonać w aucie")
		else
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and IsEntityVisible(GetPlayerPed(closestPlayer)) and closestDistance <= 3.0 then
				local closestPed = GetPlayerPed(closestPlayer)
				if data.current.value == 'body_search' then
            if (IsPedCuffed(closestPed) or IsPlayerDead(closestPlayer)) then
                procent(15, function()
                            menu.close()
                OpenBodySearchMenu(closestPlayer)
                end)
				  end
        elseif data.current.value == 'handcuff' then
          ESX.ShowNotification('~o~Zakułeś/Rozkułeś ~b~' .. GetPlayerServerId(closestPlayer))
            TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
			elseif data.current.value == 'drag' then
          if IsPedCuffed(GetPlayerPed(closestPlayer)) or IsPlayerDead(closestPlayer) then
            ESX.ShowNotification('~o~Przenosisz obywatela ~b~' .. GetPlayerServerId(closestPlayer))
            TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
          else
            ESX.ShowNotification("~r~Najpierw musisz zakuć obywatela.")
          end
        elseif data.current.value == 'put_in_vehicle' then
          ESX.ShowNotification('~o~Wsadzasz do pojazdu ~b~' .. GetPlayerServerId(closestPlayer))
					TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
        elseif data.current.value == 'out_the_vehicle' then
          ESX.ShowNotification('~o~Wyciągasz z pojazdu ~b~' .. GetPlayerServerId(closestPlayer))
					TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
				end
			else
				ESX.ShowNotification('~r~Brak graczy w pobliżu')
			end
		end
    end, function(data, menu)
		menu.close()
	end)
end
function OpenBodySearchMenu(target)
    local serverId = GetPlayerServerId(target)
    ESX.TriggerServerCallback('esx_policejob:checkSearch', function(cb)
        if cb == true then
            ESX.ShowAdvancedNotification("Ta osoba jest już przeszukiwana!") 
        else
            ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
                TriggerServerEvent('esx_policejob:isSearching', serverId)
				local elements = {}
                for i=1, #data.accounts, 1 do
                    if data.accounts[i].money > 0 then
                        if data.accounts[i].name == 'black_money' then
                            table.insert(elements, {
                                label    = '[Brudna Gotówka] $'..data.accounts[i].money,
                                value    = 'black_money',
                                type     = 'item_account',
                                amount   = data.accounts[i].money
                            })
                            break
                        end
                    end
                end
                
                for i=1, #data.inventory, 1 do
                    if data.inventory[i].count > 0 then
                        table.insert(elements, {
                            label    = data.inventory[i].label .. " x" .. data.inventory[i].count,
                            value    = data.inventory[i].name,
                            type     = 'item_standard',
                            amount   = data.inventory[i].count
                        })
                    end
                end
 
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
                    title    = 'Przeszukaj',
                    align    = 'center',
                    elements = elements
                }, function(data, menu)
                    local itemType = data.current.type
                    local itemName = data.current.value
                    local amount   = data.current.amount
                    local playerCoords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
                    local targetCoords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, target))
                    if itemType == 'item_sim' then
                        ESX.TriggerServerCallback('esx_policejob:checkSearch2', function(cb)
                            if cb == true then
                                ESX.UI.Menu.CloseAll()
                                if #(playerCoords - targetCoords) <= 3.0 then
                                    procent(5, function()
                                        TriggerServerEvent('esx_policejob:isSearching', serverId, false)
                                        OpenBodySearchMenu(target)
                                    end)
                                end
                            else
								print('xD?')
                            end
                        end, serverId)
                    else
                        if data.current.value ~= nil then
                            ESX.TriggerServerCallback('esx_policejob:checkSearch2', function(cb)
                                if cb == true then
                                    ESX.UI.Menu.CloseAll()
                                    if #(playerCoords - targetCoords) <= 3.0 then
                                        TriggerServerEvent('esx_policejob:confiscatePlayerItem', serverId, itemType, itemName, amount)
                                        procent(5, function()
                                            TriggerServerEvent('esx_policejob:isSearching', serverId, false)
                                            OpenBodySearchMenu(target)
                                        end)
                                    end
                                else
                                    print('xd?')
                                end
                            end, serverId)
                        end
                    end
                end, function(data, menu)
                    menu.close()
                    TriggerServerEvent('esx_policejob:isSearching', serverId, false)
                end)
            end, serverId)
        end
    end, serverId)
end