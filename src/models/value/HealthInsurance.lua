local HealthInsurance = {}

HealthInsurance.__index = HealthInsurance

function HealthInsurance:new()
    local this = {
        moreHealth = function(lifeForm, min, max)
            local number = love.math.random(min, max)
            lifeForm:increaseLife(number)
        end,
        moreLives = function(lifeForm, amount)
            lifeForm.increaseLives(amount)
        end
    }

    return setmetatable(this, HealthInsurance)
end

function HealthInsurance:execute(insuranceType, ...)
    assert(insuranceType, "Needs a insurance type")
    return self[insuranceType](...)
end

return HealthInsurance
