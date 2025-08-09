local slotmachine = {}

slotmachine.symbols = {
    "SEVEN",
    "CHERRY",
    "BAR",
    "ORANGE",
    "BELL"
}

slotmachine.reels = {
    { "SEVEN", "CHERRY", "BAR", "ORANGE", "BELL"},
    { "BELL", "ORANGE", "BAR", "CHERRY", "SEVEN" },
    { "CHERRY", "BAR", "SEVEN", "BELL", "ORANGE" }
}

slotmachine.reelIndex = {1,1,1}

slotmachine.spin = function()
    for i = 1, #slotmachine.reelIndex do
        slotmachine.reelIndex[i] = math.random(1, #slotmachine.reels[i])
    end
    print("Symbols: " + 
          slotmachine.reels[1][slotmachine.reelIndex[1]] + ", " +
          slotmachine.reels[2][slotmachine.reelIndex[2]] + ", " +
          slotmachine.reels[3][slotmachine.reelIndex[3]])
end


return slotmachine