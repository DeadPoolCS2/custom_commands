AddEventHandler("OnPluginStart", function(event)
    LoadCustomCommands()
    logger:Write(LogType_t.Info, "Custom Commands Plugin Loaded!")
end)

AddEventHandler("OnPlayerChat", function(event)
    local player = event:GetPlayer()
    local message = event:GetMessage()

    if HandleCustomCommands(player, message) then
        event:Block() -- Previne afișarea normală a mesajului în chat
    end
end)