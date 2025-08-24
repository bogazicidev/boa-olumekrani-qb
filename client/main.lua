

-- Config is loaded from config.lua via fxmanifest.lua

-- Load config directly if not loaded
if not Config then
    Config = {}
    Config.Language = "tr"
    Config.Languages = {
        ["tr"] = {
            ["ui_coming_soon"] = "COK YAKINDA",
            ["ui_bleeding_out"] = "KAN KAYBINDAN OLECEKSIN",
            ["ui_ambulance_wait"] = "AMBULANS BEKLE",
            ["ui_call_emergency"] = "ACIL DURUM CAGIR",
            ["ui_killed_by"] = "TARAFINDAN OLDURULDU",
            ["ui_cooldown_message"] = "Hastaneye bildirim gitti! Tekrar bildirim icin %s saniye bekleyin!",
            ["death_unknown"] = "Bilinmeyen Sebep",
            ["death_self"] = "Kendini Öldürdü",
            ["death_fall"] = "Yüksekten Düştü",
            ["death_detecting"] = "Tespit Ediliyor...",
            ["death_unknown_player"] = "Bilinmeyen Oyuncu",
            ["death_vehicle"] = "Araç Kazası",
            ["death_zombie"] = "Zombi Tarafından Öldürüldü",
            ["death_unknown_killer"] = "Bilinmeyen Saldırgan",
            ["notify_emergency_blip"] = "Acil Durum - Oyuncu %s",
            ["notify_emergency_alert"] = "Oyuncu %s acil tıbbi yardıma ihtiyaç duyuyor!"
        },
        ["en"] = {
            ["ui_coming_soon"] = "COMING SOON",
            ["ui_bleeding_out"] = "YOU WILL DIE FROM BLOOD LOSS",
            ["ui_ambulance_wait"] = "WAIT FOR AMBULANCE",
            ["ui_call_emergency"] = "CALL EMERGENCY",
            ["ui_killed_by"] = "KILLED BY",
            ["ui_cooldown_message"] = "Emergency services notified! Wait %s seconds to call again!",
            ["death_unknown"] = "Unknown Cause",
            ["death_self"] = "Suicide",
            ["death_fall"] = "Fall Damage",
            ["death_detecting"] = "Detecting...",
            ["death_unknown_player"] = "Unknown Player",
            ["death_vehicle"] = "Vehicle Accident",
            ["death_zombie"] = "Killed by Zombie",
            ["death_unknown_killer"] = "Unknown Attacker",
            ["notify_emergency_blip"] = "Emergency - Player %s",
            ["notify_emergency_alert"] = "Player %s needs emergency medical attention!"
        }
    }
    function Config.GetText(key, ...)
        local text = Config.Languages[Config.Language][key]
        if not text then
            return "TEXT_NOT_FOUND: " .. key
        end
        
        if select('#', ...) > 0 then
            return string.format(text, ...)
        end
        
        return text
    end
end

local PlayerData = {}
local isDead = false
local deathTime = 0
local deathTimer = 0
local killedBy = nil
local emergencyCooldown = 0 -- Emergency button cooldown
local emergencyBlips = {} -- Multiple emergency blips for different players
local deathScreenShown = false -- Track if death screen is currently shown
local lastDeathCheck = 0 -- Prevent multiple death events
local lastRevivalTime = 0 -- Track last manual revival time

-- Config fallback function
local function GetConfigText(key, ...)
    if Config and Config.GetText then
        return Config.GetText(key, ...)
    else
        -- If config is not loaded, return error message
        return "CONFIG_NOT_LOADED: " .. key
    end
end

-- Player Data Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = exports.qbx_core:GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Death Events
RegisterNetEvent('BOA-DeathScreen:Client:PlayerDied', function(killer, weapon)
    if deathScreenShown then
        return
    end
    
    isDead = true
    deathTime = GetGameTimer()
    deathTimer = 300 -- 5 minutes
    killedBy = killer or "Bilinmeyen"
    deathScreenShown = true
    
    -- Show death screen
    SendNUIMessage({
        type = "showDeathScreen",
        data = {
            killedBy = killedBy,
            weapon = weapon or "Bilinmeyen"
        }
    })
    SetNuiFocus(true, true)
    
    -- Disable controls
    CreateThread(function()
        while isDead do
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true) -- LookLeftRight
            EnableControlAction(0, 2, true) -- LookUpDown
            EnableControlAction(0, 245, true) -- INPUT_MP_TEXT_CHAT_TEAM
            Wait(0)
        end
    end)
