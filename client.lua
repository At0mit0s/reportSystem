ESX = exports["es_extended"]:getSharedObject()
AdminRanks = {
 ["admin"] = true,
 ["superadmin"] = true,
}

RegisterCommand(Config.commandMember, function(source, args, rawCommand)
    if args[1] ~= nil and args[2] ~= nil then 
        sendTranslation()
        ESX.TriggerServerCallback('getReportDatas', function(datas)
            local title = args[1] 
            table.remove(args, 1)
            local message = table.concat(args, " ")
            local report = {title, message, datas.name, datas.id, datas.date}
            ESX.TriggerServerCallback('sendDataToServer', function() end, report)
            ESX.TriggerServerCallback('report:Admin', function(source) end, {datas.name, datas.id})
            SendNUIMessage({action='succesReport'})
        end)
    else 
        SendNUIMessage({action='errorReport'})
    end
end)

RegisterCommand(Config.commandAdmin, function()
    ESX.TriggerServerCallback('adminCheck', function(state)
        sendTranslation()
        if AdminRanks[state] then 
            SendNUIMessage({action='reportActive'})
            SetNuiFocus(true, true)
        else 
            ESX.TriggerServerCallback('errorMessage', function(source) end)
        end
    end)
end)

TriggerEvent('chat:addSuggestion', '/report', 'Write Report', {
    { name="title", help="Name the report title" },
    { name="message", help="Write down the problem" }
})

TriggerEvent('chat:addSuggestion', '/reports', 'Check reports')

function sendTranslation()
    SendNUIMessage({translateArray = Config.TranslationWords})
end

RegisterNetEvent('sendDataToClient')
AddEventHandler('sendDataToClient', function(report)
    SendNUIMessage({action='newReport', newReport=report})
end)


-- Notify Messages
RegisterNetEvent('reportAllAdmin')
AddEventHandler('reportAllAdmin', function(information)
    SendNUIMessage({action='reportAllAdmin', reportInfo={information[1], information[2]}})
end)

RegisterNetEvent('report:solvedMessage')
AddEventHandler('report:solvedMessage', function()
    SendNUIMessage({action='reportSolved'})
end)

RegisterNetEvent('report:removedReport')
AddEventHandler('report:removedReport', function(index)
    SendNUIMessage({action='reportRemoved', indexValue=index})
end)

RegisterNetEvent('report:deletedAllReports')
AddEventHandler('report:deletedAllReports', function()
    SendNUIMessage({action='clearReports'})
end)

RegisterNetEvent('report:gotoMessageToPlayer')
AddEventHandler('report:gotoMessageToPlayer', function(datas)
    SendNUIMessage({action='gotoMessageToPlayer', gotoInfo={datas[1], datas[2]}})
end)

RegisterNetEvent('report:gotoMessageToMe')
AddEventHandler('report:gotoMessageToMe', function(datas)
    SendNUIMessage({action='gotoMessageToMe', gotoInfo2={datas[1], datas[2]}})
end)

RegisterNetEvent('report:bringMessageToPlayer')
AddEventHandler('report:bringMessageToPlayer', function(datas)
    SendNUIMessage({action='bringMessageToPlayer', bringInfo={datas[1], datas[2]}})
end)

RegisterNetEvent('report:bringMessageToMe')
AddEventHandler('report:bringMessageToMe', function(datas)
    SendNUIMessage({action='bringMessageToMe', bringInfo2={datas[1], datas[2]}})
end)

-- Callbacks
RegisterNUICallback('closePanel', function()
    SendNUIMessage({action='reportDeactive'})
    SetNuiFocus(false, false)
end)

RegisterNUICallback('reportSolved', function(player)
    ESX.TriggerServerCallback('report:solvedReport', function() end, player)
end)

RegisterNUICallback('removeCurrentReport', function(player)
    ESX.TriggerServerCallback('report:removeCurrentReport', function() end, currentReportIndex)
end)

RegisterNUICallback('deleteAllReports', function()
    ESX.TriggerServerCallback('report:deleteAllReports', function() end)
end)

RegisterNUICallback('gotoToPlayer', function(playerId)
    ESX.TriggerServerCallback('report:gotoToPlayer', function() end, playerId)
end)

RegisterNUICallback('bringPlayer', function(playerId)
    ESX.TriggerServerCallback('report:bringPlayer', function() end, playerId)
end)
