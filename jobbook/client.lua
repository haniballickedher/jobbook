local VORPcore = exports.vorp_core:GetCore()

local VORPMenu = {}

TriggerEvent("vorp_menu:getData", function(cb)
    VORPMenu = cb
end)


RegisterNetEvent('jobbook:openbook')
AddEventHandler('jobbook:openbook', function(city, region)
    -- PlayAnimation()
    Citizen.Wait(1000)
    OpenMainMenu()
end)

function PlayAnimation()
    local ped = PlayerPedId()
    RequestAnimDict("amb_work@world_human_write_notebook@female_a@idle_c")
    while not HasAnimDictLoaded("amb_work@world_human_write_notebook@female_a@idle_c") do
        Citizen.Wait(100)
    end
    if not IsEntityPlayingAnim(ped, "amb_work@world_human_write_notebook@female_a@idle_c", "idle_h", 3) then
        local male = IsPedMale(ped)
        local ledger = CreateObject(GetHashKey('P_AMB_CLIPBOARD_01'), 0.0, 0.0, 0.0, true, true, true)
        local pen = CreateObject(GetHashKey('P_PEN01X'), 0.0, 0.0, 0.0, true, true, true)
        local lefthand = GetEntityBoneIndexByName(ped, "SKEL_L_Hand")
        local righthand = GetEntityBoneIndexByName(ped, "SKEL_R_Hand")
        Wait(100)
        if male then
            AttachEntityToEntity(pen, ped, righthand, 0.105, 0.055, -0.13, -5.0, 0.0, 0.0, true, true, false, true, 1,
                true)
            AttachEntityToEntity(ledger, ped, lefthand, 0.17, 0.07, 0.08, 80.0, 160.0, 180.0, true, true, false, true,
                1, true)
        else
            AttachEntityToEntity(pen, ped, righthand, 0.095, 0.045, -0.095, -5.0, 0.0, 0.0, true, true, false, true, 1,
                true)
            AttachEntityToEntity(ledger, ped, lefthand, 0.17, 0.07, 0.08, 70.0, 155.0, 185.0, true, true, false, true,
                1, true)
        end
        TaskPlayAnim(ped, "amb_work@world_human_write_notebook@female_a@idle_c", "idle_h", 8.0, -8.0, -1, 31, 0, false,
            false, false)
    end
end

