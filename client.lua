
local minigame = false
local result = nil
local cd = false
RegisterCommand("simongame", function()
    if minigame == false then 
        SendNUIMessage({
            action = "startGame",
            gamewidth = 4,
            gamescore = 5
        })
        Citizen.Wait(1500)
        SetNuiFocus(true, true)
        minigame = true
    else 
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = "stopGame"
        })
        minigame = false
    end
end)

RegisterNUICallback('correctgame', function(data, cb)
    TriggerEvent("notification", "Basarili!")
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "stopGame"
    })
    minigame = false
    cd = false
    result = true
    ToggleTablet() 
end)

RegisterNUICallback('incorrectgame', function(data, cb)
    TriggerEvent("notification", "Basarisiz!", 2)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "stopGame"
    })
    minigame = false
    result = false
    cd = false
    ToggleTablet() 
end)



RegisterCommand("ssays", function() 
    startUiGame(4, 4, 30)
end)

function startSimonGame(width, score, time)
    -- print(width)
    -- print(score)
    -- print(time)
    -- startUiGame(width, score, time)
    TriggerEvent("start:yavzu:simonsays", width, score, time)
    Citizen.Wait(1700)
    while minigame do 
        -- print("minigame true hala")
        Citizen.Wait(10)
    end
    -- print(result)
    return result
end

RegisterNetEvent("start:yavzu:simonsays")
AddEventHandler("start:yavzu:simonsays", function(width, score, time)
    -- print(score)
    ToggleTablet()
    SendNUIMessage({
        action = "startGame",
        gamewidth = width,
        gamescore = score
    })
    Citizen.Wait(1500)
    SetNuiFocus(true, true)
    minigame = true
    cd = true
    result = nil
    Citizen.Wait(time * 1000)
    if minigame then 
        if cd then 
            TriggerEvent("notification", "Süre doldu!", 2)
            ToggleTablet() 
            SetNuiFocus(false, false)
            SendNUIMessage({
                action = "stopGame"
            })
            minigame = false
            cd = false
            result = false
        end
    end
end)

function startUiGame(width, score, time)
    SendNUIMessage({
        action = "startGame",
        gamewidth = width,
        gamescore = score
    })
    Citizen.Wait(1000)
    SetNuiFocus(true, true)
    minigame = true
    cd = true
    result = nil
    Citizen.Wait(time * 1000)
    if minigame then 
        if cd then 
            TriggerEvent("notification", "Süre doldu!", 2)
            SetNuiFocus(false, false)
            SendNUIMessage({
                action = "stopGame"
            })
            minigame = false
            cd = false
            result = false
        end
    end
end

exports("startSimonGame", startSimonGame)




local tablet = false
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)

function ToggleTablet()
    if not tablet then
        tablet = true

        Citizen.CreateThread(function()
            RequestAnimDict(tabletDict)

            while not HasAnimDictLoaded(tabletDict) do
                Citizen.Wait(150)
            end

            RequestModel(tabletProp)

            while not HasModelLoaded(tabletProp) do
                Citizen.Wait(150)
            end

            local playerPed = PlayerPedId()
            local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
            local tabletBoneIndex = GetPedBoneIndex(playerPed, tabletBone)

            SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
            AttachEntityToEntity(tabletObj, playerPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
            SetModelAsNoLongerNeeded(tabletProp)

            while tablet do
                Citizen.Wait(100)
                playerPed = PlayerPedId()

                if not IsEntityPlayingAnim(playerPed, tabletDict, tabletAnim, 3) then
                    TaskPlayAnim(playerPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                end
            end

            ClearPedSecondaryTask(playerPed)

            DetachEntity(tabletObj, true, false)
            DeleteEntity(tabletObj)
            Citizen.Wait(450)

        end)
    elseif  tablet then
        tablet = false
    end
end