local initialAmount = 1000

local money = {}
money.AMOUNT = initialAmount

function money:add(num)
    self.AMOUNT = self.AMOUNT + num
end

function money:subtract(num)
    self.AMOUNT = self.AMOUNT - num
end

function money:isBroke()
    local isBroke = self.AMOUNT <= 0
    return isBroke
end

return money