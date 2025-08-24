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

local QBCore = nil
local playerEmergencyCooldowns = {} -- Track emergency cooldowns per player
local playerDeathStates = {} -- Track player death states
local playerDeathTimes = {} -- Track player death times
local playerKillerRequests = {} -- Track killer name requests to prevent duplicates

-- Config fallback function
local function GetConfigText(key, ...)
    if Config and Config.GetText then
        return Config.GetText(key, ...)
    else
        -- Fallback texts if config is not loaded
        local fallbackTexts = {
            ["notify_emergency_sent"] = "Acil servisler bilgilendirildi!",
            ["notify_emergency_cooldown"] = "Hastaneye bildirim gitti! Tekrar bildirim için 1 dakika bekleyin!",
            ["notify_emergency_received"] = "Acil durum çağrısı alındı! Bir oyuncu tıbbi yardıma ihtiyaç duyuyor!",
            ["notify_bleed_out"] = "You have bled out and died!"
        }
        
        local text = fallbackTexts[key] or "TEXT_NOT_FOUND: " .. key
        if select('#', ...) > 0 then
            return string.format(text, ...)
        end
        return text
    end
end

-- QBX Framework kontrolü - removed GetCoreObject usage

-- Player accepted death
RegisterNetEvent('BOA-DeathScreen:Server:PlayerAcceptedDeath', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player then return end
    
    -- Reset death state
    playerDeathStates[src] = nil
    playerDeathTimes[src] = nil
    playerKillerRequests[src] = nil
    
    -- Kill player immediately
    Player.Functions.SetMetaData('inlaststand', false)
    Player.Functions.SetMetaData('isdead', true)
    
    -- Respawn player
    TriggerClientEvent('hospital:client:RespawnAfterAccept', src)
    TriggerClientEvent('BOA-DeathScreen:Client:PlayerRevived', src)
end)

-- Player called emergency
RegisterNetEvent('BOA-DeathScreen:Server:PlayerCalledEmergency', function()
    local src = source
    
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player then 
        return 
    end
    
    -- Check server-side cooldown
    local currentTime = GetGameTimer()
    local lastCall = playerEmergencyCooldowns[src] or 0
    
    if currentTime - lastCall < 60000 then -- 60 seconds
        -- Still in cooldown
        exports.qbx_core:Notify(src, {
            text = GetConfigText("notify_emergency_cooldown"),
            type = "error"
        })
        return
    end
    
    -- Set cooldown
    playerEmergencyCooldowns[src] = currentTime
    
    -- Reset death state
    playerDeathStates[src] = nil
    playerDeathTimes[src] = nil
    playerKillerRequests[src] = nil
    
    -- Get all ambulance players
    local ambulancePlayers = {}
    local players = exports.qbx_core:GetQBPlayers()
    
    if players then
        for _, v in pairs(players) do
            if v and v.PlayerData and v.PlayerData.job then
                
                if v.PlayerData.job.name == "ambulance" and v.PlayerData.job.onduty then
                    table.insert(ambulancePlayers, {
                        source = v.PlayerData.source,
                        name = v.PlayerData.charinfo.firstname .. " " .. v.PlayerData.charinfo.lastname
                    })
                end
            end
        end
    end
    
    -- Notify ambulance players
    for _, ambulancePlayer in pairs(ambulancePlayers) do
        
        exports.qbx_core:Notify(ambulancePlayer.source, {
            text = GetConfigText("notify_emergency_received"),
            type = "error",
            duration = 10000
        })
        
        -- Add blip for ambulance players - get coords from client
        TriggerClientEvent('BOA-DeathScreen:Client:GetPlayerCoordsForBlip', src, ambulancePlayer.source, src)
    end
    
    -- Notify the player
    exports.qbx_core:Notify(src, {
        text = GetConfigText("notify_emergency_sent"),
        type = "success"
    })
end)

-- Player died (from client)
RegisterNetEvent('BOA-DeathScreen:Server:PlayerDied', function(killer, weapon)
    local src = source
    
    -- Set death state on server
    playerDeathStates[src] = true
    playerDeathTimes[src] = GetGameTimer()
end)

-- Get killer name from server
RegisterNetEvent('BOA-DeathScreen:Server:GetKillerName', function(killerServerId, weapon, deathType)
    local src = source
    
    -- Prevent duplicate requests
    if playerKillerRequests[src] and playerKillerRequests[src] == killerServerId then
        return
    end
    
    playerKillerRequests[src] = killerServerId
    
    local Player = exports.qbx_core:GetPlayer(src)
    local Killer = exports.qbx_core:GetPlayer(killerServerId)
    
    if not Player then return end
    
    local killerName = "Bilinmeyen"
    
    if Killer and Killer.PlayerData and Killer.PlayerData.charinfo then
        -- Get character name (firstname + lastname)
        local firstName = Killer.PlayerData.charinfo.firstname or ""
        local lastName = Killer.PlayerData.charinfo.lastname or ""
        killerName = firstName .. " " .. lastName
        
        -- Trim whitespace
        killerName = string.gsub(killerName, "^%s*(.-)%s*$", "%1")
        
        -- If name is empty, use fallback
        if killerName == "" or killerName == " " then
            killerName = "Bilinmeyen Oyuncu"
        end
    else
        killerName = "Bilinmeyen Oyuncu"
    end
    
    -- Send killer name back to client
    TriggerClientEvent('BOA-DeathScreen:Client:SetKillerName', src, killerName, weapon, deathType)
end)

-- Player bled out
RegisterNetEvent('BOA-DeathScreen:Server:PlayerBledOut', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player then return end
    
    -- Reset states
    playerDeathStates[src] = nil
    playerDeathTimes[src] = nil
    playerKillerRequests[src] = nil
    
    -- Kill player
    Player.Functions.SetMetaData('inlaststand', false)
    Player.Functions.SetMetaData('isdead', true)
    
    -- Respawn player
    TriggerClientEvent('hospital:client:RespawnAfterAccept', src)
    TriggerClientEvent('BOA-DeathScreen:Client:PlayerRevived', src)
    
    -- Notify player
    exports.qbx_core:Notify(src, {
        text = GetConfigText("notify_bleed_out"),
        type = "error"
    })
end)

-- Add emergency blip for ambulance players
RegisterNetEvent('BOA-DeathScreen:Server:AddEmergencyBlip', function(coords)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player or Player.PlayerData.job.name ~= "ambulance" then return end
    
    TriggerClientEvent('BOA-DeathScreen:Client:AddEmergencyBlip', src, coords)
end)

-- Send coords to ambulance player
RegisterNetEvent('BOA-DeathScreen:Server:SendCoordsToAmbulance', function(ambulancePlayerId, coords, playerId)
    
    -- Create new table with coords and playerId
    local blipData = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        playerId = playerId
    }
    
    TriggerClientEvent('BOA-DeathScreen:Client:AddEmergencyBlip', ambulancePlayerId, blipData)
end)

-- Clean up player data when they disconnect
AddEventHandler('playerDropped', function()
    local src = source
    playerDeathStates[src] = nil
    playerDeathTimes[src] = nil
    playerKillerRequests[src] = nil
    playerEmergencyCooldowns[src] = nil
end)