function OpenMainMenu()
    VORPMenu.CloseAll()
    local menuElements = { {
        label = "Exit Menu",
        value = "exit_menu",
        desc = "Close Menu"
    } }
    local addMenuElement
    addMenuElement = {
        label = "Quit Job",
        value = "quit",
        desc = "Quit a Job"
    }
    table.insert(menuElements, 1, addMenuElement)
    addMenuElement = {
        label = "Save Job",
        value = "save",
        desc = "Save Current Job"
    }
    table.insert(menuElements, 1, addMenuElement)
    addMenuElement = {
        label = "Switch Job",
        value = "switch",
        desc = "Change Jobs"
    }
    table.insert(menuElements, 1, addMenuElement)
    local submenutitle = ""

    local result = VORPcore.Callback.TriggerAwait("jobbook:getCurrentJob")
    if result then
        submenutitle = result.jobgrade.." "..result.jobname
    end
    -- Open the menu using VORPMenu


    VORPMenu.Open("default", GetCurrentResourceName(), "mainmenu", {
        title = "Jobbook Menu",
        subtext = "Current job:"..submenutitle,
        align = "top-right",
        elements = menuElements,
        itemHeight = "4vh"
    }, function(data, menu)
        if data.current.value == "switch" then
            OpenSwitchMenu()
        elseif data.current.value == "save" then
            SaveJob(data.current.value)
        elseif data.current.value == "quit" then
            OpenQuitMenu()
        elseif data.current.value == "exit_menu" then
            print("close")
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenSwitchMenu()
    VORPMenu.CloseAll()
    local menuElements = {}
    local addMenuElement
    addMenuElement = {
        label = "Main Menu",
        value = "back",
        desc = "Back to Main Menu"
    }
    table.insert(menuElements, addMenuElement)
    addMenuElement = {
        label = "Exit Menu",
        value = "exit_menu",
        desc = "Close Menu"
    }
    table.insert(menuElements, addMenuElement)

    local jobname
    local jobgrade
    local joblabel
    local label
    local result = VORPcore.Callback.TriggerAwait("jobbook:getJobs")

    if #result == 0 then
        print("No jobs")
        TriggerEvent("vorp:TipBottom", "You don't have any jobs", 4000)
    else
        for k, v in pairs(result) do
            jobname = result[k].jobname
            jobgrade = result[k].jobgrade
            if result[k].joblabel then
                joblabel = result[k].joblabel
            else
                joblabel = " "
            end
            label = jobname.." "..jobgrade
            
            value = { result[k].jobname, result[k].jobgrade, "" }    
            
            
            addMenuElement = {
                label = label,
                value = value,
                desc = "Select this job"
            }
            table.insert(menuElements, addMenuElement)
        end

        -- Open the menu using VORPMenu
        VORPMenu.Open("default", GetCurrentResourceName(), "switchmenu", {
            title = "Switch Job",
            subtext = "",
            align = "top-right",
            elements = menuElements,
            itemHeight = "4vh"
        }, function(data, menu)
            if data.current.value == "back" then
                OpenMainMenu()
            elseif data.current.value == "exit_menu" then
                print("close")
                menu.close()
            else
                SwitchCurrentJob(data.current.value)
            end
        end, function(data, menu)
            menu.close()
        end)
    end
end

function OpenQuitMenu()
    VORPMenu.CloseAll()
    local menuElements = {}
    local addMenuElement
    addMenuElement = {
        label = "Main Menu",
        value = "back",
        desc = "Back to Main Menu"
    }
    table.insert(menuElements, addMenuElement)
    addMenuElement = {
        label = "Exit Menu",
        value = "exit_menu",
        desc = "Close Menu"
    }
    table.insert(menuElements, addMenuElement)
    -- Here need to get all jobs the person has
    -- @param name string callback name
    -- @vararg ...? any can send as many parameters as you want
    local jobname
    local jobgrade
    local joblabel
    local label
    local result = VORPcore.Callback.TriggerAwait("jobbook:getJobs")

    if #result == 0 then
        print("No jobs")
        TriggerEvent("vorp:TipBottom", "You don't have any jobs", 4000)
    else
        for k, v in pairs(result) do
            label = result[k].jobname .. " " .. result[k].jobgrade
            value = result[k].id
            addMenuElement = {
                label = label,
                value = value,
                desc = "Quit this job"
            }
            table.insert(menuElements, addMenuElement)
        end

        -- Open the menu using VORPMenu
        VORPMenu.Open("default", GetCurrentResourceName(), "switchmenu", {
            title = "Quit Job",
            subtext = "",
            align = "top-right",
            elements = menuElements,
            itemHeight = "4vh"
        }, function(data, menu)
            if data.current.value == "back" then
                OpenMainMenu()
            elseif data.current.value == "exit_menu" then
                print("close")
                menu.close()
            else
                QuitJob(data.current.value)
            end
        end, function(data, menu)
            menu.close()
        end)
    end
end

function SwitchCurrentJob(jobtable) -- name, grade, title
    local jobname = jobtable[1]
    local jobgrade = jobtable[2]
    local joblabel = jobtable[3]
   
    TriggerServerEvent("jobbook:switchJob", jobname, jobgrade, joblabel)
end

function SaveJob()
    VORPcore.Callback.TriggerAwait("jobbook:saveJob", function(result)
        print(result)
       
        if result then
            VORPcore.NotifyTip(Config.Languages.savedJob, 4000)
        else
            VORPcore.NotifyTip(Config.Languages.jobNotSaved, 4000)
        end
    end, jobtable)
end

function QuitJob(jobid)
    VORPcore.Callback.TriggerAsync("jobbook:quitJob", function(result)
        print(result)
    end, jobid)

    VORPcore.NotifyTip(Config.Languages.youquit, 4000)
    OpenQuitMenu()
end

RegisterCommand(Config.Command, function()
    TriggerEvent('jobbook:openbook')
end)
