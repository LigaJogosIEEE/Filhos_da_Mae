local AudioController = {}; AudioController.__index = AudioController

function AudioController:new()
    local this = {
        effects = {
            button_pressed = love.audio.newSource("assets/sounds/button_pressed.mp3", "static"),
            falling_sound = love.audio.newSource("assets/sounds/falling_sound.mp3", "static"),
            coin_sound = love.audio.newSource("assets/sounds/coin_sound.mp3", "static")
        },
        music = {
            game_music = love.audio.newSource("assets/sounds/background_music.mp3", "stream")
        }
    }

    return setmetatable(this, AudioController)
end

function AudioController:getSound(soundType, soundName)
    return self[soundType][soundName]
end

function AudioController:newSource(soundType, soundName, filename)
    if not self[soundType] then self[soundType] = {} end
    self[soundType][soundName] = love.audio.newSource(filename, soundType == "music" and "stream" or "static")
end

return AudioController
