local reward = {}

reward.storedReward = function()
    print("Default Reward")
end

function reward:setReward(r)
    self.storedReward = r
end

function reward:hasReward()
    return self.storedReward ~= nil
end

function reward:grantReward()
    if reward.storedReward then
        self.storedReward()
    else 
        print("No reward specified")
    end

    self.storedReward = nil
end

return reward