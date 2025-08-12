local slotmachine = {}

slotmachine.initialWinningChance = 0.60
slotmachine.currentWinningChance = slotmachine.initialWinningChance
slotmachine.decreaseAmount = {0.05}
slotmachine.decreaseChance = 0.50

local symbols = {
    "SEVEN",
    "CHERRY",
    "BAR",
    "BELL",
    "ORANGE"
}

local reels = {
    { "SEVEN", "CHERRY", "BAR", "BELL", "ORANGE" },
    { "BELL", "BAR", "CHERRY", "SEVEN", "ORANGE" },
    { "CHERRY", "BAR", "SEVEN", "BELL", "ORANGE" }
}

function slotmachine.getReels()
    return reels
end

local winningIndex = {
    ["SEVEN"] = {1, 4, 3},
    ["CHERRY"] = {2, 3, 1},
    ["BAR"] = {3, 2, 2},
    ["BELL"] = {4, 1, 4},
    ["ORANGE"] = {5, 5, 5}
}

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

local function copyTable(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = copyTable(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function rollSymbols(spins)

    local chance = math.random()
    local isWin = false
    local lossSeverity = 0
    if slotmachine.currentWinningChance > chance or spins == 0 then
        isWin = true
    else
        lossSeverity = math.random(1, 5)
    end

    print("IsWin?=" .. tostring(isWin))

    local chosenSymbol = symbols[math.random(1, #symbols)]
    local chosenSymbolIndices = copyTable(winningIndex[chosenSymbol])
    --print("Chosen Symbol: " .. chosenSymbol .. " with indices: " .. table.concat(chosenSymbolIndices, ", "))

    if not isWin then
        --print("Loss Severity: " .. lossSeverity)

        local loopGuard = 50
        local stillHasWinningIndices = true
        while stillHasWinningIndices and loopGuard > 0 do
            loopGuard = loopGuard - 1

            for i=1, lossSeverity do
                local randomIndex = math.random(1, #chosenSymbolIndices)
                local plusOrMinus = math.random(0, 1) == 0 and -1 or 1
                chosenSymbolIndices[randomIndex] = chosenSymbolIndices[randomIndex] + plusOrMinus
                if chosenSymbolIndices[randomIndex] < 1 then 
                    chosenSymbolIndices[randomIndex] = #reels[randomIndex]
                elseif chosenSymbolIndices[randomIndex] > #reels[randomIndex] then
                    chosenSymbolIndices[randomIndex] = 1
                end
            end
            
            stillHasWinningIndices = false
            for symbol, indices in pairs(winningIndex) do
                local found = tableEquals(indices, chosenSymbolIndices)
                --print("Checking symbol: " .. symbol .. " with indices: " .. table.concat(indices, ", ") .. " against chosen indices: " .. table.concat(chosenSymbolIndices, ", ") .. "; isWin?=" .. tostring(found))
                if found then
                    stillHasWinningIndices = true
                    --print("Found Non-Winning Indices: " .. symbol)
                    break
                end
            end

            --print("Rerolled Symbol Indices: " .. table.concat(chosenSymbolIndices, ", "))
        end

        if loopGuard <= 0 then
            --print("Warning: Loop guard triggered, unable to find a non-winning combination.")
        end

    end

    local symbols = {
        reels[1][chosenSymbolIndices[1]],
        reels[2][chosenSymbolIndices[2]],
        reels[3][chosenSymbolIndices[3]]
    }

    --print("Final Symbol Indices: " .. table.concat(chosenSymbolIndices, ", "))
    --print("Final Symbols: " .. table.concat(symbols, ", ") .. "\n")


    return {symbols, isWin, chosenSymbolIndices}

end

slotmachine.spin = function(spins)

    print("Win Chance: " .. slotmachine.currentWinningChance)
    
    print("Decrease Chance: " .. slotmachine.decreaseChance)
    local chance = math.random()
    local chanceToDecrease = slotmachine.decreaseChance
    local decreaseChance = slotmachine.decreaseAmount[math.random(1, #slotmachine.decreaseAmount)]
    if chance < chanceToDecrease and slotmachine.currentWinningChance > 0.10 then
        slotmachine.currentWinningChance = slotmachine.currentWinningChance - decreaseChance
        print("Decreased Winning Chance by: " .. decreaseChance)
    end

    if slotmachine.decreaseChance < 0.50 then
        slotmachine.decreaseChance = slotmachine.decreaseChance + 0.01
    end
    
    local rolledSymbols = rollSymbols(spins)
    local symbols = rolledSymbols[1]
    local isWin = rolledSymbols[2]
    local indices = rolledSymbols[3]
    --local test = symbols[1] == symbols[2] and symbols[2] == symbols[3]

    --print("ProjectedWin?: " .. tostring(test))
    --print("Rolled Symbols: " .. table.concat(symbols, ", ") .. "\n---------------\n")
    
    return {indices, isWin}
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
        local isWin = slotmachine.spin()[2]
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