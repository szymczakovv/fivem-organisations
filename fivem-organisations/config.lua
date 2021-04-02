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
	['org2'] = vector3(715.54, -767.54, 24.76), 
	['org3'] = vector3(-1037.0, 305.53, 66.99), 
	['org4'] = vector3(1398.81, 1146.78, 114.34),
	['org5'] = vector3(-2569.49, 1307.69, 147.12),
	['org6'] = vector3(829.93, 2190.65, 52.09),
	['org7'] = vector3(-1890.9, 2047.14, 140.86),        
	['org8'] = vector3(-818.58, 177.29, 72.23),
	['org9'] = vector3(392.69, -11.11, 85.67),  
	['org10'] = vector3(661.31, 6470.99, 32.87), 
	['org11'] = vector3(-1104.41, 4948.13, 218.54), 
	['org12'] = vector3(-1805.08, 444.74, 128.51), 
	['org13'] = vector3(-1569.46, 28.86, 59.38), 
	['org14'] = vector3(-661.33, 893.29, 229.25), 
	['org15'] = vector3(-120.86, 984.2, 235.78),
	['org16'] = vector3(-612.89, -1629.9, 33.01),
	['org17'] = vector3(975.15, -1830.43, 31.24), 
	['org18'] = vector3(817.06, -3087.98, 5.9),   
	['org19'] = vector3(826.87, -2333.3, 30.4),      
	['org20'] = vector3(8.99, 541.45, 176.03),  
	['org21'] = vector3(-1185.56, 287.95, 69.5),
	['org22'] = vector3(-87.86, 835.43, 235.72), 
	['org23'] = vector3(940.44, -1492.94, 30.08),    
	['org24'] = vector3(106.04, -1941.31, 20.8),
	['org25'] = vector3(333.52, -2037.32, 21.1),
	['org26'] = vector3(-1096.63, -1669.01, 8.41), 
	['org27'] = vector3(1151.03, -437.9, 67.0),    
	['org28'] = vector3(25.8, 6477.54, 31.88),  
	['org29'] = vector3(1569.54, -2130.13, 78.33),           
	['org30'] = vector3(872.92, -2203.24, 30.64),    
	['org31'] = vector3(1552.2, 2191.2, 78.85),     
	['org32'] = vector3(-1190.45, -1326.53, 5.29),         
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
	['org2'] = {
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
	['org2'] = {
		handcuffs = 0, 
		repair = 0,
		worek = 0
	}
}
