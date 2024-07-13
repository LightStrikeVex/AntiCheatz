-- Obtenemos el jugador local
local plr = game:GetService("Players").LocalPlayer

-- Función para obtener el nombre de la llamada
local getnamecallmethod = getnamecallmethod or function() return "" end

-- Registro de acciones
local function logAction(action)
    print("[ACTION LOG] " .. action)
end

-- Hook del método __namecall para modificar su comportamiento
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local NamecallMethod = getnamecallmethod()

    -- Registro de llamadas a InvokeServer y FireServer
    if (NamecallMethod == "InvokeServer" or NamecallMethod == "FireServer") and tostring(self) == "JyAntiCheat" then
        logAction("Intento de llamada a " .. NamecallMethod .. " desde JyAntiCheat.lua")
    end

    -- Evitar ser expulsado al intentar eliminar "JyAntiCheat"
    if NamecallMethod == "Destroy" and tostring(self) == "JyAntiCheat" then
        warn("Intento de eliminar JyAntiCheat detectado, evitando acción.")
        logAction("Intento de eliminar JyAntiCheat")
        return nil
    end

    -- Permitir la ejecución de música y "kill all"
    if NamecallMethod == "FireServer" and tostring(self) == "JyAntiCheat" then
        logAction("Llamada a FireServer (música o kill all) desde JyAntiCheat.lua")
        return oldNamecall(self, ...)
    end

    -- Pasar las llamadas no interceptadas
    return oldNamecall(self, ...)
end)

-- Función para eliminar el LocalScript "JyAntiCheat" sin ser expulsado
function removeJyAntiCheat()
    local JyAntiCheat = plr.PlayerScripts.JyAntiCheat -- Ajusta el camino según la estructura de tu juego

    if JyAntiCheat then
        JyAntiCheat:Destroy()
        logAction("JyAntiCheat ha sido eliminado exitosamente.")
    else
        logAction("No se encontró el LocalScript JyAntiCheat.")
    end
end

-- Ejemplo de uso: eliminar "JyAntiCheat" sin ser expulsado
removeJyAntiCheat()
