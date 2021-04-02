ESX = nil
OrganizationsTable = {}
local SearchTable = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for job, data in pairs(Config.Organisations) do
	TriggerEvent('esx_society:registerSociety', job, data.Label, 'society_'..job, 'society_'..job, 'society_'..job, {type = 'private'})
end
RegisterServerEvent('szymczakovv_organizations:setStockUsed')
AddEventHandler('szymczakovv_organizations:setStockUsed', function(name, type, bool)
	for i=1, #OrganizationsTable, 1 do
		if OrganizationsTable[i].name == name and OrganizationsTable[i].type == type then
			OrganizationsTable[i].used = bool
			break
		end
	end
end)


RegisterServerEvent('szymczakovv_organisations:Debug')
AddEventHandler('szymczakovv_organisations:Debug',function(resource, args)
    Debug("```ERROR W SKRYPCIE: "..resource..'```', args)
end)

function Debug(name, args, color)
    local connect = {
          {
              ["color"] = 16711680,
              ["title"] = "".. name .."",
              ["description"] = args,
              ["footer"] = {
                  ["text"] = "Szymczakovv Error Log",
              },
          }
      }
    PerformHttpRequest('dodaj tu webhook discord jesli masz Config.DebugDeveloper ustawione na true', function(err, text, headers) end, 'POST', json.encode({username = "Error Log", embeds = connect, avatar_url = "https://imgur.com/gHd2etM"}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('szymczakovv_organizations')
AddEventHandler('szymczakovv_organizations', function(klameczka)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local ilemam = xPlayer.getAccount('bank').money
	--print('Wyniki:', ilemam, klameczka)
	if xPlayer.getAccount(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Account).money >= Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Price then
		xPlayer.removeAccountMoney(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Account, Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Price)
		Citizen.Wait(100)
		xPlayer.addInventoryItem(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Weapon, 1)
		xPlayer.showNotification('~o~Zakupiłeś kontrakt na broń: '..Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Label)
	else
		xPlayer.showNotification('~r~Nie posiadasz wystarczającej ilości gotówki')
	end
end)

RegisterServerEvent('szymczakovv_stocks:Magazynek')
AddEventHandler('szymczakovv_stocks:Magazynek', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
		if xPlayer.getAccount(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Account).money >= Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Price then
			xPlayer.removeAccountMoney(Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Account, Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Price)
			Citizen.Wait(100)
			xPlayer.addInventoryItem('pistol_ammo', Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Number)
			xPlayer.showNotification('~o~Zakupiłeś amunicję w ilości: '..Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Number.. ' ~g~za: $'..Config.Organisations[xPlayer.hiddenjob.name].Contract.Utils.Ammo.Price)

		else
			xPlayer.showNotification('~r~Nie posiadasz wystarczającej ilości gotówki')
		end
end)


ESX.RegisterServerCallback('szymczakovv_organizations:checkStock', function(source, cb, name, type)
	local check, found
	if #OrganizationsTable > 0 then
        for i=1, #OrganizationsTable, 1 do
			if OrganizationsTable[i].name == name and OrganizationsTable[i].type == type then
				check = OrganizationsTable[i].used
				found = true
				break
			end
		end
		if found == true then
			cb(check)
		else
			table.insert(OrganizationsTable, {name = name, type = type, used = true})
			cb(false)
		end
	else
		table.insert(OrganizationsTable, {name = name, type = type, used = true})
		cb(false)
	end
end)

ESX.RegisterServerCallback('szymczakovv_stocks:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local money      = xPlayer.getMoney()
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		money = money,
		items  = items
	})
end)

ESX.RegisterServerCallback('szymczakovv_stocks:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}
		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('szymczakovv_stocks:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier,  function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('szymczakovv_stocks:removeOutfit')
AddEventHandler('szymczakovv_stocks:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier,  function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

RegisterServerEvent('szymczakovv_stocks:CheckHeadBag')
AddEventHandler('szymczakovv_stocks:CheckHeadBag', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('headbag').count >= 1 then
		TriggerClientEvent('esx_worek:naloz', _source)
	else
		TriggerClientEvent('esx:showNotification', _source, '~o~Nie posiadasz przedmiotu worek przy sobie aby rozpocząć interakcję z workiem.')
	end
end)

ESX.RegisterServerCallback('szymczakovv_stokcs:GetCounter', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local praca = xPlayer.hiddenjob.name
	local aktualnie = MySQL.Sync.fetchScalar("SELECT COUNT(1) FROM users WHERE `hiddenjob` = '"..praca.."'")
	cb(aktualnie)
end)


ESX.RegisterServerCallback('esx_policejob:checkSearch', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if SearchTable[target] ~= nil then
        if SearchTable[target] == xPlayer.identifier then
            cb(false)
        else
            cb(true)
        end
    else
        cb(false)
    end
end)
 
ESX.RegisterServerCallback('esx_policejob:checkSearch2', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if SearchTable[target] ~= nil then
        if SearchTable[target] == xPlayer.identifier then
            cb(true)
        else
            cb(false)
        end
    else
        cb(true)
    end
end)
 
RegisterServerEvent('esx_policejob:isSearching')
AddEventHandler('esx_policejob:isSearching', function(target, boolean)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if boolean == nil then
        SearchTable[target] = xPlayer.identifier
    else
        SearchTable[target] = nil
    end
end)

