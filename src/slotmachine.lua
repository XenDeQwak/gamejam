local slotmachine = {}

slotmachine.initialWinningChance = 0.5
slotmachine.currentWinningChance = slotmachine.initialWinningChance
slotmachine.decreaseChance = 0.02

slotmachine.symbols = {
    "SEVEN",
    "CHERRY",
    "BAR",
    "ORANGE",
    "BELL"
}

slotmachine.reels = {
    { "SEVEN", "CHERRY", "BAR", "ORANGE", "BELL" },
    { "BELL", "ORANGE", "BAR", "CHERRY", "SEVEN" },
    { "CHERRY", "BAR", "SEVEN", "BELL", "ORANGE" }
}

--[[
    Winning Indices:
    1, 5, 3 - SEVEN
    2, 4, 1 - CHERRY
    3, 3, 4 - BAR
    4, 2, 5 - ORANGE
    5, 1, 4 - BELL
]]

slotmachine.winningIndex = {
    {1, 5, 3}, -- SEVEN
    {2, 4, 1}, -- CHERRY
    {3, 3, 4}, -- BAR
    {4, 2, 5}, -- ORANGE
    {5, 1, 4}  -- BELL
}

function slotmachine.winningIndex.contains(tbl)
    for i, v in ipairs(slotmachine.winningIndex) do
        if v[1] == tbl[1] and v[2] == tbl[2] and v[3] == tbl[3] then
            return true
        end
    end
    return false
end

local function tableEquals(t1, t2)
  if #t1 ~= #t2 then return false end
  local len = #t1
  for i=1, len do
    if t1[i] ~= t2[i] then
      return false
    end
  end
  return true
end

local function rollSymbols()

    local chance = math.random()
    local isWin = false
    local lossSeverity = 0
    if slotmachine.currentWinningChance > chance then
        isWin = true
    else
        lossSeverity = math.random(1, 5)
    end

    local chosenSymbols = slotmachine.winningIndex[math.random(1, #slotmachine.winningIndex)]
    print("Chosen Combination: " .. table.concat(chosenSymbols, ", "))

    if isWin then
        print("Won\n")
        return {chosenSymbols, true}
    else
        -- Check if the chosen symbols are a winning combination, repeat if still are
        for i, v in ipairs(slotmachine.winningIndex) do
            if tableEquals(chosenSymbols, v) then
                print("Rerolling Chosen Combinations: " .. table.concat(chosenSymbols, ", "))
                for j=1, lossSeverity do
                    local randomIndex = math.random(1, #chosenSymbols)
                    local plusOrMinus = math.random(0, 1) == 0 and -1 or 1
                    chosenSymbols[randomIndex] = chosenSymbols[randomIndex] + plusOrMinus
                    chosenSymbols[randomIndex] = chosenSymbols[randomIndex] % #chosenSymbols + 1
                    --print(table.concat(chosenSymbols, ", "))
                end
            end
        end
        print("Final Chosen Combination: " .. table.concat(chosenSymbols, ", ") .. "\n")
        return {chosenSymbols, false}
    end

end

slotmachine.spin = function()

    local rolledSymbols = rollSymbols()
    
    local index = rolledSymbols[1]
    local symbols = {}
    symbols[1] = slotmachine.reels[1][index[1]]
    symbols[2] = slotmachine.reels[2][index[2]]
    symbols[3] = slotmachine.reels[3][index[3]]

    print("Current Winning Chance: " .. slotmachine.currentWinningChance)
    print("Symbols: " .. symbols[1] .. ", " .. symbols[2] .. ", " .. symbols[3])

    local isWin = symbols[1] == symbols[2] and symbols[2] == symbols[3]
    print("Is Win: " .. tostring(isWin) .. "\n")

    if isWin then
        return true
    else
        return false
    end
    
end

slotmachine.test_rollSymbols = function (testAttempts)

    local winCount = 0
    local lossCount = 0

    for i=1, testAttempts do
        local isWin = rollSymbols()[2]
        if isWin then
            winCount = winCount + 1
        else
            lossCount = lossCount + 1
        end
    end

    local percentageWin = (winCount / testAttempts) * 100

    print ("Test Results:")
    print ("Total Attempts: " .. testAttempts)
    print ("Wins: " .. winCount)
    print ("Losses: " .. lossCount)
    print ("Winning Percentage: " .. percentageWin .. "%")

end

slotmachine.test_spin = function (testAttempts)

    local winCount = 0
    local lossCount = 0

    for i=1, testAttempts do
        local isWin = slotmachine.spin()
        if isWin then
            winCount = winCount + 1
        else
            lossCount = lossCount + 1
        end
    end

    local percentageWin = (winCount / testAttempts) * 100

    print ("Test Results:")
    print ("Total Attempts: " .. testAttempts)
    print ("Wins: " .. winCount)
    print ("Losses: " .. lossCount)
    print ("Winning Percentage: " .. percentageWin .. "%")

end


return slotmachine