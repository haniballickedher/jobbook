
local VORPcore = exports.vorp_core:GetCore()

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
        local user = VORPcore.getUser(_source)
   
        -- get the characters jobs from the db
        
        -- compare the number of rows to the rows in the config
        -- going to need to interate through and see which ones are goverment and compare counts.
        local numJobs
        local numgovtJobs
        --if under the limit add the job
        -- if over return an error
   callback(...)
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

