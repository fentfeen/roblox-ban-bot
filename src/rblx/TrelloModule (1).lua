local trello = {}

trello.Key = script.Key.Value
trello.Secret = script.Secret.Value
trello.QueryParams = "key=".. trello.Key .. "&token=".. trello.Secret 
trello.BanListId = '6467be7bf5a5e741a52a554e'

local httpService = game:GetService("HttpService")

function trello.GetRequest(url)
	local request = url .. "?" .. trello.QueryParams
	local response = httpService:GetAsync(request)
	return response
end

function trello.PostRequest(url, queryData)
	queryData['key'] = trello.Key
	queryData['token'] = trello.Secret

	for name, value in pairs(queryData) do
		if not string.match(url, "?") then
			url = url .. "?" .. name .. "=" .. value
		else
			url = url .. "&" .. name .. "=" .. value
		end
	end
		
	local request = {
		["Url"] = url,
		['Method'] = "POST",
		["Headers"] = {
			['Accept'] = "application/json"
		},
		['Data'] = nil
	}
	
	local response = httpService:RequestAsync(request)
	print(response)
end
return trello


