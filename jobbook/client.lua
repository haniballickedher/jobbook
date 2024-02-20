local VORPcore = exports.vorp_core:GetCore()-

local VORPMenu = {}

TriggerEvent("vorp_menu:getData", function(cb)
    VORPMenu = cb
end)



RegisterNetEvent('jobbook:openbook')
AddEventHandler('jobbook:openbook', function(city, region)
    OpenMainMenu()
end)
function OpenMainMenu()
    VORPMenu.CloseAll()
    local menuElements = {
        { label = "Exit Menu", value = "exit_menu", desc = "Close Menu" },
    }
    local addMenuElement
    addMenuElement = { label = "Switch Job", value = "switch", desc = "Change Jobs" }
    table.insert(menuElements, 1, addMenuElement)
    addMenuElement = { label = "Save Job", value = "save", desc = "Save Current Job" }
    table.insert(menuElements, 1, addMenuElement)
    addMenuElement = { label = "Quit Job", value = "quit", desc = "Quit a Job" }
    table.insert(menuElements, 1, addMenuElement)
    -- Open the menu using VORPMenu
    VORPMenu.Open(
        "default",
        GetCurrentResourceName(),
        "mainmenu",
        {
            title = "Jobbook Menu",
            subtext = "Career Management",
            align = "top-center",
            elements = menuElements,
            itemHeight = "4vh",
        },
        function(data, menu)
            if data.current.value == "switch" then
                OpenSwitchMenu()
            elseif data.current.value == "save" then
                SaveJob()
            elseif data.current.value == "quit" then
                OpenQuitMenu()
            elseif data.current.value == "exit_menu" then
                print("close")
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenSwitchMenu()
    VORPMenu.CloseAll()
    local menuElements = {}
    local addMenuElement
    addMenuElement = { label = "Main Menu", value = "back", desc = "Back to Main Menu" }
    table.insert(menuElements, addMenuElement)
    addMenuElement = { label = "Exit Menu", value = "exit_menu", desc = "Close Menu" }
    table.insert(menuElements, addMenuElement)
    --Here need to get all jobs the person has
    --@param name string callback name
    --@vararg ...? any can send as many parameters as you want 
    local jobname
    local jobgrade
    local jobtitle
    local label
    local result =  VORPcore.Callback.TriggerAwait("jobbook:getJobs")
        
        if #result == 0 then
            print("No jobs")
            TriggerEvent("vorp:TipBottom", "You don't have any jobs", 4000)
        else
            for k, v in pairs(result) do
            label = result[k].jobtitle.. " "..result[k].jobgrade
            
            value = {jobname, jobgrade, jobtitle}
            addMenuElement = { label = label, value = value, desc = "Select this job" }
            table.insert(menuElements, addMenuElement)
        end

        addMenuElement = { label = "Main Menu", value = "back", desc = "Back to Main Menu" }
        table.insert(menuElements, addMenuElement)
        addMenuElement = { label = "Exit Menu", value = "exit_menu", desc = "Close Menu" }
        table.insert(menuElements, addMenuElement)

        
        -- Open the menu using VORPMenu
        VORPMenu.Open(
            "default",
            GetCurrentResourceName(),
            "switchmenu",
            {
                title = "Switch Job",
                subtext = "",
                align = "top-center",
                elements = menuElements,
                itemHeight = "4vh",
            },
            function(data, menu)
                if data.current.value == "back" then
                    OpenStartMenu()
                elseif data.current.value == "exit_menu" then
                    print("close")
                    menu.close()
                else
                    SwitchCurrentJob(data.current.value)
                end
            end,
            function(data, menu)
                menu.close()
            end)
    end)
        
        end

        
   
end
function SwitchCurrentJob(jobtable)
     local result =  VORPcore.Callback.TriggerAwait("jobbook:switchJob")
end

function SaveJob()
    VORPCore.Callback.TriggerASync("jobbook:saveJob", function(result)
    print(result)
   end,)
end
function QuitJob()
    VORPCore.Callback.TriggerASync("jobbook:quitJob", function(result)
    print(result)
   end,)
end
RegisterCommand("openjobbook", function()
   TriggerEvent('jobbook:openbook')
end)
