VORP = exports.vorp_core:vorpAPI()
local VorpCore = {}
local ServerRPC = exports.vorp_core:ServerRpcCall() --[[@as ServerRPC]] -- for intellisense
local VORPutils = {}

TriggerEvent("getUtils", function(utils)
    VORPutils = utils
end)
TriggerEvent("getCore",function(core)
    VorpCore = core
end)




VORP.addNewCallBack("lottery:checkifentered", function(source, cb, params)
  local _source = source
  local user = VorpCore.getUser(_source)
  local charId = (user.getUsedCharacter).charIdentifier
  local lottery = params.id
  local isEntered = false -- Initialize the variable
  MySQL.single('SELECT * FROM lotterytickets WHERE charid = ?', {charId},
    function(row)
      if not row then
        isEntered = false
      else
        isEntered = true
      end
      cb(isEntered) -- Call the callback with the result
    end
  )
end)



VORP.addNewCallBack("lottery:isAdmin", function(source, cb, params)
  local _source = source
  local user = VorpCore.getUser(_source)

  local isAllowed = false
  for k, v in pairs(Config.ElectionOfficials) do
      for _, group in ipairs(v) do
          if group == user.getGroup then
              isAllowed = true
              break
          end
      end
      if isAllowed then
          break
      end
  end
  
  cb(isAllowed)
  


    cb(isAllowed)  

end)



VORP.addNewCallBack("lottery:getResults", function(source, cb, params)
  local _source = source
  local user = VorpCore.getUser(_source)
  local charId = (user.getUsedCharacter).charIdentifier
  local query
      query = 'SELECT * from lotteries where open = 0'
  MySQL.query(query, queryParams, function(result)
      cb(result)
  end)
end)


VORP.addNewCallBack('lottery:getLotteries', function(source, cb, params)
  local query
      query = 'SELECT * from lotteries where open = 1'
  MySQL.query(query, queryParams, function(result)
      cb(result)
  end)
end)

VORP.addNewCallBack('lottery:hasenteredalready', function(source, cb, params)
  local _source = source
  local user = VorpCore.getUser(_source)
  local charId = (user.getUsedCharacter).charIdentifier
  local lotteryid = params.lotteryid
  local query, queryParams
 
      query = 'SELECT * from lotterytickets where charID=@charId and lotteryid = @lotteryid '
      queryParams = { ['@lotteryid'] = lotteryid, ['@charId'] = charId }

  MySQL.query(query, queryParams, function(result)
     -- Check if there is at least one row in the result
     local hasEntered = #result > 0
     print("has entered", hasEntered)
     cb(hasEntered)
      
  end)
end)


RegisterServerEvent('addNewLottery')
AddEventHandler('addNewLottery', function(lotteryname, daystoopen, price, description)
  local startdatestring = "NOW()" 
  local enddatestring = "DATE_ADD(NOW(),INTERVAL "..daystoopen.." DAYS" 
      query = 'INSERT INTO lotteries (lotteryname, start, days, end, open, price, desc) VALUES (@lotteryname, @startdatestring, @daystoopen, @enddatestring, 1, @price, @description)) '
      queryParams = {['@lotteryname'] = lotteryname, ['@startdatestring'] =startdatestring, ['@daystoopen'] = daystoopen, ['@enddatestring'] = enddatestring, ['@price'] =price, ['@description'] = description }
      MySQL.Async.execute(query, queryParams)
end)





--[[ 
VORP.addNewCallBack("democracy:getResults", function(source, cb, params)
  local _source = source
  local user = VorpCore.getUser(_source)
  local charId = (user.getUsedCharacter).charIdentifier
  local position = params.position
  local location = params.location
  local jurisdiction = params.jurisdiction
  local query, queryParams

  if jurisdiction == "federal" then
    query = 'SELECT COUNT(voteID) as votes, candidate_name, b.position FROM ballot b ' ..
            'LEFT JOIN ballot_votes v ON b.id = v.ballotID WHERE POSITION = @position ' ..
            'GROUP BY candidate_name, v.office, jurisdiction, location, region, city ORDER BY votes DESC'
    queryParams = { ['@position'] = position }
  elseif jurisdiction == "regional" then
    query = 'SELECT COUNT(voteID) as votes, candidate_name, b.position, b.city, b.region FROM ballot b ' ..
            'LEFT JOIN ballot_votes v ON b.id = v.ballotID WHERE POSITION = @position AND region = @region ' ..
            'GROUP BY candidate_name, v.office, region, city ORDER BY votes DESC'
    queryParams = { ['@position'] = position, ['@region'] = location }
  elseif jurisdiction == "local" then
    query = 'SELECT COUNT(voteID) as votes, candidate_name, b.position, b.city, b.region FROM ballot b ' ..
            'LEFT JOIN ballot_votes v ON b.id = v.ballotID WHERE POSITION = @position AND city = @city ' ..
            'GROUP BY candidate_name, v.office, region, city ORDER BY votes DESC'
    queryParams = { ['@position'] = position, ['@city'] = location }
  end

    MySQL.query(query, queryParams, function(result)
    cb(result)
  end)
end) ]]

--[[ function  SendToDiscordWebhook(title, description)
  for k, v in pairs(Config.Webhooks) do 
    local webhook = k.URL
    local color = k.Color
    local name = k.WebhookName
    local logo = k.WebhookLogo

    VORP.AddWebhook(title, webhook, description, color, name, logo)
  end
end ]]

