local Class = {};Class.__index = Class;function Class:new(...) return {...} end;function Class:extends(type) local class = {__call = Class.__call, __index = self, type = type, super = self}; class.__index = class; return setmetatable(class, self) end;function Class:__call(...) return setmetatable(self:new(), self) end function Class:type() return self.type end return Class
