local httpService = game:GetService("HttpService")
local playerService = game:GetService("Players")
local runService = game:GetService("RunService")
local trello = require(script.TrelloModule)

local playerTracker = {}
local admins = {
	[16229050] = true
}

game.Players.PlayerAdded:Connect(function(plr)
	BanCheck(plr)
	playerTracker[plr] = tick()
	if admins[plr.UserId] == true then
		plr.Chatted:Connect(Chatted)
	end
end)
game.Players.PlayerRemoving:Connect(function(plr)
	playerTracker[plr] = nil
end)

function Chatted(message, recip)
	if string.sub(message,1,1) == "/" then
		local fullCommand = string.sub(message,2,#message)
		
		local args = string.split(fullCommand, " ")
		local commandName = args[1]
		table.remove(args, 1)

		for name,func in pairs(require(script.CommandModule)) do
			if name:lower() == commandName:lower() then
				func(args)
			end
		end
	end
end

function BanCheck(plr)
	local cardsData = trello.GetRequest("https://api.trello.com/1/lists/".. trello.BanListId .."/cards")
	local cardsList = httpService:JSONDecode(cardsData)
	for _, card in cardsList do
		if plr.UserId == tonumber(card['name']) then
			if card['due'] then
				local expiration = DateTime.fromIsoDate(card['due'])
				local now = DateTime.now()

				local elt = expiration.ToLocalTime(expiration)
				
				if expiration.UnixTimestamp > now.UnixTimestamp then
					plr:Kick("You are banned. Expires " .. elt.Month .. "/" .. elt.Day .. "/" .. elt.Year .. ": " .. card['desc'])
				end
			else
				plr:Kick("You are banned. Expires never: " .. card['desc'])
			end
		end
	end
end

runService.Stepped:Connect(function()
	for plr, lastTick in pairs(playerTracker) do
		local currentTick = tick()
		if currentTick - lastTick >= 30 then
			BanCheck(plr)
			playerTracker[plr] = currentTick
		end
	end
end)

