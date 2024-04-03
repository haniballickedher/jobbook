
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
    cb(response)
  else
 
              VORPcore.NotifyTip(_source,Config.noJobs,4000)
            cb(nil)
  end
  
end)


RegisterServerEvent('switchJob')
AddEventHandler('switchJob', function(jobinfo)
        local _source = source
        local user = VORPcore.getUser(_source)
        local character = user.getUsedCharacter
        local charid = character.charIdentifier
        local jobinfo = params.jobtable
        local jobname = jobinfo[1]
        local jobgrade = jobinfo[2]
        local jobtitle = jobinfo[3]    
        character.setJob(jobname)
        character.setJobGrade(jobgrade)
        character.setJobLablel(jobtitle)
        VORPcore.NotifyTip(_source,jobname.." "..jobgrade.." "..Config.Languages.savedJob,4000)
 end)


 VORPcore.Callback.Register("jobbook:saveJob", function(source, cb)
  local _source = source
  local Character = VORPcore.getUser(_source).getUsedCharacter 
  local identifier = Character.charIdentifier
  local jobname = Character.job
  local jobgrade = Character.jobGrade
  local jobtitle = Character.jobLabel
  local success
  -- get the character's jobs from the db
  local response = MySQL.query.await('SELECT * from jobbook WHERE charid = ?', {
      identifier
  })
  print("here" .. #response)
  
  if response then -- are there any jobs?
      -- compare the number of rows to the rows in the config
      if #response < Config.MaxTotalJobs then
          -- we have room for the new job overall
          local numJobs = Config.MaxTotalJobs
          local numgovtJobs
          local roomforjob = true
          if Config.MaxGovtJobs == nil then
              numgovtJobs = Config.MaxTotalJobs
          else 
              numgovtJobs = Config.MaxGovtJobs
          end
          local jobGovt
          for i = 1, #response do
              local row = response[i]
              print(row.job .. " " .. row.grade)
              if row.job in Config.GovtJobs then
                  numgovtJobs = numgovtJobs - 1
                  jobGovt = true
              end
          end
          if jobGovt and numgovtJobs <= 0 then
              roomforjob = false
              VORPcore.NotifyTip(_source, jobname .. " " .. jobgrade .. " " .. Config.Languages.tooManyGovtJobs, 4000)
          end
      else
          VORPcore.NotifyTip(_source, jobname .. " " .. jobgrade .. " " .. Config.Languages.tooManyJobs, 4000)
      end
      if roomforjob then 
          local id = MySQL.insert.await('INSERT INTO jobbook (charid, jobname, jobgrade, jobtitle) VALUES (?, ?, ?, ?)', {
              identifier, jobname, jobgrade, jobtitle
          })
          print(id)
          success = "Job Saved"
      end
  end

  cb(success)
end)


 VORPcore.Callback.Register("jobbook:quitJob", function(source,cb,jobtable)
        local _source = source
        local user = VORPcore.getUser(_source)
        
   cb()
 end)
 VORPcore.Callback.Register("jobbook:addUnemployed", function(source,cb,jobtable)
  local _source = source
  local user = VORPcore.getUser(_source)
  
cb()
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