end)

RegisterNetEvent('BOA-DeathScreen:Client:PlayerRevived', function()
    if not isDead then 
        return 
    end
    
    -- Manuel revival varsa direkt izin ver
    if manualRevival then
        -- Manuel revival işlemi
    else
        -- Sadece manuel revival veya uzun süre sonra izin ver
        local currentTime = GetGameTimer()
        local timeSinceDeath = currentTime - (deathTime or currentTime)
        
        -- Eğer ölümden sonra 10 saniyeden az geçtiyse, revival'i engelle
        if timeSinceDeath < 10000 then -- 10 saniye
            return
        end
    end
    
    isDead = false
    deathTimer = 0
    killedBy = nil
    deathScreenShown = false
    manualRevival = false -- Reset manual revival flag
    
    -- Manuel revival zamanını kaydet
    if manualRevival then
        lastRevivalTime = GetGameTimer()
    end
    
    -- Hide death screen
    SendNUIMessage({
        type = "hideDeathScreen"
    })
    SetNuiFocus(false, false)
end)

-- Timer Thread
CreateThread(function()
    while true do
        if isDead then
            deathTimer = deathTimer - 1
            
            if deathTimer <= 0 then
                -- Player bleeds out
                TriggerEvent('BOA-DeathScreen:Client:PlayerBledOut')
                break
            end
            
            -- Update timer on UI only every 5 seconds to reduce spam
            if deathTimer % 5 == 0 then
                SendNUIMessage({
                    type = "updateTimer",
                    data = {
                        time = deathTimer
                    }
                })
            end
        end
        Wait(1000) -- Update every second
    end
end)

-- NUI Callbacks
RegisterNUICallback('acceptDeath', function(data, cb)
    -- Manuel revival'i tetikle
    manualRevival = true
    
    -- Server'a bildir
    TriggerServerEvent('BOA-DeathScreen:Server:PlayerAcceptedDeath')
    
    -- Client'ta revival'i tetikle
    TriggerEvent('BOA-DeathScreen:Client:PlayerRevived')
    
    cb('ok')
end)

RegisterNUICallback('getConfigText', function(data, cb)
    local text = GetConfigText(data.key, table.unpack(data.params or {}))
    cb({text = text})
end)

RegisterNUICallback('callEmergency', function(data, cb)
    local currentTime = GetGameTimer()
    
    -- Check cooldown (60 seconds = 60000 ms)
    if currentTime - emergencyCooldown < 60000 then
        -- Still in cooldown
        SendNUIMessage({
            type = "emergencyCooldown",
            data = {
                remainingTime = math.ceil((60000 - (currentTime - emergencyCooldown)) / 1000)
            }
        })
        cb('cooldown')
        return
    end
    
    -- Set cooldown
    emergencyCooldown = currentTime
    
    TriggerEvent('BOA-DeathScreen:Client:ManualRevival')
    TriggerServerEvent('BOA-DeathScreen:Server:PlayerCalledEmergency')
    cb('ok')
end)

