<img width="150" height="150" align="left" style="float: left; margin: 0 10px 0 0;" alt="Szymczakovv" src="https://i.imgur.com/42AnCgD.jpg">  

# Organisations
[![Paypal Doante](https://img.shields.io/badge/paypal-donate-blue.svg)](https://www.paypal.me/oplatyprimerp)
[![Discord](https://discordapp.com/api/guilds/690686401469087756/embed.png)](https://discord.gg/wrSqK6k)

<p></p>
Script for organizations with the ability to give a limit of people to hire, Contracts for weapons, Bossmenu, Closet, Clothing and much more.
Skrypt na organizacje z możliwością nadania limitu osób do zatrudniania, Kontrakty na broń, Bossmenu, Szafka, Ubrania i wiele więcej.
```
To change limit of people to hire go to fivem-organisations/config.lua - Config.Organisations['Org_Name'] - Settings = { limit = 20 }
Aby zmienić limit osób do zatrudnienia przejdź do fivem-organisations/config.lua - Config.Organisations['Org_Name'] - Settings = { limit = 20 }
```
<p> </p>
Aby poprawnie działał skrypt z limitami zatrudniania musisz dodać export i callback niżej example jak to powinno wyglądać:
For the script to work properly with limits and hiring add export and callback sample example how it should look like:
```
function OpenRecruitMenu2(society)

  ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)

    local elements = {}

    for i=1, #players, 1 do
      if players[i].job.name ~= society then
        table.insert(elements, {label = players[i].name, value = players[i].source, name = players[i].name, identifier = players[i].identifier})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'recruit_' .. society,
      {
        title    = _U('recruiting'),
        align    = 'center',
        elements = elements
      },
      function(data, menu)

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'recruit_confirm_' .. society,
          {
            title    = _U('do_you_want_to_recruit', data.current.name),
            elements = {
              {label = _U('yes'), value = 'yes'},
              {label = _U('no'),  value = 'no'},
            }
          },
          function(data2, menu2)

            menu2.close()

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
```
