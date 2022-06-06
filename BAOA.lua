-- for small jamjam
_G.Farm = true
_G.Settings = {
    World = 4, 
    Level = 11, 
    Difficulty = "Normal", --Easy/Normal/Hard/Extreme

    LeaveOneLeft = false, --Leaves one Unit Left so you dont lose it
    UnitToFeed = "Slime Lord", --Choose the Unit you want to Level up
    allowedRarity = {"Common","Uncommon","Epic"}, --choose which rarities you want to be fed to your selected Unit

    coinpull = false, --Enable coin pull if enough coins
    coinpullten = false, --enable coin pull for x10 pulls
    gempull = false, --Enable gem pull if enough gems
    gempullten = false, --enable gem pull for x10 pulls
}


while game.Players.LocalPlayer == nil do
    game.Players:GetPropertyChangedSignal('LocalPlayer'):wait()
end

wait(2)
print("Jamie")
game.StarterGui:SetCore("SendNotification", {
Title = "loader",
Text = "Jamie-Acc",
Icon = "",
Duration = 8,
})
local function getData()
    return game:GetService("ReplicatedStorage").RemoteFunctions.GivePlayerData:InvokeServer()
end

local function getUnitRarity(unit)
    if game:GetService("ReplicatedStorage").Units:FindFirstChild(unit) and game:GetService("ReplicatedStorage").Units[unit]:FindFirstChild("Stats") then
        return game:GetService("ReplicatedStorage").Units[unit].Stats.Stars.Value
    end
end

local function getInventoryUnits()
    local rarity = {"Common","Uncommon","Epic","Mythical","Legendary"}
    local tab = {}
    local unitData = getData().Units
    for i,v in pairs(unitData)do
        if type(v) == "string" then
            table.insert(tab,{Unit = v,Amount = unitData[i+2],Rarity = rarity[getUnitRarity(v)]})
        end
    end
    return tab
end

local function rarityAllowed(rarity)
    for i,v in pairs(_G.Settings.allowedRarity)do
        if v == rarity then
            return true
        end
    end
    return false
end


while _G.Farm and wait(1) do
    if game.PlaceId == 6310438798 then
        game.Workspace:WaitForChild("Lobby")
        local Units = getData().Units 
        local rarity = {"Common","Uncommon","Epic","Mythical","Legendary"} 
        local data = getData()
        if _G.Settings.coinpull then
            if _G.Settings.coinpullten and data.Coins >= 1000 then
                local A_1 = false
                local A_2 = 10
                local Event = game:GetService("ReplicatedStorage").RemoteFunctions.BuySpin
                Event:InvokeServer(A_1, A_2)
            elseif _G.Settings.coinpull and data.Coins >= 100 then
                local A_1 = false
                local A_2 = 1
                local Event = game:GetService("ReplicatedStorage").RemoteFunctions.BuySpin
                Event:InvokeServer(A_1, A_2)
            end
        end
        if _G.Settings.gempull then
            if _G.Settings.gempullten and data.Gems >= 200 then
                local A_1 = true
                local A_2 = 10
                local Event = game:GetService("ReplicatedStorage").RemoteFunctions.BuySpin
                Event:InvokeServer(A_1, A_2)
            elseif _G.Settings.gempull and data.Gems >= 20 then
                local A_1 = true
                local A_2 = 1
                local Event = game:GetService("ReplicatedStorage").RemoteFunctions.BuySpin
                Event:InvokeServer(A_1, A_2)
            end
        end

        for i,v in pairs(getInventoryUnits())do
            if rarityAllowed(v.Rarity) then
                if v.Amount == 1 and not _G.Settings.LeaveOneLeft or v.Amount > 1 then
                    local am = 0
                    if _G.Settings.LeaveOneLeft and v.Amount > 1 then
                        am = v.Amount -1
                    else
                        am = v.Amount
                    end
                     
                    local A_1 = _G.Settings.UnitToFeed
                    local A_2 = 
                    {
                        [1] = v.Unit, 
                        [2] = am
                    }
                    local Event = game:GetService("ReplicatedStorage").RemoteEvents.FeedUnit
                    Event:FireServer(A_1, A_2)
        
                end
            end
        end

        game:GetService("ReplicatedStorage").RemoteFunctions.JoinWorld:InvokeServer(_G.Settings.World, _G.Settings.Level, _G.Settings.Difficulty)
    else
        for i,v in pairs(game:GetService("Workspace"):WaitForChild("Team1").Units:GetChildren())do
            if v:FindFirstChild("Stats") then
                if v.Stats.UltimatePoints.Value >= v.Stats.UltimateMax.Value and v.Stats.UltRequest.Value == false and (not v.Stats:FindFirstChild("UseUlt") or v.Stats.UseUlt.Value == false) then  
                    local A_1 = v.Stats.PositionPlate.Value.Name
                    local Event = game:GetService("ReplicatedStorage").RemoteEvents.UltRequestFromClient
                    Event:FireServer(A_1)
                end
            end
        end
        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ScreenGui") and game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("OutroFrame") and game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.OutroFrame.Visible == true then
            game.ReplicatedStorage.RemoteFunctions.JoinWorld:InvokeServer()
        end
    end
end