-- Simplified Death Detection - Ultimate Fix
CreateThread(function()
    local wasDead = false
    local manualRevival = false
    
    while true do
        local player = PlayerPedId()
        local isCurrentlyDead = IsEntityDead(player)
        local currentTime = GetGameTimer()
        
        -- Check if player just died
        if isCurrentlyDead and not wasDead and not deathScreenShown then
            -- Prevent multiple death events
            if currentTime - lastDeathCheck < 2000 then
                Wait(1000)
                goto continue
            end
            lastDeathCheck = currentTime
            
            -- Get death information
            local killer = GetPedSourceOfDeath(player)
            local weapon = GetPedCauseOfDeath(player)
            
            -- Determine death cause
            local deathCause = "Bilinmeyen Sebep"
            
            -- Check if it's a self-kill (kill command, fall damage, etc.)
            if killer == 0 or killer == player then
                
                                -- Determine specific death cause based on weapon hash
                -- FiveM fall damage weapon hashes
                if weapon == 0 then
                    deathCause = GetConfigText("death_unknown")
                elseif weapon == -842959696 then
                    -- Bu hash hem /kill komutu hem de yüksekten düşme için kullanılıyor
                    -- Killer kontrolü ile ayırt ediyoruz
                    if killer == 0 or killer == player then
                        deathCause = GetConfigText("death_self")
                    else
                        deathCause = GetConfigText("death_fall")
                    end
                elseif weapon == -1569615261 or weapon == -1951375401 or weapon == -102973651 or weapon == -853065399 then
                    deathCause = GetConfigText("death_fall")
                elseif weapon == -102973651 then
                    deathCause = GetConfigText("death_unknown")
                elseif weapon == -1951375401 then
                    deathCause = GetConfigText("death_unknown")
                elseif weapon == -853065399 then
                    deathCause = GetConfigText("death_unknown")
                else
                    -- Additional fall damage checks
                    if weapon == -1569615261 or weapon == -1951375401 or weapon == -102973651 or weapon == -853065399 then
                        deathCause = GetConfigText("death_fall")
                    else
                        deathCause = GetConfigText("death_unknown")
                    end
                end
                
            elseif killer ~= 0 and killer ~= player then
                -- Check if killer is a player
                if IsPedAPlayer(killer) then
                    local killerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killer))
                    if killerServerId > 0 then
                                            -- Request killer name from server
                    TriggerServerEvent('BOA-DeathScreen:Server:GetKillerName', killerServerId, weapon)
                    deathCause = GetConfigText("death_detecting")
                else
                    deathCause = GetConfigText("death_unknown_player")
                end
                else
                    -- Check if it's a vehicle
                    if IsEntityAVehicle(killer) then
                        local driver = GetPedInVehicleSeat(killer, -1)
                        if driver ~= 0 and driver ~= player and IsPedAPlayer(driver) then
                            local driverServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(driver))
                                                    if driverServerId > 0 then
                            TriggerServerEvent('BOA-DeathScreen:Server:GetKillerName', driverServerId, weapon, "vehicle")
                            deathCause = GetConfigText("death_detecting")
                        else
                            deathCause = GetConfigText("death_vehicle")
                        end
                    else
                        deathCause = GetConfigText("death_vehicle")
                        end
                    else
                        -- Check for zombie or other NPC
                        local entityModel = GetEntityModel(killer)
                        if entityModel == GetHashKey("u_m_y_zombiea_01") or 
                           entityModel == GetHashKey("u_m_y_zombiea_02") or
                           entityModel == GetHashKey("u_m_y_zombiea_03") or
                           entityModel == GetHashKey("a_m_m_zombie_01") or
                           entityModel == GetHashKey("a_m_y_zombie_01") then
                            deathCause = GetConfigText("death_zombie")
                        else
                            deathCause = GetConfigText("death_unknown_killer")
                        end
                    end
                end
            end
            
            -- Show death screen immediately
            TriggerEvent('BOA-DeathScreen:Client:PlayerDied', deathCause, weapon)
            
            -- Notify server about death
            TriggerServerEvent('BOA-DeathScreen:Server:PlayerDied', killer, weapon)
            
        elseif not isCurrentlyDead and wasDead and deathScreenShown and isDead then
            -- Only allow revival if it's manual (button press) or after very long time
            local timeSinceDeath = currentTime - lastDeathCheck
            
            if manualRevival or (timeSinceDeath > 600000) then -- 10 minutes or manual
                TriggerEvent('BOA-DeathScreen:Client:PlayerRevived')
            else
                -- Force player to stay dead
                SetEntityHealth(player, 0)
            end
        end
        
        wasDead = isCurrentlyDead
        ::continue::
        Wait(1000)
    end
end)



-- Manual revival event
RegisterNetEvent('BOA-DeathScreen:Client:ManualRevival', function()
    manualRevival = true
end)

-- Bleed out event
RegisterNetEvent('BOA-DeathScreen:Client:PlayerBledOut', function()
    TriggerServerEvent('BOA-DeathScreen:Server:PlayerBledOut')
end)

-- Set killer name from server
RegisterNetEvent('BOA-DeathScreen:Client:SetKillerName', function(killerName, weapon, deathType)
    
    -- Update the death screen with real killer name
    SendNUIMessage({
        type = "updateKillerName",
        data = {
            killedBy = killerName
        }
    })
end)

