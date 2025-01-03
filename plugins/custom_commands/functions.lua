local QueuedCommands = {}

function LoadCustomCommands()
    local config = LoadConfig("custom_commands.json") -- Încărcăm noul fișier JSON
    if not config then
        logger:Write(LogType_t.Error, "Custom Commands: Failed to load custom_commands.json.")
        return
    end

    local customCommands = config["custom_commands"]
    if not customCommands or type(customCommands) ~= "table" then
        logger:Write(LogType_t.Error, "Custom Commands: No valid commands found in the configuration file.")
        return
    end

    for command, data in pairs(customCommands) do
        if type(data) == "table" and data.message then
            table.insert(QueuedCommands, { 
                command = command, 
                response = data.message, 
                send_to_all = data.send_to_all or false 
            })
        end
    end

    logger:Write(LogType_t.Info, "Loaded " .. #QueuedCommands .. " custom commands.")
end

function HandleCustomCommands(player, message)
    for i = 1, #QueuedCommands do
        if QueuedCommands[i].command == message then
            local formattedMessage = config["prefix"] .. " " .. QueuedCommands[i].response

            if QueuedCommands[i].send_to_all then
                SendCustomCommandToAll(formattedMessage)
            else
                player:SendMsg(MessageType.Chat, formattedMessage)
            end
            return true
        end
    end
    return false
end

function SendCustomCommandToAll(message)
    for i = 1, playermanager:GetPlayerCap() do
        local player = GetPlayer(i - 1)
        if player then
            player:SendMsg(MessageType.Chat, message)
        end
    end
end