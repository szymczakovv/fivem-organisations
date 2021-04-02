<img width="150" height="150" align="left" style="float: left; margin: 0 10px 0 0;" alt="Szymczakovv" src="https://i.imgur.com/42AnCgD.jpg">  

# ESX Organisations
[![Paypal Doante](https://img.shields.io/badge/paypal-donate-blue.svg)](https://www.paypal.me/oplatyprimerp)
[![Discord](https://discordapp.com/api/guilds/690686401469087756/embed.png)](https://discord.gg/wrSqK6k) <p></p>
<p></p>
Script for organizations with the ability to give a limit of people to hire, Contracts for weapons, Bossmenu, Closet, Clothing and much more.
<p></p>
Skrypt na organizacje z możliwością nadania limitu osób do zatrudniania, Kontrakty na broń, Bossmenu, Szafka, Ubrania i wiele więcej.
<p></p>
To change limit of people to hire go to fivem-organisations/config.lua - Config.Organisations['Org_Name'] - Settings = { limit = 20 }
<p></p>
Aby zmienić limit osób do zatrudnienia przejdź do fivem-organisations/config.lua - Config.Organisations['Org_Name'] - Settings = { limit = 20 }

<p> </p>
Aby poprawnie działał skrypt z limitami zatrudniania musisz dodać export i callback w esx_society niżej example jak to powinno wyglądać:
<p></p>
For the script to work properly with limits and hiring add export and callback in esx_society sample example how it should look like:
<p></p>



```lua
if data2.current.value == 'yes' then
	ESX.TriggerServerCallback('szymczakovv_stokcs:GetCounter', function(aktualnie)
		local limit = exports['fivem-organisations']:GetLimitEmployee()
		if aktualnie >= limit then
			ESX.ShowNotification('Przekroczono limit zatrudniania osób. ['..aktualnie..'/'..limit..']')
		else
			TriggerEvent('esx:showNotification', _U('you_have_hired', data.current.name))
			ESX.TriggerServerCallback('esx_society:setHiddenJob', function()
				OpenRecruitMenu2(society)
			end, data.current.identifier, society, 0, 'hire')
		end
	end)
end
```


```
TO-DO (in next update):
Saving a limit in the database to do organisation leveling
Zapisywanie limitu graczy w jednej organizacji w bazie danych aby ostatecznie zrobić levelowanie organizacji
```
**Requirements:**
```
esx_society
esx_headbag
es_extended
mysql-async
```

<img width="150" height="150" align="left" style="float: left; margin: 0 10px 0 0;" alt="Resmon" src="https://i.imgur.com/9d3rCyQ.png">  

<p></p>
Jeżeli macie jakie kolwiek pytania piszcie u mnie na discord serwerze, nie na DM!

<p></p>
https://szymczakovv.pl/
<p></p>
https://twitch.tv/szymczakovv
<p></p>
https://instagram.com/szymczakovv/
<p></p>
https://steamcommunity.com/id/szymczakovv

<p></p>
https://discord.gg/wrSqK6k
