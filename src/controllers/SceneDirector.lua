local SceneDirector = {}

SceneDirector.__index = SceneDirector

function SceneDirector:new(firstScene)
    assert(firstScene, "SceneDirector needs a initial scene to work properly")
    local this = {
        currentScene = nil,
        currentSubscene = nil,
        sceneObjects = {},
        subsceneObjects = {},
        sceneStack = gameDirector:getLibrary("Stack"):new()
    }

    this.currentScene = firstScene

    return setmetatable(this, SceneDirector)
end

function SceneDirector:reset(scene)
    assert(self.sceneObjects[scene], "Unable to find required scene: '" .. tostring(scene) .. "'")
    if self.sceneObjects[scene].reset then
        self.sceneObjects[scene]:reset()
    end
end

function SceneDirector:addScene(sceneName, sceneObject, override)
    if override or not self.sceneObjects[sceneName] then
        self.sceneObjects[sceneName] = sceneObject
    end
end

function SceneDirector:addSubscene(subsceneName, subsceneObject, override)
    if override or not self.subsceneObjects[subsceneName] then
        self.subsceneObjects[subsceneName] = subsceneObject
    end
end

function SceneDirector:switchScene(scene, message)
    assert(self.sceneObjects[scene], "Unable to find required scene: '" .. tostring(scene) .. "'")
    self.sceneStack.push(self.currentScene)
    self.currentScene = self.sceneObjects[scene] or self.currentScene
    self.currentScene.message = message
    self.currentSubscene = nil
end

function SceneDirector:previousScene()
    if self.sceneStack.peek() then
        self.currentScene = self.sceneStack.pop()
        self.currentSubscene = nil
    end
end

function SceneDirector:clearStack(scene)
    assert(scene and self.sceneObjects[scene], "Unable to find required scene: '" .. tostring(scene) .. "'")
    while not self.sceneStack.isEmpty() do
        self.currentScene = self.sceneStack.pop()
    end
    self.currentScene = (scene and self.sceneObjects[scene]) or self.currentScene
    self.sceneStack.push(self.currentScene)
    self.currentSubscene = nil
end

function SceneDirector:switchSubscene(subscene)
    self.currentSubscene = self.subsceneObjects[subscene]
    assert(self.currentSubscene, string.format("Unable to find requested subscene \"%s\"", tostring(subscene)))
end

function SceneDirector:exitSubscene()
    self.currentSubscene = nil
end

function SceneDirector:keypressed(key, scancode, isrepeat)
    if not self.currentSubscene then
        if self.currentScene.keypressed then
            self.currentScene:keypressed(key, scancode, isrepeat)
        end
    elseif self.currentSubscene.keypressed then
        self.currentSubscene:keypressed(key, scancode, isrepeat)
    end
end

function SceneDirector:keyreleased(key, scancode)
    if not self.currentSubscene then
        if self.currentScene.keyreleased then
            self.currentScene:keyreleased(key, scancode)
        end
    elseif self.currentSubscene.keyreleased then
        self.currentSubscene:keyreleased(key, scancode)
    end
end

function SceneDirector:mousemoved(x, y, dx, dy, istouch)
    if not self.currentSubscene then
        if self.currentScene.mousemoved then
            self.currentScene:mousemoved(x, y, dx, dy, istouch)
        end
    elseif self.currentSubscene.mousemoved then
        self.currentSubscene:mousemoved(x, y, dx, dy, istouch)
    end
end

function SceneDirector:mousepressed(x, y, button)
    if not self.currentSubscene then
        if self.currentScene.mousepressed then
            self.currentScene:mousepressed(x, y, button)
        end
    elseif self.currentSubscene.mousepressed then
        self.currentSubscene:mousepressed(x, y, button)
    end
end

function SceneDirector:mousereleased(x, y, button)
    if not self.currentSubscene then
        if self.currentScene.mousereleased then
            self.currentScene:mousereleased(x, y, button)
        end
    elseif self.currentSubscene.mousereleased then
        self.currentSubscene:mousereleased(x, y, button)
    end
end

function SceneDirector:wheelmoved(x, y)
    if not self.currentSubscene then
        if self.currentScene.wheelmoved then
            self.currentScene:wheelmoved(x, y)
        end
    elseif self.currentSubscene.wheelmoved then
        self.currentSubscene:wheelmoved(x, y)
    end
end

function SceneDirector:update(dt)
    if not self.currentSubscene then
        if self.currentScene.update then
            self.currentScene:update(dt)
        end
    elseif self.currentSubscene.update then
        self.currentSubscene:update(dt)
    end
end

function SceneDirector:draw()
    if self.currentScene.draw then
        self.currentScene:draw()
    end
    if self.currentSubscene and self.currentSubscene.draw then
        self.currentSubscene:draw()
    end
end

function SceneDirector:resize(w, h)
    if self.currentScene.resize then
        self.currentScene:resize(w, h)
    end
end

return SceneDirector
