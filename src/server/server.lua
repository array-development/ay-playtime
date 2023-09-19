-- // [VARIABLES] \\ --

local playerData = {}

-- // [THREADS] \\ --

CreateThread(function()
    while true do 
        for i=1, #playerData do 
            if playerData[i] then 
                local timeNow = os.time()
                local time = tonumber(timeNow - playerData[i]['actualTime'])
                local allTime = time + playerData[i]['playtime']

                playerData[i]['playtime'] = allTime
            end
        end
        
        Wait(15 * 1000)
    end
end)

-- // [EVENTS] \\ --

AddEventHandler('esx:playerLoaded', function(src)
    if source == 0 or source == '' then
        MySQL.scalar('SELECT `playtime` FROM `users` WHERE `identifier` = ? LIMIT 1', {
            GetPlayerIdentifiers(src)[1]
        }, function(result)
            if not playerData[src] then 
                playerData[src] = {}
            end

            playerData[src]['playtime'] = tonumber(result) or 0 
            playerData[src]['actualTime'] = os.time()

            print('[^6' .. GetCurrentResourceName() .. '^0] Player: ^6' .. GetPlayerName(src) .. ' ^0their playtime has been loaded.')
        end)
    end
end)

AddEventHandler('esx:playerDropped', function(src, reason)
    if source == 0 or source == '' then
        if not playerData[src] then return end

        MySQL.update('UPDATE `users` SET `playtime` = ? WHERE identifier = ?', {
            playerData[src]['playtime'], GetPlayerIdentifiers(src)[1]
        }, function(affectedRows)
        end)

        print('[^6' .. GetCurrentResourceName() .. '^0] Player: ^6' .. GetPlayerName(src) .. ' ^0their playtime has been saved.')
    end
end)

-- // [EXPORTS] \\ --

exports('receiveData', function(src)
    return playerData[src]['playtime'] and playerData[src]['playtime'] or 0
end)

-- // [COMMANDS] \\ --

RegisterCommand('playtime', function(source, args, rawCommand)
    TriggerClientEvent('chat:addMessage', source, { args = { 'You have a total of ' ..secondsToClock(playerData[source]['playtime']) .. ' playtime!' }})
end)

-- // [FUNCTIONS] \\ --

secondsToClock = function(seconds)
    if not seconds then return end

    local seconds = tonumber(seconds)
    if seconds <= 0 then return '0 days, 0 hours, 0 minutes'  end
    days = string.format('%02.f', math.floor(seconds / (3600*24)));
    hours = string.format('%02.f', math.floor(seconds / 3600));
    mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)));
    secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60));
    return days .. ' days, ' .. hours .. ' hours, ' .. mins .. ' minutes'
end