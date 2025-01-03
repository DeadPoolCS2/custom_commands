AddEventHandler("OnPluginStart", function(event)
    LoadCustomCommands()
end)

AddEventHandler("OnClientChat", function(event, playerid, text, teamonly)
    local player = GetPlayer(playerid)

    if HandleCustomCommands(player, text) then
        event:SetReturn(false)
    end
end)
