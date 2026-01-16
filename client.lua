local yogaActive = false
local countdown = false
local npcPed = nil

ESX = exports["es_extended"]:getSharedObject()

-- NPC erstellen
CreateThread(function()
    RequestModel(GetHashKey(Config.NPC.model))
    while not HasModelLoaded(GetHashKey(Config.NPC.model)) do
        Wait(10)
    end

    npcPed = CreatePed(4, GetHashKey(Config.NPC.model), Config.NPC.coords.xyz, Config.NPC.coords.w, false, true)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
end)

-- Blip
CreateThread(function()
    if Config.Blip.enabled then
        local blip = AddBlipForCoord(Config.NPC.coords.xyz)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipColour(blip, Config.Blip.color)
        SetBlipScale(blip, Config.Blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Blip.name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Interaktion
CreateThread(function()
    while true do
        local sleep = 1500
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local dist = #(coords - Config.NPC.coords.xyz)

        if dist < 2.0 and not yogaActive and not countdown then
            sleep = 0
            ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um Yoga zu starten')

            if IsControlJustPressed(0, Config.Keys.interact) then
                startYogaCountdown()
            end
        end

        Wait(sleep)
    end
end)

function startYogaCountdown()
    countdown = true
    local time = Config.Yoga.startDelay

    CreateThread(function()
        while time > 0 do
            ESX.ShowNotification('Yoga startet in ~g~' .. time .. '~s~ Sekunden')
            time = time - 1
            Wait(1000)
        end

        startYoga()
        countdown = false
    end)
end

function startYoga()
    yogaActive = true
    local ped = PlayerPedId()

    RequestAnimDict(Config.Yoga.animation.dict)
    while not HasAnimDictLoaded(Config.Yoga.animation.dict) do
        Wait(10)
    end

    TaskPlayAnim(ped, Config.Yoga.animation.dict, Config.Yoga.animation.name, 8.0, -8.0, -1, 1, 0, false, false, false)

    CreateThread(function()
        while yogaActive do
            ESX.ShowHelpNotification(Config.Yoga.durationText)

            if IsControlJustPressed(0, Config.Keys.cancel) then
                stopYoga()
            end

            Wait(0)
        end
    end)
end

function stopYoga()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    yogaActive = false
    ESX.ShowNotification('Yoga beendet')
end
