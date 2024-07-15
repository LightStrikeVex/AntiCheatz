-- Define el módulo de parche para Adonis
local PatchModule = {}

-- Función para parchear el método de llamada de nombre
function PatchModule.PatchNamecall(game)
    -- Verifica si el juego y los métodos necesarios están disponibles
    if not game or not hookmethod or not closure or not getnamecallmethod or not checkcaller then
        error("Required methods or game instance not found.")
        return
    end

    -- Define una función local para manejar el método de llamada de nombre
    local function HandleNamecall(self, ...)
        -- Obtiene el método de llamada de nombre actual y sus argumentos
        local NamecallMethod = getnamecallmethod()
        local args = { ... }

        -- Verifica si el método de llamada de nombre es "Kick" y no es el llamador verificado
        if (NamecallMethod == "Kick" or NamecallMethod == "kick") and not checkcaller() then
            -- Puedes agregar acciones preventivas aquí, como registrar el intento de uso o bloquear la acción
            print("Intento de usar método de Kick detectado y bloqueado.")
            return
        end

        -- Llama al método de llamada original con los argumentos
        return PatchModule.OldNamecall(self, ...)
    end

    -- Captura y asigna el método de llamada de nombre al juego
    PatchModule.OldNamecall = hookmethod(game, "__namecall", closure(HandleNamecall))

    -- Imprime un mensaje de confirmación cuando se carga correctamente el parche
    print("Parche para Adonis cargado correctamente.")
end

-- Devuelve el módulo de parche para su uso en Adonis
return PatchModule

-- Para usar este módulo dentro de Adonis, simplemente inclúyelo como un ModuleScript y luego carga y activa el parche en tu entorno de juego según sea necesario. Asegúrate de ajustar y probar el código en un entorno controlado para asegurar su efectividad y que cumpla con tus requisitos específicos de seguridad y gestión de scripts.
