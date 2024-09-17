local RSGCore = exports['rsg-core']:GetCoreObject()

local pvp = true
--[[
RegisterNetEvent('rsg-pvp:client:pvpToggle',function()
    local ped = PlayerPedId()

    if pvp == true then
        SetRelationshipBetweenGroups(1,`PLAYER`, `PLAYER`)
        --NetworkSetFriendlyFireOption(false)
        Citizen.InvokeNative(0xB8DE69D9473B7593, ped, 6) -- Disable choking other people

        pvp = false 

        RSGCore.Functions.Notify(Lang:t('primary.pvp_off'), 'primary')
        return
    end

    SetRelationshipBetweenGroups(5, `PLAYER`, `PLAYER`)
    NetworkSetFriendlyFireOption(true)
    Citizen.InvokeNative(0x949B2F9ED2917F5D, ped, 6) -- Enable choking other people

    pvp = true

    RSGCore.Functions.Notify(Lang:t('primary.pvp_on'), 'primary')
end)]]
--[[
CreateThread(function()
    while true do
        DisableControlAction(0, 0x1F6D95E5, true) -- Disable F4 HUD menu

        if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0x1F6D95E5) then
            TriggerEvent('rsg-pvp:client:pvpToggle')
        end

        Wait(5)
    end
end)]]
CreateThread(function()
    local active = false
    local timer = 0
    while true do 
        Wait(0)
        if active == false and not IsPedOnMount(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId()) then
            SetRelationshipBetweenGroups(3, `PLAYER`, `PLAYER`)
            
        else
            SetRelationshipBetweenGroups(1, `PLAYER`, `PLAYER`)
        end

        if IsControlJustPressed(0,0xCEFD9220) then -- E KEY
            timer = 0
            active = true
            while  timer < 200 do 
                Wait(0)
                timer = timer + 1
                SetRelationshipBetweenGroups(1, `PLAYER`, `PLAYER`)
            end
            
            active = false
        end

        if IsControlJustPressed(0,0xB2F377E8) then -- F KEY
            Wait(500)
            SetRelationshipBetweenGroups(1, `PLAYER`, `PLAYER`)
            active = false
            timer = 0
        end
                
        Citizen.InvokeNative(0xF808475FA571D823, true) --enable friendly fire
        NetworkSetFriendlyFireOption(true)
    end
end)
