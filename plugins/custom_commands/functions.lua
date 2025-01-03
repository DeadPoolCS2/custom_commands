local QueuedCommands = {}

function LoadCustomCommands()
    local customCommands = config:Fetch("custom_commands.custom_commands")

    if not customCommands or type(customCommands) ~= "table" then
        logger:Write(LogType_t.Error, "Custom Commands: No valid commands found in the configuration file.")
        return
    end

    for i = 1, #customCommands do
        local cmdData = customCommands[i]
        
        if not cmdData.command or not cmdData.message then
            logger:Write(LogType_t.Error, string.format("Couldn't load custom command #%d because 'command' or 'message' is missing.", i))
            goto loopContinue
        end

        table.insert(QueuedCommands, {
            command = cmdData.command,
            response = cmdData.message,
            send_to_all = cmdData.send_to_all or false
        })

        ::loopContinue::
    end

    logger:Write(LogType_t.Info, "Loaded " .. #QueuedCommands .. " custom commands.")
end

function HandleCustomCommands(player, message)
    for i = 1, #QueuedCommands do
        if QueuedCommands[i].command == message then
            local formattedMessage = config:Fetch("custom_commands.prefix") .. " " .. QueuedCommands[i].response

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
