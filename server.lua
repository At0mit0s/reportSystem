ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('adminCheck', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    cb(xPlayer.getGroup())
end)

ESX.RegisterServerCallback('sendDataToServer', function(source, cb, datas)
    for _, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('sendDataToClient', playerId, datas)
    end  
end)

ESX.RegisterServerCallback('getReportDatas', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Datas = {
        name = xPlayer.getName(),
        id = source,
        date = os.date("%x")
    }

    cb(Datas)
end)

ESX.RegisterServerCallback('errorMessage', function(source, cb)
    TriggerClientEvent('esx:showNotification', source, 'You don`t have permisson!', "error")
end)

ESX.RegisterServerCallback('report:Admin', function(source, cb, args)
    for _, playerId in ipairs(GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(playerId)
        if xTarget.getGroup() == 'admin' then
            TriggerClientEvent('reportAllAdmin', playerId, args)
        end
    end      
end)


ESX.RegisterServerCallback('report:solvedReport', function(source, cb, playerId)
    TriggerClientEvent('report:solvedMessage', playerId)
 end)

ESX.RegisterServerCallback('report:removeCurrentReport', function(source, cb, currentReportIndex)
    for _, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('report:removedReport', playerId, currentReportIndex)
    end 
end)

ESX.RegisterServerCallback('report:deleteAllReports', function(source, cb, player)
    for _, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('report:deletedAllReports', playerId)
    end 
 end)

 ESX.RegisterServerCallback('report:gotoToPlayer', function(source, cb, playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)
    xPlayer.setCoords(xTarget.getCoords())
    TriggerClientEvent('report:gotoMessageToPlayer', playerId, {xPlayer.getName(), source})
    TriggerClientEvent('report:gotoMessageToMe', source, {xTarget.getName(), playerId})
 end)

 ESX.RegisterServerCallback('report:bringPlayer', function(source, cb, playerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)
    xTarget.setCoords(xPlayer.getCoords())
    TriggerClientEvent('report:bringMessageToPlayer', playerId, {xPlayer.getName(), source})
    TriggerClientEvent('report:bringMessageToMe', source, {xTarget.getName(), playerId})
 end)