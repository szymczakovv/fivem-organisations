Config                            = {}
Config.DrawDistance               = 10.0
Config.DebugDeveloper = false --[[ 
	Jeśli ta opcja jest ustawiona na true pozwala ona nam debugować błędy, które zostaną wysłane na
	Discord Webhook jak i zostanie wyprintowany początek i koniec błędu tak abyście wiedzieli gdzie jest błąd
	+ Dzięki debug mode ułatwicie pracę na przyszłość developerom, którzy będą w łatwy sposób mogli wykryć błąd
	!!! Jeśli ustawiłeś na true zmień webhook w server.lua !!!
]]

Config.Blips = {
    ['org1'] = vector3(-1541.8, 126.41, 56.78),   
}

Config.List = {
	[1] = 'SNS', -- Nazwa Borni (Label - Wyświetlana nazwa) 60k
	[2] = 'snspistol', -- Nazwa Borni (Spawn - Spawn borni) 60k
	[3] = 'SNS MK2', -- Nazwa Borni (Label - Wyświetlana nazwa) 80k
	[4] = 'snspistol_mk2', -- Nazwa Borni (Spawn - Spawn borni) 80k
	[5] = 'Pistolet', -- Nazwa Borni (Label - Wyświetlana nazwa) 90k
	[6] = 'pistol', -- Nazwa Borni (Spawn - Spawn borni) 90k
	[7] = 'Pistolet MK2', -- Nazwa Borni (Label - Wyświetlana nazwa) 100k
	[8] = 'pistol_mk2', -- Nazwa Borni (Spawn - Spawn borni) 100k
	[9] = 'Vintage', -- Nazwa Borni (Label - Wyświetlana nazwa) 120k
	[10] = 'vintagepistol', -- Nazwa Borni (Spawn - Spawn borni) 120k
	[11] = 'machete', -- Nazwa Borni (Spawn - Spawn borni) 15k
	[12] = 'Toporek', -- Nazwa Borni (Spawn - Spawn borni) 15k
	[13] = 'battleaxe', -- Nazwa Borni (Spawn - Spawn borni) 15k
	[14] = 'Kij bejsbolowy', -- Nazwa Borni (Spawn - Spawn borni) 10k
	[15] = 'bat', -- Nazwa Borni (Spawn - Spawn borni) 10k
	[16] = 'Nóż', -- Nazwa Borni (Spawn - Spawn borni) 20k
	[17] = 'knife', -- Nazwa Borni (Spawn - Spawn borni) 20k
}   

Config.Organisations = {
	['org1'] = {
		Settings = {
			Limit = 20,
			Label = 'Creeper'
		},
		Cloakroom = {
			coords = vector3(732.82, -795.88, 18.07),
		},
		Inventory = {
			coords = vector3(724.36, -791.24, 16.47),
			from = 4, -- grade od ktorego to ma
		},
		BossMenu = {
			coords = vector3(172.37, -877.37, 30.59),
			from = 4, -- grade od ktorego to ma
			Info = {from = 1}
		},
		Contract = {
			coords = vector3(727.38, -791.03, 15.47+0.95),
			from = 0,
			Utils = {
				Label = Config.List[3],
				Weapon = Config.List[4],
				Account = 'black_money',
				Price = 80000,
				Ammo = {
					Account = 'black_money',
					Price = 200, -- za ammo ilość niżej podana
					Number = 1, -- ile ma dodawać amunicji za powyższą cenę
				},
			},
		}
 	}
}

Config.Interactions = {
	['org1'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	}
}
