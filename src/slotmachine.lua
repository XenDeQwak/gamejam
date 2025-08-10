local slotmachine = {}

slotmachine.initialWinningChance = 0.60
slotmachine.currentWinningChance = slotmachine.initialWinningChance
slotmachine.decreaseChance = 0.02

local symbols = {
    "SEVEN",
    "CHERRY",
    "BAR",
    "ORANGE",
    "BELL"
}

local reels = {
    { "SEVEN", "CHERRY", "BAR", "ORANGE", "BELL" },
    { "BELL", "ORANGE", "BAR", "CHERRY", "SEVEN" },
    { "CHERRY", "BAR", "SEVEN", "BELL", "ORANGE" }
}

local winningIndex = {
    ["SEVEN"] = {1, 5, 3},
    ["CHERRY"] = {2, 4, 1},
    ["BAR"] = {3, 3, 2},
    ["ORANGE"] = {4, 2, 5},
    ["BELL"] = {5, 1, 4}
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

local function rollSymbols()

    print("Win Chance: " .. slotmachine.currentWinningChance)

    local chance = math.random()
    local isWin = false
    local lossSeverity = 0
    if slotmachine.currentWinningChance > chance then
        isWin = true
    else
        lossSeverity = math.random(1, 5)
    end

    print("IsWin?=" .. tostring(isWin))

    local chosenSymbol = symbols[math.random(1, #symbols)]
    local chosenSymbolIndices = copyTable(winningIndex[chosenSymbol])
    print("Chosen Symbol: " .. chosenSymbol .. " with indices: " .. table.concat(chosenSymbolIndices, ", "))

    if not isWin then
        print("Loss Severity: " .. lossSeverity)

        local loopGuard = 50
        local stillHasWinningIndices = true
        while stillHasWinningIndices and loopGuard > 0 do
            loopGuard = loopGuard - 1
            --print("Loop Guard: " .. loopGuard)

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
                    print("Found Non-Winning Indices: " .. symbol)
                    break
                end
            end

            print("Rerolled Symbol Indices: " .. table.concat(chosenSymbolIndices, ", "))
        end

        if loopGuard <= 0 then
            print("Warning: Loop guard triggered, unable to find a non-winning combination.")
        end

    end

    print("Final Symbol Indices: " .. table.concat(chosenSymbolIndices, ", "))

    local symbols = {
        reels[1][chosenSymbolIndices[1]],
        reels[2][chosenSymbolIndices[2]],
        reels[3][chosenSymbolIndices[3]]
    }

    return {symbols, isWin}

end

slotmachine.spin = function()
    local rolledSymbols = rollSymbols()
    local symbols = rolledSymbols[1]
    local isWin = rolledSymbols[2]
    --local test = symbols[1] == symbols[2] and symbols[2] == symbols[3]

    --print("ProjectedWin?: " .. tostring(test))
    print("Rolled Symbols: " .. table.concat(symbols, ", ") .. "\n---------------\n")
    

    return isWin
end

slotmachine.test_rollSymbols = function (testAttempts)

    local winCount = 0
    local lossCount = 0

    for i=1, testAttempts do
        local isWin = rollSymbols()
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