<img width="150" height="150" align="left" style="float: left; margin: 0 10px 0 0;" alt="Szymczakovv" src="https://i.imgur.com/42AnCgD.jpg">  

# ESX Organisations
[![Paypal Doante](https://img.shields.io/badge/paypal-donate-blue.svg)](https://www.paypal.me/oplatyprimerp)
[![Discord](https://discordapp.com/api/guilds/690686401469087756/embed.png)](https://discord.gg/wrSqK6k)
<br> </br>
Script for organizations with the ability to give a limit of people to hire, Contracts for weapons, Bossmenu, Closet, Clothing and much more.
<br> </br>
Skrypt na organizacje z możliwością nadania limitu osób do zatrudniania, Kontrakty na broń, Bossmenu, Szafka, Ubrania i wiele więcej.
<br> </br>
To change limit of people to hire go to fivem-organisations/config.lua - Config.Organisations['Org_Name'] - Settings = { limit = 20 }
<br> </br>
Aby zmienić limit osób do zatrudnienia przejdź do fivem-organisations/config.lua - Config.Organisations['Org_Name'] - Settings = { limit = 20 }
<br> </br>
Aby poprawnie działał skrypt z limitami zatrudniania musisz dodać export i callback w esx_society niżej example jak to powinno wyglądać:
<br> </br>
For the script to work properly with limits and hiring add export and callback in esx_society sample example how it should look like:
<br> </br>



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
<br> </br>
If player is not in marker, Resmon Result:
<p></p>
Jeśli gracz nie jest w markerze, Wynik z Resmon:
<img width="390" height="26" align="left" style="float: left; margin: 0 10px 0 0;" alt="Resmon" src="https://i.imgur.com/9d3rCyQ.png">  
<br> </br>
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
