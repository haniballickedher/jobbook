
local VORPcore = exports.vorp_core:GetCore()
VORPcore.Callback.Register("jobbook:getJobs", function(source,cb,jobtable)
  local _source = source
  local user = VORPcore.getUser(_source)
  local Character = VORPcore.getUser(_source).getUsedCharacter 
  local charid = Character.charIdentifier 
  
  local response = MySQL.query.await('SELECT * from jobbook  WHERE charid = ?', {
    charid
  })
  if response then
    callback(response)
  else
    --insert an unemployed for the person
              --no jobs saved yet
              local unemployed = Config.unemployedJob
              
              local id = MySQL.insert.await('INSERT INTO jobbook (charid,jobname, jobgrade,jobtitle ) VALUES (?, ?, ?)', {
                identifier, unemployed, 0, "Jobless and Hopeless"
            })

            local response = MySQL.query.await('SELECT * from jobbook  WHERE id = ?', {
              id
            })
            callback(response)
  end
  
end)
 VORPcore.Callback.Register("jobbook:switchJob", function(source,cb,jobtable)
        local _source = source
        local user = VORPcore.getUser(_source)
        local character = user.getUsedCharacter
        local charid = character.charIdentifier
        local jobinfo = params.jobtable
        local jobname = jobinfo[1]
        local jobgrade = jobinfo[2]
        local jobtitle = jobinfo[3]    

        local affectedRows = MySQL.update.await('update characters set job=?, joblabel=?, jobgrade=? where charidentifier=?', {
    jobname, joblabel, jobgrade, charid })
         print(affectedRows)
        if affectedRows then
            cb=true
        else
             cb=false   
        end 
 end)

 VORPcore.Callback.Register("jobbook:saveJob", function(source,cb,jobtable)
        local _source = source
         local Character = VORPcore.getUser(_source).getUsedCharacter 
        local identifer = Character.charIdentifier
        local jobname - jobtable[1]
        local jobgrade = jobtable[2]
        local jobtitle = jobtable[3]
        local success
        -- get the characters jobs from the db
        local response = MySQL.query.await('SELECT * from jobbook WHERE charid = ?', {
          identifier
      })
       
      
        if response then
        -- compare the number of rows to the rows in the config
        if #response < Config.MaxTotalJobs then
          local numJobs
          local numgovtJobs
          for i = 1, #response do
            local row = response[i]
            print(row.job.." "..row.grade)
          end
        else
          --no jobs saved yet
          local id = MySQL.insert.await('INSERT INTO jobbook (charid,jobname, jobgrade,jobtitle ) VALUES (?, ?, ?)', {
            identifier, jobname, jobgrade, jobtitle
        })
         
          print(id)
        success = "Job Saved"
        end if
      end
   callback(success)
 end)

 VORPcore.Callback.Register("jobbook:quitJob", function(source,cb,jobtable)
        local _source = source
        local user = VORPcore.getUser(_source)
        
   callback(...)
 end)


--[[ function  SendToDiscordWebhook(title, description)
  for k, v in pairs(Config.Webhooks) do 
    local webhook = k.URL
    local color = k.Color
    local name = k.WebhookName
    local logo = k.WebhookLogo

    VORP.AddWebhook(title, webhook, description, color, name, logo)
  end
end ]]

