RegisterNetEvent('qbx_core:client:Teleport')
AddEventHandler('qbx_core:client:Teleport', function(coords)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
end)