-- Nombre del script que quieres eliminar
local scriptName = "JyAntiCheat.lua"

-- Webhook URL de Discord para notificaciones
local webhookUrl = "https://discord.com/api/webhooks/1261525118958567464/CzZBlK5TF-U_YKsaN5I_l1N-ynfGDdi-aZ0j61BFGgmdLS_JvKWb2hYetan8ULy4526h"

-- Función para enviar un mensaje a la webhook de Discord
local function sendToWebhook(message)
    local data = {
        content = message
    }

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local success, response = pcall(function()
        return game:HttpGetAsync(webhookUrl, true, headers)
    end)

    if success then
        print("Mensaje enviado a la webhook de Discord.")
    else
        warn("Error al enviar mensaje a la webhook de Discord:", response)
    end
end

-- Función para encontrar y eliminar un LocalScript del jugador
local function removeScript(scriptName)
    local found = false

    -- Buscamos en Workspace
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("LocalScript") and descendant.Name == scriptName then
            descendant:Destroy() -- Eliminamos el script local
            found = true
        end
    end

    -- Buscamos en Players
    for _, player in ipairs(game.Players:GetPlayers()) do
        local character = player.Character
        if character then
            for _, descendant in ipairs(character:GetDescendants()) do
                if descendant:IsA("LocalScript") and descendant.Name == scriptName then
                    descendant:Destroy() -- Eliminamos el script local
                    found = true
                end
            end
        end
    end

    return found
end

-- Monitoreo para verificar si el script reaparece
local function monitorScript()
    while true do
        wait(5) -- Esperamos 5 segundos antes de verificar nuevamente

        local scriptFound = false

        -- Verificamos en Workspace
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("LocalScript") and descendant.Name == scriptName then
                scriptFound = true
                break
            end
        end

        if not scriptFound then
            -- Verificamos en Players
            for _, player in ipairs(game.Players:GetPlayers()) do
                local character = player.Character
                if character then
                    for _, descendant in ipairs(character:GetDescendants()) do
                        if descendant:IsA("LocalScript") and descendant.Name == scriptName then
                            scriptFound = true
                            break
                        end
                    end
                end
            end
        end

        if scriptFound then
            local message = string.format("¡Alerta! El script %s ha reaparecido en el juego.", scriptName)
            sendToWebhook(message)
        end
    end
end

-- Intentamos eliminar el script y enviar mensaje a la webhook
local success = removeScript(scriptName)

if success then
    -- Obtener información del jugador
    local player = game.Players.LocalPlayer
    local username = player.Name
    local userId = player.UserId

    -- Enviar mensaje a la webhook
    local message = string.format("Se ha eliminado el script %s del jugador %s (ID: %d).", scriptName, username, userId)
    sendToWebhook(message)
else
    print("No se encontró el script " .. scriptName .. " para eliminar.")
end

-- Iniciar monitoreo del script
spawn(monitorScript)

-- Evitamos ser expulsados por cualquier otro script
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall

setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- Prevenir expulsiones por métodos como Kick, Ban, etc.
    if method == "Kick" or method == "Ban" then
        local player = game.Players:GetPlayerFromCharacter(self)
        if player then
            local username = player.Name
            local reason = args[1] or "Razón no especificada"
            local message = string.format("El jugador %s fue expulsado por %s: %s", username, method, reason)
            sendToWebhook(message)
        end
        return
    end

    -- Llamar al método original
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

print("Se ha establecido la protección contra expulsiones por otros scripts y el monitoreo del script eliminado en Workspace y Players.")
