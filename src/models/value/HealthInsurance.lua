local HealthInsurance = {}

HealthInsurance.__index = HealthInsurance

function HealthInsurance:new()
    local this = {

    }

    return setmetatable(this, HealthInsurance)
end

return HealthInsurance