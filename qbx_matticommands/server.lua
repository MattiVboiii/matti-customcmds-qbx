lib.addCommand('duty', {
    help = locale('command.duty.help')
}, function(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end

    local job = player.PlayerData.job
    if job.onduty then
        -- Toggle off duty
        player.Functions.SetJobDuty(false)
        exports.qbx_core:Notify(source, locale('command.duty.off'), 'success')
    else
        -- Toggle on duty
        player.Functions.SetJobDuty(true)
        exports.qbx_core:Notify(source, locale('command.duty.on'), 'success')
    end
end)

lib.addCommand('tpmc', {
    help = locale('command.tpmc.help'),
    restricted = 'group.admin'
}, function(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end

    local coords = vector4(501.64, 5602.94, 799.01, 177.35) -- Replace with desired coordinates

    TriggerClientEvent('QBCore:Command:TeleportToCoords', source, coords.x, coords.y, coords.z, coords.w)

    exports.qbx_core:Notify(source, locale('command.tpmc.success'), 'success')
end)

lib.addCommand('reviveall', {
    help = locale('command.reviveall.help'),
    restricted = 'group.admin'
}, function(source)
    for _, player in pairs(exports.qbx_core:GetQBPlayers()) do
        TriggerClientEvent('qbx_medical:client:playerRevived', -1)
    end
    exports.qbx_core:Notify(source, locale('command.reviveall.success'), 'success')
end)

lib.addCommand('defaultinv', {
    help = locale('command.defaultinv.help'),
    restricted = 'group.admin'
}, function(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end

    -- Define the items to give
    local defaultItems = {
        { name = 'weapon_combatpistol', count = 1 },
        { name = 'ammo-9', count = 99 },
        { name = 'water_bottle', count = 3 },
        { name = 'tosti', count = 3 },
        { name = 'money', count = 99999 },
        { name = 'phone', count = 1 },
    }

    -- Give the items to the player
    for _, item in pairs(defaultItems) do
        exports.ox_inventory:AddItem(source, item.name, item.count)
    end

    exports.qbx_core:Notify(source, locale('command.defaultinv.success'), 'success')
end)

lib.addCommand('cid', {
    help = locale('command.cid.help'), 
    params = {{name = 'id', help = locale('command.arg_help'), optional = true}},
    restricted = 'group.admin'
}, function(source, args)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end

    local targetPlayer = args.id and exports.qbx_core:GetPlayer(tonumber(args.id))
    if targetPlayer then
        local message = locale('command.cid.success'):format(targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname, targetPlayer.PlayerData.citizenid)
        exports.qbx_core:Notify(source, message, 'success')
    elseif args.id then
        exports.qbx_core:Notify(source, locale('command.plyrnotfound'), 'error')
    else
        local message = locale('command.cid.your_id'):format(player.PlayerData.citizenid)
        exports.qbx_core:Notify(source, message, 'success')
    end
end)

-- Bring command
lib.addCommand('bring', {
    help = locale('command.bring.help'),
    params = {
        { name = 'id', help = locale('command.arg_help') },
    },
    restricted = 'group.admin'
}, function(source, args)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return end

    local targetId = tonumber(args.id)
    if targetId == player.PlayerData.source then
        exports.qbx_core:Notify(source, locale('command.own_id'), 'error')
        return
    end

    local targetPlayer = exports.qbx_core:GetPlayer(targetId)
    if targetPlayer then
        local adminPos = GetEntityCoords(GetPlayerPed(source))
        SetEntityCoords(targetPlayer.PlayerData.source, adminPos.x + 1, adminPos.y, adminPos.z)
        exports.qbx_core:Notify(source, locale('command.bring.success'):format(targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname, targetId), 'success')
    else
        exports.qbx_core:Notify(source, locale('command.plyrnotfound'), 'error')
    end
end)
