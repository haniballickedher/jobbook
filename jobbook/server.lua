local VORPcore = exports.vorp_core:GetCore()

VORPcore.Callback.Register("jobbook:getCurrentJob", function(source, cb)
    local _source = source
    local character = VORPcore.getUser(_source).getUsedCharacter
    local jobinfo = {}
    jobinfo.jobname = character.job
    print(jobinfo.jobname)
    jobinfo.jobgrade = character.jobGrade
    cb(jobinfo)
end)

VORPcore.Callback.Register("jobbook:getJobs", function(source, cb, jobtable)
    local _source = source
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

RegisterServerEvent('jobbook:switchJob')
AddEventHandler('jobbook:switchJob', function(jobname, jobgrade, jobtitle)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local charid = Character.charIdentifier
    Character.setJob(jobname)
    print(jobname)
    Character.setJobGrade(jobgrade)
    print(jobgrade)
    Character.setJobLabel(jobtitle)
    print(jobtitle)
    VORPcore.NotifyTip(_source, Config.Languages.switchedTo..jobname .. " " .. jobgrade, 4000)
end)

VORPcore.Callback.Register("jobbook:saveJob", function(source, cb)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.charIdentifier
    local jobname = Character.job
    local jobgrade = Character.jobGrade
    local jobtitle = Character.jobLabel
    local success = false

    -- Get the character's jobs from the database
    local response = MySQL.query.await('SELECT * FROM jobbook WHERE charid = ?', {identifier})

    if response then -- Check if there are any jobs
        local numJobs = #response
        local numGovtJobs = 0
        local hasThisJobAlready = false

        -- Count the current government jobs and check if the character already has this job
        for i = 1, numJobs do
            local row = response[i]
            if table.contains(Config.GovtJobs, row.jobname) then
                numGovtJobs = numGovtJobs + 1
            end
            if row.jobname == jobname then
                hasThisJobAlready = true
                -- Update the existing job
                local id = MySQL.update.await(
                    'UPDATE jobbook SET charid = ?, jobname = ?, jobgrade = ?, jobtitle = ? WHERE id = ?',
                    {identifier, jobname, jobgrade, jobtitle, row.id}
                )
                print("Updated job with ID: " .. id)
                success = true
                VORPcore.NotifySimpleTop(_source, jobname .. " " .. jobgrade .. " updated", 4000)
            end
        end

        -- Check if there's room for the new job
        if not hasThisJobAlready then
            local isGovtJob = table.contains(Config.GovtJobs, jobname)
            if (Config.MaxTotalJobs and numJobs >= Config.MaxTotalJobs) or (isGovtJob and numGovtJobs >= (Config.MaxGovtJobs or Config.MaxTotalJobs)) then
                -- Notify the player if there's no room for the new job
                
                VORPcore.NotifySimpleTop(_source, Config.Languages.tooManyGovtJobs, 4000)
            else
                -- Insert the new job into the jobbook table
                local id = MySQL.insert.await(
                    'INSERT INTO jobbook (charid, jobname, jobgrade, jobtitle) VALUES (?, ?, ?, ?)',
                    {identifier, jobname, jobgrade, jobtitle}
                )
                print("Inserted job with ID: " .. id)
                success = true
                VORPcore.NotifySimpleTop(_source, Config.Languages.savedJob, 4000)
            end
        end
    else
        -- Notify the player if there was an issue retrieving job data
        VORPcore.NotifyTip(_source, Config.Languages.unable, 4000)
    end

    cb(success)
end)

-- Helper function to check if a table contains a value
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end


VORPcore.Callback.Register("jobbook:quitJob", function(source, cb, jobid)
    local _source = source
    local user = VORPcore.getUser(_source)
    local id = MySQL.query.await(
        'DELETE from jobbook  where id = ?',
        {jobid})
        print("Deleted job with ID: " .. jobid)    
    cb(true)
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

