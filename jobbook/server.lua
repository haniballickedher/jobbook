local VORPcore = exports.vorp_core:GetCore()
VORPcore.Callback.Register("jobbook:getJobs", function(source, cb, jobtable)
    local _source = source
    local user = VORPcore.getUser(_source)
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local charid = Character.charIdentifier

    local response = MySQL.query.await('SELECT * from jobbook  WHERE charid = ?', {charid})
    if response then
        cb(response)
    else

        VORPcore.NotifyTip(_source, Config.noJobs, 4000)
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
    VORPcore.NotifyTip(_source, jobname .. " " .. jobgrade .. " " .. Config.Languages.savedJob, 4000)
end)

VORPcore.Callback.Register("jobbook:saveJob", function(source, cb)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter() -- Added parentheses to call the function
    local identifier = Character.charIdentifier
    local jobname = Character.job
    local jobgrade = Character.jobGrade
    local jobtitle = Character.jobLabel
    local success

    -- Get the character's jobs from the database
    local response = MySQL.query.await('SELECT * FROM jobbook WHERE charid = ?', {identifier})

    if response then -- Check if there are any jobs
        local numJobs = Config.MaxTotalJobs
        local numgovtJobs = Config.MaxGovtJobs or Config.MaxTotalJobs
        local roomforjob = true
        local jobGovt = false

        -- Check if the new job is a government job and if there's room for it
        for i = 1, #response do
            local row = response[i]
            if Config.GovtJobs[row.jobname] then -- Fixed the key name to match your database column name
                numgovtJobs = numgovtJobs - 1
                jobGovt = true
            end
        end

        -- Check if there's room for the new government job
        if jobGovt and numgovtJobs <= 0 then
            roomforjob = false
            VORPcore.NotifyTip(_source, jobname .. " " .. jobgrade .. " " .. Config.Languages.tooManyGovtJobs, 4000)
        end

        if roomforjob then
            -- Insert the new job into the jobbook table
            local id = MySQL.insert.await(
                'INSERT INTO jobbook (charid, jobname, jobgrade, jobtitle) VALUES (?, ?, ?, ?)',
                {identifier, jobname, jobgrade, jobtitle})
            print("Inserted job with ID: " .. id)
            success = "Job Saved"
        end
    else
        -- Notify the player if there was an issue retrieving job data
        VORPcore.NotifyTip(_source, "Error: Unable to retrieve job data.", 4000)
    end

    cb(success)
end)

VORPcore.Callback.Register("jobbook:quitJob", function(source, cb, jobtable)
    local _source = source
    local user = VORPcore.getUser(_source)

    cb()
end)
VORPcore.Callback.Register("jobbook:addUnemployed", function(source, cb, jobtable)
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

