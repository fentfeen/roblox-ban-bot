local commands = {}
local trello = require(script.Parent.TrelloModule)
local players = game:GetService("Players")

commands.kick = function(args)
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if string.match(player.Name:lower(), args[1]:lower()) then
			local reason = ""
			if args[2] then
				for i,word in pairs(args) do
					if i >= 2 then
						reason = reason .. word .. " "
					end
				end
			else
				reason = "No reason specified."
			end

			player:Kick(reason)
		end
	end
end

commands.ban = function(args) -- player, time (days), reason
	local userId = nil
	for _,player in pairs(game:GetService("Players"):GetPlayers()) do
		if string.match(player.Name:lower(), args[1]:lower()) then
			userId = player.UserId
			player:Kick("You have been banned.")
			break
		end
	end
	
	if not userId then
		userId = players:GetUserIdFromNameAsync(args[1])
	end
	
	local days = tonumber(args[2])
	local reason = ""
	if args[3] then
		for i,word in pairs(args) do
			if i >= 3 then
				reason = reason .. word .. " "
			end
		end
	else
		reason = "No reason specified."
	end
	
	
	print(reason)

	local unixExpiration = DateTime.now().UnixTimestamp + (days * 86400)
	local expiration = DateTime.fromUnixTimestamp(unixExpiration)
	local elt = expiration.ToIsoDate(expiration)
	
	local data = {
		['idList'] = trello.BanListId,
		['due'] = elt,
		['name'] = userId,
		['desc'] = reason
	}

	trello.PostRequest("https://api.trello.com/1/cards", data)
end

return commands