-- Add emergency blip for ambulance players
RegisterNetEvent('BOA-DeathScreen:Client:AddEmergencyBlip', function(coords)
    -- Remove existing emergency blip if any
    if emergencyBlips[coords.playerId] then
        RemoveBlip(emergencyBlips[coords.playerId])
        emergencyBlips[coords.playerId] = nil
    end
    
    -- Try to create blip
    local newBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    
    if newBlip and newBlip ~= 0 then
        emergencyBlips[coords.playerId] = newBlip
        
        -- Set blip properties - same as test blip
        SetBlipSprite(newBlip, 1) -- Standard waypoint (same as test)
        SetBlipColour(newBlip, 1) -- Red
        SetBlipScale(newBlip, 1.0) -- Same scale as test
        SetBlipAsShortRange(newBlip, false)
        
        -- Set blip name
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(GetConfigText("notify_emergency_blip", coords.playerId))
        EndTextCommandSetBlipName(newBlip)
        
        -- Flash the blip
        SetBlipFlashes(newBlip, true)
        
        -- Remove blip after 5 minutes
        CreateThread(function()
            Wait(300000) -- 5 minutes
            if emergencyBlips[coords.playerId] then
                RemoveBlip(emergencyBlips[coords.playerId])
                emergencyBlips[coords.playerId] = nil
            end
        end)
        
    else
        -- Failed to create blip - silent fail
    end
    
    -- Play sound notification - try different sounds
    PlaySoundFrontend(-1, "BEEP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    Wait(300)
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(300)
    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    
    -- ALTERNATIVE: Show big notification and play sound
    -- This will work even if blip doesn't work
    exports.qbx_core:Notify({
        text = GetConfigText("notify_emergency_alert", coords.playerId),
        type = "error",
        duration = 10000
    })
    
end)

-- Get player coords for blip (called from server)
RegisterNetEvent('BOA-DeathScreen:Client:GetPlayerCoordsForBlip', function(ambulancePlayerId, playerId)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('BOA-DeathScreen:Server:SendCoordsToAmbulance', ambulancePlayerId, coords, playerId)
end)

-- Additional safety check - Force death screen if player is dead but screen not shown
-- Bu sistem ana ölüm tespit sisteminin kaçırdığı durumları yakalar
CreateThread(function()
    while true do
        if not isDead and not deathScreenShown then
            local player = PlayerPedId()
            local health = GetEntityHealth(player)
            
            -- Check if player is dead (health <= 0) but death screen not shown
            if health <= 0 and not deathScreenShown then
                -- Manuel revival sonrası kısa bir bekleme süresi
                local currentTime = GetGameTimer()
                local timeSinceRevival = currentTime - (lastRevivalTime or 0)
                
                -- Manuel revival'den sonra 5 saniye beklet
                if lastRevivalTime and timeSinceRevival < 5000 then
                    Wait(1000)
                    goto continue_safety_check
                end
                
                -- Get actual death information
                local killer = GetPedSourceOfDeath(player)
                local weapon = GetPedCauseOfDeath(player)
                
                -- Determine actual death cause
                local deathCause = "Bilinmeyen Sebep"
                if killer == 0 or killer == player then
                    -- Determine specific death cause based on weapon hash
                    -- FiveM fall damage weapon hashes
                    if weapon == 0 then
                        deathCause = GetConfigText("death_unknown")
                    elseif weapon == -842959696 then
                        -- Bu hash hem /kill komutu hem de yüksekten düşme için kullanılıyor
                        -- Killer kontrolü ile ayırt ediyoruz
                        if killer == 0 or killer == player then
                            deathCause = GetConfigText("death_self")
                        else
                            deathCause = GetConfigText("death_fall")
                        end
                    elseif weapon == -1569615261 or weapon == -1951375401 or weapon == -102973651 or weapon == -853065399 then
                        deathCause = GetConfigText("death_fall")
                    elseif weapon == -102973651 then
                        deathCause = GetConfigText("death_unknown")
                    elseif weapon == -1951375401 then
                        deathCause = GetConfigText("death_unknown")
                    elseif weapon == -853065399 then
                        deathCause = GetConfigText("death_unknown")
                    else
                        deathCause = GetConfigText("death_unknown")
                    end
                elseif killer ~= 0 and killer ~= player then
                    if IsPedAPlayer(killer) then
                        local killerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killer))
                        if killerServerId > 0 then
                            TriggerServerEvent('BOA-DeathScreen:Server:GetKillerName', killerServerId, weapon)
                            deathCause = GetConfigText("death_detecting")
                        else
                            deathCause = GetConfigText("death_unknown_player")
                        end
                    else
                        deathCause = GetConfigText("death_unknown_killer")
                    end
                end
                
                -- Force death screen with actual death cause
                TriggerEvent('BOA-DeathScreen:Client:PlayerDied', deathCause, weapon)
                
                -- Wait a bit to prevent spam
                Wait(5000)
            end
        end
        
        ::continue_safety_check::
        Wait(2000) -- Check every 2 seconds
    end
end)


