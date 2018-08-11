local KeyboardManager = {}

KeyboardManager.__index = KeyboardManager

function KeyboardManager:new(defaultKeys)
    local this = {
        keys = defaultKeys or {}
    }

    return setmetatable(this, KeyboardManager)
end

function KeyboardManager:changeKey(command, key)
    if self.keys[command] then
        self.keys[command] = key
    end
end

function KeyboardManager:getAllKeys()
    return self.keys
end

return KeyboardManager
